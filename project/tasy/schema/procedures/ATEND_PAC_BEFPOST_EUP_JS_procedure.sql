-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atend_pac_befpost_eup_js ( nm_medico_externo_p text, crm_medico_externo_p text, ie_carater_inter_sus_p text, nr_seq_queixa_p bigint, nr_seq_classif_medico_p bigint, ie_completo_p text, ie_tipo_atend_old_p bigint, ds_senha_p text, cd_pessoa_resp_old_p text, dt_chegada_paciente_p timestamp, dt_recebimento_senha_p timestamp, nr_atend_original_p bigint, dt_atend_original_p timestamp, dt_entrada_p timestamp, ie_responsavel_p text, nr_seq_indicacao_p bigint, nr_atend_origem_pa_p bigint, cd_procedencia_p bigint, ie_novo_p text, ie_tipo_convenio_p bigint, dt_alta_p timestamp, ie_tipo_atend_tiss_p bigint, nr_atendimento_p bigint, cd_setor_usuario_p bigint, nr_seq_regra_funcao_atual_p bigint, nr_seq_regra_funcao_p bigint, cd_pessoa_fisica_p text, cd_tipo_agenda_p bigint, nr_seq_agenda_p bigint, cd_pessoa_responsavel_p text, cd_medico_referido_p text, ie_tipo_atendimento_p bigint, ie_clinica_p bigint, nr_seq_classificacao_p bigint, ie_modo_edicao_novo_p text, ie_modo_edicao_p text, cd_medico_resp_p text, cd_medico_resp_old_p text, nm_usuario_p text, ds_msg_erro_p INOUT text, ds_msg_erro_cancel_p INOUT text, ds_msg_atend_orig_fat_p INOUT text, ds_msg_alerta_cpf_resp_p INOUT text, ds_msg_alerta_senha_p INOUT text, ds_msg_alerta_dt_chegada_p INOUT text, ds_msg_alerta_cons_conv_p INOUT text, ds_msg_confir_inf_resp_p INOUT text, ds_msg_conf_atend_alta_p INOUT text, ie_opcao_alerta_p INOUT text, ds_mensagem_comun_p INOUT text, cd_perfil_p INOUT text, ds_retorno_senha_p INOUT text, ds_msg_confirm_reinternacao_p INOUT text, ds_msg_alerta_isol_p INOUT text, ds_msg_alerta_atend_ps_p INOUT text, ds_msg_classif_medico_p INOUT text, ie_atend_setor_p INOUT text, ds_msg_email_p INOUT text, nr_seq_queixa_ret_p INOUT bigint, ds_queixa_p INOUT text, ds_msg_alerta_tit_venc_p INOUT text, ds_msg_alerta_med_ext_p INOUT text, ds_msg_alerta_crend_mdic_p INOUT text, ds_msg_carater_atend_p INOUT text) AS $body$
DECLARE


cd_estabelecimento_w	smallint;
ie_perm_alt_medico_resp_w	varchar(1);
ie_consistir_classif_atend_w	varchar(1);
ie_resp_sem_cpf_w		varchar(1);
ie_resp_menor_idade_w		varchar(1);
ie_exige_resp_atend_intern_w	varchar(1);
ie_resp_nao_medico_w		varchar(1);
ie_considerar_regra_atual_w	varchar(1);
ie_consis_credenc_medico_w	varchar(1);
qt_idade_min_cons_cpf_w		bigint;
ds_msg_erro_w			varchar(255);
ds_msg_erro_cancel_w		varchar(255);
ie_qt_max_min_idade_w		varchar(10);
ie_vinculo_medico_inst_w	varchar(30);
ie_novo_atend_alta_anterior_w	varchar(3);
ie_forma_consist_credenc_med_w	varchar(1);
ie_consis_medico_tipo_atend_w	varchar(1);
ie_consis_tipo_convenio_w	varchar(1);
ie_consis_medico_estab_w	varchar(1);
ie_verifica_atend_vali_w	varchar(1);
ie_proced_atend_pa_w		varchar(60);
ie_classif_obriga_indic_w	varchar(60);
ie_permite_resp_paciente_w	varchar(1);
ie_obriga_resp_w		varchar(1);
ie_permite_atend_orig_fat_w	varchar(1);
ie_status_acerto_w		smallint;
ds_msg_atend_orig_fat_w		varchar(255);
ie_exige_cpf_resp_w		varchar(1);
ds_msg_alerta_cpf_resp_w	varchar(255);
ds_msg_alerta_senha_w		varchar(255);
ie_perm_dt_senha_sup_atend_w	varchar(1);
ie_perm_dt_real_w		varchar(1);
ds_msg_alerta_dt_chegada_w	varchar(255);
ie_consiste_regra_atend_conv_w	varchar(1);
ie_alerta_menor_sem_resp_w	varchar(1);
ie_opcao_alerta_w		varchar(5) := 'S';
ds_mensagem_comun_w		varchar(255);
cd_perfil_w			bigint := null;
cd_pessoa_aviso_w		varchar(10) := null;
ds_retorno_senha_w		varchar(20);
qt_dias_internacao_w		bigint;
ie_data_reinternacao_w		varchar(2);
qt_dias_interncao_w		bigint;
ie_tipo_atend_isolam_w		varchar(60);
nr_atend_isol_w			bigint;
ie_gerar_alerta_w		varchar(1);
ds_motivo_isol_w		varchar(255);
qt_dias_alerta_ps_w		bigint;
dt_entrada_ps_w			timestamp;
nr_atend_ps_w			bigint;
dt_alta_ps_w			timestamp;
ie_atualiza_medico_conta_w	varchar(1);
ie_cons_email_conv_part_w	varchar(1);
ie_obriga_classif_medico_w	varchar(1);
ie_email_w			varchar(1);
ie_permite_setor_null_w		varchar(1);
ie_nr_seq_queixa_w		bigint := 0;
nr_seq_queixa_w			bigint;
ie_valor_pend_estab_w		varchar(1);
ei_carat_perm_atend_tit_venc_w	varchar(60);
ie_perm_novo_tit_aberto_w	varchar(3);
ie_cd_medico_ext_w		varchar(60);
ie_consiste_medico_ext_w	varchar(1);
cd_msg_medico_ext_w		bigint;
ie_exige_med_ext_w		varchar(1);
ie_tipo_senha_w regra_senha_atend.ie_tipo_senha%type;
ds_senha_antiga_w atendimento_paciente.ds_senha%type;
nr_seq_episodio_w atendimento_paciente.nr_seq_episodio%type;
ie_case	varchar(1);


BEGIN

/* Esta procedure é geral para o evento BeforePost,;
Para verificações que retornam abort utilizar atend_pac_befpost_abort_eup
para verificações que retonar mensagem que necessitam de confirmação do usuário utilizar atend_pac_befpost_conf_eup_js
A variavel ds_msg_erro é utlizada para verificar se irá apresentar uma msg que aborta a execução por isso é necessário sempre verificá-la

*/
cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;
ie_novo_atend_alta_anterior_w := Obter_param_Usuario(916, 16, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_novo_atend_alta_anterior_w);
ie_alerta_menor_sem_resp_w := Obter_param_Usuario(916, 89, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_alerta_menor_sem_resp_w);
qt_dias_internacao_w := Obter_param_Usuario(916, 99, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, qt_dias_internacao_w);
ie_cd_medico_ext_w := Obter_param_Usuario(916, 125, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_cd_medico_ext_w);
ie_consiste_regra_atend_conv_w := Obter_param_Usuario(916, 141, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_consiste_regra_atend_conv_w);
ie_qt_max_min_idade_w := Obter_param_Usuario(916, 151, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_qt_max_min_idade_w);
ie_vinculo_medico_inst_w := Obter_param_Usuario(916, 167, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_vinculo_medico_inst_w);
ie_consis_medico_tipo_atend_w := Obter_param_Usuario(916, 265, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_consis_medico_tipo_atend_w);
ie_consis_tipo_convenio_w := Obter_param_Usuario(916, 279, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_consis_tipo_convenio_w);
ie_nr_seq_queixa_w := Obter_param_Usuario(916, 293, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_nr_seq_queixa_w);
ie_perm_dt_senha_sup_atend_w := Obter_param_Usuario(916, 359, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_perm_dt_senha_sup_atend_w);
ie_permite_atend_orig_fat_w := Obter_param_Usuario(916, 360, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_permite_atend_orig_fat_w);
ie_resp_sem_cpf_w := Obter_param_Usuario(916, 368, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_resp_sem_cpf_w);

insert into log_mov(dt_atualizacao, nm_usuario, ds_log, cd_log) values (clock_timestamp(), 'Teste', '1-'||ie_resp_sem_cpf_w||'/2-'||cd_estabelecimento_w
||'/3-'||nm_usuario_p||'/4-'||obter_perfil_ativo||'/5-'||nr_atendimento_p,889988);
commit;

ie_resp_menor_idade_w := Obter_param_Usuario(916, 387, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_resp_menor_idade_w);
ie_data_reinternacao_w := Obter_param_Usuario(916, 397, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_data_reinternacao_w);
qt_dias_interncao_w := Obter_param_Usuario(916, 400, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, qt_dias_interncao_w);
ie_considerar_regra_atual_w := Obter_param_Usuario(916, 403, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_considerar_regra_atual_w);
qt_dias_alerta_ps_w := Obter_param_Usuario(916, 448, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, qt_dias_alerta_ps_w);
ie_perm_alt_medico_resp_w := Obter_param_Usuario(916, 500, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_perm_alt_medico_resp_w);
ie_consistir_classif_atend_w := Obter_param_Usuario(916, 621, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_consistir_classif_atend_w);
ie_consis_medico_estab_w := Obter_param_Usuario(916, 657, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_consis_medico_estab_w);
ie_permite_setor_null_w := Obter_param_Usuario(916, 668, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_permite_setor_null_w);
ie_perm_dt_real_w := Obter_param_Usuario(916, 703, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_perm_dt_real_w);
ie_obriga_classif_medico_w := Obter_param_Usuario(916, 730, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_obriga_classif_medico_w);
ie_atualiza_medico_conta_w := Obter_param_Usuario(916, 748, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_atualiza_medico_conta_w);
ie_verifica_atend_vali_w := Obter_param_Usuario(916, 767, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_verifica_atend_vali_w);
ie_proced_atend_pa_w := Obter_param_Usuario(916, 772, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_proced_atend_pa_w);
ie_resp_nao_medico_w := Obter_param_Usuario(916, 789, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_resp_nao_medico_w);
ie_classif_obriga_indic_w := Obter_param_Usuario(916, 803, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_classif_obriga_indic_w);
ie_exige_resp_atend_intern_w := Obter_param_Usuario(916, 817, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_exige_resp_atend_intern_w);
qt_idade_min_cons_cpf_w := Obter_param_Usuario(916, 896, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, qt_idade_min_cons_cpf_w);
ie_exige_cpf_resp_w := Obter_param_Usuario(916, 950, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_exige_cpf_resp_w);
ie_permite_resp_paciente_w := Obter_param_Usuario(916, 974, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_permite_resp_paciente_w);
ie_cons_email_conv_part_w := Obter_param_Usuario(916, 989, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_cons_email_conv_part_w);
ie_perm_novo_tit_aberto_w := Obter_param_Usuario(916, 1026, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_perm_novo_tit_aberto_w);
ie_obriga_resp_w := Obter_param_Usuario(916, 1051, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_obriga_resp_w);
ie_exige_med_ext_w := Obter_param_Usuario(916, 1056, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_exige_med_ext_w);
ei_carat_perm_atend_tit_venc_w := Obter_param_Usuario(916, 1060, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ei_carat_perm_atend_tit_venc_w);
ie_consiste_medico_ext_w := Obter_param_Usuario(916, 1064, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_consiste_medico_ext_w);
ie_tipo_atend_isolam_w := Obter_param_Usuario(916, 1097, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_tipo_atend_isolam_w);
ie_forma_consist_credenc_med_w := Obter_param_Usuario(916, 1118, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_forma_consist_credenc_med_w);

ie_valor_pend_estab_w := Obter_param_Usuario(-815, 2, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_valor_pend_estab_w);


SELECT * FROM atend_pac_befpost_abort_eup(dt_entrada_p, ie_responsavel_p, ie_obriga_resp_w, ie_permite_resp_paciente_w, nr_seq_indicacao_p, ie_classif_obriga_indic_w, ie_proced_atend_pa_w, nr_atend_origem_pa_p, ie_verifica_atend_vali_w, ie_consis_medico_estab_w, cd_procedencia_p, ie_novo_p, ie_tipo_convenio_p, ie_consis_tipo_convenio_w, ie_consis_medico_tipo_atend_w, ie_tipo_atend_tiss_p, nr_atendimento_p, ie_novo_atend_alta_anterior_w, ie_vinculo_medico_inst_w, cd_setor_usuario_p, ie_considerar_regra_atual_w, nr_seq_regra_funcao_atual_p, nr_seq_regra_funcao_p, ie_resp_nao_medico_w, ie_exige_resp_atend_intern_w, ie_qt_max_min_idade_w, cd_pessoa_fisica_p, cd_tipo_agenda_p, nr_seq_agenda_p, ie_resp_menor_idade_w, qt_idade_min_cons_cpf_w, cd_pessoa_responsavel_p, ie_resp_sem_cpf_w, cd_medico_referido_p, ie_tipo_atendimento_p, cd_estabelecimento_w, ie_clinica_p, nr_seq_classificacao_p, ie_modo_edicao_novo_p, ie_consistir_classif_atend_w, ie_modo_edicao_p, nm_usuario_p, cd_medico_resp_p, cd_medico_resp_old_p, ie_perm_alt_medico_resp_w, ds_msg_erro_w, ds_msg_erro_cancel_w) INTO STRICT ds_msg_erro_w, ds_msg_erro_cancel_w;

CALL cons_regra_clinica_espec(ie_tipo_atendimento_p, ie_clinica_p, cd_medico_resp_p, nm_usuario_p);

if (ds_msg_erro_w IS NOT NULL AND ds_msg_erro_w::text <> '') then
	goto final;
end if;
	SELECT * FROM atend_pac_befpost_conf_eup_js(dt_entrada_p, ie_data_reinternacao_w, qt_dias_internacao_w, ie_completo_p, ie_tipo_atend_old_p, ie_novo_atend_alta_anterior_w, ie_novo_p, cd_medico_resp_p, ie_alerta_menor_sem_resp_w, ie_consiste_regra_atend_conv_w, ie_tipo_atendimento_p, cd_estabelecimento_w, nr_atendimento_p, ie_modo_edicao_p, cd_pessoa_responsavel_p, cd_pessoa_fisica_p, ie_exige_cpf_resp_w, nm_usuario_p, ie_forma_consist_credenc_med_w, ie_clinica_p, dt_alta_p, ds_msg_erro_w, ds_msg_alerta_cpf_resp_w, ds_msg_alerta_cons_conv_p, ds_msg_confir_inf_resp_p, ds_msg_conf_atend_alta_p, ds_msg_confirm_reinternacao_p, ds_msg_alerta_crend_mdic_p, nr_seq_classificacao_p, ie_tipo_convenio_p) INTO STRICT ds_msg_erro_w, ds_msg_alerta_cpf_resp_w, ds_msg_alerta_cons_conv_p, ds_msg_confir_inf_resp_p, ds_msg_conf_atend_alta_p, ds_msg_confirm_reinternacao_p, ds_msg_alerta_crend_mdic_p;

if (ds_msg_erro_w IS NOT NULL AND ds_msg_erro_w::text <> '') then
	goto final;
end if;

if (ie_permite_atend_orig_fat_w = 'N') and (coalesce(nr_atend_original_p,0) > 0) and (coalesce(dt_atend_original_p::text, '') = '') then

	select	coalesce(max(ie_status_acerto),1)
	into STRICT	ie_status_acerto_w
	from	conta_paciente
	where	nr_atendimento = nr_atend_original_p;

	if (ie_status_acerto_w <> 1) then
		ds_msg_atend_orig_fat_w := substr(obter_texto_tasy(93403, wheb_usuario_pck.get_nr_seq_idioma),1,255);
	end if;
end if;

if (ie_perm_dt_senha_sup_atend_w = 'N') and (dt_recebimento_senha_p IS NOT NULL AND dt_recebimento_senha_p::text <> '') then
	if (dt_recebimento_senha_p > dt_entrada_p) then
		ds_msg_alerta_senha_w := substr(obter_texto_tasy(93451, wheb_usuario_pck.get_nr_seq_idioma),1,255);
	end if;
elsif (ie_perm_dt_senha_sup_atend_w = 'B') and
	((coalesce(dt_recebimento_senha_p::text, '') = '')  or (dt_recebimento_senha_p IS NOT NULL AND dt_recebimento_senha_p::text <> '' AND dt_recebimento_senha_p > dt_entrada_p)) then
	ds_msg_erro_w := substr(obter_texto_tasy(157418, wheb_usuario_pck.get_nr_seq_idioma),1,255);
end if;

if (ds_msg_erro_w IS NOT NULL AND ds_msg_erro_w::text <> '') then
	goto final;
end if;


if	((ie_perm_novo_tit_aberto_w = 'R') or (ie_perm_novo_tit_aberto_w = 'PR') or (ie_perm_novo_tit_aberto_w = 'PE')) and (cd_pessoa_responsavel_p IS NOT NULL AND cd_pessoa_responsavel_p::text <> '') then
	SELECT * FROM consiste_tit_aberto_eup_js(ie_carater_inter_sus_p, ei_carat_perm_atend_tit_venc_w, 'R', cd_pessoa_fisica_p, cd_pessoa_responsavel_p, null, cd_estabelecimento_w, ie_valor_pend_estab_w, nm_usuario_p, ds_msg_erro_w, ds_msg_alerta_tit_venc_p) INTO STRICT ds_msg_erro_w, ds_msg_alerta_tit_venc_p;
elsif (ie_perm_novo_tit_aberto_w = 'P') or (ie_perm_novo_tit_aberto_w = 'PR') or (ie_perm_novo_tit_aberto_w = 'PE') then
	SELECT * FROM consiste_tit_aberto_eup_js(ie_carater_inter_sus_p, ei_carat_perm_atend_tit_venc_w, 'P', cd_pessoa_fisica_p, cd_pessoa_responsavel_p, null, cd_estabelecimento_w, ie_valor_pend_estab_w, nm_usuario_p, ds_msg_erro_w, ds_msg_alerta_tit_venc_p) INTO STRICT ds_msg_erro_w, ds_msg_alerta_tit_venc_p;
end if;

if (ds_msg_erro_w IS NOT NULL AND ds_msg_erro_w::text <> '') then
	goto final;
end if;

if (ie_perm_dt_real_w = 'N') and (dt_chegada_paciente_p IS NOT NULL AND dt_chegada_paciente_p::text <> '') and (dt_chegada_paciente_p > dt_entrada_p) then
	ds_msg_alerta_dt_chegada_w := substr(obter_texto_tasy(93452, wheb_usuario_pck.get_nr_seq_idioma),1,255);

end if;

SELECT * FROM consiste_paciente_debito(cd_estabelecimento_w, cd_pessoa_fisica_p, 'S', nm_usuario_p, ie_opcao_alerta_w, ds_mensagem_comun_w, cd_perfil_w, cd_pessoa_aviso_w, nr_atendimento_p) INTO STRICT ie_opcao_alerta_w, ds_mensagem_comun_w, cd_perfil_w, cd_pessoa_aviso_w;

if (ie_modo_edicao_p = 'S') and
	(((coalesce(cd_pessoa_resp_old_p::text, '') = '') and (cd_pessoa_responsavel_p IS NOT NULL AND cd_pessoa_responsavel_p::text <> '')) or (cd_pessoa_responsavel_p <> cd_pessoa_resp_old_p)) then
	CALL atualizar_pagador_resp(nr_atendimento_p, cd_pessoa_responsavel_p, nm_usuario_p, cd_estabelecimento_w, obter_perfil_ativo);
end if;

ie_case := obter_uso_case(nm_usuario_p);

if (coalesce(ds_senha_p::text, '') = '' and ie_case != 'S') then
	ds_retorno_senha_w := gerar_senha_atendimento(ie_tipo_atendimento_p, nr_seq_regra_funcao_p, cd_pessoa_fisica_p, null, nr_atendimento_p);
else
begin
	if (ie_case = 'S') then
	begin
		select 	max(ie_tipo_senha)
		into STRICT 	ie_tipo_senha_w
		from 	regra_senha_atend 
		where 	cd_estabelecimento	= coalesce(cd_estabelecimento_w,cd_estabelecimento) 
		and 	coalesce(ie_tipo_atendimento, coalesce(ie_tipo_atendimento_p,0)) = coalesce(ie_tipo_atendimento_p,0) 
		and 	coalesce(nr_seq_regra_funcao, coalesce(nr_seq_regra_funcao_p,0)) = coalesce(nr_seq_regra_funcao_p,0);

		if (ie_tipo_senha_w = 'C') then
		begin
			select	max(ds_senha)
			into STRICT	ds_senha_antiga_w
			from 	atendimento_paciente
			where 	nr_atendimento = nr_atendimento_p;

			nr_seq_episodio_w := obter_episodio_atendimento(nr_atendimento_p);
			
			if (coalesce(ds_senha_antiga_w::text, '') = '' or
				ds_senha_antiga_w <> ds_senha_p) then
			begin
				if (nr_seq_episodio_w != 0) then
				begin
					update	atendimento_paciente 
					set	ds_senha = ds_senha_p          
					where 	nr_seq_episodio = nr_seq_episodio_w;
				end;
				else
				begin
					update	atendimento_paciente
					set	ds_senha = ds_senha_p          
					where 	nr_atendimento = nr_atendimento_p;				
				end;
				end if;
			end;
			end if;
			
			ds_retorno_senha_p := ds_senha_p;
		end;
		end if;
	end;
	end if;
end;
end if;

if (coalesce(qt_dias_interncao_w,0) > 0) and
	((coalesce(ie_tipo_atend_isolam_w::text, '') = '') or (obter_se_contido_entre_virgula(ie_tipo_atend_isolam_w,ie_tipo_atendimento_p) <> 'S')) then
	nr_atend_isol_w := obter_ultimo_atend_isolamento(cd_pessoa_fisica_p, nm_usuario_p);

	if (coalesce(nr_atend_isol_w,0) > 0) then

		select	coalesce(obter_se_isol_gera_alerta(nr_atend_isol_w),'S')
		into STRICT	ie_gerar_alerta_w
		;
		if (ie_gerar_alerta_w = 'S') then
			select	substr(coalesce(obter_desc_motivo_isol_cih(nr_atend_isol_w), obter_texto_tasy(293923, wheb_usuario_pck.get_nr_seq_idioma)),1,255)
			into STRICT	ds_motivo_isol_w
			;

			ds_msg_alerta_isol_p := substr(obter_texto_dic_objeto(293918, wheb_usuario_pck.get_nr_seq_idioma, 'NR_ATEND='||nr_atend_isol_w) ||
							chr(10) || obter_texto_tasy(293919, wheb_usuario_pck.get_nr_seq_idioma) ||
							chr(10) || obter_texto_dic_objeto(293920, wheb_usuario_pck.get_nr_seq_idioma, 'DS_MOTIVO_ISOL_W='||ds_motivo_isol_w),1,255);


		end if;
	end if;
end if;

if (coalesce(qt_dias_alerta_ps_w,0) > 0) and (ie_tipo_atendimento_p = 3) and (ie_novo_p = 'S') then

	select	max(dt_entrada),
		coalesce(max(nr_atendimento),0),
		max(dt_alta)
	into STRICT	dt_entrada_ps_w,
		nr_atend_ps_w,
		dt_alta_ps_w
		from  	atendimento_paciente
		where 	cd_pessoa_fisica = cd_pessoa_fisica_p
		and   	ie_tipo_atendimento = 3
		and   	coalesce(dt_cancelamento::text, '') = ''
		and   	dt_entrada >= (to_date(clock_timestamp()) - qt_dias_alerta_ps_w)
		order by dt_entrada desc;

	if (nr_atend_ps_w > 0) then

		ds_msg_alerta_atend_ps_p :=  substr(obter_texto_dic_objeto(293986, wheb_usuario_pck.get_nr_seq_idioma, 'QT_DIA='||to_char(qt_dias_alerta_ps_w+1)|| ';DT_ENTRADA='||to_char(dt_entrada_ps_w,'dd/mm/yyyy hh24:mi:ss') || ';NR_ATEND='||nr_atend_ps_w|| ';DT_ALTA='||to_char(dt_alta_ps_w,'dd/mm/yyyy hh24:mi:ss')),1,255);
	end if;

end if;


if (ie_cons_email_conv_part_w = 'S') and (coalesce(ie_tipo_convenio_p,0) = 1) then

	SELECT  MAX(ie_email)
	into STRICT	ie_email_w
	FROM (SELECT	   CASE WHEN trim(both a.ds_email)='' THEN 'N'  ELSE 'S' END  ie_email
		FROM       compl_pessoa_fisica a
		WHERE      a.cd_pessoa_fisica    = cd_pessoa_fisica_p
		AND 	   a.ie_tipo_complemento = 1
			
UNION

		SELECT     MAX('N') ie_email
		FROM	   pessoa_fisica b
		WHERE	   b.cd_pessoa_fisica = cd_pessoa_fisica_p
		AND	   NOT EXISTS (SELECT x.cd_pessoa_fisica
					FROM   compl_pessoa_fisica x
					WHERE  x.cd_pessoa_fisica = cd_pessoa_fisica_p)) alias7;
	if (ie_email_w = 'N') then
		ds_msg_email_p := obter_texto_tasy(215189, wheb_usuario_pck.get_nr_seq_idioma);
	end if;

end if;

if (ie_obriga_classif_medico_w = 'O') and (coalesce(nr_seq_classif_medico_p,0) = 0) then
	ds_msg_classif_medico_p := obter_texto_tasy(93829, wheb_usuario_pck.get_nr_seq_idioma);
end if;

if (ie_permite_setor_null_w = 'N') and (coalesce(nr_atendimento_p,0) > 0) then
	ie_atend_setor_p := obter_se_atendimento_tem_setor(nr_atendimento_p);

end if;

nr_seq_queixa_w := nr_seq_queixa_p;

if (coalesce(ie_nr_seq_queixa_w,0) > 0) and (ie_modo_edicao_novo_p = 'S') and (coalesce(nr_atend_original_p,0) > 0) then
	nr_seq_queixa_w := ie_nr_seq_queixa_w;
end if;

if (coalesce(nr_seq_queixa_w,0) > 0) then
	ds_queixa_p := obter_desc_queixa(nr_seq_queixa_w);
end if;

if (ie_cd_medico_ext_w IS NOT NULL AND ie_cd_medico_ext_w::text <> '') and (ie_modo_edicao_novo_p = 'S') and
	((coalesce(nm_medico_externo_p::text, '') = '') or (coalesce(crm_medico_externo_p::text, '') = '')) then
	if	((ie_consiste_medico_ext_w = 'R') and (cd_medico_resp_p IS NOT NULL AND cd_medico_resp_p::text <> '') and (cd_medico_resp_p = ie_cd_medico_ext_w)) or
		((ie_consiste_medico_ext_w = 'F') and (cd_medico_referido_p IS NOT NULL AND cd_medico_referido_p::text <> '') and (cd_medico_referido_p = ie_cd_medico_ext_w))  then
		cd_msg_medico_ext_w := msg_cons_medico_ext_eup_js(ie_exige_med_ext_w, nm_medico_externo_p, crm_medico_externo_p);
		if (coalesce(cd_msg_medico_ext_w,0) > 0) then
			ds_msg_alerta_med_ext_p := obter_texto_tasy(cd_msg_medico_ext_w, wheb_usuario_pck.get_nr_seq_idioma);
		end if;
	end if;
end if;

if (ie_carater_inter_sus_p IS NOT NULL AND ie_carater_inter_sus_p::text <> '') and (ie_carater_inter_sus_p <> '')  and (Obter_Qt_Carat_Inter_Regra(ie_tipo_atendimento_p) > 0) and (Obter_Se_Carat_Inter_Regra(ie_tipo_atendimento_p, ie_carater_inter_sus_p) = 'N') then
	ds_msg_carater_atend_p := obter_texto_tasy(342537, wheb_usuario_pck.get_nr_seq_idioma);
	end if;

/* Deixar  esta verificação para o final pois se não ocorrer nenhum erro, ai atualiza o medico da conta*/

if (ie_modo_edicao_p = 'S') and (ie_atualiza_medico_conta_w = 'S') and (cd_medico_resp_p <> cd_medico_resp_old_p) then
	CALL Atualizar_Medico_Conta(nr_atendimento_p, cd_medico_resp_old_p, cd_medico_resp_p, nm_usuario_p);
end if;

<<final>>

nr_seq_queixa_ret_p		:= nr_seq_queixa_w;
ds_retorno_senha_p 		:= ds_retorno_senha_w;
cd_perfil_p			:= cd_perfil_w;
ds_mensagem_comun_p   		:= ds_mensagem_comun_w;
ie_opcao_alerta_p		:= ie_opcao_alerta_w;
ds_msg_alerta_dt_chegada_p 	:= ds_msg_alerta_dt_chegada_w;
ds_msg_alerta_senha_p 		:= ds_msg_alerta_senha_w;
ds_msg_alerta_cpf_resp_p 	:= ds_msg_alerta_cpf_resp_w;
ds_msg_atend_orig_fat_p 	:= ds_msg_atend_orig_fat_w;
ds_msg_erro_p 			:= ds_msg_erro_w;
ds_msg_erro_cancel_p 		:= ds_msg_erro_cancel_w;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atend_pac_befpost_eup_js ( nm_medico_externo_p text, crm_medico_externo_p text, ie_carater_inter_sus_p text, nr_seq_queixa_p bigint, nr_seq_classif_medico_p bigint, ie_completo_p text, ie_tipo_atend_old_p bigint, ds_senha_p text, cd_pessoa_resp_old_p text, dt_chegada_paciente_p timestamp, dt_recebimento_senha_p timestamp, nr_atend_original_p bigint, dt_atend_original_p timestamp, dt_entrada_p timestamp, ie_responsavel_p text, nr_seq_indicacao_p bigint, nr_atend_origem_pa_p bigint, cd_procedencia_p bigint, ie_novo_p text, ie_tipo_convenio_p bigint, dt_alta_p timestamp, ie_tipo_atend_tiss_p bigint, nr_atendimento_p bigint, cd_setor_usuario_p bigint, nr_seq_regra_funcao_atual_p bigint, nr_seq_regra_funcao_p bigint, cd_pessoa_fisica_p text, cd_tipo_agenda_p bigint, nr_seq_agenda_p bigint, cd_pessoa_responsavel_p text, cd_medico_referido_p text, ie_tipo_atendimento_p bigint, ie_clinica_p bigint, nr_seq_classificacao_p bigint, ie_modo_edicao_novo_p text, ie_modo_edicao_p text, cd_medico_resp_p text, cd_medico_resp_old_p text, nm_usuario_p text, ds_msg_erro_p INOUT text, ds_msg_erro_cancel_p INOUT text, ds_msg_atend_orig_fat_p INOUT text, ds_msg_alerta_cpf_resp_p INOUT text, ds_msg_alerta_senha_p INOUT text, ds_msg_alerta_dt_chegada_p INOUT text, ds_msg_alerta_cons_conv_p INOUT text, ds_msg_confir_inf_resp_p INOUT text, ds_msg_conf_atend_alta_p INOUT text, ie_opcao_alerta_p INOUT text, ds_mensagem_comun_p INOUT text, cd_perfil_p INOUT text, ds_retorno_senha_p INOUT text, ds_msg_confirm_reinternacao_p INOUT text, ds_msg_alerta_isol_p INOUT text, ds_msg_alerta_atend_ps_p INOUT text, ds_msg_classif_medico_p INOUT text, ie_atend_setor_p INOUT text, ds_msg_email_p INOUT text, nr_seq_queixa_ret_p INOUT bigint, ds_queixa_p INOUT text, ds_msg_alerta_tit_venc_p INOUT text, ds_msg_alerta_med_ext_p INOUT text, ds_msg_alerta_crend_mdic_p INOUT text, ds_msg_carater_atend_p INOUT text) FROM PUBLIC;

