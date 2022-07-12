-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW doenca_cronica_validador_v (nr_atendimento, cd_doenca, nm_pessoa_fisica, cd_pessoa_fisica, ie_doenca_cronica_mx, dt_entrada, nm_primeiro_nome, nm_sobrenome_pai, nm_sobrenome_mae, dt_nascimento, qt_idade, ie_sexo, cd_curp, nr_prontuario, qt_altura_cm, ds_endereco, nr_endereco, cd_cep, nr_telefone, ds_email, nr_telefone_celular, ds_bairro, ds_endereco_outro, nr_endereco_outro, cd_cep_outro, ds_bairro_outro, cd_tipo_asen, cd_tipo_asen_outro, clues, sg_estado_nasc, sg_estado, cd_cat_municipio, sg_estado_outro, cd_cat_municipio_outro, cd_tipo_logradouro, cd_tipo_logradouro_outro, nr_seq_localicacao_mx, nr_seq_localizacao_mx_outro, dt_atualizacao_nrec, dt_atualizacao, nr_seq_etnia, nr_spss, nr_spss_desc, dt_liberacao, dt_diagnostico, dt_inicio_diagnostico, cd_parentesco_mx, dt_atualizacao_antec, cd_doenca_antec, dt_inicio, ie_status, qt_glicemia_capilar, qt_pa_sistolica, qt_pa_diastolica, qt_peso, qt_altura_cm_sn, dt_consulta, dt_agendamento, dt_atualizacao_nrec_sn, ie_tipo_medicao, qt_pontos, ie_resultado_visita, dt_atendimento_visita, dt_atualizacao_nrec_visita, cd_cgc) AS SELECT 	A.NR_ATENDIMENTO NR_ATENDIMENTO,
		B.CD_DOENCA ,
		pf.NM_PESSOA_FISICA ,
		A.CD_PESSOA_FISICA CD_PESSOA_FISICA ,
		C.IE_DOENCA_CRONICA_MX,
		A.DT_ENTRADA,
		Y.DS_GIVEN_NAME NM_PRIMEIRO_NOME,
		Y.DS_FAMILY_NAME NM_SOBRENOME_PAI,
		Y.DS_COMPONENT_NAME_1 NM_SOBRENOME_MAE,
		pf.DT_NASCIMENTO DT_NASCIMENTO,
		OBTER_IDADE(pf.DT_NASCIMENTO, LOCALTIMESTAMP, 'A') QT_IDADE,
		pf.IE_SEXO IE_SEXO,
		pf.CD_CURP CD_CURP,
		pf.NR_PRONTUARIO NR_PRONTUARIO,
		pf.QT_ALTURA_CM QT_ALTURA_CM,
		get_info_end_endereco(cpfr.nr_seq_pessoa_endereco,'RUA_VIALIDADE','D') DS_ENDERECO,
		get_info_end_endereco(cpfr.nr_seq_pessoa_endereco,'NUMERO','D') NR_ENDERECO,
		get_info_end_endereco(cpfr.nr_seq_pessoa_endereco,'CODIGO_POSTAL','D') CD_CEP,
		cpfr.NR_TELEFONE NR_TELEFONE,
		cpfr.DS_EMAIL DS_EMAIL,
		cpfr.NR_TELEFONE_CELULAR NR_TELEFONE_CELULAR,
		get_info_end_endereco(cpfr.nr_seq_pessoa_endereco,'TIPO_BAIRRO','D') DS_BAIRRO,
		get_info_end_endereco(cpfc.nr_seq_pessoa_endereco,'TIPO_LOGRAD','C') DS_ENDERECO_OUTRO,
		get_info_end_endereco(cpfc.nr_seq_pessoa_endereco,'NUMERO','D') NR_ENDERECO_OUTRO,
		get_info_end_endereco(cpfc.nr_seq_pessoa_endereco,'CODIGO_POSTAL','D') CD_CEP_OUTRO,
		get_info_end_endereco(cpfc.nr_seq_pessoa_endereco,'TIPO_BAIRRO','D') DS_BAIRRO_OUTRO,
		get_info_end_endereco(cpfr.nr_seq_pessoa_endereco,'TIPO_BAIRRO','C') CD_TIPO_ASEN,
		get_info_end_endereco(cpfc.nr_seq_pessoa_endereco,'TIPO_BAIRRO','C')CD_TIPO_ASEN_OUTRO,
		pj.CD_INTERNACIONAL CLUES,
		get_info_end_endereco(cpfr.nr_seq_pessoa_endereco,'ESTADO_PROVINCI','C') SG_ESTADO_NASC,
		get_info_end_endereco(cpfr.nr_seq_pessoa_endereco,'ESTADO_PROVINCI','C') SG_ESTADO,
		get_info_end_endereco(cpfr.nr_seq_pessoa_endereco,'MUNICIPIO','C') CD_CAT_MUNICIPIO,
		get_info_end_endereco(cpfc.nr_seq_pessoa_endereco,'ESTADO_PROVINCI','C') SG_ESTADO_OUTRO,
		get_info_end_endereco(cpfc.nr_seq_pessoa_endereco,'MUNICIPIO','C') CD_CAT_MUNICIPIO_OUTRO,
		get_info_end_endereco(cpfr.nr_seq_pessoa_endereco,'TIPO_LOGRAD','C') CD_TIPO_LOGRADOURO,
		get_info_end_endereco(cpfc.nr_seq_pessoa_endereco,'TIPO_LOGRAD','C')  CD_TIPO_LOGRADOURO_OUTRO,
		get_info_end_endereco(cpfr.nr_seq_pessoa_endereco,'LOCALIDADE_AREA','C') NR_SEQ_LOCALICACAO_MX,
		get_info_end_endereco(cpfc.nr_seq_pessoa_endereco,'LOCALIDADE_AREA','C') NR_SEQ_LOCALIZACAO_MX_OUTRO,
		pf.DT_ATUALIZACAO_NREC DT_ATUALIZACAO_NREC,
		pf.DT_ATUALIZACAO DT_ATUALIZACAO,
		pf.NR_SEQ_ETNIA  NR_SEQ_ETNIA,
		pf.NR_SPSS NR_SPSS,
		pf.NR_SPSS NR_SPSS_DESC,
		B.DT_LIBERACAO,
		b.dt_diagnostico,
		b.dt_inicio DT_INICIO_DIAGNOSTICO,
		CASE WHEN pac.nr_atendimento IS NULL THEN  'xpto'  ELSE (SELECT gpx.CD_PARENTESCO_MX FROM GRAU_PARENTESCO gpx WHERE gpx.nr_sequencia = pac.NR_SEQ_PARENTESCO) END  CD_PARENTESCO_MX,
	    CASE WHEN pac.nr_atendimento IS NULL THEN  'xpto'  ELSE TO_CHAR(pac.DT_ATUALIZACAO, 'yyyy-mm-dd hh-mm-ss') END  DT_ATUALIZACAO_ANTEC,
	    CASE WHEN pac.nr_atendimento IS NULL THEN  'xpto'  ELSE pac.CD_DOENCA END  CD_DOENCA_ANTEC,
	    CASE WHEN pac.nr_atendimento IS NULL THEN  LOCALTIMESTAMP  ELSE pac.dt_inicio END  dt_inicio,
		coalesce((SELECT atcx.IE_STATUS FROM PACIENTE_ANTEC_CLINICO atcx WHERE atcx.nr_sequencia = (SELECT MAX(nr_sequencia) FROM PACIENTE_ANTEC_CLINICO WHERE nr_atendimento = a.nr_atendimento)), 'xpto') IE_STATUS,
		TO_CHAR(obter_sinal_vital(a.NR_ATENDIMENTO, 'GC')) QT_GLICEMIA_CAPILAR,
    	TO_CHAR(obter_sinal_vital(a.NR_ATENDIMENTO, 'PAMAX')) QT_PA_SISTOLICA,
    	TO_CHAR(obter_sinal_vital(a.NR_ATENDIMENTO, 'PAMIN')) QT_PA_DIASTOLICA,
    	TO_CHAR(obter_sinal_vital(a.NR_ATENDIMENTO, 'PESO')) QT_PESO,
		TO_CHAR(obter_sinal_vital(a.NR_ATENDIMENTO, 'ALTURA')) QT_ALTURA_CM_SN,
		coalesce((SELECT MAX(DT_CONSULTA) FROM AGENDA_CONSULTA WHERE cd_pessoa_fisica = pf.cd_pessoa_fisica), LOCALTIMESTAMP) DT_CONSULTA,
		coalesce((SELECT MAX(DT_AGENDAMENTO) FROM AGENDA_CONSULTA WHERE cd_pessoa_fisica = pf.cd_pessoa_fisica), LOCALTIMESTAMP) DT_AGENDAMENTO,
		(SELECT z.dt_atualizacao FROM atendimento_sinal_vital z WHERE z.nr_sequencia = (SELECT MAX(asvx.nr_sequencia) FROM atendimento_sinal_vital asvx WHERE asvx.nr_Atendimento = a.nr_Atendimento AND asvx.IE_TIPO_MEDICAO IS NOT NULL)) DT_ATUALIZACAO_NREC_SN,
		(SELECT z.IE_TIPO_MEDICAO FROM atendimento_sinal_vital z WHERE z.nr_sequencia = (SELECT MAX(asvx.nr_sequencia) FROM atendimento_sinal_vital asvx WHERE asvx.nr_Atendimento = a.nr_Atendimento AND asvx.IE_TIPO_MEDICAO IS NOT NULL)) IE_TIPO_MEDICAO,
		(SELECT TO_CHAR(efx.QT_PONTOS) FROM ESCALA_FARGESTROM efx WHERE nr_sequencia = (SELECT MAX(nr_sequencia) FROM ESCALA_FARGESTROM  WHERE cd_pessoa_fisica = a.cd_pessoa_fisica)) QT_PONTOS,
		pha.IE_RESULTADO_VISITA IE_RESULTADO_VISITA,
	   pha.DT_ATENDIMENTO DT_ATENDIMENTO_VISITA,
	   pha.DT_ATUALIZACAO_NREC DT_ATUALIZACAO_NREC_VISITA,
	pj.cd_cgc
FROM pessoa_juridica pj, estabelecimento e, compl_pessoa_fisica cpfr, cid_doenca c, diagnostico_doenca b, atendimento_paciente a
LEFT OUTER JOIN paciente_antec_clinico pac ON (a.nr_atendimento = pac.nr_atendimento)
LEFT OUTER JOIN paciente_hc_atend pha ON (a.NR_ATENDIMENTO = pha.NR_ATENDIMENTO)
, pessoa_fisica pf
LEFT OUTER JOIN person_name y ON (pf.NR_SEQ_PERSON_NAME = Y.NR_SEQUENCIA AND 'main' = Y.DS_TYPE)
LEFT OUTER JOIN compl_pessoa_fisica cpfc ON (pf.CD_PESSOA_FISICA = CPFc.CD_PESSOA_FISICA AND 2 = cpfc.IE_TIPO_COMPLEMENTO)
WHERE A.NR_ATENDIMENTO = B.NR_ATENDIMENTO AND UPPER(trim(both B.CD_DOENCA)) = UPPER(trim(both C.CD_DOENCA_CID)) AND C.IE_DOENCA_CRONICA_MX IS NOT NULL AND C.IE_DOENCA_CRONICA_MX IN ('DIABT', 'HIPAS', 'OBSDA', 'LIPDM', 'MTABO') AND A.CD_PESSOA_FISICA = pf.CD_PESSOA_FISICA AND (B.DT_DIAGNOSTICO IS NOT NULL AND
		b.dt_liberacao IS NOT NULL AND
		b.dt_inativacao IS NULL)   AND pf.CD_PESSOA_FISICA = CPFr.CD_PESSOA_FISICA    AND a.CD_ESTABELECIMENTO = e.CD_ESTABELECIMENTO AND e.CD_CGC = pj.CD_CGC  -- CLUES
  AND pac.NR_SEQ_PARENTESCO IS NOT NULL;

