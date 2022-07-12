-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_pronto_socorro_v (cd_estabelecimento, dt_referencia, hr_atendimento, cd_medico, cd_motivo_alta, ie_clinica, cd_convenio, cd_setor_atendimento, cd_procedencia, ie_tipo_atendimento, cd_especialidade, nr_pacientes, qt_minuto_espera, qt_minuto_consulta, qt_min_espera_med, qt_atend_tempo, nm_usuario_atend, cd_cid_doenca, ds_bairro, cd_pessoa_fisica, nr_seq_queixa, nr_seq_tipo_acidente, ie_carater_inter_sus, qt_min_desfecho, cd_tipo_acomodacao, cd_unidade_basica, cd_unidade_compl, qt_min_ps, nr_seq_triagem, qt_min_triagem, qt_min_atend, nm_usuario_triagem, qt_min_espera_recep, qt_min_abertura_ficha, ie_status, nr_seq_classificacao, ie_desfecho, nr_atendimento, qt_min_fim_enf, nr_seq_triagem_prioridade, qt_min_senha, cd_categoria, qt_minuto_checagem, qt_min_atend_senha, qt_min_senha_cons, qt_min_parecer, qt_min_internacao, qt_min_senha_desfecho, qt_min_classif_atend, qt_min_triagem_cons, qt_min_triagem_atend, qt_min_observacao, nr_seq_turno, nr_pacientes_obs, qt_min_atend_prescr, qt_media_min_espera, qt_media_min_consulta, qt_media_min_espera_med, qt_media_desfecho, qt_media_min_classif_atend, qt_media_min_triagem_cons, qt_media_min_triagem_atend, ds_motivo_alta, ds_convenio, ds_categoria, nm_medico, ds_setor_atendimento, ds_clinica, ds_tipo_atendimento, ds_procedencia, ds_dia_semana, ie_dia_semana, ds_especialidade, ds_cid, ds_categoria_cid, ds_hora_atend, ds_municipio, ds_municipio_ibge, ds_bairro_pf, ie_faixa_etaria, ds_queixa, ds_tipo_acidente, ds_carater_inter, ds_sexo, ds_unidade, ds_tipo_acomodacao, cd_empresa, ds_triagem, ds_horas_atend, ds_horas_perm, ds_status, ds_classificacao, ds_triagem_prioridade, ds_desfecho, ds_atend_pac, nr_seq_triagem_inf, nr_seq_triagem_prior_inf, nr_seq_coordenadoria, ds_coordenadoria, ds_agrup_setor, nr_seq_agrup_classif, nm_paciente, ds_turno, qt_min_atend_prescr_i) AS SELECT	a.CD_ESTABELECIMENTO,a.DT_REFERENCIA,a.HR_ATENDIMENTO,a.CD_MEDICO,a.CD_MOTIVO_ALTA,a.IE_CLINICA,a.CD_CONVENIO,a.CD_SETOR_ATENDIMENTO,a.CD_PROCEDENCIA,a.IE_TIPO_ATENDIMENTO,a.CD_ESPECIALIDADE,a.NR_PACIENTES,a.QT_MINUTO_ESPERA,a.QT_MINUTO_CONSULTA,a.QT_MIN_ESPERA_MED,a.QT_ATEND_TEMPO,a.NM_USUARIO_ATEND,a.CD_CID_DOENCA,a.DS_BAIRRO,a.CD_PESSOA_FISICA,a.NR_SEQ_QUEIXA,a.NR_SEQ_TIPO_ACIDENTE,a.IE_CARATER_INTER_SUS,a.QT_MIN_DESFECHO,a.CD_TIPO_ACOMODACAO,a.CD_UNIDADE_BASICA,a.CD_UNIDADE_COMPL,a.QT_MIN_PS,a.NR_SEQ_TRIAGEM,a.QT_MIN_TRIAGEM,a.QT_MIN_ATEND,a.NM_USUARIO_TRIAGEM,a.QT_MIN_ESPERA_RECEP,a.QT_MIN_ABERTURA_FICHA,a.IE_STATUS,a.NR_SEQ_CLASSIFICACAO,a.IE_DESFECHO,a.NR_ATENDIMENTO,a.QT_MIN_FIM_ENF,a.NR_SEQ_TRIAGEM_PRIORIDADE,a.QT_MIN_SENHA,a.CD_CATEGORIA,a.QT_MINUTO_CHECAGEM,a.QT_MIN_ATEND_SENHA,a.QT_MIN_SENHA_CONS,a.QT_MIN_PARECER,a.QT_MIN_INTERNACAO,a.QT_MIN_SENHA_DESFECHO,a.QT_MIN_CLASSIF_ATEND,a.QT_MIN_TRIAGEM_CONS,a.QT_MIN_TRIAGEM_ATEND,a.QT_MIN_OBSERVACAO,a.NR_SEQ_TURNO,a.NR_PACIENTES_OBS,a.QT_MIN_ATEND_PRESCR,
	round((dividir(a.qt_minuto_espera, a.nr_pacientes))::numeric,2) qt_media_min_espera, 
	round((dividir(a.qt_minuto_consulta, a.nr_pacientes))::numeric,2) qt_media_min_consulta, 
	round((dividir(a.qt_min_espera_med, a.nr_pacientes))::numeric,2) qt_media_min_espera_med, 
	round((dividir(qt_min_desfecho, a.nr_pacientes))::numeric,2) qt_media_desfecho, 
	round((dividir(a.qt_min_classif_atend, a.nr_pacientes))::numeric,2) qt_media_min_classif_atend, 
	round((dividir(a.qt_min_triagem_cons, a.nr_pacientes))::numeric,2) qt_media_min_triagem_cons, 
	round((dividir(a.qt_min_triagem_atend, a.nr_pacientes))::numeric,2) qt_media_min_triagem_atend,	 
	SUBSTR(obter_desc_motivo_alta(a.cd_motivo_alta),1,150) ds_motivo_alta, 
	SUBSTR(obter_nome_convenio(a.cd_convenio),1,255) ds_convenio, 
	SUBSTR(OBTER_CATEGORIA_CONVENIO(a.cd_convenio,a.cd_categoria),1,255) ds_categoria, 
	SUBSTR(obter_nome_pessoa_fisica(a.cd_medico, NULL),1,255) nm_medico, 
	SUBSTR(obter_nome_setor(a.cd_setor_atendimento),1,255) ds_setor_atendimento, 
	SUBSTR(obter_valor_dominio(17, a.ie_clinica),1,255) ds_clinica, 
	SUBSTR(obter_valor_dominio(12, a.ie_tipo_atendimento),1,255) ds_tipo_atendimento, 
	SUBSTR(obter_desc_procedencia(a.cd_procedencia),1,255) ds_procedencia, 
	SUBSTR(TO_CHAR(a.dt_referencia, 'd') ||' - '|| obter_valor_dominio(35, TO_CHAR(a.dt_referencia, 'd')),1,255) ds_dia_semana, 
	SUBSTR(TO_CHAR(a.dt_referencia, 'd'),1,20) ie_dia_semana, 
	SUBSTR(Obter_Desc_Espec_medica(a.cd_especialidade),1,255) ds_especialidade, 
	SUBSTR(OBTER_DESC_CID(cd_cid_doenca),1,100) ds_cid, 
	SUBSTR(Obter_Categoria_Cid(cd_cid_doenca),1,100) ds_categoria_cid, 
	SUBSTR(TO_CHAR(LPAD(a.hr_atendimento,2,0)) || ':00',1,255) ds_hora_atend, 
	SUBSTR(INITCAP(obter_compl_pf(cd_pessoa_fisica,1, 'CI')),1,255) ds_municipio, 
	SUBSTR(INITCAP(obter_compl_pf(cd_pessoa_fisica,1, 'DM')),1,255) ds_municipio_ibge, 
	SUBSTR(coalesce(a.ds_bairro, INITCAP(obter_compl_pf(cd_pessoa_fisica,1, 'B'))),1,255) ds_bairro_pf, 
	SUBSTR(obter_idade(obter_data_nascto_pf(a.cd_pessoa_fisica),a.dt_referencia,'E'),1,10) ie_faixa_etaria, 
	SUBSTR(obter_descricao_padrao('QUEIXA_PACIENTE','DS_QUEIXA',nr_seq_queixa),1,100) ds_queixa, 
	SUBSTR(obter_descricao_padrao('TIPO_ACIDENTE','DS_TIPO_ACIDENTE',nr_seq_tipo_acidente),1,100) ds_tipo_acidente, 
	SUBSTR(obter_valor_dominio(802, a.ie_carater_inter_sus),1,255) ds_carater_inter, 
	SUBSTR(obter_sexo_pf(cd_pessoa_fisica,'D'),1,100) ds_sexo, 
	SUBSTR(obter_nome_setor(a.cd_setor_atendimento) || ' ' || cd_unidade_basica || ' ' || cd_unidade_compl,1,255) ds_unidade, 
	SUBSTR(obter_desc_tipo_acomod(cd_tipo_acomodacao),1,100) ds_tipo_acomodacao, 
	SUBSTR(obter_empresa_estab(a.cd_estabelecimento),1,100) cd_empresa, 
	SUBSTR(obter_desc_triagem(a.nr_seq_triagem),1,60) ds_triagem, 
	SUBSTR(OBTER_HORAS_MINUTOS(qt_min_atend),1,255) ds_horas_atend, 
	SUBSTR(obter_intervalo_min(coalesce(qt_min_atend,0)),1,100) ds_horas_perm, 
	SUBSTR(obter_valor_dominio(2179,a.ie_status),1,150) ds_status, 
	substr(obter_desc_classif_atend(nr_seq_classificacao),1,255) ds_classificacao, 
	substr(obter_dados_tcp(a.nr_seq_triagem_prioridade,'DESC'),1,60) ds_triagem_prioridade, 
	substr(obter_valor_dominio(4559,a.ie_desfecho),1,100) ds_desfecho, 
	a.nr_atendimento||' - '||substr(obter_pessoa_atendimento(a.nr_atendimento,'N'),1,255) ds_atend_pac, 
	coalesce(a.nr_seq_triagem,999) nr_seq_triagem_inf, 
	coalesce(nr_seq_triagem_prioridade,999) nr_seq_triagem_prior_inf, 
	substr(obter_dados_sus_municipio(obter_compl_pf(cd_pessoa_fisica,1,'CDM'),'NC'),1,10) nr_seq_coordenadoria, 
	substr(obter_dados_sus_municipio(obter_compl_pf(cd_pessoa_fisica,1,'CDM'),'DC'),1,255) ds_coordenadoria, 
	substr(Obter_agrup_setor(a.cd_setor_atendimento,'D'),1,255) ds_agrup_setor, 
	somente_numero(substr(Obter_agrup_setor(a.cd_setor_atendimento,'C'),1,255)) nr_seq_agrup_classif, 
	SUBSTR(OBTER_NOME_PF(CD_PESSOA_FISICA),1,80) nm_paciente, 
	SUBSTR(obter_desc_turno_atend(NR_SEQ_TURNO),1,15) DS_TURNO, 
	round((dividir(a.QT_MIN_ATEND_PRESCR, a.nr_pacientes))::numeric,2) QT_MIN_ATEND_PRESCR_I 
FROM	eis_pronto_socorro a;
