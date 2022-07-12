-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW usuario_v (nm_usuario, ds_usuario, ds_senha, ie_situacao, dt_atualizacao, nm_usuario_atual, cd_setor_atendimento, cd_pessoa_fisica, cd_barras, dt_alteracao_senha, ds_email, nr_sequencia, cd_estabelecimento, nr_ramal, ie_mensagem_rec, ie_mensagem_envio, qt_dia_senha, ds_conta_email, ie_anexar_arquivo, ds_senha_laudo, ie_comunic_interna, ie_tipo_evolucao, ie_localizar_medico, cd_funcao, ie_versao_anterior, nr_seq_classif, ie_chamar_tasymon, cd_perfil_inicial, ie_evento_agenda, ie_evento_sac, ie_evento_processo, ie_evento_prescr, ie_evento_proc_agenda, ie_evento_comunic, ie_evento_alerta, ie_evento_aprov_compra, ie_evento_exame_urg, ie_evento_aprov_doc, ie_fechar_tasymon, ds_senha_email, ie_evento_lib_telefone, nm_usuario_orig, ie_mostrar_anexo_comunic, ie_evento_ordem_serv, ie_evento_obj_inv, ds_comunic_padrao, ie_evento_recoleta, nr_seq_impressora, ie_atualizar_dic, cd_classif_localizador, nr_seq_perfil, dt_validade_usuario, nr_ramal_temp, ie_profissional, qt_acesso_invalido, ds_login, ie_os_pe_bsc, ie_evento_susp_exame, ie_evento_med_cih, ie_evento_int_agenda_san, ie_evento_vinc_agenda_san, ie_evento_canc_cir_san, ie_evento_canc_agenda_san, ie_evento_enc_agenda_san, ie_evento_transf_agenda_san, ds_hist_padrao, ie_evento_solic_pront, ie_evento_alteracao_param, cd_certificado, nr_seq_justific_acesso, ie_evento_paciente, ds_texto_email, ie_evento_estrangeiro, dt_atualizacao_nrec, nm_usuario_nrec, ie_evento_alta_partic, ie_evento_alerta_medico, ie_evento_alta_partic_ext, ie_evento_alta_regra, ie_receber_copia_email, ie_evento_prev_alta, nr_seq_idioma, nm_usuario_pesquisa, ie_saida_logoff, ds_observacao, ie_evento_os_programar, ie_dieta_prescrita, nr_nivel_aprovacao, ie_evento_agenda_comercial, ie_evento_requisicao_lib, nr_seq_apres_prof, ie_evento_alt_status_san, ie_ocorrencia_retorno, ie_evento_solic_compra, ie_terceiro, ie_alerta_forma_entrega, dt_validade_certificado, ie_evento_hemo, ie_evento_sc_urgente, ie_evento_agenda_carater, dt_emissao_certificado, ie_resp_auditoria, ie_evento_lib_receb_pp, ie_renovacao_certificado, ie_evento_higienizacao_leito, cd_barras_numerico, dt_inativacao, nr_seq_ordem, ie_evento_retorno_ligacao, ds_tec, ie_evento_vaga_pend_aprov, ie_termo_uso, nm_usuario_git, nm_usuario_github, ds_utc, ds_utc_atualizacao, ie_horario_verao, dt_aceite_termo_uso, ie_can_view_sensitive_info, ie_can_view_patient_info, user_2fa_status, user_2fa_secret, ie_can_auth_patient_deletion, ie_can_delete_patient, ds_setor_atendimento, ds_usuario_setor, ds_estabelecimento) AS select 	a.NM_USUARIO,a.DS_USUARIO,a.DS_SENHA,a.IE_SITUACAO,a.DT_ATUALIZACAO,a.NM_USUARIO_ATUAL,a.CD_SETOR_ATENDIMENTO,a.CD_PESSOA_FISICA,a.CD_BARRAS,a.DT_ALTERACAO_SENHA,a.DS_EMAIL,a.NR_SEQUENCIA,a.CD_ESTABELECIMENTO,a.NR_RAMAL,a.IE_MENSAGEM_REC,a.IE_MENSAGEM_ENVIO,a.QT_DIA_SENHA,a.DS_CONTA_EMAIL,a.IE_ANEXAR_ARQUIVO,a.DS_SENHA_LAUDO,a.IE_COMUNIC_INTERNA,a.IE_TIPO_EVOLUCAO,a.IE_LOCALIZAR_MEDICO,a.CD_FUNCAO,a.IE_VERSAO_ANTERIOR,a.NR_SEQ_CLASSIF,a.IE_CHAMAR_TASYMON,a.CD_PERFIL_INICIAL,a.IE_EVENTO_AGENDA,a.IE_EVENTO_SAC,a.IE_EVENTO_PROCESSO,a.IE_EVENTO_PRESCR,a.IE_EVENTO_PROC_AGENDA,a.IE_EVENTO_COMUNIC,a.IE_EVENTO_ALERTA,a.IE_EVENTO_APROV_COMPRA,a.IE_EVENTO_EXAME_URG,a.IE_EVENTO_APROV_DOC,a.IE_FECHAR_TASYMON,a.DS_SENHA_EMAIL,a.IE_EVENTO_LIB_TELEFONE,a.NM_USUARIO_ORIG,a.IE_MOSTRAR_ANEXO_COMUNIC,a.IE_EVENTO_ORDEM_SERV,a.IE_EVENTO_OBJ_INV,a.DS_COMUNIC_PADRAO,a.IE_EVENTO_RECOLETA,a.NR_SEQ_IMPRESSORA,a.IE_ATUALIZAR_DIC,a.CD_CLASSIF_LOCALIZADOR,a.NR_SEQ_PERFIL,a.DT_VALIDADE_USUARIO,a.NR_RAMAL_TEMP,a.IE_PROFISSIONAL,a.QT_ACESSO_INVALIDO,a.DS_LOGIN,a.IE_OS_PE_BSC,a.IE_EVENTO_SUSP_EXAME,a.IE_EVENTO_MED_CIH,a.IE_EVENTO_INT_AGENDA_SAN,a.IE_EVENTO_VINC_AGENDA_SAN,a.IE_EVENTO_CANC_CIR_SAN,a.IE_EVENTO_CANC_AGENDA_SAN,a.IE_EVENTO_ENC_AGENDA_SAN,a.IE_EVENTO_TRANSF_AGENDA_SAN,a.DS_HIST_PADRAO,a.IE_EVENTO_SOLIC_PRONT,a.IE_EVENTO_ALTERACAO_PARAM,a.CD_CERTIFICADO,a.NR_SEQ_JUSTIFIC_ACESSO,a.IE_EVENTO_PACIENTE,a.DS_TEXTO_EMAIL,a.IE_EVENTO_ESTRANGEIRO,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC,a.IE_EVENTO_ALTA_PARTIC,a.IE_EVENTO_ALERTA_MEDICO,a.IE_EVENTO_ALTA_PARTIC_EXT,a.IE_EVENTO_ALTA_REGRA,a.IE_RECEBER_COPIA_EMAIL,a.IE_EVENTO_PREV_ALTA,a.NR_SEQ_IDIOMA,a.NM_USUARIO_PESQUISA,a.IE_SAIDA_LOGOFF,a.DS_OBSERVACAO,a.IE_EVENTO_OS_PROGRAMAR,a.IE_DIETA_PRESCRITA,a.NR_NIVEL_APROVACAO,a.IE_EVENTO_AGENDA_COMERCIAL,a.IE_EVENTO_REQUISICAO_LIB,a.NR_SEQ_APRES_PROF,a.IE_EVENTO_ALT_STATUS_SAN,a.IE_OCORRENCIA_RETORNO,a.IE_EVENTO_SOLIC_COMPRA,a.IE_TERCEIRO,a.IE_ALERTA_FORMA_ENTREGA,a.DT_VALIDADE_CERTIFICADO,a.IE_EVENTO_HEMO,a.IE_EVENTO_SC_URGENTE,a.IE_EVENTO_AGENDA_CARATER,a.DT_EMISSAO_CERTIFICADO,a.IE_RESP_AUDITORIA,a.IE_EVENTO_LIB_RECEB_PP,a.IE_RENOVACAO_CERTIFICADO,a.IE_EVENTO_HIGIENIZACAO_LEITO,a.CD_BARRAS_NUMERICO,a.DT_INATIVACAO,a.NR_SEQ_ORDEM,a.IE_EVENTO_RETORNO_LIGACAO,a.DS_TEC,a.IE_EVENTO_VAGA_PEND_APROV,a.IE_TERMO_USO,a.NM_USUARIO_GIT,a.NM_USUARIO_GITHUB,a.DS_UTC,a.DS_UTC_ATUALIZACAO,a.IE_HORARIO_VERAO,a.DT_ACEITE_TERMO_USO,a.IE_CAN_VIEW_SENSITIVE_INFO,a.IE_CAN_VIEW_PATIENT_INFO,a.USER_2FA_STATUS,a.USER_2FA_SECRET,a.IE_CAN_AUTH_PATIENT_DELETION,a.IE_CAN_DELETE_PATIENT,
	substr(obter_desc_expressao(b.cd_exp_setor_atend,b.ds_setor_atendimento),1,100) ds_setor_atendimento, 
	a.ds_usuario || '(' || substr(obter_desc_expressao(b.cd_exp_setor_atend,b.ds_setor_atendimento),1,100) || ')' ds_usuario_setor, 
	substr(OBTER_NOME_ESTABELECIMENTO(a.cd_estabelecimento), 1,255) ds_estabelecimento 
FROM usuario a
LEFT OUTER JOIN setor_atendimento b ON (a.cd_setor_atendimento = b.cd_setor_atendimento);

