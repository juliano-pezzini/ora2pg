-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atend_pac_afterpost_eup_js ( nr_seq_autorizacao_p text, ds_lista_age_serv_p text, ds_lista_age_cons_p text, ds_lista_age_exame_p text, ds_lista_age_pac_p text, ie_novo_atend_lista_age_p text, ie_novo_atend_cham_p text, nr_internacao_aghos_p bigint, nr_seq_atend_futuro_p bigint, ie_regra_lancto_auto_p text, ie_edicao_registro_p text, cd_pessoa_responsavel_p text, ie_carater_inter_sus_p text, nr_seq_checkup_p bigint, ie_novo_atend_checkup_p text, ie_classif_doenca_p text, ie_tipo_diagnostico_p bigint, cd_doenca_p text, nr_seq_pac_espera_p bigint, ie_tipo_convenio_p bigint, cd_pessoa_fisica_p text, ie_novo_registro_p text, ie_tipo_atendimento_p bigint, ie_clinica_p bigint, dt_entrada_p timestamp, nr_seq_classificacao_p bigint, cd_tipo_agenda_p bigint, nr_seq_agenda_p bigint, cd_medico_resp_p text, nr_atendimento_p bigint, nm_usuario_p text, nr_seq_gestao_p text, ds_msg_esp_quest_p INOUT text, ie_permit_esp_p INOUT text, ie_retorno_cid_p INOUT text, ds_msg_cep_p INOUT text, ds_msg_idade_pagador_p INOUT text, ds_msg_informa_pagador_p INOUT text, ds_msg_vincula_agenda_p INOUT text, nr_seq_vincula_agenda_p INOUT bigint, ds_msg_auto_conve_perm_p INOUT text, ds_msg_auto_conve_p INOUT text, ie_perm_auto_conv_p INOUT text, cd_convenio_p INOUT bigint, cd_categoria_p INOUT text, qt_prescr_cult_positiva_p INOUT bigint, ds_msg_tempo_espera_atend_p INOUT text, ds_msg_fila_espera_p INOUT text, ie_atend_fila_espera_p INOUT text, qt_orc_pac_aprovado_p INOUT bigint, qt_cartao_fidel_p INOUT bigint, nr_prontuario_p INOUT bigint, ds_msg_laudo_preenchido_p INOUT text, cd_conv_atend_fut_p INOUT bigint, cd_categ_atend_fut_p INOUT text, cd_plano_convenio_p INOUT text, cd_usuario_convenio_p INOUT text, dt_validade_carteira_p INOUT timestamp, qt_dia_internacao_p INOUT bigint, dt_validade_cart_glosa_p INOUT timestamp, nr_doc_convenio_p INOUT text, cd_senha_p INOUT text, ds_msg_regra_carater_conv_p INOUT text, ie_pular_convenio_p INOUT text, ie_atualiza_dados_conv_dieta_p INOUT text, ds_msg_conf_atu_dieta_p INOUT text, cd_carteirinha_p INOUT text) AS $body$
DECLARE


					
cd_estabelecimento_w		smallint;
ie_permite_escolher_esp_w	varchar(1);
ie_informar_profissional_w	varchar(1);
ie_pular_campos_conv_sus_w	varchar(1);
ie_atualiza_dados_conv_dieta_w	varchar(1);
nr_seq_pq_proc_w		bigint;
nr_seq_protocolo_w		bigint;	
					

BEGIN
/* PROCEDURE CHAMADA APENAS NA PASTA COMPLETO (EUP)  
*/
cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;
ie_pular_campos_conv_sus_w := Obter_param_Usuario(916, 22, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_pular_campos_conv_sus_w);
ie_permite_escolher_esp_w := Obter_param_Usuario(916, 909, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_permite_escolher_esp_w);
ie_atualiza_dados_conv_dieta_w := Obter_param_Usuario(916, 1117, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_atualiza_dados_conv_dieta_w);


SELECT * FROM permite_escol_esp_medico_js(nr_atendimento_p, 'P', ie_permite_escolher_esp_w, cd_medico_resp_p, nm_usuario_p, ds_msg_esp_quest_p, ie_permit_esp_p) INTO STRICT ds_msg_esp_quest_p, ie_permit_esp_p;

 SELECT * FROM atend_pac_aftpost_comun_eup_js(nr_seq_autorizacao_p, ds_lista_age_serv_p, ds_lista_age_cons_p, ds_lista_age_exame_p, ds_lista_age_pac_p, ie_novo_atend_lista_age_p, ie_novo_atend_cham_p, nr_internacao_aghos_p, nr_seq_atend_futuro_p, ie_regra_lancto_auto_p, ie_edicao_registro_p, cd_pessoa_responsavel_p, ie_carater_inter_sus_p, nr_seq_checkup_p, ie_novo_atend_checkup_p, ie_classif_doenca_p, ie_tipo_diagnostico_p, cd_medico_resp_p, cd_doenca_p, nr_seq_pac_espera_p, ie_tipo_convenio_p, cd_pessoa_fisica_p, nr_seq_classificacao_p, dt_entrada_p, ie_clinica_p, ie_tipo_atendimento_p, nr_atendimento_p, cd_tipo_agenda_p, nr_seq_agenda_p, ie_novo_registro_p, nm_usuario_p, nr_seq_gestao_p, ie_retorno_cid_p, ds_msg_cep_p, ds_msg_idade_pagador_p, ds_msg_informa_pagador_p, ds_msg_vincula_agenda_p, nr_seq_vincula_agenda_p, ds_msg_auto_conve_perm_p, ds_msg_auto_conve_p, ie_perm_auto_conv_p, cd_convenio_p, cd_categoria_p, qt_prescr_cult_positiva_p, ds_msg_tempo_espera_atend_p, ds_msg_fila_espera_p, ie_atend_fila_espera_p, qt_orc_pac_aprovado_p, qt_cartao_fidel_p, nr_prontuario_p, ds_msg_laudo_preenchido_p, cd_conv_atend_fut_p, cd_categ_atend_fut_p, cd_plano_convenio_p, cd_usuario_convenio_p, dt_validade_carteira_p, qt_dia_internacao_p, dt_validade_cart_glosa_p, nr_doc_convenio_p, cd_senha_p, ds_msg_regra_carater_conv_p, cd_carteirinha_p, ds_msg_esp_quest_p, ie_permit_esp_p) INTO STRICT ie_retorno_cid_p, ds_msg_cep_p, ds_msg_idade_pagador_p, ds_msg_informa_pagador_p, ds_msg_vincula_agenda_p, nr_seq_vincula_agenda_p, ds_msg_auto_conve_perm_p, ds_msg_auto_conve_p, ie_perm_auto_conv_p, cd_convenio_p, cd_categoria_p, qt_prescr_cult_positiva_p, ds_msg_tempo_espera_atend_p, ds_msg_fila_espera_p, ie_atend_fila_espera_p, qt_orc_pac_aprovado_p, qt_cartao_fidel_p, nr_prontuario_p, ds_msg_laudo_preenchido_p, cd_conv_atend_fut_p, cd_categ_atend_fut_p, cd_plano_convenio_p, cd_usuario_convenio_p, dt_validade_carteira_p, qt_dia_internacao_p, dt_validade_cart_glosa_p, nr_doc_convenio_p, cd_senha_p, ds_msg_regra_carater_conv_p, cd_carteirinha_p, ds_msg_esp_quest_p, ie_permit_esp_p;

if (ie_pular_campos_conv_sus_w = 'T') or
	(ie_pular_campos_conv_sus_w = 'S' AND ie_tipo_atendimento_p = 1) and (ie_tipo_convenio_p = 3) then	
	ie_pular_convenio_p := 'S';
end if;

if (ie_atualiza_dados_conv_dieta_w = 'S') then
	ie_atualiza_dados_conv_dieta_p := ie_atualiza_dados_conv_dieta_w;
elsif (ie_atualiza_dados_conv_dieta_w = 'Q') then
	ie_atualiza_dados_conv_dieta_p := ie_atualiza_dados_conv_dieta_w;
	ds_msg_conf_atu_dieta_p	:= substr(obter_texto_tasy(290685,wheb_usuario_pck.get_nr_seq_idioma),1,255);
end if;

if (ie_novo_atend_cham_p = 'S') then
	select  max(nr_seq_pq_proc)
	into STRICT	nr_seq_pq_proc_w
	from    agenda_consulta
	where   nr_sequencia = nr_seq_agenda_p;
	if (coalesce(nr_seq_pq_proc_w,0) > 0) then

		select  nr_seq_protocolo
		into STRICT	nr_seq_protocolo_w
		from    pq_procedimento           
		where    nr_sequencia = nr_seq_pq_proc_w;
		if (coalesce(nr_seq_protocolo_w,0) > 0) then
			CALL Atualizar_Protocolo_EUP(nr_atendimento_p, nr_seq_protocolo_w, nm_usuario_p);
			
			CALL Gerar_Prescr_Prot_Pesquisa(nr_seq_agenda_p, nm_usuario_p);
		end if;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atend_pac_afterpost_eup_js ( nr_seq_autorizacao_p text, ds_lista_age_serv_p text, ds_lista_age_cons_p text, ds_lista_age_exame_p text, ds_lista_age_pac_p text, ie_novo_atend_lista_age_p text, ie_novo_atend_cham_p text, nr_internacao_aghos_p bigint, nr_seq_atend_futuro_p bigint, ie_regra_lancto_auto_p text, ie_edicao_registro_p text, cd_pessoa_responsavel_p text, ie_carater_inter_sus_p text, nr_seq_checkup_p bigint, ie_novo_atend_checkup_p text, ie_classif_doenca_p text, ie_tipo_diagnostico_p bigint, cd_doenca_p text, nr_seq_pac_espera_p bigint, ie_tipo_convenio_p bigint, cd_pessoa_fisica_p text, ie_novo_registro_p text, ie_tipo_atendimento_p bigint, ie_clinica_p bigint, dt_entrada_p timestamp, nr_seq_classificacao_p bigint, cd_tipo_agenda_p bigint, nr_seq_agenda_p bigint, cd_medico_resp_p text, nr_atendimento_p bigint, nm_usuario_p text, nr_seq_gestao_p text, ds_msg_esp_quest_p INOUT text, ie_permit_esp_p INOUT text, ie_retorno_cid_p INOUT text, ds_msg_cep_p INOUT text, ds_msg_idade_pagador_p INOUT text, ds_msg_informa_pagador_p INOUT text, ds_msg_vincula_agenda_p INOUT text, nr_seq_vincula_agenda_p INOUT bigint, ds_msg_auto_conve_perm_p INOUT text, ds_msg_auto_conve_p INOUT text, ie_perm_auto_conv_p INOUT text, cd_convenio_p INOUT bigint, cd_categoria_p INOUT text, qt_prescr_cult_positiva_p INOUT bigint, ds_msg_tempo_espera_atend_p INOUT text, ds_msg_fila_espera_p INOUT text, ie_atend_fila_espera_p INOUT text, qt_orc_pac_aprovado_p INOUT bigint, qt_cartao_fidel_p INOUT bigint, nr_prontuario_p INOUT bigint, ds_msg_laudo_preenchido_p INOUT text, cd_conv_atend_fut_p INOUT bigint, cd_categ_atend_fut_p INOUT text, cd_plano_convenio_p INOUT text, cd_usuario_convenio_p INOUT text, dt_validade_carteira_p INOUT timestamp, qt_dia_internacao_p INOUT bigint, dt_validade_cart_glosa_p INOUT timestamp, nr_doc_convenio_p INOUT text, cd_senha_p INOUT text, ds_msg_regra_carater_conv_p INOUT text, ie_pular_convenio_p INOUT text, ie_atualiza_dados_conv_dieta_p INOUT text, ds_msg_conf_atu_dieta_p INOUT text, cd_carteirinha_p INOUT text) FROM PUBLIC;

