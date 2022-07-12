-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE execucao_prescricao_pck.material_atend_pac_new_record ( nr_atendimento_p INOUT bigint, dt_atendimento_p INOUT timestamp, dt_entrada_unidade_p INOUT timestamp, nr_seq_atepacu_p INOUT bigint, cd_setor_atendimento_p INOUT bigint, cd_convenio_p INOUT bigint, cd_categoria_p INOUT text, nr_doc_convenio_p INOUT text, ie_tipo_guia_p INOUT text, cd_senha_p INOUT text, cd_acao_p INOUT text, vl_unitario_p INOUT bigint, qt_ajuste_conta_p INOUT bigint, ie_valor_informado_p INOUT text, ie_guia_informada_p INOUT text, ie_auditoria_p INOUT text, nm_usuario_original_p INOUT text, nr_seq_proc_princ_p INOUT bigint, cd_situacao_glosa_p INOUT bigint, dt_conta_p INOUT timestamp, nr_sequencia_p bigint, cd_convenio_wlcb_p bigint, nr_seq_proc_chamada_p bigint, cd_categoria_wlcb_p text, cd_material_p bigint, ie_barras_p text, dt_alta_p timestamp, dt_atend_barras_p timestamp, dt_fim_auditoria_p timestamp, nm_usuario_p text, ie_erro_p INOUT text) AS $body$
BEGIN
	
	obter_param_usuario(24, 2, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, current_setting('execucao_prescricao_pck.ie_parametro_2_w')::varchar(1));
	obter_param_usuario(24, 12, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, current_setting('execucao_prescricao_pck.ie_parametro_12_w')::varchar(1));
	obter_param_usuario(24, 224, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, current_setting('execucao_prescricao_pck.ie_parametro_224_w')::varchar(1));
	obter_param_usuario(24, 55, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, current_setting('execucao_prescricao_pck.ie_parametro_55_w')::varchar(255));
		
	if (current_setting('execucao_prescricao_pck.ie_parametro_2_w')::varchar(1) = 'E') then
		CALL execucao_prescricao_pck.gerar_w_execucao_proc_mat(nr_atendimento_p, wheb_mensagem_pck.get_texto(180015), wheb_mensagem_pck.get_texto(1046161, 'NR_PARAMETRO='||'2;DS_REGRA='||''), 'S', null, cd_material_p, null, nm_usuario_p);
		ie_erro_p := 'S';
		goto Final;
	elsif (current_setting('execucao_prescricao_pck.ie_parametro_2_w')::varchar(1) = 'EB') and (ie_barras_p = 'S') then
		CALL execucao_prescricao_pck.gerar_w_execucao_proc_mat(nr_atendimento_p, wheb_mensagem_pck.get_texto(180017), wheb_mensagem_pck.get_texto(1046161, 'NR_PARAMETRO='||'2;DS_REGRA='||''), 'S', null, cd_material_p, null, nm_usuario_p);
		ie_erro_p := 'S';
		goto Final;
	elsif (current_setting('execucao_prescricao_pck.ie_parametro_12_w')::varchar(1) = 'P') and (dt_alta_p IS NOT NULL AND dt_alta_p::text <> '')then
		CALL execucao_prescricao_pck.gerar_w_execucao_proc_mat(nr_atendimento_p, wheb_mensagem_pck.get_texto(180018), wheb_mensagem_pck.get_texto(1046161, 'NR_PARAMETRO='||'12;DS_REGRA='||''), 'S', null, cd_material_p, null, nm_usuario_p);
		ie_erro_p := 'S';
		goto Final;
	end if;
	
	dt_atendimento_p := clock_timestamp();
	if (ie_barras_p = 'S') then
		dt_atendimento_p := dt_atend_barras_p;
	end if;
	nr_atendimento_p 		:= nr_atendimento_p;
	dt_entrada_unidade_p 	:= dt_entrada_unidade_p;
	nr_seq_atepacu_p		:= nr_seq_atepacu_p;
	cd_setor_atendimento_p	:= cd_setor_atendimento_p;
	cd_acao_p				:= '1';
	vl_unitario_p			:= 0;
	qt_ajuste_conta_p		:= 0;
	ie_valor_informado_p	:= 'N';
	ie_guia_informada_p		:= 'N';
	ie_auditoria_p			:= 'N';
	nm_usuario_original_p	:= nm_usuario_p;
	cd_situacao_glosa_p		:= 0;
	
	obter_convenio_execucao(
					nr_atendimento_p,
					dt_atendimento_p,
					cd_convenio_p,
					cd_categoria_p,
					nr_doc_convenio_p,
					ie_tipo_guia_p,
					cd_senha_p);
	
	if (current_setting('execucao_prescricao_pck.ie_parametro_224_w')::varchar(1) = 'S') and (cd_convenio_wlcb_p IS NOT NULL AND cd_convenio_wlcb_p::text <> '') and (cd_categoria_wlcb_p IS NOT NULL AND cd_categoria_wlcb_p::text <> '') then
		cd_convenio_p	:= cd_convenio_wlcb_p;
		cd_categoria_p	:= cd_categoria_wlcb_p;
	end if;
	
	dt_conta_p := null;
	
	if (dt_fim_auditoria_p IS NOT NULL AND dt_fim_auditoria_p::text <> '') then
		dt_atendimento_p	:= dt_fim_auditoria_p;
		dt_conta_p			:= dt_fim_auditoria_p;
	end if;
	
	if (current_setting('execucao_prescricao_pck.ie_parametro_55_w')::varchar(255) = 'S') then
		select	max(a.dt_alta)
		into STRICT	current_setting('execucao_prescricao_pck.dt_param_w')::timestamp
		from	atendimento_paciente a
		where	a.nr_atendimento = nr_atendimento_p;
		if (current_setting('execucao_prescricao_pck.dt_param_w')::(timestamp IS NOT NULL AND timestamp::text <> '')) then
			dt_atendimento_p := current_setting('execucao_prescricao_pck.dt_param_w')::timestamp;
		end if;
	end if;
	
	if (current_setting('execucao_prescricao_pck.ie_parametro_265_w')::varchar(1) = 'S') and (nr_seq_proc_chamada_p > 0) then
		select	count(1)
		into STRICT	current_setting('execucao_prescricao_pck.qt_existe_w')::bigint
		from	procedimento_paciente
		where	nr_sequencia = nr_sequencia_p
		and		nr_atendimento = nr_atendimento_p
		and		cd_setor_atendimento = cd_setor_atendimento_p
		and		coalesce(nr_seq_proc_pacote, 0) <> nr_sequencia;
		
		if (current_setting('execucao_prescricao_pck.qt_existe_w')::bigint > 0) then
			nr_seq_proc_princ_p := nr_seq_proc_chamada_p;
		end if;
	
	
	end if;	
	
	<<Final>>
	
	PERFORM set_config('execucao_prescricao_pck.qt_existe_w', 0, false);
	
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE execucao_prescricao_pck.material_atend_pac_new_record ( nr_atendimento_p INOUT bigint, dt_atendimento_p INOUT timestamp, dt_entrada_unidade_p INOUT timestamp, nr_seq_atepacu_p INOUT bigint, cd_setor_atendimento_p INOUT bigint, cd_convenio_p INOUT bigint, cd_categoria_p INOUT text, nr_doc_convenio_p INOUT text, ie_tipo_guia_p INOUT text, cd_senha_p INOUT text, cd_acao_p INOUT text, vl_unitario_p INOUT bigint, qt_ajuste_conta_p INOUT bigint, ie_valor_informado_p INOUT text, ie_guia_informada_p INOUT text, ie_auditoria_p INOUT text, nm_usuario_original_p INOUT text, nr_seq_proc_princ_p INOUT bigint, cd_situacao_glosa_p INOUT bigint, dt_conta_p INOUT timestamp, nr_sequencia_p bigint, cd_convenio_wlcb_p bigint, nr_seq_proc_chamada_p bigint, cd_categoria_wlcb_p text, cd_material_p bigint, ie_barras_p text, dt_alta_p timestamp, dt_atend_barras_p timestamp, dt_fim_auditoria_p timestamp, nm_usuario_p text, ie_erro_p INOUT text) FROM PUBLIC;