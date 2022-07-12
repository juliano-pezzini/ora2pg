-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW sus_apac_unif_v (nr_sequencia, nr_apac, cd_estabelecimento, nr_atendimento, cd_procedimento, ie_origem_proced, dt_competencia, dt_inicio_validade, dt_fim_validade, dt_emissao, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, ie_tipo_apac, cd_motivo_cobranca, cd_medico_responsavel, dt_solicitacao, cd_medico_autorizador, dt_autorizacao, nr_apac_anterior, dt_ocorrencia, cd_cid_principal, cd_cid_secundario, cd_cid_causa_assoc, nr_interno_conta, dt_inicio_tratamento, dt_diagnostico, cd_carater_internacao, cd_cid_topografia, cd_cid_primeiro_trat, cd_cid_segundo_trat, cd_cid_terceiro_trat, dt_pri_tratamento, dt_seg_tratamento, dt_ter_tratamento, ie_linfonodos_reg_inv, cd_estadio, cd_grau_histopat, dt_diag_cito_hist, ie_tratamento_ant, ie_finalidade, cd_cid_pri_radiacao, cd_cid_seg_radiacao, cd_cid_ter_radiacao, nr_campos_pri_radi, nr_campos_seg_radi, nr_campos_ter_radi, dt_inicio_pri_radi, dt_inicio_seg_radi, dt_inicio_ter_radi, dt_fim_pri_radi, dt_fim_seg_radi, dt_fim_ter_radi, ds_sigla_esquema, qt_meses_planejados, qt_meses_autorizados, dt_pri_dialise, qt_altura_cm, qt_peso, qt_diurese, qt_glicose, pr_albumina, pr_hb, ie_acesso_vascular, ie_hiv, ie_hcv, ie_hb_sangue, ie_ultra_abdomen, ie_continuidade_trat, qt_interv_fistola, ie_inscrito_cncdo, nr_tru, ie_transplantado, qt_transplante, ie_gestante, cd_proc_aih1, cd_proc_aih2, cd_proc_aih3, nr_aih1, nr_aih2, dt_cirurgia1, dt_cirurgia2, nr_meses_acomp, dt_acompanhamento, qt_pont_barros, nr_tabela_barros, nr_seq_pri_trat, nr_seq_seg_trat, nr_seq_ter_trat, nr_seq_mot_apac_obt, ds_justificativa, qt_ureia_pre_hemo, qt_ureia_pos_hemo, dt_inicio_dialise_cli, ie_caract_tratamento, ie_acesso_vasc_dial, ie_acomp_nefrol, ie_situacao_usu_ini, ie_situacao_trasp, ie_dados_apto, qt_fosforo, qt_ktv_semanal, qt_pth, ie_inter_clinica, ie_peritonite_diag, ie_encaminhado_fav, ie_encam_imp_cateter, ie_situacao_vacina, ie_anti_hbs, ie_influenza, ie_difteria_tetano, ie_pneumococica, ie_ieca, ie_bra, ie_duplex_previo, ie_cateter_outros, ie_fav_previas, ie_flebites, ie_hematomas, ie_veia_visivel, ie_presenca_pulso, qt_diametro_veia, qt_diametro_arteria, ie_fremito_traj_fav, ie_pulso_fremito, cd_proced, qt_procedimento, cd_cgc_prestador, nr_nf_prestador, vl_procedimento, vl_medico, vl_materiais, vl_custo_operacional, vl_anestesista, ds_proc_principal, ds_procedimento, dt_entrada, dt_alta, nm_paciente, nm_medico_resp, nr_seq_protocolo) AS select
	a.NR_SEQUENCIA,a.NR_APAC,a.CD_ESTABELECIMENTO,a.NR_ATENDIMENTO,a.CD_PROCEDIMENTO,a.IE_ORIGEM_PROCED,a.DT_COMPETENCIA,a.DT_INICIO_VALIDADE,a.DT_FIM_VALIDADE,a.DT_EMISSAO,a.DT_ATUALIZACAO,a.NM_USUARIO,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC,a.IE_TIPO_APAC,a.CD_MOTIVO_COBRANCA,a.CD_MEDICO_RESPONSAVEL,a.DT_SOLICITACAO,a.CD_MEDICO_AUTORIZADOR,a.DT_AUTORIZACAO,a.NR_APAC_ANTERIOR,a.DT_OCORRENCIA,a.CD_CID_PRINCIPAL,a.CD_CID_SECUNDARIO,a.CD_CID_CAUSA_ASSOC,a.NR_INTERNO_CONTA,a.DT_INICIO_TRATAMENTO,a.DT_DIAGNOSTICO,a.CD_CARATER_INTERNACAO,a.CD_CID_TOPOGRAFIA,a.CD_CID_PRIMEIRO_TRAT,a.CD_CID_SEGUNDO_TRAT,a.CD_CID_TERCEIRO_TRAT,a.DT_PRI_TRATAMENTO,a.DT_SEG_TRATAMENTO,a.DT_TER_TRATAMENTO,a.IE_LINFONODOS_REG_INV,a.CD_ESTADIO,a.CD_GRAU_HISTOPAT,a.DT_DIAG_CITO_HIST,a.IE_TRATAMENTO_ANT,a.IE_FINALIDADE,a.CD_CID_PRI_RADIACAO,a.CD_CID_SEG_RADIACAO,a.CD_CID_TER_RADIACAO,a.NR_CAMPOS_PRI_RADI,a.NR_CAMPOS_SEG_RADI,a.NR_CAMPOS_TER_RADI,a.DT_INICIO_PRI_RADI,a.DT_INICIO_SEG_RADI,a.DT_INICIO_TER_RADI,a.DT_FIM_PRI_RADI,a.DT_FIM_SEG_RADI,a.DT_FIM_TER_RADI,a.DS_SIGLA_ESQUEMA,a.QT_MESES_PLANEJADOS,a.QT_MESES_AUTORIZADOS,a.DT_PRI_DIALISE,a.QT_ALTURA_CM,a.QT_PESO,a.QT_DIURESE,a.QT_GLICOSE,a.PR_ALBUMINA,a.PR_HB,a.IE_ACESSO_VASCULAR,a.IE_HIV,a.IE_HCV,a.IE_HB_SANGUE,a.IE_ULTRA_ABDOMEN,a.IE_CONTINUIDADE_TRAT,a.QT_INTERV_FISTOLA,a.IE_INSCRITO_CNCDO,a.NR_TRU,a.IE_TRANSPLANTADO,a.QT_TRANSPLANTE,a.IE_GESTANTE,a.CD_PROC_AIH1,a.CD_PROC_AIH2,a.CD_PROC_AIH3,a.NR_AIH1,a.NR_AIH2,a.DT_CIRURGIA1,a.DT_CIRURGIA2,a.NR_MESES_ACOMP,a.DT_ACOMPANHAMENTO,a.QT_PONT_BARROS,a.NR_TABELA_BARROS,a.NR_SEQ_PRI_TRAT,a.NR_SEQ_SEG_TRAT,a.NR_SEQ_TER_TRAT,a.NR_SEQ_MOT_APAC_OBT,a.DS_JUSTIFICATIVA,a.QT_UREIA_PRE_HEMO,a.QT_UREIA_POS_HEMO,a.DT_INICIO_DIALISE_CLI,a.IE_CARACT_TRATAMENTO,a.IE_ACESSO_VASC_DIAL,a.IE_ACOMP_NEFROL,a.IE_SITUACAO_USU_INI,a.IE_SITUACAO_TRASP,a.IE_DADOS_APTO,a.QT_FOSFORO,a.QT_KTV_SEMANAL,a.QT_PTH,a.IE_INTER_CLINICA,a.IE_PERITONITE_DIAG,a.IE_ENCAMINHADO_FAV,a.IE_ENCAM_IMP_CATETER,a.IE_SITUACAO_VACINA,a.IE_ANTI_HBS,a.IE_INFLUENZA,a.IE_DIFTERIA_TETANO,a.IE_PNEUMOCOCICA,a.IE_IECA,a.IE_BRA,a.IE_DUPLEX_PREVIO,a.IE_CATETER_OUTROS,a.IE_FAV_PREVIAS,a.IE_FLEBITES,a.IE_HEMATOMAS,a.IE_VEIA_VISIVEL,a.IE_PRESENCA_PULSO,a.QT_DIAMETRO_VEIA,a.QT_DIAMETRO_ARTERIA,a.IE_FREMITO_TRAJ_FAV,a.IE_PULSO_FREMITO, 
	c.cd_procedimento cd_proced, 
	c.qt_procedimento, 
	c.cd_cgc_prestador, 
	c.nr_nf_prestador, 
	c.vl_procedimento, 
	c.vl_medico, 
	c.vl_materiais, 
	c.vl_custo_operacional, 
	c.vl_anestesista, 
	substr(obter_descricao_procedimento(a.cd_procedimento, 
			a.ie_origem_proced),1,80) ds_proc_principal, 
	substr(obter_descricao_procedimento(c.cd_procedimento, 
			c.ie_origem_proced),1,80) ds_procedimento, 
	d.dt_entrada, 
	d.dt_alta, 
	d.nm_paciente, 
	e.nm_pessoa_fisica nm_medico_resp, 
	f.nr_seq_protocolo 
FROM pessoa_fisica e, atendimento_paciente_v d, procedimento_paciente c, sus_apac_unif a
LEFT OUTER JOIN conta_paciente f ON (a.nr_interno_conta = f.nr_interno_conta)
WHERE c.ie_origem_proced	= 7 and a.nr_atendimento	= d.nr_atendimento and a.cd_medico_responsavel	= e.cd_pessoa_fisica  and f.nr_interno_conta	= c.nr_interno_conta and c.cd_motivo_exc_conta	is null;

