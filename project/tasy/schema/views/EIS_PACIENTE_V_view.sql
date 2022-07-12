-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_paciente_v (cd_cgc_indicacao, cd_cgc_seguradora, cd_estabelecimento, cd_funcao_alta_medica, cd_lugar_acc, cd_medico_atendimento, cd_medico_chamado, cd_medico_infect, cd_medico_preferencia, cd_medico_referido, cd_medico_resp, cd_motivo_alta, cd_motivo_alta_medica, cd_municipio_ocorrencia, cd_perfil_ativo, cd_pessoa_fisica, cd_pessoa_indic, cd_pessoa_juridica_indic, cd_pessoa_responsavel, cd_procedencia, cd_psicologo, cd_serv_alta_mx, cd_serv_entrada_mx, cd_serv_sec_mx, cd_serv_ter_mx, cd_setor_desejado, cd_setor_obito, cd_setor_usuario_atend, cd_tipo_acomod_desej, crm_medico_externo, ds_causa_externa, ds_informacao, ds_justif_saida_real, ds_obs_alta, ds_obs_alta_medic, ds_observacao, ds_observacao_biobanco, ds_obs_pa, ds_obs_prev_alta, ds_obs_prior, ds_pend_autorizacao, ds_sintoma_paciente, ds_utc, ds_utc_atualizacao, ds_vinculo_censo, dt_alta, dt_alta_interno, dt_alta_medico, dt_alta_tesouraria, dt_atend_medico, dt_atend_original, dt_atualizacao, dt_atualizacao_biobanco, dt_atualizacao_nrec, dt_cancelamento, dt_chamada_enfermagem, dt_chamada_medic, dt_chamada_paciente, dt_chamada_reavaliacao, dt_checagem_adep, dt_chegada_medic, dt_chegada_paciente, dt_classif_risco, dt_descolonizar_paciente, dt_entrada, dt_fim_consulta, dt_fim_conta, dt_fim_esp_exame, dt_fim_observacao, dt_fim_prescr_pa, dt_fim_reavaliacao, dt_fim_triagem, dt_impressao, dt_impressao_alta, dt_inicio_atendimento, dt_inicio_esp_exame, dt_inicio_observacao, dt_inicio_prescr_pa, dt_inicio_reavaliacao, dt_liberacao_enfermagem, dt_liberacao_financeiro, dt_lib_medico, dt_medicacao, dt_ocorrencia, dt_previsto_alta, dt_reavaliacao_medica, dt_recebimento_senha, dt_saida_prev_loc_pa, dt_saida_real, dt_ultima_menstruacao, dt_usuario_intern, dt_ver_prev_alta, ie_assinou_termo_biobanco, ie_avisar_medico_referido, ie_boletim_inform, ie_carater_inter_sus, ie_chamado, ie_classif_lote_ent, ie_clinica, ie_clinica_alta, ie_clinica_ant, ie_declaracao_obito, ie_divulgar_obito, ie_extra_teto, ie_fim_conta, ie_grupo_atend_bpa, ie_horario_verao, ie_laudo_preenchido, ie_liberado_checkout, ie_modo_internacao, ie_necropsia, ie_nivel_atencao, ie_paciente_gravida, ie_paciente_isolado, ie_permite_acomp, ie_permite_visita, ie_permite_visita_rel, ie_prm, ie_probabilidade_alta, ie_responsavel, ie_status_atendimento, ie_status_pa, ie_tipo_alta, ie_tipo_atend_bpa, ie_tipo_atendimento, ie_tipo_atend_tiss, ie_tipo_consulta, ie_tipo_convenio, ie_tipo_endereco_entrega, ie_tipo_saida_consulta, ie_tipo_serv_mx, ie_tipo_status_alta, ie_tipo_vaga, ie_trat_conta_rn, ie_vinculo_sus, nm_descolonizar_paciente, nm_fim_triagem, nm_inicio_atendimento, nm_medico_externo, nm_usuario, nm_usuario_alta, nm_usuario_alta_medica, nm_usuario_atend, nm_usuario_biobanco, nm_usuario_cancelamento, nm_usuario_intern, nm_usuario_nrec, nm_usuario_prob_alta, nm_usuario_saida, nm_usuario_triagem, nr_atend_alta, nr_atendimento, nr_atendimento_mae, nr_atend_origem_bpa, nr_atend_origem_pa, nr_atend_original, nr_bilhete, nr_cat, nr_conv_interno, nr_dias_prev_alta, nr_gestante_pre_natal, nr_int_cross, nr_reserva_leito, nr_seq_atend_pls, nr_seq_cat, nr_seq_check_list, nr_seq_classif_esp, nr_seq_classificacao, nr_seq_classif_medico, nr_seq_episodio, nr_seq_evento_atend, nr_seq_ficha, nr_seq_ficha_lote, nr_seq_ficha_lote_ant, nr_seq_forma_chegada, nr_seq_forma_laudo, nr_seq_grau_parentesco, nr_seq_indicacao, nr_seq_informacao, nr_seq_local_destino, nr_seq_local_pa, nr_seq_motivo_biobanco, nr_seq_oftalmo, nr_seq_pac_senha_fila, nr_seq_pa_status, nr_seq_pq_protocolo, nr_seq_queixa, nr_seq_registro, nr_seq_regra_funcao, nr_seq_segurado, nr_seq_tipo_acidente, nr_seq_tipo_admissao_fat, nr_seq_tipo_lesao, nr_seq_tipo_midia, nr_seq_tipo_obs_alta, nr_seq_topografia, nr_seq_triagem, nr_seq_triagem_old, nr_seq_triagem_prioridade, nr_seq_unid_atual, nr_seq_unid_int, nr_serie_bilhete, nr_submotivo_alta, nr_vinculo_censo, qt_dia_longa_perm, qt_dias_prev_inter, qt_ig_dia, qt_ig_semana, vl_consulta, cd_religiao, ie_sexo, ie_estado_civil, ie_grau_instrucao, nm_usuario_int, nm_usuario_atend_up, nm_usuario_inter_up, nm_usuario_alta_up, ds_retorno, cd_retorno, cd_convenio, ds_convenio, ie_faixa_etaria, ds_municipio_ibge, ds_municipio, cd_municipio_ibge, ds_bairro, ds_procedencia, ds_sexo, ds_estado_civil, ds_grau_instrucao, ds_tipo_atendimento, ds_clinica, ds_religiao, nm_medico, ds_forma_chegada, ds_tipo_acidente, cd_especialidade, ds_especialidade, cd_setor_atendimento, ds_setor_atendimento, ds_microregiao, dt_dia_entrada, dt_dia_alta, dt_mes_entrada, dt_ano_entrada, cd_tipo_convenio, ds_tipo_convenio, ds_tipo_indicacao, nm_pessoa_indic, nm_pj_indic, ie_atendimento, ds_atendimento, ds_motivo_alta, nr_primeiro_atend, cd_empresa_atend, nm_empresa_atend, ds_classificacao, ds_diagnostico, cd_doenca_cid, ie_tipo_guia, ds_tipo_guia, ds_interna_proc, ds_lado, ds_procedimento, cd_procedimento, ie_proced_origem, nm_procedimento_up, ds_tipo_acomodacao, nr_dias_internado, ds_estabelecimento, ds_queixa, cd_classif_setor, ds_classif_setor, ds_classif_medico, ds_hora, cd_hora, ds_dia_semana, ds_dia_mes, ds_dia_mes_alta, ds_categoria, cd_plano, ds_plano, ds_nacionalidade, ds_carater_inter, ds_unidade, ds_hora_intervalo, cd_hora_intervalo, cd_empresa, ds_dia_turno, ds_turno, cd_turno, nr_dias_internado_number, ds_idade, cd_idade, nr_seq_cor_pele, ds_cor_pele, ie_fluencia_portugues, ds_fluencia_portugues, ds_usuario_alta, ds_usuario_atend, ds_usuario_internacao, ds_cidade_natal, nr_cep_cidade_nasc, ds_municipio_estado_ibge, nm_medico_referido, ds_motivo_transf, ds_hospital_destino, ds_convenio_glosa, ds_categoria_glosa, cd_convenio_glosa, cd_categoria_glosa, ds_categoria_cid, cd_categoria_cid, ds_hora_alta, cd_hora_alta, cd_setor_entrada, ds_setor_entrada, cd_tipo_historico, ds_tipo_historico, ds_agrupamento, nr_seq_agrupamento, ds_motivo_canc_atend, nr_seq_motivo_canc, ie_atend_cancelado, ds_atend_cancelado, ds_proc_interno, ds_cidade_param86) AS select	a.CD_CGC_INDICACAO,
        a.CD_CGC_SEGURADORA,
        a.CD_ESTABELECIMENTO,
        a.CD_FUNCAO_ALTA_MEDICA,
        a.CD_LUGAR_ACC,
        a.CD_MEDICO_ATENDIMENTO,
        a.CD_MEDICO_CHAMADO,
        a.CD_MEDICO_INFECT,
        a.CD_MEDICO_PREFERENCIA,
        a.CD_MEDICO_REFERIDO,
        a.CD_MEDICO_RESP,
        a.CD_MOTIVO_ALTA,
        a.CD_MOTIVO_ALTA_MEDICA,
        a.CD_MUNICIPIO_OCORRENCIA,
        a.CD_PERFIL_ATIVO,
        a.CD_PESSOA_FISICA,
        a.CD_PESSOA_INDIC,
        a.CD_PESSOA_JURIDICA_INDIC,
        a.CD_PESSOA_RESPONSAVEL,
        a.CD_PROCEDENCIA,
        a.CD_PSICOLOGO,
        a.CD_SERV_ALTA_MX,
        a.CD_SERV_ENTRADA_MX,
        a.CD_SERV_SEC_MX,
        a.CD_SERV_TER_MX,
        a.CD_SETOR_DESEJADO,
        a.CD_SETOR_OBITO,
        a.CD_SETOR_USUARIO_ATEND,
        a.CD_TIPO_ACOMOD_DESEJ,
        a.CRM_MEDICO_EXTERNO,
        a.DS_CAUSA_EXTERNA,
        a.DS_INFORMACAO,
        a.DS_JUSTIF_SAIDA_REAL,
        a.DS_OBS_ALTA,
        a.DS_OBS_ALTA_MEDIC,
        a.DS_OBSERVACAO,
        a.DS_OBSERVACAO_BIOBANCO,
        a.DS_OBS_PA,
        a.DS_OBS_PREV_ALTA,
        a.DS_OBS_PRIOR,
        a.DS_PEND_AUTORIZACAO,
        a.DS_SINTOMA_PACIENTE,
        a.DS_UTC,
        a.DS_UTC_ATUALIZACAO,
        a.DS_VINCULO_CENSO,
        a.DT_ALTA,
        a.DT_ALTA_INTERNO,
        a.DT_ALTA_MEDICO,
        a.DT_ALTA_TESOURARIA,
        a.DT_ATEND_MEDICO,
        a.DT_ATEND_ORIGINAL,
        a.DT_ATUALIZACAO,
        a.DT_ATUALIZACAO_BIOBANCO,
        a.DT_ATUALIZACAO_NREC,
        a.DT_CANCELAMENTO,
        a.DT_CHAMADA_ENFERMAGEM,
        a.DT_CHAMADA_MEDIC,
        a.DT_CHAMADA_PACIENTE,
        a.DT_CHAMADA_REAVALIACAO,
        a.DT_CHECAGEM_ADEP,
        a.DT_CHEGADA_MEDIC,
        a.DT_CHEGADA_PACIENTE,
        a.DT_CLASSIF_RISCO,
        a.DT_DESCOLONIZAR_PACIENTE,
        a.DT_ENTRADA,
        a.DT_FIM_CONSULTA,
        a.DT_FIM_CONTA,
        a.DT_FIM_ESP_EXAME,
        a.DT_FIM_OBSERVACAO,
        a.DT_FIM_PRESCR_PA,
        a.DT_FIM_REAVALIACAO,
        a.DT_FIM_TRIAGEM,
        a.DT_IMPRESSAO,
        a.DT_IMPRESSAO_ALTA,
        a.DT_INICIO_ATENDIMENTO,
        a.DT_INICIO_ESP_EXAME,
        a.DT_INICIO_OBSERVACAO,
        a.DT_INICIO_PRESCR_PA,
        a.DT_INICIO_REAVALIACAO,
        a.DT_LIBERACAO_ENFERMAGEM,
        a.DT_LIBERACAO_FINANCEIRO,
        a.DT_LIB_MEDICO,
        a.DT_MEDICACAO,
        a.DT_OCORRENCIA,
        a.DT_PREVISTO_ALTA,
        a.DT_REAVALIACAO_MEDICA,
        a.DT_RECEBIMENTO_SENHA,
        a.DT_SAIDA_PREV_LOC_PA,
        a.DT_SAIDA_REAL,
        a.DT_ULTIMA_MENSTRUACAO,
        a.DT_USUARIO_INTERN,
        a.DT_VER_PREV_ALTA,
        a.IE_ASSINOU_TERMO_BIOBANCO,
        a.IE_AVISAR_MEDICO_REFERIDO,
        a.IE_BOLETIM_INFORM,
        a.IE_CARATER_INTER_SUS,
        a.IE_CHAMADO,
        a.IE_CLASSIF_LOTE_ENT,
        a.IE_CLINICA,
        a.IE_CLINICA_ALTA,
        a.IE_CLINICA_ANT,
        a.IE_DECLARACAO_OBITO,
        a.IE_DIVULGAR_OBITO,
        a.IE_EXTRA_TETO,
        a.IE_FIM_CONTA,
        a.IE_GRUPO_ATEND_BPA,
        a.IE_HORARIO_VERAO,
        a.IE_LAUDO_PREENCHIDO,
        a.IE_LIBERADO_CHECKOUT,
        a.IE_MODO_INTERNACAO,
        a.IE_NECROPSIA,
        a.IE_NIVEL_ATENCAO,
        a.IE_PACIENTE_GRAVIDA,
        a.IE_PACIENTE_ISOLADO,
        a.IE_PERMITE_ACOMP,
        a.IE_PERMITE_VISITA,
        a.IE_PERMITE_VISITA_REL,
        a.IE_PRM,
        a.IE_PROBABILIDADE_ALTA,
        a.IE_RESPONSAVEL,
        a.IE_STATUS_ATENDIMENTO,
        a.IE_STATUS_PA,
        a.IE_TIPO_ALTA,
        a.IE_TIPO_ATEND_BPA,
        a.IE_TIPO_ATENDIMENTO,
        a.IE_TIPO_ATEND_TISS,
        a.IE_TIPO_CONSULTA,
        a.IE_TIPO_CONVENIO,
        a.IE_TIPO_ENDERECO_ENTREGA,
        a.IE_TIPO_SAIDA_CONSULTA,
        a.IE_TIPO_SERV_MX,
        a.IE_TIPO_STATUS_ALTA,
        a.IE_TIPO_VAGA,
        a.IE_TRAT_CONTA_RN,
        a.IE_VINCULO_SUS,
        a.NM_DESCOLONIZAR_PACIENTE,
        a.NM_FIM_TRIAGEM,
        a.NM_INICIO_ATENDIMENTO,
        a.NM_MEDICO_EXTERNO,
        a.NM_USUARIO,
        a.NM_USUARIO_ALTA,
        a.NM_USUARIO_ALTA_MEDICA,
        a.NM_USUARIO_ATEND,
        a.NM_USUARIO_BIOBANCO,
        a.NM_USUARIO_CANCELAMENTO,
        a.NM_USUARIO_INTERN,
        a.NM_USUARIO_NREC,
        a.NM_USUARIO_PROB_ALTA,
        a.NM_USUARIO_SAIDA,
        a.NM_USUARIO_TRIAGEM,
        a.NR_ATEND_ALTA,
        a.NR_ATENDIMENTO,
        a.NR_ATENDIMENTO_MAE,
        a.NR_ATEND_ORIGEM_BPA,
        a.NR_ATEND_ORIGEM_PA,
        a.NR_ATEND_ORIGINAL,
        a.NR_BILHETE,
        a.NR_CAT,
        a.NR_CONV_INTERNO,
        a.NR_DIAS_PREV_ALTA,
        a.NR_GESTANTE_PRE_NATAL,
        a.NR_INT_CROSS,
        a.NR_RESERVA_LEITO,
        a.NR_SEQ_ATEND_PLS,
        a.NR_SEQ_CAT,
        a.NR_SEQ_CHECK_LIST,
        a.NR_SEQ_CLASSIF_ESP,
        a.NR_SEQ_CLASSIFICACAO,
        a.NR_SEQ_CLASSIF_MEDICO,
        a.NR_SEQ_EPISODIO,
        a.NR_SEQ_EVENTO_ATEND,
        a.NR_SEQ_FICHA,
        a.NR_SEQ_FICHA_LOTE,
        a.NR_SEQ_FICHA_LOTE_ANT,
        a.NR_SEQ_FORMA_CHEGADA,
        a.NR_SEQ_FORMA_LAUDO,
        a.NR_SEQ_GRAU_PARENTESCO,
        a.NR_SEQ_INDICACAO,
        a.NR_SEQ_INFORMACAO,
        a.NR_SEQ_LOCAL_DESTINO,
        a.NR_SEQ_LOCAL_PA,
        a.NR_SEQ_MOTIVO_BIOBANCO,
        a.NR_SEQ_OFTALMO,
        a.NR_SEQ_PAC_SENHA_FILA,
        a.NR_SEQ_PA_STATUS,
        a.NR_SEQ_PQ_PROTOCOLO,
        a.NR_SEQ_QUEIXA,
        a.NR_SEQ_REGISTRO,
        a.NR_SEQ_REGRA_FUNCAO,
        a.NR_SEQ_SEGURADO,
        a.NR_SEQ_TIPO_ACIDENTE,
        a.NR_SEQ_TIPO_ADMISSAO_FAT,
        a.NR_SEQ_TIPO_LESAO,
        a.NR_SEQ_TIPO_MIDIA,
        a.NR_SEQ_TIPO_OBS_ALTA,
        a.NR_SEQ_TOPOGRAFIA,
        a.NR_SEQ_TRIAGEM,
        a.NR_SEQ_TRIAGEM_OLD,
        a.NR_SEQ_TRIAGEM_PRIORIDADE,
        a.NR_SEQ_UNID_ATUAL,
        a.NR_SEQ_UNID_INT,
        a.NR_SERIE_BILHETE,
        a.NR_SUBMOTIVO_ALTA,
        a.NR_VINCULO_CENSO,
        a.QT_DIA_LONGA_PERM,
        a.QT_DIAS_PREV_INTER,
        a.QT_IG_DIA,
        a.QT_IG_SEMANA,
        a.VL_CONSULTA,
	b.cd_religiao,
	b.ie_sexo,
	b.ie_estado_civil,
	b.ie_grau_instrucao,
	(select substr(obter_usuario_prim_internacao(a.NM_USUARIO_INTERN,a.nr_atendimento),1,15) ) nm_usuario_int,
	uppeR(a.nm_usuario_atend) nm_usuario_atend_up,
	(select upper(substr(obter_usuario_prim_internacao(a.NM_USUARIO_INTERN,a.nr_atendimento),1,15)) ) nm_usuario_inter_up,
	upper(a.nm_usuario_alta) nm_usuario_alta_up,
	(select CASE WHEN Obter_se_atend_retorno(a.nr_atendimento)='S' THEN  OBTER_DESC_EXPRESSAO(297871)   ELSE OBTER_DESC_EXPRESSAO(346808) END  ) ds_retorno,
	(select Obter_se_atend_retorno(a.nr_atendimento) ) cd_retorno,
	d.cd_convenio cd_convenio,
	(select substr(obter_nome_convenio(d.cd_convenio),1,150) ) ds_convenio,
	(select substr(obter_idade(b.dt_nascimento,dt_entrada,'E'),1,10) ) ie_faixa_etaria,
	(select Initcap(obter_compl_pf(b.cd_pessoa_fisica,1, 'DM')) ) ds_municipio_ibge,
	(select Initcap(obter_compl_pf(b.cd_pessoa_fisica,1, 'DSM')) ) ds_municipio,
	(select obter_compl_pf(b.cd_pessoa_fisica,1, 'CDM') ) cd_municipio_ibge,
	(select Initcap(obter_compl_pf(b.cd_pessoa_fisica,1, 'B')) ) ds_bairro,
	(select obter_desc_procedencia(a.cd_procedencia) ) ds_procedencia,
	(select obter_valor_dominio(4, b.ie_sexo) ) ds_sexo,
	(select obter_valor_dominio(5, b.ie_estado_civil) ) ds_estado_civil,
	(select obter_valor_dominio(10, b.ie_grau_instrucao) ) ds_grau_instrucao,
	(select obter_valor_dominio(12, a.ie_tipo_atendimento) ) ds_tipo_atendimento,
	(select obter_valor_dominio(17, a.ie_clinica) ) ds_clinica,
	(select obter_descricao_padrao('RELIGIAO', 'DS_RELIGIAO', b.cd_religiao) ) ds_religiao,
	(select obter_nome_pessoa_fisica(a.cd_medico_resp, null) ) nm_medico,
	(select obter_descricao_padrao('FORMA_CHEGADA', 'DS_FORMA', A.NR_SEQ_FORMA_CHEGADA) ) ds_forma_chegada,
	(select obter_descricao_padrao('TIPO_ACIDENTE', 'DS_TIPO_ACIDENTE', A.NR_SEQ_TIPO_ACIDENTE) ) ds_tipo_acidente,
	(select COALESCE(Obter_Espec_medico_atend(a.nr_atendimento,a.cd_medico_resp,'C'), Obter_Especialidade_medico(a.cd_medico_resp, 'C')) ) cd_especialidade,
	(select COALESCE(Obter_Espec_medico_atend(a.nr_atendimento,a.cd_medico_resp,'D'), Obter_Especialidade_medico(a.cd_medico_resp, 'D')) ) ds_especialidade,
	c.cd_setor_atendimento,
	(select obter_nome_setor(c.cd_setor_atendimento) ) ds_setor_atendimento,
 	(select COALESCE(Obter_Microregiao_Paciente(obter_compl_pf(b.cd_pessoa_fisica,1,'CEP'),obter_compl_pf(b.cd_pessoa_fisica,1,'CDM')),Obter_Microregiao_Paciente(null,obter_compl_pf(b.cd_pessoa_fisica,1,'CDM'))) ) ds_microregiao,
	trunc(a.dt_entrada, 'dd') dt_dia_entrada,
	trunc(a.dt_alta, 'dd') dt_dia_alta,
	trunc(a.dt_entrada, 'mm') dt_mes_entrada,
	trunc(a.dt_entrada, 'year') dt_ano_entrada,
	(select obter_tipo_convenio(d.cd_convenio) ) cd_tipo_convenio,
	(select substr(obter_desc_tipo_convenio(d.cd_convenio),1,200) ) ds_tipo_convenio,
	(select substr(obter_descricao_padrao('TIPO_INDICACAO', 'DS_INDICACAO', a.NR_SEQ_INDICACAO),1,100) ) ds_tipo_indicacao,
	(select substr(obter_nome_pf(a.CD_PESSOA_INDIC),1,200) ) nm_pessoa_indic,
	(select substr(obter_nome_pf_pj(null,cd_pessoa_juridica_indic),1,200) ) nm_pj_indic,
	CASE WHEN COALESCE(a.nr_atend_original,0)=0 THEN 'N'  ELSE 'O' END  ie_atendimento,
	(select obter_valor_dominio(1536,CASE WHEN COALESCE(a.nr_atend_original,0)=0 THEN 'N'  ELSE 'O' END ) ) ds_atendimento,
	(select obter_desc_motivo_alta(a.cd_motivo_alta) ) ds_motivo_alta,
	(select CASE WHEN obter_se_primeiro_atend_pf(a.cd_pessoa_fisica)=a.nr_atendimento THEN 1  ELSE 0 END  ) nr_primeiro_atend,
	(select Obter_Empresa_Atend(a.nr_atendimento,'A','C') ) cd_empresa_atend,
	(select Obter_Empresa_Atend(a.nr_atendimento,'A','N') ) nm_empresa_atend,
	(select substr(obter_descricao_padrao('CLASSIFICACAO_ATENDIMENTO','DS_CLASSIFICACAO',a.NR_SEQ_CLASSIFICACAO),1,254) ) ds_classificacao,
	(select substr(obter_diagnostico_atendimento(a.nr_atendimento),1,100) ) ds_diagnostico,
	(select substr(obter_diag_atend_opcao(a.nr_atendimento,'CD'),1,254) ) cd_doenca_cid,
	(select obter_tipo_guia_convenio(a.nr_atendimento) ) ie_tipo_guia,
	(select obter_valor_dominio(1031,obter_tipo_guia_convenio(a.nr_atendimento)) ) ds_tipo_guia,
	(select substr(Obter_Desc_intern_Proc_Princ(a.nr_atendimento),1,125) ) ds_interna_proc,
	(select obter_lado_proced_princ_atend(a.nr_atendimento, 'D') ) ds_lado,
	(select substr(obter_proc_principal(a.nr_atendimento, d.cd_convenio, a.ie_tipo_atendimento, null, 'D'),1,50) ) ds_procedimento,
	(select substr(obter_proc_principal(a.nr_atendimento, d.cd_convenio, a.ie_tipo_atendimento, null, 'C'),1,50) ) cd_procedimento,
	(select substr(obter_proc_principal(a.nr_atendimento, d.cd_convenio, a.ie_tipo_atendimento, null, 'IO'),1,50) ) ie_proced_origem,
	(select upper(substr(obter_proc_principal(a.nr_atendimento, d.cd_convenio, a.ie_tipo_atendimento, null, 'D'),1,50)) ) nm_procedimento_up,
	(select substr(obter_tipo_acomod_atend(a.nr_atendimento,'D'),1,80) ) ds_tipo_acomodacao,
	trunc(trunc(COALESCE(A.DT_ALTA, LOCALTIMESTAMP)) - trunc(A.DT_ENTRADA)) nr_dias_internado,
	(select substr(obter_nome_estabelecimento(a.cd_estabelecimento),1,80) ) ds_estabelecimento,
	(select substr(obter_descricao_padrao('QUEIXA_PACIENTE','DS_QUEIXA',a.nr_seq_queixa),1,40) ) ds_queixa,
	(select obter_classif_setor(c.cd_setor_atendimento) ) cd_classif_setor,
	(select substr(obter_valor_dominio(1,obter_classif_setor(c.cd_setor_atendimento)),1,100) ) ds_classif_setor,
	(select substr(obter_descricao_padrao('MEDICO_CLASSIF_ATEND','DS_CLASSIFICACAO',a.NR_SEQ_CLASSIF_MEDICO),1,40) ) ds_classif_medico,
	to_char(a.dt_entrada,'hh24')||':00' ds_hora,
	(to_char(a.dt_entrada,'hh24'))::numeric  cd_hora,
	(select substr(obter_dia_semana(a.dt_entrada),1,20) ) ds_dia_semana,
	lpad(to_char(a.dt_entrada,'dd'),2,'0') ds_dia_mes,
	lpad(coalesce(to_char(a.dt_alta,'dd'), '0'),2,'0') ds_dia_mes_alta,
	(select substr(obter_categoria_convenio(d.cd_convenio, d.cd_categoria),1,100) ) ds_categoria,
	cd_plano_convenio cd_plano,
	(select substr(obter_desc_plano_conv(d.cd_convenio,d.cd_plano_convenio),1,100) ) ds_plano,
	(select substr(obter_compl_pf(a.cd_pessoa_fisica,1,'NA'),1,30) ) ds_nacionalidade,
	(select substr(Sus_Obter_Desc_Carater_Int(a.ie_carater_inter_sus),1,50) ) ds_carater_inter,
	(select substr(obter_nome_setor(c.cd_setor_atendimento),1,100) || ' ' || cd_unidade_basica || ' ' || cd_unidade_compl ) ds_unidade,
	(select to_char(truncar_hora_parametro(a.dt_entrada,15),'hh24:mi') ) ds_hora_intervalo,
	(select (to_char(truncar_hora_parametro(a.dt_entrada,15),'hh24mi'))::numeric  ) cd_hora_intervalo,
	f.cd_empresa,
	(select Obter_Turno_Atendimento(a.dt_entrada,a.cd_estabelecimento,'T') ) ds_dia_turno,
	(select Obter_Turno_Atendimento(a.dt_entrada,a.cd_estabelecimento,'D') ) ds_turno,
	(select Obter_Turno_Atendimento(a.dt_entrada,a.cd_estabelecimento,'C') ) cd_turno,
	lpad((trunc(trunc(COALESCE(A.DT_ALTA, LOCALTIMESTAMP)) - trunc(A.DT_ENTRADA)))::numeric ,2,'0') nr_dias_internado_number,
	(select substr(lpad(obter_idade(b.dt_nascimento,LOCALTIMESTAMP,'A'),3,'0'),1,50) ) ds_idade,
	(select (obter_idade(b.dt_nascimento,LOCALTIMESTAMP,'A'))::numeric  ) cd_idade,
	b.nr_seq_cor_pele,
	(select substr(COALESCE(obter_desc_cor_pele(b.nr_seq_cor_pele),OBTER_DESC_EXPRESSAO(778770)),1,80) ) ds_cor_pele,
	b.ie_fluencia_portugues,
	(select substr(obter_valor_dominio(1343,b.ie_fluencia_portugues),1,100) ) ds_fluencia_portugues,
	(select substr(obter_nome_usuario(a.nm_usuario_alta),1,100) ) ds_usuario_alta,
	(select substr(obter_nome_usuario(a.nm_usuario_atend),1,100) ) ds_usuario_atend,
	(select substr(obter_nome_usuario(substr(obter_usuario_prim_internacao(a.NM_USUARIO_INTERN,a.nr_atendimento),1,15)),1,100) ) ds_usuario_internacao,
	(select substr(OBTER_DESC_CEP_LOC(b.NR_CEP_CIDADE_NASC),1,240) ) ds_cidade_natal,
	b.NR_CEP_CIDADE_NASC,
	(select Initcap(obter_compl_pf(b.cd_pessoa_fisica,1, 'DM'))||CASE WHEN obter_compl_pf(b.cd_pessoa_fisica,1,'DM') IS NULL THEN ''  ELSE CASE WHEN obter_uf_ibge(obter_compl_pf(b.cd_pessoa_fisica,1, 'CDM')) IS NULL THEN ''  ELSE ' - '||obter_uf_ibge(obter_compl_pf(b.cd_pessoa_fisica,1, 'CDM')) END  END  ) ds_municipio_estado_ibge,
	(select substr(obter_nome_medico(a.cd_medico_referido,'N'),1,254) ) nm_medico_referido,
	(select substr(Obter_dados_alta_transf(a.nr_atendimento,'DM'),1,255) ) ds_motivo_transf,
	(select substr(Obter_dados_alta_transf(a.nr_atendimento,'HD'),1,255) ) ds_hospital_destino,
	(select substr(obter_nome_convenio(d.cd_convenio_glosa),1,150) ) ds_convenio_glosa,
	(select substr(obter_categoria_convenio(d.cd_convenio_glosa, d.cd_categoria_glosa),1,100) ) ds_categoria_glosa,
	d.cd_convenio_glosa,
	d.cd_categoria_glosa,
	(select substr(obter_desc_categoria_cid(Obter_Categoria_Cid(obter_diag_atend_opcao(a.nr_atendimento,'CD'))),1,100) ) DS_CATEGORIA_CID,
	(select substr(Obter_Categoria_Cid(obter_diag_atend_opcao(a.nr_atendimento,'CD')),1,10) ) cd_categoria_cid,
	to_char(a.dt_alta,'hh24')||':00' ds_hora_alta,
	(to_char(a.dt_alta,'hh24'))::numeric  cd_hora_alta,
	(select	COALESCE(cd_setor_atendimento,0) 
	from	atend_paciente_unidade 
	where	nr_seq_interno = obter_atepacu_paciente(c.nr_atendimento, 'P')) cd_setor_entrada,
	COALESCE(substr(obter_nome_setor((select	cd_setor_atendimento 
	from	atend_paciente_unidade 
	where	nr_seq_interno = obter_atepacu_paciente(c.nr_atendimento, 'P'))),1,255),
	OBTER_DESC_EXPRESSAO(327119)) ds_setor_entrada,
	(select substr(obter_historico_atendimento(c.nr_atendimento, 'C'), 1, 10) ) cd_tipo_historico,
	(select substr(COALESCE(obter_historico_atendimento(c.nr_atendimento, 'D'),OBTER_DESC_EXPRESSAO(327119)), 1, 100) ) ds_tipo_historico,
	(select substr(Obter_desc_agrupamento_setor(c.cd_setor_atendimento),1,255) ) ds_agrupamento,
	(select (substr(Obter_agrupamento_setor(c.cd_setor_atendimento),1,10))::numeric  ) nr_seq_agrupamento,
	(select substr(obter_desc_canc_atend(a.nr_atendimento),1,100) ) ds_motivo_canc_atend,
	(select obter_mot_canc_atend(a.nr_atendimento) ) nr_seq_motivo_canc,
	CASE WHEN a.dt_cancelamento IS NULL THEN 'N'  ELSE 'C' END  ie_atend_cancelado,
	(select obter_valor_dominio(5727,CASE WHEN a.dt_cancelamento IS NULL THEN 'N'  ELSE 'C' END ) ) ds_atend_cancelado,
	(select substr(Obter_Desc_Proc_Inter(somente_numero(obter_proc_principal(a.nr_atendimento, d.cd_convenio, a.ie_tipo_atendimento, null, 'C')),somente_numero(obter_proc_principal(a.nr_atendimento, d.cd_convenio, a.ie_tipo_atendimento, null, 'IO'))),1,100) ) ds_proc_interno,
	(select substr(obter_dados_pf(a.cd_pessoa_fisica,'CNP'),1,240) ) ds_cidade_param86
FROM estabelecimento f, atend_categoria_convenio d, atend_paciente_unidade c, pessoa_fisica b, atendimento_paciente a
LEFT OUTER JOIN motivo_alta h ON (a.cd_motivo_alta = h.cd_motivo_alta)
WHERE a.cd_pessoa_fisica	= b.cd_pessoa_fisica and a.nr_atendimento	= c.nr_atendimento and d.nr_atendimento	= a.nr_atendimento and a.cd_estabelecimento	= f.cd_estabelecimento  and COALESCE(h.ie_cancelado,'N')	= 'N' and c.nr_seq_interno 	=
	(	select	coalesce(max(x.nr_seq_interno),0)
		from 	atend_paciente_unidade x
		where	x.nr_atendimento = a.nr_atendimento
	  	and 	coalesce(x.dt_saida_unidade, x.dt_entrada_unidade + 9999)	= 
			(select max(coalesce(y.dt_saida_unidade, y.dt_entrada_unidade + 9999))
			from 	atend_paciente_unidade y
			where 	y.nr_atendimento 	= a.nr_atendimento)) and d.nr_seq_interno	= (	select	coalesce(max(p.nr_seq_interno),0)
					from 	atend_categoria_convenio p
					where	p.nr_atendimento = a.nr_atendimento
					and 	p.dt_inicio_vigencia = 
						(	select max(q.dt_inicio_vigencia)
							from atend_categoria_convenio q
							where q.nr_atendimento = a.nr_atendimento));
