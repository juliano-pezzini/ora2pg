-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW medico_v (cd_pessoa_fisica, nr_ddd_celular, dt_nascimento, nr_identidade, nr_telefone_celular, nm_pessoa_fisica, nm_social, nr_cartao_nac_sus, nr_cpf, ie_emancipado, ie_tipo_sangue, dt_vencimento_cnh, ds_profissao, cd_funcionario, nr_rga, ds_email_ccih, ie_dependente, nr_seq_nome_solteiro, dt_revisao, dt_demissao_hosp, ie_revisar, dt_naturalizacao_pf, nr_seq_cartorio_nasc, ie_vinculo_profissional, ie_tipo_prontuario, nr_seq_etnia, ie_socio, dt_nascimento_ig, ie_frequenta_escola, dt_validade_conselho, uf_conselho, nm_abreviado, dt_fim_experiencia, nr_reg_geral_estrang, nr_seq_cor_olho, ie_escolaridade_cns, ie_doador, ie_fornecedor, nr_celular_numeros, dt_atualizacao, ie_vinculo_sus, cd_religiao, ie_status_exportar, cd_cbo_sus, nm_sobrenome_pai, dt_cadastro_original, nm_usuario_revisao, ie_fluencia_portugues, qt_semanas_ig, nr_livro_cert_nasc, nr_seq_classif_pac_age, nm_usuario_nrec, cd_curp, nr_cartao_estrangeiro, nr_contra_ref_sus, nr_folha_cert_casamento, dt_alta_institucional, cd_pessoa_cross, dt_adocao, nr_pront_ext, nr_seq_cartorio_divorcio, ie_funcionario, nr_spss, nr_certidao_obito, nr_titulo_eleitor, qt_altura_cm, ie_dependencia_sus, nr_cnh, nr_ddi_celular, nr_livro_cert_casamento, ie_estado_civil, ds_fonetica_cns, nr_pager_bip, nr_portaria_nat, ds_fonetica, ie_fumante, cd_cgc_orig_transpl, ds_orgao_emissor_ci, ds_observacao, nr_inscricao_municipal, sg_estado_nasc, ie_gemelar, nr_seq_agencia_inss, nr_seq_cor_pele, cd_nit, nr_seq_funcao_pf, ie_nf_correio, nr_seq_perfil, nr_seq_person_name, nr_prontuario, ds_historico, ie_perm_sms_email, ie_vegetariano, ie_grau_instrucao, dt_afastamento, qt_peso_nasc, nr_cep_cidade_nasc, nr_seq_lingua_indigena, dt_laudo_anat_patol, nm_usuario, nr_pis_pasep, ds_categoria_cnh, nr_seq_conselho, ds_laudo_anat_patol, nr_zona, nm_usuario_princ_ci, dt_integracao_externa, ie_consiste_nr_serie_nf, cd_cid_direta, qt_peso, nr_pront_dv, nr_iss, dt_chegada_brasil, nr_seq_cartorio_casamento, nm_usuario_original, ds_orientacao_cobranca, cd_nacionalidade, nr_seq_chefia, dt_geracao_pront, cd_cargo, nr_cert_divorcio, dt_inicio_ocup_atual, nr_cert_nasc, dt_emissao_ctps, cd_atividade_sus, ds_empresa_pf, nm_pessoa_pesquisa, nr_inss, nr_cert_militar, uf_emissora_ctps, nr_seq_pais, ie_situacao_conj_cns, sg_emissora_ci, cd_declaracao_nasc_vivo, nr_folha_cert_nasc, nr_ctps, dt_atualizacao_nrec, dt_emissao_ci, dt_emissao_cert_divorcio, ie_status_usuario_event, cd_pessoa_mae, nm_primeiro_nome, qt_dependente, dt_admissao_hosp, dt_validade_coren, ie_tipo_pessoa, ds_apelido, cd_rfc, ie_fator_rh, nr_codigo_serv_prest, cd_medico, nr_seq_nut_perfil, dt_obito, ie_rh_fraco, nr_matricula_nasc, nr_seq_tipo_incapacidade, nr_inscricao_estadual, cd_barras_pessoa, cd_tipo_pj, cd_ife, cd_empresa, ie_regra_ig, nr_same, cd_municipio_ibge, nr_transplante, nr_cert_casamento, ie_sexo, dt_emissao_cert_casamento, nr_seq_cor_cabelo, dt_primeira_admissao, nr_ccm, dt_transplante, dt_cad_sistema_ant, dt_fim_prorrogacao, ds_codigo_prof, ie_subtipo_sanguineo, nr_seq_turno_trabalho, ie_tratamento_psiquiatrico, nr_seq_cbo_saude, nr_transacao_sus, ie_coren, qt_dias_ig, nr_secao, nr_livro_cert_divorcio, nr_ric, nr_passaporte, cd_cnes, cd_sistema_ant, dt_validade_rg, ds_municipio_nasc_estrangeiro, cd_estabelecimento, cd_puericultura, nr_serie_ctps, nm_sobrenome_mae, cd_familia, ie_conselheiro, ie_endereco_correspondencia, nr_termo_cert_nasc, nr_registro_pls, dt_emissao_cert_nasc, ie_tipo_definitivo_provisorio, cd_ult_profissao, nr_folha_cert_div, cd_perfil_ativo, nr_seq_tipo_beneficio, nm_pessoa_fisica_sem_acento, ie_ocupacao_habitual, ie_considera_indio, ie_nasc_estimado, qt_peso_um, ie_unid_med_peso, nr_seq_forma_trat, ie_situacao, nr_crm, nm_guerra, ie_cobra_pf_pj, ie_vinculo_medico, cd_cgc, ie_conveniado_sus, ie_auditor_sus, ds_doc_medico, uf_crm) AS SELECT A.CD_PESSOA_FISICA,
       A.NR_DDD_CELULAR,
       A.DT_NASCIMENTO,
       A.NR_IDENTIDADE,
       A.NR_TELEFONE_CELULAR,
       A.NM_PESSOA_FISICA,
       A.NM_SOCIAL,
       A.NR_CARTAO_NAC_SUS,
       A.NR_CPF,
       A.IE_EMANCIPADO,
       A.IE_TIPO_SANGUE,
       A.DT_VENCIMENTO_CNH,
       A.DS_PROFISSAO,
       A.CD_FUNCIONARIO,
       A.NR_RGA,
       A.DS_EMAIL_CCIH,
       A.IE_DEPENDENTE,
       A.NR_SEQ_NOME_SOLTEIRO,
       A.DT_REVISAO,
       A.DT_DEMISSAO_HOSP,
       A.IE_REVISAR,
       A.DT_NATURALIZACAO_PF,
       A.NR_SEQ_CARTORIO_NASC,
       A.IE_VINCULO_PROFISSIONAL,
       A.IE_TIPO_PRONTUARIO,
       A.NR_SEQ_ETNIA,
       A.IE_SOCIO,
       A.DT_NASCIMENTO_IG,
       A.IE_FREQUENTA_ESCOLA,
       A.DT_VALIDADE_CONSELHO,
       A.UF_CONSELHO,
       A.NM_ABREVIADO,
       A.DT_FIM_EXPERIENCIA,
       A.NR_REG_GERAL_ESTRANG,
       A.NR_SEQ_COR_OLHO,
       A.IE_ESCOLARIDADE_CNS,
       A.IE_DOADOR,
       A.IE_FORNECEDOR,
       A.NR_CELULAR_NUMEROS,
       A.DT_ATUALIZACAO,
       A.IE_VINCULO_SUS,
       A.CD_RELIGIAO,
       A.IE_STATUS_EXPORTAR,
       A.CD_CBO_SUS,
       A.NM_SOBRENOME_PAI,
       A.DT_CADASTRO_ORIGINAL,
       A.NM_USUARIO_REVISAO,
       A.IE_FLUENCIA_PORTUGUES,
       A.QT_SEMANAS_IG,
       A.NR_LIVRO_CERT_NASC,
       A.NR_SEQ_CLASSIF_PAC_AGE,
       A.NM_USUARIO_NREC,
       A.CD_CURP,
       A.NR_CARTAO_ESTRANGEIRO,
       A.NR_CONTRA_REF_SUS,
       A.NR_FOLHA_CERT_CASAMENTO,
       A.DT_ALTA_INSTITUCIONAL,
       A.CD_PESSOA_CROSS,
       A.DT_ADOCAO,
       A.NR_PRONT_EXT,
       A.NR_SEQ_CARTORIO_DIVORCIO,
       A.IE_FUNCIONARIO,
       A.NR_SPSS,
       A.NR_CERTIDAO_OBITO,
       A.NR_TITULO_ELEITOR,
       A.QT_ALTURA_CM,
       A.IE_DEPENDENCIA_SUS,
       A.NR_CNH,
       A.NR_DDI_CELULAR,
       A.NR_LIVRO_CERT_CASAMENTO,
       A.IE_ESTADO_CIVIL,
       A.DS_FONETICA_CNS,
       A.NR_PAGER_BIP,
       A.NR_PORTARIA_NAT,
       A.DS_FONETICA,
       A.IE_FUMANTE,
       A.CD_CGC_ORIG_TRANSPL,
       A.DS_ORGAO_EMISSOR_CI,
       A.DS_OBSERVACAO,
       A.NR_INSCRICAO_MUNICIPAL,
       A.SG_ESTADO_NASC,
       A.IE_GEMELAR,
       A.NR_SEQ_AGENCIA_INSS,
       A.NR_SEQ_COR_PELE,
       A.CD_NIT,
       A.NR_SEQ_FUNCAO_PF,
       A.IE_NF_CORREIO,
       A.NR_SEQ_PERFIL,
       A.NR_SEQ_PERSON_NAME,
       A.NR_PRONTUARIO,
       A.DS_HISTORICO,
       A.IE_PERM_SMS_EMAIL,
       A.IE_VEGETARIANO,
       A.IE_GRAU_INSTRUCAO,
       A.DT_AFASTAMENTO,
       A.QT_PESO_NASC,
       A.NR_CEP_CIDADE_NASC,
       A.NR_SEQ_LINGUA_INDIGENA,
       A.DT_LAUDO_ANAT_PATOL,
       A.NM_USUARIO,
       A.NR_PIS_PASEP,
       A.DS_CATEGORIA_CNH,
       A.NR_SEQ_CONSELHO,
       A.DS_LAUDO_ANAT_PATOL,
       A.NR_ZONA,
       A.NM_USUARIO_PRINC_CI,
       A.DT_INTEGRACAO_EXTERNA,
       A.IE_CONSISTE_NR_SERIE_NF,
       A.CD_CID_DIRETA,
       A.QT_PESO,
       A.NR_PRONT_DV,
       A.NR_ISS,
       A.DT_CHEGADA_BRASIL,
       A.NR_SEQ_CARTORIO_CASAMENTO,
       A.NM_USUARIO_ORIGINAL,
       A.DS_ORIENTACAO_COBRANCA,
       A.CD_NACIONALIDADE,
       A.NR_SEQ_CHEFIA,
       A.DT_GERACAO_PRONT,
       A.CD_CARGO,
       A.NR_CERT_DIVORCIO,
       A.DT_INICIO_OCUP_ATUAL,
       A.NR_CERT_NASC,
       A.DT_EMISSAO_CTPS,
       A.CD_ATIVIDADE_SUS,
       A.DS_EMPRESA_PF,
       A.NM_PESSOA_PESQUISA,
       A.NR_INSS,
       A.NR_CERT_MILITAR,
       A.UF_EMISSORA_CTPS,
       A.NR_SEQ_PAIS,
       A.IE_SITUACAO_CONJ_CNS,
       A.SG_EMISSORA_CI,
       A.CD_DECLARACAO_NASC_VIVO,
       A.NR_FOLHA_CERT_NASC,
       A.NR_CTPS,
       A.DT_ATUALIZACAO_NREC,
       A.DT_EMISSAO_CI,
       A.DT_EMISSAO_CERT_DIVORCIO,
       A.IE_STATUS_USUARIO_EVENT,
       A.CD_PESSOA_MAE,
       A.NM_PRIMEIRO_NOME,
       A.QT_DEPENDENTE,
       A.DT_ADMISSAO_HOSP,
       A.DT_VALIDADE_COREN,
       A.IE_TIPO_PESSOA,
       A.DS_APELIDO,
       A.CD_RFC,
       A.IE_FATOR_RH,
       A.NR_CODIGO_SERV_PREST,
       A.CD_MEDICO,
       A.NR_SEQ_NUT_PERFIL,
       A.DT_OBITO,
       A.IE_RH_FRACO,
       A.NR_MATRICULA_NASC,
       A.NR_SEQ_TIPO_INCAPACIDADE,
       A.NR_INSCRICAO_ESTADUAL,
       A.CD_BARRAS_PESSOA,
       A.CD_TIPO_PJ,
       A.CD_IFE,
       A.CD_EMPRESA,
       A.IE_REGRA_IG,
       A.NR_SAME,
       A.CD_MUNICIPIO_IBGE,
       A.NR_TRANSPLANTE,
       A.NR_CERT_CASAMENTO,
       A.IE_SEXO,
       A.DT_EMISSAO_CERT_CASAMENTO,
       A.NR_SEQ_COR_CABELO,
       A.DT_PRIMEIRA_ADMISSAO,
       A.NR_CCM,
       A.DT_TRANSPLANTE,
       A.DT_CAD_SISTEMA_ANT,
       A.DT_FIM_PRORROGACAO,
       A.DS_CODIGO_PROF,
       A.IE_SUBTIPO_SANGUINEO,
       A.NR_SEQ_TURNO_TRABALHO,
       A.IE_TRATAMENTO_PSIQUIATRICO,
       A.NR_SEQ_CBO_SAUDE,
       A.NR_TRANSACAO_SUS,
       A.IE_COREN,
       A.QT_DIAS_IG,
       A.NR_SECAO,
       A.NR_LIVRO_CERT_DIVORCIO,
       A.NR_RIC,
       A.NR_PASSAPORTE,
       A.CD_CNES,
       A.CD_SISTEMA_ANT,
       A.DT_VALIDADE_RG,
       A.DS_MUNICIPIO_NASC_ESTRANGEIRO,
       A.CD_ESTABELECIMENTO,
       A.CD_PUERICULTURA,
       A.NR_SERIE_CTPS,
       A.NM_SOBRENOME_MAE,
       A.CD_FAMILIA,
       A.IE_CONSELHEIRO,
       A.IE_ENDERECO_CORRESPONDENCIA,
       A.NR_TERMO_CERT_NASC,
       A.NR_REGISTRO_PLS,
       A.DT_EMISSAO_CERT_NASC,
       A.IE_TIPO_DEFINITIVO_PROVISORIO,
       A.CD_ULT_PROFISSAO,
       A.NR_FOLHA_CERT_DIV,
       A.CD_PERFIL_ATIVO,
       A.NR_SEQ_TIPO_BENEFICIO,
       A.NM_PESSOA_FISICA_SEM_ACENTO,
       A.IE_OCUPACAO_HABITUAL,
       A.IE_CONSIDERA_INDIO,
       A.IE_NASC_ESTIMADO,
       A.QT_PESO_UM,
       A.IE_UNID_MED_PESO,
       A.NR_SEQ_FORMA_TRAT,
	B.IE_SITUACAO,
       substr(obter_crm_medico(B.cd_pessoa_fisica), 1, 255) nr_crm,
       B.NM_GUERRA,
       B.IE_COBRA_PF_PJ,
       B.IE_VINCULO_MEDICO,
       B.CD_CGC,
       B.IE_CONVENIADO_SUS,
       B.IE_AUDITOR_SUS,
	 CASE WHEN B.ie_cobra_pf_pj='J' THEN B.cd_cgc  ELSE A.nr_cpf END  ds_doc_medico,
	substr(obter_uf_crm_medico(B.cd_pessoa_fisica), 1, 255) uf_crm
FROM   PESSOA_FISICA A,
	MEDICO B
WHERE  A.CD_PESSOA_FISICA = B.CD_PESSOA_FISICA;

