-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lote_ent_incluir_ficha_ad (nr_seq_lote_sec_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_ficha_p bigint) AS $body$
DECLARE

			 
 
cd_pessoa_fisica_resp_w	varchar(10);			
cd_procedencia_w	integer;
nr_atendimento_w	bigint;
nr_prescricao_w		bigint;
nr_seq_ficha_w		bigint;
cd_pessoa_fisica_w	varchar(10);
nr_seq_exame_w		bigint;
nr_seq_proc_interno_w	bigint;
ie_origem_proced_w	bigint;
cd_procedimento_w	bigint;
nr_seq_prescr_proc_w	integer;
dt_entrada_w		timestamp;
cd_convenio_w		atend_categoria_convenio.cd_convenio%type;
cd_categoria_w		atend_categoria_convenio.cd_categoria%type;
cd_plano_convenio_w	atend_categoria_convenio.cd_plano_convenio%type;
--cd_tipo_acomodacao_w	atend_categoria_convenio.cd_tipo_acomodacao%type; 
cd_setor_atendimento_w	setor_atendimento.cd_setor_atendimento%type;
nr_seq_forma_laudo_w	lote_ent_inst_geracao.nr_seq_forma_laudo%type;
ie_tipo_convenio_w	lote_ent_inst_geracao.ie_tipo_convenio%type;
dt_coleta_w				timestamp;
ie_status_coleta_w	smallint;
ie_amostra_inadequada_w	varchar(2);
contador_lote_w		integer;
contador_ficha_w	integer;
ds_erro_w			varchar(255);
ie_medico_w			varchar(2);
cd_material_exame_w	varchar(20);
cd_unidade_basica_w	varchar(10);
cd_unidade_compl_w	varchar(10);
nr_seq_prescr_procc_w	integer;
nr_seq_pacote_w		bigint;

nr_atend_ficha_w 	bigint;
nr_prescr_ficha_w	bigint;
cd_tipo_acomod_w	lote_ent_inst_geracao.cd_tipo_acomodacao%type;

cd_proced_pacote_w		bigint;
ie_origem_proced_pac_w	bigint;
ie_ficha_urg_w varchar(1);

C01 CURSOR FOR 
	SELECT	nr_sequencia, 
     cd_pessoa_fisica, 
     cd_medico_resp, 
     coalesce(to_date(to_char(DT_COLETA_FICHA_F, 'dd/mm/yyyy') || to_char(HR_COLETA_F, 'hh24:mi'),'dd/mm/yyyy hh24:mi'),clock_timestamp()), 
     ie_susp_am_inad, 
     IE_FICHA_URG 
	from	lote_ent_sec_ficha 
	where	nr_seq_lote_sec = nr_seq_lote_sec_p 
	and		nr_sequencia = nr_seq_ficha_p;			
	 
C02 CURSOR FOR 
	SELECT	nr_seq_exame 
	from	lote_ent_sec_ficha_exam 
	where	nr_seq_ficha = nr_seq_ficha_w 
	and		coalesce(ie_tipo_coleta::text, '') = '';
	

BEGIN 
 
select	max(ie_status_coleta) 
into STRICT	ie_status_coleta_w 
from	lab_parametro 
where	cd_estabelecimento = cd_estabelecimento_p;
 
select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
into STRICT	ie_medico_w 
from	medico a, 
		usuario b 
where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica 
and		b.nm_usuario		= nm_usuario_p 
and		a.ie_situacao		= 'A';
 
SELECT	max(nr_seq_pacote) 
INTO STRICT 	nr_seq_pacote_w 
FROM	lote_ent_secretaria b 
WHERE	b.nr_sequencia = nr_seq_lote_sec_p;
 
if (nr_seq_lote_sec_p IS NOT NULL AND nr_seq_lote_sec_p::text <> '') then 
	 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_ficha_w, 
		cd_pessoa_fisica_w, 
		cd_pessoa_fisica_resp_w, 
		dt_coleta_w, 
		ie_amostra_inadequada_w, 
  ie_ficha_urg_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		 
		select	coalesce(max(nr_atendimento),0), 
		coalesce(max(nr_prescricao),0) 
		into STRICT	nr_atend_ficha_w, 
				nr_prescr_ficha_w 
		from	lote_ent_sec_ficha 
		where	nr_sequencia = nr_seq_ficha_w;
		 
		if (nr_atend_ficha_w = 0 AND nr_prescr_ficha_w = 0) then 
			 
			dt_entrada_w	:= clock_timestamp();
					 
			--Verifica se possui ocorrências para o lote / ficha 
			SELECT	COUNT(*) 
			INTO STRICT 	contador_lote_w 
			FROM	lote_ent_ocorrencia a, 
					lote_ent_secretaria b 
			WHERE	b.nr_sequencia = a.nr_seq_lote_sec 
			AND		b.nr_sequencia = nr_seq_lote_sec_p;
			 
			SELECT 	COUNT(*) 
			INTO STRICT	contador_ficha_w 
			FROM	lote_ent_ocorrencia a, 
					lote_ent_sec_ficha b 
			WHERE	a.nr_seq_ficha = b.nr_sequencia 
			AND		a.nr_seq_ficha = nr_seq_ficha_w;
 
			if ((contador_lote_w > 0) or (contador_ficha_w > 0)) then 
 
				if (contador_lote_w > 0) then 
				 
					update	lote_ent_ocorrencia 
					set		dt_baixa = clock_timestamp(), 
							nm_usuario_baixa = nm_usuario_p 
					where	nr_seq_lote_sec = nr_seq_lote_sec_p;
					 
				end if;
				 
				if (contador_ficha_w > 0) then 
				 
					update	lote_ent_ocorrencia 
					set		dt_baixa = clock_timestamp(), 
							nm_usuario_baixa = nm_usuario_p 
					where	nr_seq_ficha = nr_seq_ficha_w;
				 
				end if;
				 
			end if;
			 
			-- 
			select	max(c.cd_convenio), 
					max(c.cd_categoria), 
					max(c.cd_plano_convenio), 
					max(c.cd_setor_atendimento), 
					max(cd_procedencia), 
					max(c.cd_medico_resp), 
					max(c.nr_seq_forma_laudo), 
					max(c.cd_unidade_basica), 
					max(c.cd_unidade_compl), 
					max(c.ie_tipo_convenio), 
					max(c.cd_tipo_acomodacao) 
			into STRICT	cd_convenio_w, 
					cd_categoria_w, 
					cd_plano_convenio_w, 
					cd_setor_atendimento_w, 
					cd_procedencia_w, 
					cd_pessoa_fisica_resp_w, 
					nr_seq_forma_laudo_w, 
					cd_unidade_basica_w, 
					cd_unidade_compl_w, 
					ie_tipo_convenio_w, 
					cd_tipo_acomod_w 
			from	lote_ent_secretaria a,			 
					lote_ent_inst_geracao c 
			where	a.nr_seq_instituicao = c.nr_seq_instituicao 
			and		a.nr_sequencia = nr_seq_lote_sec_p;
			 
			--Insere o atendimento 
			select	nextval('atendimento_paciente_seq') 
			into STRICT	nr_atendimento_w 
			;
			 
			insert into atendimento_paciente( 
				nr_atendimento, 
				ie_permite_visita, 
				dt_entrada, 
				ie_tipo_atendimento, 
				cd_procedencia, 
				cd_medico_resp, 
				cd_pessoa_fisica, 
				cd_estabelecimento, 
				dt_atualizacao, 
				nm_usuario, 
				nr_seq_ficha_lote, 
				ie_tipo_convenio 
			) values ( 
				nr_atendimento_w, 
				'S', 
				dt_entrada_w, 
				7, 
				cd_procedencia_w, 
				cd_pessoa_fisica_resp_w, 
				cd_pessoa_fisica_w, 
				cd_estabelecimento_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				nr_seq_ficha_w, 
				ie_tipo_convenio_w 
			);
		 
			insert into atend_categoria_convenio( 
				nr_seq_interno, 
				nr_atendimento, 
				cd_convenio, 
				cd_categoria, 
				cd_plano_convenio, 
				--cd_tipo_acomodacao, 
				--cd_usuario_convenio, 
				dt_validade_carteira, 
				dt_inicio_vigencia, 
				ie_tipo_guia, 
				nm_usuario, 
				dt_atualizacao, 
				nr_doc_convenio, 
				cd_tipo_acomodacao 
			) values ( 
				nextval('atend_categoria_convenio_seq'), 
				nr_atendimento_w, 
				cd_convenio_w, -- 
				cd_categoria_w, -- 
				cd_plano_convenio_w, -- 
				--cd_tipo_acomodacao_w, -- 
				--nvl(cd_usuario_convenio_w,123), 
				dt_entrada_w+365, 
				dt_entrada_w, 
				'L', 
				nm_usuario_p, 
				clock_timestamp(), 
				nr_atendimento_w, 
				cd_tipo_acomod_w 
			);
 
			--insere a unidade		 
			insert into atend_paciente_unidade( 
					nr_atendimento, 
					nr_sequencia, 
					cd_setor_atendimento, 
					cd_unidade_basica, 
					cd_unidade_compl, 
					dt_entrada_unidade, 
					dt_saida_interno, 
					nr_seq_interno, 
					dt_atualizacao, 
					dt_atualizacao_nrec, 
					nm_usuario, 
					nm_usuario_nrec, 
					cd_tipo_acomodacao 
			) values ( 
					nr_atendimento_w, 
					1, 
					cd_setor_atendimento_w, 
					cd_unidade_basica_w, 
					cd_unidade_compl_w, 
					clock_timestamp(), 
					clock_timestamp(), 
					nextval('atend_paciente_unidade_seq'), 
					clock_timestamp(), 
					clock_timestamp(), 
					'Tasy', 
					'Tasy', 
					2 
			);
 
			--Insere a prescrição 
			select	nextval('prescr_medica_seq') 
			into STRICT	nr_prescricao_w 
			;
			 
			insert into prescr_medica( 
				nr_prescricao, 
				cd_pessoa_fisica, 
				dt_prescricao, 
				dt_atualizacao, 
				nm_usuario, 
				nr_atendimento, 
				nr_seq_ficha_lote, 
				nr_seq_lote_entrada, 
				cd_estabelecimento, 
				cd_medico, 
				cd_setor_entrega, 
				nr_seq_forma_laudo 
			) values ( 
				nr_prescricao_w, 
				cd_pessoa_fisica_w, 
				clock_timestamp(), 
				clock_timestamp(), 
				nm_usuario_p, 
				nr_atendimento_w, 
				nr_seq_ficha_w, 
				nr_seq_lote_sec_p, 
				cd_estabelecimento_p, 
				cd_pessoa_fisica_resp_w, 
				cd_setor_atendimento_w, 
				nr_seq_forma_laudo_w 
			);		
		 
			update	lote_ent_sec_ficha 
			set		nr_prescricao = nr_prescricao_w, nr_atendimento = nr_atendimento_w 
			where	nr_sequencia = nr_seq_ficha_w;
			-- Insere os procedimentos da prescrição 
		 
			open C02;
			loop 
			fetch C02 into	 
				nr_seq_exame_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin 
				select	max(nr_seq_proc_interno), 
						max(ie_origem_proced), 
						max(cd_procedimento) 
				into STRICT	nr_seq_proc_interno_w, 
						ie_origem_proced_w, 
						cd_procedimento_w 
				from	exame_laboratorio 
				where	nr_seq_exame = nr_seq_exame_w;
				 
				select	coalesce(max(nr_sequencia), 0) + 1 
				into STRICT	nr_seq_prescr_proc_w 
				from	prescr_procedimento 
				where	nr_prescricao	= nr_prescricao_w;
				 
				SELECT 	MAX(b.cd_material_exame) 
				into STRICT	cd_material_exame_w 
				FROM	material_exame_lab b, 
						exame_lab_material a 
				WHERE 	a.nr_seq_material	= b.nr_sequencia 
				AND 	a.nr_seq_exame		= nr_seq_exame_w 
				AND 	a.ie_situacao		= 'A' 
				ORDER BY a.ie_prioridade;
 
				insert into prescr_procedimento(	 
					nr_sequencia, 
					cd_procedimento, 
					qt_procedimento, 
					nr_prescricao, 
					dt_atualizacao, 
					nm_usuario, 
					ie_origem_inf, 
					nr_seq_proc_interno, 
					ie_origem_proced, 
					nr_seq_interno, 
					nr_seq_exame, 
					dt_coleta, 
					dt_prev_execucao, 
					ie_status_atend, 
					cd_setor_atendimento, 
					cd_motivo_baixa, 
					cd_material_exame, 
					ie_suspenso, 
     ie_urgencia 
				) values ( 
					nr_seq_prescr_proc_w, 
					cd_procedimento_w, 
					1, 
					nr_prescricao_w, 
					clock_timestamp(), 
					nm_usuario_p, 
					'1', 
					nr_seq_proc_interno_w, 
					ie_origem_proced_w, 
					nextval('prescr_procedimento_seq'), 
					nr_seq_exame_w, 
					coalesce(dt_coleta_w,clock_timestamp()), 
					Obter_data_prev_exec(clock_timestamp(), clock_timestamp(), cd_setor_atendimento_w, nr_prescricao_w, 'A'), 
					CASE WHEN ie_amostra_inadequada_w='S' THEN '23'  ELSE ie_status_coleta_w END , 
					cd_setor_atendimento_w, 
					0, 
					cd_material_exame_w, 
					'N', 
     case ie_ficha_urg_w when 'S' then 'S' else 'N' end 
				);
							 
				end;
			end loop;
			close C02;
			 
			SELECT 	max(a.cd_proced_pacote), 
					max(a.ie_origem_proced) 
			into STRICT	cd_proced_pacote_w, 
					ie_origem_proced_pac_w 
			FROM	pacote a 
			WHERE	a.nr_seq_pacote = nr_seq_pacote_w;
 
			select	coalesce(max(nr_sequencia), 0) + 1 
			into STRICT	nr_seq_prescr_procc_w 
			from	prescr_procedimento 
			where	nr_prescricao	= nr_prescricao_w;
 
			if (cd_proced_pacote_w IS NOT NULL AND cd_proced_pacote_w::text <> '')	then 
				insert into prescr_procedimento( 
					nr_sequencia, 
					cd_procedimento, 
					qt_procedimento, 
					nr_prescricao, 
					dt_atualizacao, 
					nm_usuario, 
					ie_origem_inf, 
					ie_origem_proced, 
					nr_seq_interno, 
					cd_setor_atendimento, 
					ie_suspenso, 
					ie_status_atend, 
					dt_prev_execucao, 
     ie_urgencia 
				) values ( 
					nr_seq_prescr_procc_w, 
					cd_proced_pacote_w, 
					1, 
					nr_prescricao_w, 
					clock_timestamp(), 
					nm_usuario_p, 
					'1', 
					ie_origem_proced_pac_w, 
					nextval('prescr_procedimento_seq'), 
					cd_setor_atendimento_w, 
					'N', 
					CASE WHEN ie_amostra_inadequada_w='S' THEN '23'  ELSE ie_status_coleta_w END , 
					Obter_data_prev_exec(clock_timestamp(), clock_timestamp(), cd_setor_atendimento_w, nr_prescricao_w, 'A'), 
     case ie_ficha_urg_w when 'S' then 'S' else 'N' end 
				);
			end if;
 
			ds_erro_w := Liberar_Prescricao(nr_prescricao_w, nr_atendimento_w, ie_medico_w, Obter_Perfil_Ativo, nm_usuario_p, 'S', ds_erro_w);
 
		end if;
			 
		end;
	end loop;
	close C01;
	 
	update	lote_ent_secretaria 
	set		dt_liberacao = clock_timestamp() 
	where	nr_sequencia = nr_seq_lote_sec_p;
	 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lote_ent_incluir_ficha_ad (nr_seq_lote_sec_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_ficha_p bigint) FROM PUBLIC;

