-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fleury_lab_duplic_exame_interf ( nr_prescricao_p bigint, nr_seq_origem_p bigint, nr_seq_exame_p text, nm_usuario_p text, nr_sequencia_p INOUT bigint) AS $body$
DECLARE

					 
nr_sequencia_w		bigint;
cd_intervalo_w		varchar(7);
dt_prev_execucao_w	timestamp;
cd_material_exame_w	varchar(20);
dt_prescricao_w		timestamp;
nr_atendimento_w	bigint;
cd_convenio_w		integer;
cd_categoria_w		varchar(10);
ie_tipo_atendimento_w	smallint;
cd_estab_w		smallint;
ie_tipo_convenio_w	smallint;
cd_setor_atend_w	integer;
cd_setor_atend_ww	varchar(255);
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
ds_erro_w		varchar(255);
cd_setor_coleta_w	varchar(255);
cd_setor_entrega_w	varchar(255);
qt_dia_entrega_w	smallint;
ie_emite_mapa_w		varchar(1);
ie_data_resultado_w	varchar(1);
ds_hora_fixa_w		varchar(2);
dt_coleta_w		timestamp;
ie_amostra_w		varchar(1);
nr_seq_lab_w		varchar(20);
--nr_seq_grupo_imp_w	NUMBER(10); 
nr_seq_proc_interno_w	bigint;
nr_seq_proc_interno_aux_w bigint;
ie_gerar_sequencia_w		varchar(1);
ie_gera_amostra_coleta_w 	varchar(1);
ie_status_atend_w		smallint;
cd_plano_convenio_w		varchar(10);

BEGIN
 
IF (nr_seq_exame_p > 0) THEN 
 
	SELECT	MAX(a.nr_sequencia) 
	INTO STRICT	nr_sequencia_w 
	FROM	prescr_procedimento a 
	WHERE	a.nr_prescricao = nr_prescricao_p 
	AND		coalesce(a.nr_seq_origem,a.nr_sequencia) = nr_seq_origem_p 
	AND		a.nr_seq_exame = nr_seq_exame_p;
 
	IF (coalesce(nr_sequencia_w,0) = 0) THEN 
		 
		SELECT	coalesce(MAX(nr_sequencia),0) + 1 
		INTO STRICT	nr_sequencia_w 
		FROM	prescr_procedimento 
		WHERE 	nr_prescricao = nr_prescricao_p;
		 
		SELECT	coalesce(MAX(nr_atendimento), 0), 
			coalesce(MAX(dt_prescricao), clock_timestamp()) 
		INTO STRICT	nr_atendimento_w, 
			dt_prescricao_w 
		FROM	prescr_medica 
		WHERE	nr_prescricao = nr_prescricao_p;
		 
		IF (coalesce(nr_atendimento_w, 0) > 0) THEN 
			BEGIN 
			 
			SELECT	a.ie_tipo_convenio, 
				a.ie_tipo_atendimento, 
				b.cd_convenio, 
				b.cd_categoria, 
				a.cd_estabelecimento, 
				b.cd_plano_convenio 
			INTO STRICT	ie_tipo_convenio_w, 
				ie_tipo_atendimento_w, 
				cd_convenio_w, 
				cd_categoria_w, 
				cd_estab_w, 
				cd_plano_convenio_w 
			FROM	atend_categoria_convenio b, 
				atendimento_paciente a 
			WHERE	a.nr_atendimento	= nr_atendimento_w 
			AND	b.nr_atendimento	= a.nr_atendimento 
			AND	b.nr_seq_interno	= OBTER_ATECACO_ATENDIMENTO(A.NR_ATENDIMENTO);
			 
			EXCEPTION	 
				WHEN no_data_found THEN 
				--rai_application_error(-20011,'Faltam informações do convênio na Entrada Única.'); 
				CALL wheb_mensagem_pck.exibir_mensagem_abort(192526);
			END;
			 
			SELECT	MAX(nr_seq_proc_interno), 
				MAX(cd_material_exame) 
			INTO STRICT	nr_seq_proc_interno_w, 
				cd_material_exame_w 
			FROM	Prescr_procedimento 
			WHERE	nr_prescricao = nr_prescricao_p 
			AND	nr_sequencia = nr_seq_origem_p;
			 
			SELECT * FROM obter_exame_lab_convenio(nr_seq_exame_p, cd_convenio_w, cd_categoria_w, ie_tipo_atendimento_w, cd_estab_w, ie_tipo_convenio_w, nr_seq_proc_interno_w, cd_material_exame_w, cd_plano_convenio_w, cd_setor_atend_w, cd_procedimento_w, ie_origem_proced_w, ds_erro_w, nr_seq_proc_interno_aux_w) INTO STRICT cd_setor_atend_w, cd_procedimento_w, ie_origem_proced_w, ds_erro_w, nr_seq_proc_interno_aux_w;
						 
		END IF;
	--	obter_setor_exame_lab(	nr_prescricao_p, nr_seq_exame_w, cd_setor_atendimento_p, cd_material_exame_w, dt_coleta_w,'N', cd_setor_atend_ww, cd_setor_coleta_w, cd_setor_entrega_w, 
	--						qt_dia_entrega_w, ie_emite_mapa_w, ds_hora_fixa_w, ie_data_resultado_w); 
 
		/*SELECT 	MAX(NVL(lab_obter_grupo_imp_estab(cd_estab_w,a.nr_seq_exame, cd_convenio_w),a.nr_seq_grupo_imp)) 
		INTO	nr_seq_grupo_imp_w 
		FROM	exame_laboratorio a 
		WHERE	a.nr_seq_exame = nr_seq_exame_p;*/
 
 
		INSERT INTO prescr_procedimento( 
			nr_prescricao, nr_sequencia, cd_procedimento, qt_procedimento, dt_atualizacao, 
			nm_usuario, cd_motivo_baixa, ie_origem_proced, cd_intervalo, 
			ie_urgencia, ie_suspenso, cd_setor_atendimento, dt_prev_execucao, 
			ie_status_atend, ie_origem_inf, ie_executar_leito, ie_se_necessario, 
			ie_acm, nr_ocorrencia, ds_observacao, 
			nr_seq_interno, nr_seq_proc_interno, ie_avisar_result, nr_seq_exame, cd_material_exame, 
			ie_amostra, dt_resultado, nr_seq_lab, 
			cd_setor_coleta,cd_setor_entrega, dt_integracao, nr_seq_origem) 
		SELECT	nr_prescricao_p, nr_sequencia_w, cd_procedimento_w, 1, clock_timestamp(), 
			nm_usuario_p, 0, ie_origem_proced_w, NULL, 
			'N', 'N', a.cd_setor_atendimento, coalesce(a.dt_prev_execucao,clock_timestamp()) , 
			a.ie_status_atend, 'L','N','N', 
			'N',1, 'Fleury - Procedimento dependente gerado pela integração: '||nm_usuario_p||' em '||TO_CHAR(clock_timestamp(),'dd/mm/yyyy hh24:mi:ss'), 
			nextval('prescr_procedimento_seq'), NULL, 'N', nr_seq_exame_p, a.cd_material_exame, 
			a.ie_amostra, dt_prescricao_w + qt_dia_entrega_w, NULL, 
			a.cd_setor_coleta,a.cd_setor_entrega, a.dt_integracao, nr_seq_origem_p	 
		FROM	prescr_procedimento a 
		WHERE	nr_prescricao = nr_prescricao_p 
		AND	nr_sequencia = nr_seq_origem_p;
 
		SELECT coalesce(MAX(a.ie_gerar_sequencia),'P'), 
			coalesce(MAX(a.ie_gera_amostra_coleta),'N') 
		INTO STRICT 	ie_gerar_sequencia_w, 
			ie_gera_amostra_coleta_w	 
		FROM 	lab_parametro a, 
			prescr_medica b 
		WHERE 	a.cd_estabelecimento = b.cd_estabelecimento 
		AND	b.nr_prescricao = nr_prescricao_p;
		SELECT 	MAX(ie_status_atend) 
		INTO STRICT	ie_status_atend_w 
		FROM 	prescr_procedimento 
		WHERE	nr_prescricao 	= nr_prescricao_p 
		AND	nr_sequencia	= nr_seq_origem_p;
		 
		CALL Gerar_Prescr_Proc_Seq_Lab(nr_prescricao_p, nm_usuario_p, 'P');
		 
		IF 	((ie_gerar_sequencia_w <> 'C') OR (ie_gera_amostra_coleta_w <> 'S')) OR 
			((ie_gerar_sequencia_w = 'C') AND (ie_gera_amostra_coleta_w = 'S') AND (ie_status_atend_w >= 20)) THEN 
			CALL gerar_prescr_proc_mat_item(nr_prescricao_p, nm_usuario_p, cd_estab_w);
		END IF;
	end if;
	 
	nr_sequencia_p	:= nr_sequencia_w;
 
END IF;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fleury_lab_duplic_exame_interf ( nr_prescricao_p bigint, nr_seq_origem_p bigint, nr_seq_exame_p text, nm_usuario_p text, nr_sequencia_p INOUT bigint) FROM PUBLIC;
