-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW prescr_dieta_v (nr_prescricao, cd_pessoa_fisica, nr_atendimento, cd_medico, dt_prescricao, dt_atualizacao, nm_usuario, ds_observacao, nr_horas_validade, cd_motivo_baixa, dt_baixa, dt_primeiro_horario, dt_liberacao, dt_emissao_setor, dt_emissao_farmacia, cd_setor_atendimento, dt_entrada_unidade, ie_recem_nato, ie_origem_inf, nr_prescricao_anterior, nm_usuario_original, ie_motivo_prescricao, dt_liberacao_medico, nr_prescricao_mae, cd_protocolo, nr_seq_protocolo, dt_entrega, cd_setor_entrega, nr_cirurgia, nr_seq_agenda, qt_altura_cm, qt_peso, dt_mestruacao, ds_dado_clinico, nr_controle, cd_recem_nato, cd_estabelecimento, ds_medicacao_uso, nr_doc_conv, cd_prescritor, nr_prioridade, ds_de_ate, dt_suspensao, nm_usuario_susp, cd_senha, ie_emergencia, nr_seq_forma_laudo, nr_seq_agecons, ie_funcao_prescritor, dt_fim_prescricao, ie_prescricao_alta, dt_liberacao_farmacia, ie_lib_farm, cd_local_estoque, dt_validade_prescr, dt_inicio_prescr, ie_adep, ie_prescr_emergencia, nm_usuario_imp_far, ie_hemodialise, cd_farmac_lib, qt_creatinina, qt_clearence, ie_calculo_clearence, nm_usuario_lib_enf, nr_seq_clearence_pep, nr_seq_status_farm, ds_justificativa, ds_justif_imp_adep, nm_usuario_imp_adep, dt_imp_adep, nr_seq_transcricao, dt_revisao, nm_usuario_revisao, nr_seq_motivo_susp, ds_motivo_susp, ds_obs_enfermagem, nr_seq_assinatura, nr_controle_lab, ie_gerou_kit, dt_controle_prescr, cd_perfil_ativo, cd_cgc_solic, ie_prescritor_aux, dt_liberacao_aux, ie_prescr_farm, nr_prescricoes, ie_tipo_prescr_cirur, nr_prescricao_original, nr_cirurgia_patologia, ie_prescr_nutricao, ie_prescricao_sae, nr_seq_atend, nr_seq_atend_futuro, dt_inicio_analise_farm, nm_usuario_analise_farm, ie_prescricao_identica, cd_especialidade, nr_prescr_interf_farm, ds_observacao_copia, nr_prescr_orig_fut, ie_modo_integracao, nr_seq_atecaco, ds_endereco_entrega, cd_setor_orig, cd_unid_basica, cd_unid_compl, nr_seq_regra_copia, ie_exame_anterior, ds_exame_anterior, dt_impressao, dt_prescricao_original, nr_seq_assinatura_farm, nr_seq_assinatura_enf, nr_seq_justificativa, dt_ignora_prescr_nut, nm_usuario_ignora_nut, dt_impressao_exame, cd_funcao_origem, ie_liberacao_final, nr_seq_pepo, dt_rep_pt, nr_seq_pend_pac_acao, dt_rep_pt2, nr_seq_assinatura_susp, nr_seq_externo, nr_recem_nato, dt_endosso, nr_seq_consulta_oft, ds_stack, dt_solic_prescr, ds_itens_prescr, qt_tempo_jejum_real, qt_caracter_espaco, qt_dias_extensao, ie_cartao_emergencia, ie_estendida_liberacao, nr_sequencia, cd_dieta, qt_parametro, ds_horarios, ds_obs_dieta, cd_motivo_baixa_dieta, dt_baixa_dieta, ie_destino_dieta, ie_refeicao, ie_suspenso, dt_suspensao_dieta, nm_usuario_susp_dieta, dt_emissao_dieta, qt_urgente) AS select	a.NR_PRESCRICAO,a.CD_PESSOA_FISICA,a.NR_ATENDIMENTO,a.CD_MEDICO,a.DT_PRESCRICAO,a.DT_ATUALIZACAO,a.NM_USUARIO,a.DS_OBSERVACAO,a.NR_HORAS_VALIDADE,a.CD_MOTIVO_BAIXA,a.DT_BAIXA,a.DT_PRIMEIRO_HORARIO,a.DT_LIBERACAO,a.DT_EMISSAO_SETOR,a.DT_EMISSAO_FARMACIA,a.CD_SETOR_ATENDIMENTO,a.DT_ENTRADA_UNIDADE,a.IE_RECEM_NATO,a.IE_ORIGEM_INF,a.NR_PRESCRICAO_ANTERIOR,a.NM_USUARIO_ORIGINAL,a.IE_MOTIVO_PRESCRICAO,a.DT_LIBERACAO_MEDICO,a.NR_PRESCRICAO_MAE,a.CD_PROTOCOLO,a.NR_SEQ_PROTOCOLO,a.DT_ENTREGA,a.CD_SETOR_ENTREGA,a.NR_CIRURGIA,a.NR_SEQ_AGENDA,a.QT_ALTURA_CM,a.QT_PESO,a.DT_MESTRUACAO,a.DS_DADO_CLINICO,a.NR_CONTROLE,a.CD_RECEM_NATO,a.CD_ESTABELECIMENTO,a.DS_MEDICACAO_USO,a.NR_DOC_CONV,a.CD_PRESCRITOR,a.NR_PRIORIDADE,a.DS_DE_ATE,a.DT_SUSPENSAO,a.NM_USUARIO_SUSP,a.CD_SENHA,a.IE_EMERGENCIA,a.NR_SEQ_FORMA_LAUDO,a.NR_SEQ_AGECONS,a.IE_FUNCAO_PRESCRITOR,a.DT_FIM_PRESCRICAO,a.IE_PRESCRICAO_ALTA,a.DT_LIBERACAO_FARMACIA,a.IE_LIB_FARM,a.CD_LOCAL_ESTOQUE,a.DT_VALIDADE_PRESCR,a.DT_INICIO_PRESCR,a.IE_ADEP,a.IE_PRESCR_EMERGENCIA,a.NM_USUARIO_IMP_FAR,a.IE_HEMODIALISE,a.CD_FARMAC_LIB,a.QT_CREATININA,a.QT_CLEARENCE,a.IE_CALCULO_CLEARENCE,a.NM_USUARIO_LIB_ENF,a.NR_SEQ_CLEARENCE_PEP,a.NR_SEQ_STATUS_FARM,a.DS_JUSTIFICATIVA,a.DS_JUSTIF_IMP_ADEP,a.NM_USUARIO_IMP_ADEP,a.DT_IMP_ADEP,a.NR_SEQ_TRANSCRICAO,a.DT_REVISAO,a.NM_USUARIO_REVISAO,a.NR_SEQ_MOTIVO_SUSP,a.DS_MOTIVO_SUSP,a.DS_OBS_ENFERMAGEM,a.NR_SEQ_ASSINATURA,a.NR_CONTROLE_LAB,a.IE_GEROU_KIT,a.DT_CONTROLE_PRESCR,a.CD_PERFIL_ATIVO,a.CD_CGC_SOLIC,a.IE_PRESCRITOR_AUX,a.DT_LIBERACAO_AUX,a.IE_PRESCR_FARM,a.NR_PRESCRICOES,a.IE_TIPO_PRESCR_CIRUR,a.NR_PRESCRICAO_ORIGINAL,a.NR_CIRURGIA_PATOLOGIA,a.IE_PRESCR_NUTRICAO,a.IE_PRESCRICAO_SAE,a.NR_SEQ_ATEND,a.NR_SEQ_ATEND_FUTURO,a.DT_INICIO_ANALISE_FARM,a.NM_USUARIO_ANALISE_FARM,a.IE_PRESCRICAO_IDENTICA,a.CD_ESPECIALIDADE,a.NR_PRESCR_INTERF_FARM,a.DS_OBSERVACAO_COPIA,a.NR_PRESCR_ORIG_FUT,a.IE_MODO_INTEGRACAO,a.NR_SEQ_ATECACO,a.DS_ENDERECO_ENTREGA,a.CD_SETOR_ORIG,a.CD_UNID_BASICA,a.CD_UNID_COMPL,a.NR_SEQ_REGRA_COPIA,a.IE_EXAME_ANTERIOR,a.DS_EXAME_ANTERIOR,a.DT_IMPRESSAO,a.DT_PRESCRICAO_ORIGINAL,a.NR_SEQ_ASSINATURA_FARM,a.NR_SEQ_ASSINATURA_ENF,a.NR_SEQ_JUSTIFICATIVA,a.DT_IGNORA_PRESCR_NUT,a.NM_USUARIO_IGNORA_NUT,a.DT_IMPRESSAO_EXAME,a.CD_FUNCAO_ORIGEM,a.IE_LIBERACAO_FINAL,a.NR_SEQ_PEPO,a.DT_REP_PT,a.NR_SEQ_PEND_PAC_ACAO,a.DT_REP_PT2,a.NR_SEQ_ASSINATURA_SUSP,a.NR_SEQ_EXTERNO,a.NR_RECEM_NATO,a.DT_ENDOSSO,a.NR_SEQ_CONSULTA_OFT,a.DS_STACK,a.DT_SOLIC_PRESCR,a.DS_ITENS_PRESCR,a.QT_TEMPO_JEJUM_REAL,a.QT_CARACTER_ESPACO,a.QT_DIAS_EXTENSAO,a.IE_CARTAO_EMERGENCIA,a.IE_ESTENDIDA_LIBERACAO,
	b.nr_sequencia,
	b.cd_dieta,
	b.qt_parametro,
	b.ds_horarios,
	b.ds_observacao ds_obs_dieta,
	b.cd_motivo_baixa cd_motivo_baixa_dieta,
	b.dt_baixa dt_baixa_dieta,
	b.ie_destino_dieta,
	b.ie_refeicao,
	b.ie_suspenso,
	b.dt_suspensao dt_suspensao_dieta,
	b.nm_usuario_susp nm_usuario_susp_dieta,
	b.dt_emissao_dieta,
	0 qt_urgente
FROM	prescr_dieta b,
	prescr_medica a
where	a.nr_prescricao	= b.nr_prescricao
and	a.dt_liberacao is not null
and	a.dt_prescricao > LOCALTIMESTAMP - interval '5 days'
and	b.dt_emissao_dieta is null
and not exists (select 1
		from rep_jejum z
		where z.nr_prescricao = a.nr_prescricao)
and not exists (select 1
		from nut_paciente x
		where x.nr_prescricao = a.nr_prescricao)

union

select  a.NR_PRESCRICAO,a.CD_PESSOA_FISICA,a.NR_ATENDIMENTO,a.CD_MEDICO,a.DT_PRESCRICAO,a.DT_ATUALIZACAO,a.NM_USUARIO,a.DS_OBSERVACAO,a.NR_HORAS_VALIDADE,a.CD_MOTIVO_BAIXA,a.DT_BAIXA,a.DT_PRIMEIRO_HORARIO,a.DT_LIBERACAO,a.DT_EMISSAO_SETOR,a.DT_EMISSAO_FARMACIA,a.CD_SETOR_ATENDIMENTO,a.DT_ENTRADA_UNIDADE,a.IE_RECEM_NATO,a.IE_ORIGEM_INF,a.NR_PRESCRICAO_ANTERIOR,a.NM_USUARIO_ORIGINAL,a.IE_MOTIVO_PRESCRICAO,a.DT_LIBERACAO_MEDICO,a.NR_PRESCRICAO_MAE,a.CD_PROTOCOLO,a.NR_SEQ_PROTOCOLO,a.DT_ENTREGA,a.CD_SETOR_ENTREGA,a.NR_CIRURGIA,a.NR_SEQ_AGENDA,a.QT_ALTURA_CM,a.QT_PESO,a.DT_MESTRUACAO,a.DS_DADO_CLINICO,a.NR_CONTROLE,a.CD_RECEM_NATO,a.CD_ESTABELECIMENTO,a.DS_MEDICACAO_USO,a.NR_DOC_CONV,a.CD_PRESCRITOR,a.NR_PRIORIDADE,a.DS_DE_ATE,a.DT_SUSPENSAO,a.NM_USUARIO_SUSP,a.CD_SENHA,a.IE_EMERGENCIA,a.NR_SEQ_FORMA_LAUDO,a.NR_SEQ_AGECONS,a.IE_FUNCAO_PRESCRITOR,a.DT_FIM_PRESCRICAO,a.IE_PRESCRICAO_ALTA,a.DT_LIBERACAO_FARMACIA,a.IE_LIB_FARM,a.CD_LOCAL_ESTOQUE,a.DT_VALIDADE_PRESCR,a.DT_INICIO_PRESCR,a.IE_ADEP,a.IE_PRESCR_EMERGENCIA,a.NM_USUARIO_IMP_FAR,a.IE_HEMODIALISE,a.CD_FARMAC_LIB,a.QT_CREATININA,a.QT_CLEARENCE,a.IE_CALCULO_CLEARENCE,a.NM_USUARIO_LIB_ENF,a.NR_SEQ_CLEARENCE_PEP,a.NR_SEQ_STATUS_FARM,a.DS_JUSTIFICATIVA,a.DS_JUSTIF_IMP_ADEP,a.NM_USUARIO_IMP_ADEP,a.DT_IMP_ADEP,a.NR_SEQ_TRANSCRICAO,a.DT_REVISAO,a.NM_USUARIO_REVISAO,a.NR_SEQ_MOTIVO_SUSP,a.DS_MOTIVO_SUSP,a.DS_OBS_ENFERMAGEM,a.NR_SEQ_ASSINATURA,a.NR_CONTROLE_LAB,a.IE_GEROU_KIT,a.DT_CONTROLE_PRESCR,a.CD_PERFIL_ATIVO,a.CD_CGC_SOLIC,a.IE_PRESCRITOR_AUX,a.DT_LIBERACAO_AUX,a.IE_PRESCR_FARM,a.NR_PRESCRICOES,a.IE_TIPO_PRESCR_CIRUR,a.NR_PRESCRICAO_ORIGINAL,a.NR_CIRURGIA_PATOLOGIA,a.IE_PRESCR_NUTRICAO,a.IE_PRESCRICAO_SAE,a.NR_SEQ_ATEND,a.NR_SEQ_ATEND_FUTURO,a.DT_INICIO_ANALISE_FARM,a.NM_USUARIO_ANALISE_FARM,a.IE_PRESCRICAO_IDENTICA,a.CD_ESPECIALIDADE,a.NR_PRESCR_INTERF_FARM,a.DS_OBSERVACAO_COPIA,a.NR_PRESCR_ORIG_FUT,a.IE_MODO_INTEGRACAO,a.NR_SEQ_ATECACO,a.DS_ENDERECO_ENTREGA,a.CD_SETOR_ORIG,a.CD_UNID_BASICA,a.CD_UNID_COMPL,a.NR_SEQ_REGRA_COPIA,a.IE_EXAME_ANTERIOR,a.DS_EXAME_ANTERIOR,a.DT_IMPRESSAO,a.DT_PRESCRICAO_ORIGINAL,a.NR_SEQ_ASSINATURA_FARM,a.NR_SEQ_ASSINATURA_ENF,a.NR_SEQ_JUSTIFICATIVA,a.DT_IGNORA_PRESCR_NUT,a.NM_USUARIO_IGNORA_NUT,a.DT_IMPRESSAO_EXAME,a.CD_FUNCAO_ORIGEM,a.IE_LIBERACAO_FINAL,a.NR_SEQ_PEPO,a.DT_REP_PT,a.NR_SEQ_PEND_PAC_ACAO,a.DT_REP_PT2,a.NR_SEQ_ASSINATURA_SUSP,a.NR_SEQ_EXTERNO,a.NR_RECEM_NATO,a.DT_ENDOSSO,a.NR_SEQ_CONSULTA_OFT,a.DS_STACK,a.DT_SOLIC_PRESCR,a.DS_ITENS_PRESCR,a.QT_TEMPO_JEJUM_REAL,a.QT_CARACTER_ESPACO,a.QT_DIAS_EXTENSAO,a.IE_CARTAO_EMERGENCIA,a.IE_ESTENDIDA_LIBERACAO,
	b.nr_sequencia,
	b.cd_dieta,
	b.qt_parametro,
	b.ds_horarios,
	b.ds_observacao ds_obs_dieta,
	b.cd_motivo_baixa cd_motivo_baixa_dieta,
	b.dt_baixa dt_baixa_dieta,
	b.ie_destino_dieta,
	b.ie_refeicao,
	b.ie_suspenso,
	b.dt_suspensao dt_suspensao_dieta,
	b.nm_usuario_susp nm_usuario_susp_dieta,
	b.dt_emissao_dieta,
	0 qt_urgente
FROM rep_jejum c, prescr_medica a
LEFT OUTER JOIN prescr_dieta b ON (a.nr_prescricao = b.nr_prescricao)
WHERE a.nr_prescricao = c.nr_prescricao and a.dt_liberacao is not null and a.dt_prescricao > LOCALTIMESTAMP - interval '5 days' and b.dt_emissao_dieta is null and c.dt_emissao is null

union

select	a.NR_PRESCRICAO,a.CD_PESSOA_FISICA,a.NR_ATENDIMENTO,a.CD_MEDICO,a.DT_PRESCRICAO,a.DT_ATUALIZACAO,a.NM_USUARIO,a.DS_OBSERVACAO,a.NR_HORAS_VALIDADE,a.CD_MOTIVO_BAIXA,a.DT_BAIXA,a.DT_PRIMEIRO_HORARIO,a.DT_LIBERACAO,a.DT_EMISSAO_SETOR,a.DT_EMISSAO_FARMACIA,a.CD_SETOR_ATENDIMENTO,a.DT_ENTRADA_UNIDADE,a.IE_RECEM_NATO,a.IE_ORIGEM_INF,a.NR_PRESCRICAO_ANTERIOR,a.NM_USUARIO_ORIGINAL,a.IE_MOTIVO_PRESCRICAO,a.DT_LIBERACAO_MEDICO,a.NR_PRESCRICAO_MAE,a.CD_PROTOCOLO,a.NR_SEQ_PROTOCOLO,a.DT_ENTREGA,a.CD_SETOR_ENTREGA,a.NR_CIRURGIA,a.NR_SEQ_AGENDA,a.QT_ALTURA_CM,a.QT_PESO,a.DT_MESTRUACAO,a.DS_DADO_CLINICO,a.NR_CONTROLE,a.CD_RECEM_NATO,a.CD_ESTABELECIMENTO,a.DS_MEDICACAO_USO,a.NR_DOC_CONV,a.CD_PRESCRITOR,a.NR_PRIORIDADE,a.DS_DE_ATE,a.DT_SUSPENSAO,a.NM_USUARIO_SUSP,a.CD_SENHA,a.IE_EMERGENCIA,a.NR_SEQ_FORMA_LAUDO,a.NR_SEQ_AGECONS,a.IE_FUNCAO_PRESCRITOR,a.DT_FIM_PRESCRICAO,a.IE_PRESCRICAO_ALTA,a.DT_LIBERACAO_FARMACIA,a.IE_LIB_FARM,a.CD_LOCAL_ESTOQUE,a.DT_VALIDADE_PRESCR,a.DT_INICIO_PRESCR,a.IE_ADEP,a.IE_PRESCR_EMERGENCIA,a.NM_USUARIO_IMP_FAR,a.IE_HEMODIALISE,a.CD_FARMAC_LIB,a.QT_CREATININA,a.QT_CLEARENCE,a.IE_CALCULO_CLEARENCE,a.NM_USUARIO_LIB_ENF,a.NR_SEQ_CLEARENCE_PEP,a.NR_SEQ_STATUS_FARM,a.DS_JUSTIFICATIVA,a.DS_JUSTIF_IMP_ADEP,a.NM_USUARIO_IMP_ADEP,a.DT_IMP_ADEP,a.NR_SEQ_TRANSCRICAO,a.DT_REVISAO,a.NM_USUARIO_REVISAO,a.NR_SEQ_MOTIVO_SUSP,a.DS_MOTIVO_SUSP,a.DS_OBS_ENFERMAGEM,a.NR_SEQ_ASSINATURA,a.NR_CONTROLE_LAB,a.IE_GEROU_KIT,a.DT_CONTROLE_PRESCR,a.CD_PERFIL_ATIVO,a.CD_CGC_SOLIC,a.IE_PRESCRITOR_AUX,a.DT_LIBERACAO_AUX,a.IE_PRESCR_FARM,a.NR_PRESCRICOES,a.IE_TIPO_PRESCR_CIRUR,a.NR_PRESCRICAO_ORIGINAL,a.NR_CIRURGIA_PATOLOGIA,a.IE_PRESCR_NUTRICAO,a.IE_PRESCRICAO_SAE,a.NR_SEQ_ATEND,a.NR_SEQ_ATEND_FUTURO,a.DT_INICIO_ANALISE_FARM,a.NM_USUARIO_ANALISE_FARM,a.IE_PRESCRICAO_IDENTICA,a.CD_ESPECIALIDADE,a.NR_PRESCR_INTERF_FARM,a.DS_OBSERVACAO_COPIA,a.NR_PRESCR_ORIG_FUT,a.IE_MODO_INTEGRACAO,a.NR_SEQ_ATECACO,a.DS_ENDERECO_ENTREGA,a.CD_SETOR_ORIG,a.CD_UNID_BASICA,a.CD_UNID_COMPL,a.NR_SEQ_REGRA_COPIA,a.IE_EXAME_ANTERIOR,a.DS_EXAME_ANTERIOR,a.DT_IMPRESSAO,a.DT_PRESCRICAO_ORIGINAL,a.NR_SEQ_ASSINATURA_FARM,a.NR_SEQ_ASSINATURA_ENF,a.NR_SEQ_JUSTIFICATIVA,a.DT_IGNORA_PRESCR_NUT,a.NM_USUARIO_IGNORA_NUT,a.DT_IMPRESSAO_EXAME,a.CD_FUNCAO_ORIGEM,a.IE_LIBERACAO_FINAL,a.NR_SEQ_PEPO,a.DT_REP_PT,a.NR_SEQ_PEND_PAC_ACAO,a.DT_REP_PT2,a.NR_SEQ_ASSINATURA_SUSP,a.NR_SEQ_EXTERNO,a.NR_RECEM_NATO,a.DT_ENDOSSO,a.NR_SEQ_CONSULTA_OFT,a.DS_STACK,a.DT_SOLIC_PRESCR,a.DS_ITENS_PRESCR,a.QT_TEMPO_JEJUM_REAL,a.QT_CARACTER_ESPACO,a.QT_DIAS_EXTENSAO,a.IE_CARTAO_EMERGENCIA,a.IE_ESTENDIDA_LIBERACAO,
	b.nr_sequencia,
	b.cd_dieta,
	b.qt_parametro,
	b.ds_horarios,
	b.ds_observacao ds_obs_dieta,
	b.cd_motivo_baixa cd_motivo_baixa_dieta,
	b.dt_baixa dt_baixa_dieta,
	b.ie_destino_dieta,
	b.ie_refeicao,
	b.ie_suspenso,
	b.dt_suspensao dt_suspensao_dieta,
	b.nm_usuario_susp nm_usuario_susp_dieta,
	b.dt_emissao_dieta,
	0 qt_urgente
FROM nut_paciente d, prescr_medica a
LEFT OUTER JOIN prescr_dieta b ON (a.nr_prescricao = b.nr_prescricao)
WHERE a.nr_prescricao	= d.nr_prescricao and a.dt_liberacao is not null and a.dt_prescricao > LOCALTIMESTAMP - interval '5 days' and b.dt_emissao_dieta is null and d.dt_emissao is null and d.ie_suspenso = 'N';

