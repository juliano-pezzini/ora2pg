-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_censo_diario_v3 (ds_faixa_etaria, ds_idade, cd_idade, cd_convenio, cd_estabelecimento, ie_periodo, cd_tipo_acomodacao, cd_setor_atendimento, ie_clinica, dt_referencia, cd_medico, nm_pessoa_fisica, nm_paciente, ie_situacao, cd_procedencia, ie_tipo_atendimento, qt_hora_alta, ie_clinica_alta, nr_seq_origem, ie_sexo, cd_cid_principal, cd_categoria_cid, ds_cid_principal, ds_categoria_cid, ds_referencia, cd_dia, nr_pacientes, nr_pac_dia, qt_temp, nr_admissoes, nr_altas, nr_obitos, nr_transf_entrada, nr_transf_saida, nr_transf_ent_int, nr_transf_ent_ext, nr_transf_saida_int, nr_transf_saida_ext, qt_admitido_alta_dia, hr_alta, ie_tipo_convenio, cd_especialidade, qt_leito_livre, cd_procedimento, ds_procedimento, ds_estabelecimento, ds_motivo_alta, cd_motivo_alta, cd_empresa, cd_classif_etaria, ds_classif_etaria, cd_estabelecimento_base, cd_municipio_ibge, nr_seq_queixa, ds_queixa, cd_categoria, ds_categoria, nr_seq_forma_chegada, ds_forma_chegada, nr_horario, cd_convenio_glosa, cd_categoria_glosa, ds_convenio_glosa, ds_categoria_glosa, ds_indicacao, nr_seq_indicacao, cd_pessoa_fisica, ie_carater_inter_sus, ds_carater_atend, cd_empresa_conv, ds_empresa_conv, ds_agrupamento, nr_seq_agrupamento, nr_seq_classificacao, ds_grupo, ds_subgrupo, ds_forma_organizacao, ds_grupo_proc, ds_area_proc, ds_especialidade_proc, cd_grupo, cd_subgrupo, cd_forma_organizacao, cd_grupo_proc, cd_area_proc, cd_especialidade_proc, cd_proced_principal, ds_proced_principal, ds_classif_atend, ds_estado_civil, nr_control) AS SELECT	substr(eis_obter_faixa_etaria((obter_idade_pf(A.cd_pessoa_fisica, LOCALTIMESTAMP, 'A'))::numeric ),1,50) ds_faixa_etaria,
	substr(lpad(obter_idade_pf(A.cd_pessoa_fisica, LOCALTIMESTAMP, 'A'),3,'0'),1,50) ds_idade,
	(obter_idade_pf(A.cd_pessoa_fisica, LOCALTIMESTAMP, 'A'))::numeric  cd_idade,
	A.cd_convenio,
	A.cd_estabelecimento,
	A.IE_PERIODO,
	A.cd_tipo_acomodacao,
	A.cd_setor_atendimento,
	A.ie_clinica,
	A.DT_REFERENCIA,
	coalesce(A.CD_MEDICO,'0') cd_medico,
	obter_nome_pf(A.cd_medico) nm_pessoa_fisica,
	obter_nome_pf(A.cd_pessoa_fisica) nm_paciente,
	A.IE_SITUACAO,
	A.cd_procedencia,
	A.ie_TIPO_ATENDIMENTO,
	(to_char(A.hr_alta,'00'))::numeric  qt_hora_alta,
	A.ie_clinica_alta,
	A.nr_seq_origem,
	obter_sexo_pf(A.cd_pessoa_fisica,'C') ie_sexo,
	A.cd_cid_principal,
	obter_categoria_cid(A.cd_cid_principal) cd_categoria_cid,
	 '(' || cd_cid_principal ||')'|| ' - '|| substr(obter_desc_cid(A.cd_cid_principal),1,200) ds_cid_principal,
	substr(obter_desc_categoria_cid(obter_categoria_cid(A.cd_cid_principal)),1,255) ds_categoria_cid,
	to_char(A.dt_referencia, 'dd/mm/yyyy') ds_referencia,
	(to_char(A.dt_referencia, 'd'))::numeric  cd_dia,
	sum(CASE WHEN A.IE_periodo='D' THEN  NR_PACIENTES  ELSE 0 END )  NR_PACIENTES,
	sum(CASE WHEN Obter_Se_Unidade_Temp(A.cd_setor_atendimento, A.dt_referencia, A.cd_unidade_basica, A.cd_unidade_compl)='N' THEN (CASE WHEN A.IE_SITUACAO='P' THEN NR_PACIENTES  ELSE 0 END )  ELSE (CASE WHEN A.cd_pessoa_fisica IS NULL THEN  0  ELSE NR_PACIENTES END ) END ) NR_PAC_DIA,
	sum(CASE WHEN Obter_Se_Unidade_Temp(A.cd_setor_atendimento, A.dt_referencia, A.cd_unidade_basica, A.cd_unidade_compl)='S' THEN  1  ELSE 0 END ) qt_temp,
	SUM(NR_ADMISSOES) NR_ADMISSOES,
	SUM(NR_ALTAS) NR_ALTAS,
	SUM(NR_OBITOS) NR_OBITOS,
	SUM(NR_TRANSF_ENTRADA) NR_TRANSF_ENTRADA,
	SUM(NR_TRANSF_SAIDA) NR_TRANSF_SAIDA,
	sum(nr_transf_ent_interna) nr_transf_ent_int,
	sum(nr_transf_ent_externa) nr_transf_ent_ext,
	sum(nr_transf_saida_interna) nr_transf_saida_int,
	sum(nr_transf_saida_externa) nr_transf_saida_ext,
	sum(qt_admitido_alta_dia) qt_admitido_alta_dia,
	A.HR_ALTA,
	obter_tipo_convenio(A.cd_convenio) ie_tipo_convenio,
	obter_especialidade_medico(A.cd_medico,'C') CD_ESPECIALIDADE,
	sum(qt_leito_livre) qt_leito_livre,
	cd_procedimento,
	substr(obter_descricao_procedimento(cd_procedimento, ie_origem_proced),1,100) ds_procedimento,
	substr(obter_nome_estabelecimento(A.cd_estabelecimento),1,80) ds_estabelecimento,
	substr(obter_desc_motivo_alta(A.cd_motivo_alta),1,255) ds_motivo_alta,
	A.cd_motivo_alta,
	A.cd_empresa,
	Obter_classif_etaria(A.cd_estabelecimento,A.cd_pessoa_fisica,'C') cd_classif_etaria,
	obter_valor_dominio(1698, Obter_classif_etaria(A.cd_estabelecimento,A.cd_pessoa_fisica,'C')) ds_classif_etaria,
	c.cd_estabelecimento_base,
	substr(coalesce(obter_compl_pf(A.cd_pessoa_fisica,1,'CDM'),null),1,100) cd_municipio_ibge,
	A.nr_seq_queixa,
	substr(coalesce(obter_desc_queixa(A.nr_seq_queixa),obter_texto_tasy(1098949,null)),1,255) ds_queixa,
	A.cd_categoria,
	substr(obter_nome_convenio(A.cd_convenio)||' - '||obter_categoria_convenio(A.cd_convenio,A.cd_categoria),1,200) ds_categoria,
	A.nr_seq_forma_chegada,
	substr(coalesce(obter_desc_forma_chegada(A.nr_seq_forma_chegada),obter_texto_tasy(1098949,null)),1,255) ds_forma_chegada,
	(to_char(A.dt_entrada,'hh24'))::numeric  nr_horario,
	coalesce(A.cd_convenio_glosa,0) cd_convenio_glosa,
	A.cd_categoria_glosa,
	substr(coalesce(obter_nome_convenio(A.cd_convenio_glosa),obter_texto_tasy(1098949,null)),1,100) ds_convenio_glosa,
	substr(coalesce(obter_categoria_convenio(A.cd_convenio_glosa,A.cd_categoria_glosa),obter_texto_tasy(1098949,null)),1,200) ds_categoria_glosa,
	substr(coalesce(OBTER_DESC_INDICACAO(A.NR_SEQ_INDICACAO),obter_texto_tasy(1098949,null)),1,100) ds_indicacao,
	A.NR_SEQ_INDICACAO,
	A.cd_pessoa_fisica,
	A.ie_carater_inter_sus,
	substr(coalesce(sus_obter_desc_carater_atend(A.ie_carater_inter_sus),obter_texto_tasy(1098949,null)),1,100) ds_carater_atend,
	A.cd_empresa_conv,
	substr(coalesce(obter_nome_emp_ref(A.cd_empresa_conv),obter_texto_tasy(1098949,null)),1,100) ds_empresa_conv,
	CASE WHEN c.nr_seq_agrupamento='' THEN obter_texto_tasy(793289,null)  ELSE substr(Obter_desc_agrup_setor(c.nr_seq_agrupamento),1,50) END  ds_agrupamento,
	coalesce(c.nr_seq_agrupamento,0) nr_seq_Agrupamento,
	A.nr_seq_classificacao,
	substr(sus_obter_desc_grupo(A.cd_grupo),1,40) ds_grupo,
	substr(sus_obter_desc_subgrupo(A.cd_subgrupo),1,40) ds_subgrupo,
	substr(sus_obter_Desc_Forma_Org(A.cd_forma_organizacao),1,40) ds_forma_organizacao,
	substr(obter_desc_grupo_proc(A.cd_grupo_proc),1,40) ds_grupo_proc,
	substr(obter_desc_area_procedimento(A.cd_area_proc),1,40)  ds_area_proc,
	substr(obter_desc_especialidade_proc(A.cd_especialidade_proc),1,40) ds_especialidade_proc,
	A.cd_grupo,
	A.cd_subgrupo,
	A.cd_forma_organizacao,
	A.cd_grupo_proc,
	A.cd_area_proc,
	A.cd_especialidade_proc,
	A.cd_proced_principal,
	substr(obter_descricao_procedimento(A.cd_proced_principal, A.ie_origem_proced_princ),1,100) ds_proced_principal,
	SUBSTR(OBTER_DESC_CLASSIF_ATEND(A.NR_SEQ_CLASSIFICACAO),1,255) ds_classif_atend,
	substr(obter_valor_dominio(5, obter_dados_pf(A.cd_pessoa_fisica, 'EC')), 1, 15) ds_estado_civil,
	SUBSTR(OBTER_DADOS_SUS_MUNICIPIO(x.cd_municipio_ibge,'NC'),1,255) nr_control
FROM setor_atendimento c, eis_ocupacao_hospitalar a
LEFT OUTER JOIN compl_pessoa_fisica x ON (A.cd_pessoa_fisica = x.cd_pessoa_fisica AND 1 = x.ie_tipo_complemento
GROUP 	BY substr(eis_obter_faixa_etaria((obter_idade_pf(A.cd_pessoa_fisica, LOCALTIMESTAMP, 'A'))::numeric ),1,50),
	substr(lpad(obter_idade_pf(A.cd_pessoa_fisica, LOCALTIMESTAMP, 'A'),3,'0'),1,50),
	(obter_idade_pf(A.cd_pessoa_fisica, LOCALTIMESTAMP, 'A'))::numeric ,
	A.cd_convenio,
	A.cd_pessoa_fisica,
	A.cd_estabelecimento,
	A.IE_PERIODO,
	A.cd_tipo_acomodacao,
	A.cd_setor_atendimento,
	to_char(A.dt_referencia, 'dd/mm/yyyy'),
	A.ie_clinica,
	A.cd_cid_principal,
	obter_categoria_cid(A.cd_cid_principal),
	substr(obter_desc_cid(A.cd_cid_principal),1,200) || ' - '|| '(' || cd_cid_principal ||')',
	substr(obter_desc_categoria_cid(obter_categoria_cid(A.cd_cid_principal)),1,255),
	(to_char(A.dt_referencia, 'd'))::numeric ,
	A.DT_REFERENCIA,
	coalesce(A.CD_MEDICO,'0'),
	A.IE_SITUACAO,
	A.cd_procedencia,
	A.ie_TIPO_ATENDIMENTO,
	(to_char(A.hr_alta,'00'))::numeric ,
	A.nr_seq_origem,
	obter_sexo_pf(A.cd_pessoa_fisica,'C'),
	A.ie_clinica_alta,
	A.HR_ALTA,
	obter_tipo_convenio(A.cd_convenio),
	obter_especialidade_medico(A.cd_medico,'C'),
	obter_nome_pf(A.cd_medico),
	cd_procedimento,
	substr(obter_descricao_procedimento(cd_procedimento, ie_origem_proced),1,100),
	substr(obter_nome_estabelecimento(A.cd_estabelecimento),1,80),
	substr(obter_desc_motivo_alta(A.cd_motivo_alta),1,255),
	A.cd_motivo_alta,
	A.cd_empresa,
	Obter_classif_etaria(A.cd_estabelecimento,A.cd_pessoa_fisica,'C'),
	obter_valor_dominio(1698, Obter_classif_etaria(A.cd_estabelecimento,A.cd_pessoa_fisica,'C')),
	c.cd_estabelecimento_base,
	substr(coalesce(obter_compl_pf(A.cd_pessoa_fisica,1,'CDM'),null),1,100),
	A.nr_seq_queixa,
	substr(coalesce(obter_desc_queixa(A.nr_seq_queixa),obter_texto_tasy(1098949,null)),1,255),
	A.cd_categoria,
	substr(obter_nome_convenio(A.cd_convenio)||' - '||obter_categoria_convenio(A.cd_convenio,A.cd_categoria),1,200),
	A.nr_seq_forma_chegada,
	substr(coalesce(obter_desc_forma_chegada(A.nr_seq_forma_chegada),obter_texto_tasy(1098949,null)),1,255),
	(to_char(A.dt_entrada,'hh24'))::numeric ,
	coalesce(A.cd_convenio_glosa,0),
	A.cd_categoria_glosa,
	substr(coalesce(obter_nome_convenio(A.cd_convenio_glosa),obter_texto_tasy(1098949,null)),1,100),
	substr(coalesce(obter_categoria_convenio(A.cd_convenio_glosa,A.cd_categoria_glosa),obter_texto_tasy(1098949,null)),1,200),
	substr(coalesce(OBTER_DESC_INDICACAO(A.NR_SEQ_INDICACAO),obter_texto_tasy(1098949,null)),1,100),
	A.NR_SEQ_INDICACAO,
	A.cd_pessoa_fisica,
	A.ie_carater_inter_sus,
	substr(coalesce(sus_obter_desc_carater_atend(A.ie_carater_inter_sus),obter_texto_tasy(1098949,null)),1,100),
	A.cd_empresa_conv,
	CASE WHEN c.nr_seq_agrupamento)
WHERE A.cd_setor_atendimento	= c.cd_setor_atendimento
union

SELECT	substr(eis_obter_faixa_etaria((obter_idade_pf(A.cd_pessoa_fisica, LOCALTIMESTAMP, 'A'))::numeric ),1,50),
	substr(lpad(obter_idade_pf(A.cd_pessoa_fisica, LOCALTIMESTAMP, 'A'),3,'0'),1,50),
	(obter_idade_pf(A.cd_pessoa_fisica, LOCALTIMESTAMP, 'A'))::numeric ,
	A.cd_convenio,
	A.cd_estabelecimento,
	'M',
	A.cd_tipo_acomodacao,
	A.cd_setor_atendimento,
	A.ie_clinica,
	A.DT_REFERENCIA,
	coalesce(A.CD_MEDICO,'0') cd_medico,
	obter_nome_pf(A.cd_medico) nm_pessoa_fisica,
	obter_nome_pf(A.cd_pessoa_fisica) nm_paciente,
	A.IE_SITUACAO,
	A.cd_procedencia,
	A.ie_TIPO_ATENDIMENTO,
	(to_char(A.hr_alta,'00'))::numeric ,
	A.ie_clinica_alta,
	A.nr_seq_origem,
	obter_sexo_pf(A.cd_pessoa_fisica,'C') ie_sexo,
	A.cd_cid_principal,
	obter_categoria_cid(A.cd_cid_principal) cd_categoria_cid,
	 '(' || cd_cid_principal ||')'|| ' - '|| substr(obter_desc_cid(A.cd_cid_principal),1,200) ds_cid_principal,
	substr(obter_desc_categoria_cid(obter_categoria_cid(A.cd_cid_principal)),1,255) ds_categoria_cid,
	to_char(A.dt_referencia, 'dd/mm/yyyy'),
	(to_char(A.dt_referencia, 'd'))::numeric  cd_dia,
	sum(CASE WHEN greatest(last_day(A.DT_REFERENCIA), trunc(LOCALTIMESTAMP, 'dd'))=trunc(LOCALTIMESTAMP, 'dd') THEN 	CASE WHEN trunc(A.DT_REFERENCIA,'mm')=A.DT_REFERENCIA THEN  CASE WHEN A.ie_periodo='M' THEN NR_PACIENTES  ELSE 0 END   ELSE 0 END   ELSE CASE WHEN greatest(trunc(A.DT_REFERENCIA, 'dd'), trunc(LOCALTIMESTAMP, 'dd') - 1)=trunc(LOCALTIMESTAMP, 'dd') - 1 THEN 		CASE WHEN A.ie_periodo='D' THEN NR_PACIENTES  ELSE 0 END   ELSE 0 END  END )  NR_PACIENTES,
	0 NR_PAC_DIA,
	sum(CASE WHEN Obter_Se_Unidade_Temp(A.cd_setor_atendimento, A.dt_referencia, A.cd_unidade_basica, A.cd_unidade_compl)='S' THEN  1  ELSE 0 END ) qt_temp,
	0 NR_ADMISSOES,
	0 NR_ALTAS,
	0 NR_OBITOS,
	0 NR_TRANSF_ENTRADA,
	0 NR_TRANSF_SAIDA,
	0 NR_TRANSF_ENT_INT,
	0 NR_TRANSF_ENT_EXT,
	0 NR_TRANSF_SAIDA_INT,
	0 NR_TRANSF_SAIDA_EXT,
	0 qt_admitido_alta_dia,
	A.HR_ALTA,
	obter_tipo_convenio(A.cd_convenio),
	obter_especialidade_medico(A.cd_medico,'C'),
	sum(qt_leito_livre) qt_leito_livre,
	cd_procedimento,
	substr(obter_descricao_procedimento(cd_procedimento, ie_origem_proced),1,100) ds_procedimento,
	substr(obter_nome_estabelecimento(A.cd_estabelecimento),1,80) ds_estabelecimento,
	substr(obter_desc_motivo_alta(A.cd_motivo_alta),1,255),
	A.cd_motivo_alta,
	A.cd_empresa,
	Obter_classif_etaria(A.cd_estabelecimento,A.cd_pessoa_fisica,'C') cd_classif_etaria,
	obter_valor_dominio(1698, Obter_classif_etaria(A.cd_estabelecimento,A.cd_pessoa_fisica,'C')) ds_classif_etaria,
	c.cd_estabelecimento_base,
	substr(coalesce(obter_compl_pf(A.cd_pessoa_fisica,1,'CDM'),null),1,100) cd_municipio_ibge,
	A.nr_seq_queixa,
	substr(coalesce(obter_desc_queixa(A.nr_seq_queixa),obter_texto_tasy(1098949,null)),1,255) ds_queixa,
	A.cd_categoria,
	substr(obter_nome_convenio(A.cd_convenio)||' - '||obter_categoria_convenio(A.cd_convenio,A.cd_categoria),1,200) ds_categoria,
	A.nr_seq_forma_chegada,
	substr(coalesce(obter_desc_forma_chegada(A.nr_seq_forma_chegada),obter_texto_tasy(1098949,null)),1,255) ds_forma_chegada,
	(to_char(A.dt_entrada,'hh24'))::numeric  nr_horario,
	coalesce(A.cd_convenio_glosa,0),
	A.cd_categoria_glosa,
	substr(coalesce(obter_nome_convenio(A.cd_convenio_glosa),obter_texto_tasy(1098949,null)),1,100) ds_convenio_glosa,
	substr(coalesce(obter_categoria_convenio(A.cd_convenio_glosa,A.cd_categoria_glosa),obter_texto_tasy(1098949,null)),1,200) ds_categoria_glosa,
	substr(coalesce(OBTER_DESC_INDICACAO(A.NR_SEQ_INDICACAO),obter_texto_tasy(1098949,null)),1,100) ds_indicacao,
	A.NR_SEQ_INDICACAO,
	A.cd_pessoa_fisica,
	A.ie_carater_inter_sus,
	substr(coalesce(sus_obter_desc_carater_atend(A.ie_carater_inter_sus),obter_texto_tasy(1098949,null)),1,100) ds_carater_atend,
	A.cd_empresa_conv,
	substr(coalesce(obter_nome_emp_ref(A.cd_empresa_conv),obter_texto_tasy(1098949,null)),1,100) ds_empresa_conv,
	CASE WHEN c.nr_seq_agrupamento='' THEN obter_texto_tasy(793289,null)  ELSE substr(Obter_desc_agrup_setor(c.nr_seq_agrupamento),1,50) END  ds_agrupamento,
	coalesce(c.nr_seq_agrupamento,0) nr_seq_Agrupamento,
	A.nr_seq_classificacao,
	substr(sus_obter_desc_grupo(A.cd_grupo),1,40) ds_grupo,
	substr(sus_obter_desc_subgrupo(A.cd_subgrupo),1,40) ds_subgrupo,
	substr(sus_obter_Desc_Forma_Org(A.cd_forma_organizacao),1,40) ds_forma_organizacao,
	substr(obter_desc_grupo_proc(A.cd_grupo_proc),1,40) ds_grupo_proc,
	substr(obter_desc_area_procedimento(A.cd_area_proc),1,40)  ds_area_proc,
	substr(obter_desc_especialidade_proc(A.cd_especialidade_proc),1,40) ds_especialidade_proc,
	A.cd_grupo,
	A.cd_subgrupo,
	A.cd_forma_organizacao,
	A.cd_grupo_proc,
	A.cd_area_proc,
	A.cd_especialidade_proc,
	A.cd_proced_principal,
	substr(obter_descricao_procedimento(A.cd_proced_principal, A.ie_origem_proced_princ),1,100) ds_proced_principal,
	SUBSTR(OBTER_DESC_CLASSIF_ATEND(A.NR_SEQ_CLASSIFICACAO),1,255) ds_classif_atend,
	substr(obter_valor_dominio(5, obter_dados_pf(A.cd_pessoa_fisica, 'EC')), 1, 15) ds_estado_civil,
	SUBSTR(OBTER_DADOS_SUS_MUNICIPIO(x.cd_municipio_ibge,'NC'),1,255) nr_control
FROM setor_atendimento c, eis_ocupacao_hospitalar a
LEFT OUTER JOIN compl_pessoa_fisica x ON (A.cd_pessoa_fisica = x.cd_pessoa_fisica AND 1 = x.ie_tipo_complemento
GROUP 	BY substr(eis_obter_faixa_etaria((obter_idade_pf(A.cd_pessoa_fisica, LOCALTIMESTAMP, 'A'))::numeric ),1,50),
	substr(lpad(obter_idade_pf(A.cd_pessoa_fisica, LOCALTIMESTAMP, 'A'),3,'0'),1,50),
	(obter_idade_pf(A.cd_pessoa_fisica, LOCALTIMESTAMP, 'A'))::numeric ,
	A.cd_convenio,
	A.cd_pessoa_fisica,
	A.cd_estabelecimento,
	obter_sexo_pf(A.cd_pessoa_fisica,'C'),
	A.IE_PERIODO,
	A.cd_tipo_acomodacao,
	A.cd_setor_atendimento,
	A.cd_cid_principal,
	A.ie_clinica,
	substr(obter_desc_cid(A.cd_cid_principal),1,200) || ' - '|| '(' || cd_cid_principal ||')',
	obter_categoria_cid(A.cd_cid_principal),
	substr(obter_desc_categoria_cid(obter_categoria_cid(A.cd_cid_principal)),1,255),
	A.DT_REFERENCIA,
	coalesce(A.CD_MEDICO,'0'),
	to_char(A.dt_referencia, 'dd/mm/yyyy'),
	(to_char(A.dt_referencia, 'd'))::numeric ,
	A.IE_SITUACAO,
	A.cd_procedencia,
	A.ie_TIPO_ATENDIMENTO,
	(to_char(A.hr_alta,'00'))::numeric ,
	A.nr_seq_origem,
	A.ie_clinica_alta,
	A.HR_ALTA,
	obter_tipo_convenio(A.cd_convenio),
	obter_especialidade_medico(A.cd_medico,'C'),
	obter_nome_pf(A.cd_medico),
	cd_procedimento,
	substr(obter_descricao_procedimento(cd_procedimento, ie_origem_proced),1,100),
	substr(obter_nome_estabelecimento(A.cd_estabelecimento),1,80),
	substr(obter_desc_motivo_alta(A.cd_motivo_alta),1,255),
	A.cd_motivo_alta,
	A.cd_empresa,
		Obter_classif_etaria(A.cd_estabelecimento,A.cd_pessoa_fisica,'C'),
	obter_valor_dominio(1698, Obter_classif_etaria(A.cd_estabelecimento,A.cd_pessoa_fisica,'C')),
	c.cd_estabelecimento_base,
	substr(coalesce(obter_compl_pf(A.cd_pessoa_fisica,1,'CDM'),null),1,100),
	A.nr_seq_queixa,
	substr(coalesce(obter_desc_queixa(A.nr_seq_queixa),obter_texto_tasy(1098949,null)),1,255),
	A.cd_categoria,
	substr(obter_nome_convenio(A.cd_convenio)||' - '||obter_categoria_convenio(A.cd_convenio,A.cd_categoria),1,200),
	A.nr_seq_forma_chegada,
	substr(coalesce(obter_desc_forma_chegada(A.nr_seq_forma_chegada),obter_texto_tasy(1098949,null)),1,255),
	(to_char(A.dt_entrada,'hh24'))::numeric ,
	A.cd_convenio_glosa,
	A.cd_categoria_glosa,
	substr(coalesce(obter_nome_convenio(A.cd_convenio_glosa),obter_texto_tasy(1098949,null)),1,100),
	substr(coalesce(obter_categoria_convenio(A.cd_convenio_glosa,A.cd_categoria_glosa),obter_texto_tasy(1098949,null)),1,200),
	substr(coalesce(OBTER_DESC_INDICACAO(A.NR_SEQ_INDICACAO),obter_texto_tasy(1098949,null)),1,100),
	A.NR_SEQ_INDICACAO,
	A.cd_pessoa_fisica,
	A.ie_carater_inter_sus,
	substr(coalesce(sus_obter_desc_carater_atend(A.ie_carater_inter_sus),obter_texto_tasy(1098949,null)),1,100),
	A.cd_empresa_conv,
	CASE WHEN c.nr_seq_agrupamento)
WHERE A.cd_setor_atendimento	= c.cd_setor_atendimento;
