-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW agenda_consulta_v (nr_sequencia, cd_agenda, dt_agenda, nr_minuto_duracao, ie_status_agenda, ie_classif_agenda, dt_atualizacao, nm_usuario, cd_convenio, cd_pessoa_fisica, nm_pessoa_contato, ds_observacao, ie_status_paciente, nr_seq_consulta, nm_paciente, nr_atendimento, dt_confirmacao, ds_confirmacao, nr_telefone, qt_idade_pac, nr_seq_plano, nr_seq_classif_med, nm_usuario_origem, ie_necessita_contato, nr_seq_sala, cd_categoria, cd_tipo_acomodacao, cd_usuario_convenio, cd_complemento, dt_validade_carteira, nr_doc_convenio, cd_senha, nr_seq_agepaci, ds_senha, dt_nascimento_pac, cd_turno, dt_agendamento, cd_medico, nr_seq_hora, nr_seq_pq_proc, cd_motivo_cancelamento, cd_procedimento, nr_seq_proc_interno, qt_total_secao, nr_secao, ie_origem_proced, dt_aguardando, dt_consulta, dt_atendido, cd_medico_solic, nr_seq_indicacao, cd_pessoa_indicacao, cd_setor_atendimento, dt_provavel_term, ie_encaixe, ie_retorno, ds_motivo_copia_trans, nm_usuario_acesso, nm_usuario_copia_trans, dt_copia_trans, nr_seq_motivo_transf, nm_usuario_horario, cd_medico_req, cd_plano, nm_usuario_confirm, nr_seq_turno, dt_status, ds_motivo_status, nm_usuario_status, nr_seq_oftalmo, nm_usuario_aguardando, nm_usuario_consulta, nm_usuario_atendido, nr_seq_preferencia, nr_seq_agenda_rxt, cd_cid, cd_procedencia, dt_horario_forcado, nr_seq_agenda_sessao, nr_seq_exame, nr_seq_forma_confirmacao, nr_seq_motivo_encaixe, cd_setor_coleta, cd_setor_entrega, ie_forma_agendamento, nr_seq_status_pac, cd_empresa_ref, ie_bloqueado_manual, nr_seq_turno_esp, qt_procedimento, nr_atend_pls, nr_seq_motivo_bloq, nr_seq_evento_atend, qt_peso, qt_altura_cm, cd_especialidade, ie_autorizacao, nr_seq_rp_mod_item, nr_seq_rp_item_ind, nr_controle_secao, nr_seq_fa_entrega, ie_transferido, ds_dados_cobranca, ie_confirmacao_aut, ie_classif_agenda_origem, nm_usuario_confirm_encaixe, dt_confirm_encaixe, nm_medico_externo, crm_medico_externo, nr_seq_segurado, dt_chegada, nr_seq_pac_senha_fila, cd_agendamento_externo, nr_seq_motivo_agendamento, nr_reserva, nr_seq_pac_reab, nr_seq_lista_espera, nm_usuario_cancelamento, qt_diaria_prev, dt_cancelamento, nr_seq_unidade, nr_seq_classif, ie_carater_inter_sus, ie_tipo_atendimento, ie_chamada_painel, ie_regra, nr_seq_regra, ie_glosa, ie_agenda_web, nr_seq_paciente_pmc, nr_seq_apres_classif, qt_valor_cobranca, cd_pessoa_responsavel, nr_tel_responsavel, nm_pessoa_responsavel, nr_controle_sus, ds_motivo_atraso, dt_status_atendido, dt_em_exame, ie_agenda_transf, nr_seq_motivo_atraso, ie_horario_forcado, nr_transacao_sus, ds_observacao_fat, cd_convenio_turno, cd_material_exame, ie_envio_sms, nr_seq_agendamento, nr_matricula_ageweb, dt_vinculacao_atendimento, nr_seq_motivo_prazo, ds_motivo_prazo, cd_cgc_indicacao, cd_regulacao_sus, cd_chave_regulacao_sus, nr_seq_motivo_reserva, nr_seq_transporte, nm_pessoa_indicacao, nr_seq_tipo_midia, ds_email, nr_seq_atendimento, dt_chamada_atend, nr_seq_banco_leite, nr_seq_lista_reab, nm_usuario_residente, nm_usuario_vinculo_atend, dt_validade_senha, nr_seq_fitness, nr_seq_motivo_falta, ie_atualizou_autoatendimento, dt_status_pac, ie_lado, cd_topografia_proced, nr_seq_partic_ciclo_item, nr_seq_captacao, nr_seq_opm, nr_ddi, nr_ddi_resp, nr_seq_agend_coletiva, ie_agend_coletivo, ie_sessao_diariamente, ie_sessao_final_semana, qt_sessao_intervalo, ds_sessao_dias_semana, ie_sessao_copiar_proced_adic, ie_sessao_copiar_proced, ie_cod_usuario_mae_resp, nr_seq_tipo_consulta, nr_seq_cobertura, nr_seq_person_name, nr_application_code, nr_inss_wjtf, nm_pessoa_fisica, qt_anos, nr_telefone_celular, nr_telefone_contato, nr_prontuario, ds_status_agenda, ds_classif_agenda, ds_classif_agenda_tasy, ds_convenio, ds_status_paciente, nr_seq_agenda, dt_entrada, dt_saida, qt_min_espera_tasy, qt_min_espera, qt_min_consulta, ds_convenio_plano, nr_minutos_atraso, ds_classif_pac, ds_idade, cd_sistema_ant, cd_classif_tasy, nm_agenda, ds_indicacao, nm_pessoa_indic, nm_medico, nm_medico_solic) AS select
	a.NR_SEQUENCIA,
	a.CD_AGENDA,
	a.DT_AGENDA,
	a.NR_MINUTO_DURACAO,
	a.IE_STATUS_AGENDA,
	a.IE_CLASSIF_AGENDA,
	a.DT_ATUALIZACAO,
	a.NM_USUARIO,
	a.CD_CONVENIO,
	a.CD_PESSOA_FISICA,
	a.NM_PESSOA_CONTATO,
	a.DS_OBSERVACAO,
	a.IE_STATUS_PACIENTE,
	a.NR_SEQ_CONSULTA,
	a.NM_PACIENTE,
	a.NR_ATENDIMENTO,
	a.DT_CONFIRMACAO,
	a.DS_CONFIRMACAO,
	a.NR_TELEFONE,
	a.QT_IDADE_PAC,
	a.NR_SEQ_PLANO,
	a.NR_SEQ_CLASSIF_MED,
	a.NM_USUARIO_ORIGEM,
	a.IE_NECESSITA_CONTATO,
	a.NR_SEQ_SALA,
	a.CD_CATEGORIA,
	a.CD_TIPO_ACOMODACAO,
	a.CD_USUARIO_CONVENIO,
	a.CD_COMPLEMENTO,
	a.DT_VALIDADE_CARTEIRA,
	a.NR_DOC_CONVENIO,
	a.CD_SENHA,
	a.NR_SEQ_AGEPACI,
	a.DS_SENHA,
	a.DT_NASCIMENTO_PAC,
	a.CD_TURNO,
	a.DT_AGENDAMENTO,
	a.CD_MEDICO,
	a.NR_SEQ_HORA,
	a.NR_SEQ_PQ_PROC,
	a.CD_MOTIVO_CANCELAMENTO,
	a.CD_PROCEDIMENTO,
	a.NR_SEQ_PROC_INTERNO,
	a.QT_TOTAL_SECAO,
	a.NR_SECAO,
	a.IE_ORIGEM_PROCED,
	a.DT_AGUARDANDO,
	a.DT_CONSULTA,
	a.DT_ATENDIDO,
	a.CD_MEDICO_SOLIC,
	a.NR_SEQ_INDICACAO,
	a.CD_PESSOA_INDICACAO,
	a.CD_SETOR_ATENDIMENTO,
	a.DT_PROVAVEL_TERM,
	a.IE_ENCAIXE,
	a.IE_RETORNO,
	a.DS_MOTIVO_COPIA_TRANS,
	a.NM_USUARIO_ACESSO,
	a.NM_USUARIO_COPIA_TRANS,
	a.DT_COPIA_TRANS,
	a.NR_SEQ_MOTIVO_TRANSF,
	a.NM_USUARIO_HORARIO,
	a.CD_MEDICO_REQ,
	a.CD_PLANO,
	a.NM_USUARIO_CONFIRM,
	a.NR_SEQ_TURNO,
	a.DT_STATUS,
	a.DS_MOTIVO_STATUS,
	a.NM_USUARIO_STATUS,
	a.NR_SEQ_OFTALMO,
	a.NM_USUARIO_AGUARDANDO,
	a.NM_USUARIO_CONSULTA,
	a.NM_USUARIO_ATENDIDO,
	a.NR_SEQ_PREFERENCIA,
	a.NR_SEQ_AGENDA_RXT,
	a.CD_CID,
	a.CD_PROCEDENCIA,
	a.DT_HORARIO_FORCADO,
	a.NR_SEQ_AGENDA_SESSAO,
	a.NR_SEQ_EXAME,
	a.NR_SEQ_FORMA_CONFIRMACAO,
	a.NR_SEQ_MOTIVO_ENCAIXE,
	a.CD_SETOR_COLETA,
	a.CD_SETOR_ENTREGA,
	a.IE_FORMA_AGENDAMENTO,
	a.NR_SEQ_STATUS_PAC,
	a.CD_EMPRESA_REF,
	a.IE_BLOQUEADO_MANUAL,
	a.NR_SEQ_TURNO_ESP,
	a.QT_PROCEDIMENTO,
	a.NR_ATEND_PLS,
	a.NR_SEQ_MOTIVO_BLOQ,
	a.NR_SEQ_EVENTO_ATEND,
	a.QT_PESO,
	a.QT_ALTURA_CM,
	a.CD_ESPECIALIDADE,
	a.IE_AUTORIZACAO,
	a.NR_SEQ_RP_MOD_ITEM,
	a.NR_SEQ_RP_ITEM_IND,
	a.NR_CONTROLE_SECAO,
	a.NR_SEQ_FA_ENTREGA,
	a.IE_TRANSFERIDO,
	a.DS_DADOS_COBRANCA,
	a.IE_CONFIRMACAO_AUT,
	a.IE_CLASSIF_AGENDA_ORIGEM,
	a.NM_USUARIO_CONFIRM_ENCAIXE,
	a.DT_CONFIRM_ENCAIXE,
	a.NM_MEDICO_EXTERNO,
	a.CRM_MEDICO_EXTERNO,
	a.NR_SEQ_SEGURADO,
	a.DT_CHEGADA,
	a.NR_SEQ_PAC_SENHA_FILA,
	a.CD_AGENDAMENTO_EXTERNO,
	a.NR_SEQ_MOTIVO_AGENDAMENTO,
	a.NR_RESERVA,
	a.NR_SEQ_PAC_REAB,
	a.NR_SEQ_LISTA_ESPERA,
	a.NM_USUARIO_CANCELAMENTO,
	a.QT_DIARIA_PREV,
	a.DT_CANCELAMENTO,
	a.NR_SEQ_UNIDADE,
	a.NR_SEQ_CLASSIF,
	a.IE_CARATER_INTER_SUS,
	a.IE_TIPO_ATENDIMENTO,
	a.IE_CHAMADA_PAINEL,
	a.IE_REGRA,
	a.NR_SEQ_REGRA,
	a.IE_GLOSA,
	a.IE_AGENDA_WEB,
	a.NR_SEQ_PACIENTE_PMC,
	a.NR_SEQ_APRES_CLASSIF,
	a.QT_VALOR_COBRANCA,
	a.CD_PESSOA_RESPONSAVEL,
	a.NR_TEL_RESPONSAVEL,
	a.NM_PESSOA_RESPONSAVEL,
	a.NR_CONTROLE_SUS,
	a.DS_MOTIVO_ATRASO,
	a.DT_STATUS_ATENDIDO,
	a.DT_EM_EXAME,
	a.IE_AGENDA_TRANSF,
	a.NR_SEQ_MOTIVO_ATRASO,
	a.IE_HORARIO_FORCADO,
	a.NR_TRANSACAO_SUS,
	a.DS_OBSERVACAO_FAT,
	a.CD_CONVENIO_TURNO,
	a.CD_MATERIAL_EXAME,
	a.IE_ENVIO_SMS,
	a.NR_SEQ_AGENDAMENTO,
	a.NR_MATRICULA_AGEWEB,
	a.DT_VINCULACAO_ATENDIMENTO,
	a.NR_SEQ_MOTIVO_PRAZO,
	a.DS_MOTIVO_PRAZO,
	a.CD_CGC_INDICACAO,
	a.CD_REGULACAO_SUS,
	a.CD_CHAVE_REGULACAO_SUS,
	a.NR_SEQ_MOTIVO_RESERVA,
	a.NR_SEQ_TRANSPORTE,
	a.NM_PESSOA_INDICACAO,
	a.NR_SEQ_TIPO_MIDIA,
	a.DS_EMAIL,
	a.NR_SEQ_ATENDIMENTO,
	a.DT_CHAMADA_ATEND,
	a.NR_SEQ_BANCO_LEITE,
	a.NR_SEQ_LISTA_REAB,
	a.NM_USUARIO_RESIDENTE,
	a.NM_USUARIO_VINCULO_ATEND,
	a.DT_VALIDADE_SENHA,
	a.NR_SEQ_FITNESS,
	a.NR_SEQ_MOTIVO_FALTA,
	a.IE_ATUALIZOU_AUTOATENDIMENTO,
	a.DT_STATUS_PAC,
	a.IE_LADO,
	a.CD_TOPOGRAFIA_PROCED,
	a.NR_SEQ_PARTIC_CICLO_ITEM,
	a.NR_SEQ_CAPTACAO,
	a.NR_SEQ_OPM,
	a.NR_DDI,
	a.NR_DDI_RESP,
	a.NR_SEQ_AGEND_COLETIVA,
	a.IE_AGEND_COLETIVO,
	a.IE_SESSAO_DIARIAMENTE,
	a.IE_SESSAO_FINAL_SEMANA,
	a.QT_SESSAO_INTERVALO,
	a.DS_SESSAO_DIAS_SEMANA,
	a.IE_SESSAO_COPIAR_PROCED_ADIC,
	a.IE_SESSAO_COPIAR_PROCED,
	a.IE_COD_USUARIO_MAE_RESP,
	a.NR_SEQ_TIPO_CONSULTA,
	a.NR_SEQ_COBERTURA,
	a.NR_SEQ_PERSON_NAME,
	a.NR_APPLICATION_CODE,
	a.NR_INSS_WJTF,	
	coalesce(obter_nome_pf(b.cd_pessoa_fisica),nm_paciente) nm_pessoa_fisica,
	coalesce(qt_idade_pac, substr(obter_idade(b.dt_nascimento, LOCALTIMESTAMP, 'A'),1,3)) 	qt_anos,
      b.nr_telefone_celular,
      coalesce(a.nr_telefone, b.nr_telefone_celular) nr_telefone_contato,
	b.nr_prontuario,
	substr(c.ds_status_agenda,1,100) ds_status_agenda,
      substr(obter_desc_classif_agenda(a.cd_agenda, d.cd_classif_agenda),1,40) 	ds_classif_agenda,
	d.ds_classif_agenda ds_classif_agenda_tasy,
	e.ds_convenio,
      substr(g.ds_status_paciente,1,100) ds_status_paciente,
	f.nr_seq_agenda,
	f.dt_entrada,
	f.dt_saida,
	Obter_Tempo_Espera_Atend(a.nr_atendimento) qt_min_espera_tasy,
	to_number(CASE WHEN f.dt_entrada IS NULL THEN  null  ELSE CASE WHEN a.ie_status_agenda='N' THEN  Null  ELSE round((coalesce(f.dt_inicio_consulta, LOCALTIMESTAMP) - f.dt_entrada) * 			1440) END  END ) qt_min_espera,
	to_number(CASE WHEN f.dt_inicio_consulta IS NULL THEN  null  ELSE round((coalesce(f.dt_saida,LOCALTIMESTAMP) - f.dt_inicio_consulta) * 1440) END ) 	qt_min_Consulta,
	substr(e.ds_convenio || '  ' || obter_med_plano(a.nr_seq_plano),1,100) ds_convenio_plano,
	obter_minutos_atraso_agenda(a.nr_sequencia) nr_minutos_atraso,
       substr(Obter_Med_Classif_Paciente(
              obter_codigo_sist_orig(a.cd_pessoa_fisica, b.cd_pessoa_fisica), b.cd_pessoa_fisica),1,100) ds_classif_pac,
	substr(obter_idade(b.dt_nascimento, LOCALTIMESTAMP, 'S'),1,50) ds_idade,
	b.cd_sistema_ant cd_sistema_ant,
	d.cd_classif_tasy,
	substr(obter_nome_agenda_cons(a.cd_agenda),1,80) nm_agenda,
	substr(obter_desc_indicacao(a.nr_seq_indicacao),1,40) ds_indicacao,
	substr(obter_nome_pf(a.cd_pessoa_indicacao),1,60) nm_pessoa_indic,
	substr(obter_nome_pf(a.cd_medico),1,60) nm_medico,
	substr(obter_nome_pf(a.cd_medico_solic),1,60) nm_medico_solic
FROM status_agenda_v c, agenda_consulta a
LEFT OUTER JOIN pessoa_fisica b ON (a.cd_pessoa_fisica = b.cd_pessoa_fisica)
LEFT OUTER JOIN classif_agenda_consulta_v d ON (a.ie_classif_agenda = d.cd_classif_agenda)
LEFT OUTER JOIN status_paciente_v g ON (a.ie_status_paciente = g.cd_status_paciente)
LEFT OUTER JOIN convenio e ON (a.cd_convenio = e.cd_convenio)
LEFT OUTER JOIN med_atendimento f ON (a.nr_sequencia = f.nr_seq_agenda)
WHERE a.ie_status_agenda   	= c.cd_status_agenda;

