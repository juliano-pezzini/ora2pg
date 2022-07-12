-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW get_birth_informations (c_04, c_05, c_06, c_07, c_08, c_09, c_10, c_11, c_12, c_13, c_14, c_15, c_16, c_17, c_18, c_19, c_20, c_21, c_22, c_23, c_24, c_25, c_26, c_27, c_28, c_29, c_30, c_31, c_32, c_33, c_34, c_35, c_36, c_37, c_38, c_39, c_40, c_41, c_42, c_43, c_44, c_45, c_46, nr_atendimento, nr_seq_nascimento) AS SELECT 	(CASE WHEN z.ds_given_name IS NOT NULL THEN trim(both substr(z.ds_given_name,1,40)) ELSE 'SIN INFORMACIÓN' END) C_04,
		(CASE WHEN z.ds_family_name IS NOT NULL THEN trim(both substr(z.ds_family_name,1,20)) ELSE 'SIN INFORMACIÓN' END) C_05,
		(CASE WHEN z.ds_component_name_1 IS NOT NULL THEN trim(both substr(z.ds_component_name_1,1,20)) ELSE 'SIN INFORMACIÓN' END)C_06,
		coalesce(b.cd_curp,'SIN INFORMACIÓN') C_07,
		lpad(coalesce(obter_dados_cat_entidade(b.cd_pessoa_fisica,'CD_ENTIDADE'),'99'),2,'0') C_08,
		coalesce(obter_dados_cat_municipio(b.cd_municipio_ibge,'CD_CAT_MUNICIPIO'),'999') C_09,
		coalesce(TO_CHAR(b.dt_nascimento,'dd/mm/yyyy'),'99/99/9999') C_10,
		CASE WHEN b.dt_nascimento IS NULL THEN '99'  ELSE obter_idade(b.dt_nascimento,LOCALTIMESTAMP,'A') END  C_11,
		CASE WHEN obter_se_indigina(b.nr_seq_cor_pele)='S' THEN  1  ELSE 2 END  C_12,
		CASE WHEN b.nr_seq_lingua_indigena IS NULL THEN '2'  ELSE '1' END  C_13,
		lpad(coalesce(obter_dados_cat_lingua_indig(b.nr_seq_lingua_indigena,'CD_LINGUA_INDIGENA_MF'),'9999'),4,'0') C_14,
		CASE WHEN b.ie_estado_civil='1' THEN '12' WHEN b.ie_estado_civil='2' THEN '11' WHEN b.ie_estado_civil='3' THEN '13' WHEN b.ie_estado_civil='4' THEN '16' WHEN b.ie_estado_civil='5' THEN '14' WHEN b.ie_estado_civil='6' THEN '16' WHEN b.ie_estado_civil='7' THEN '15' WHEN b.ie_estado_civil='9' THEN '88'  ELSE '99' END  C_15,
		lpad(substr(coalesce(get_info_end_endereco(c.nr_seq_pessoa_endereco,'TIPO_LOGRAD','C'),'99'),1,2),2,'0') C_16,
		substr(coalesce(get_info_end_endereco(c.nr_seq_pessoa_endereco,'RUA_VIALIDADE','D'),'SIN INFORMACIÓN'),1,80) C_17,
		substr(coalesce(get_info_end_endereco(c.nr_seq_pessoa_endereco,'NUMERO','D'),'9999999999'),1,10) C_18,
		substr(get_info_end_endereco(c.nr_seq_pessoa_endereco,'COMPLEMENTO','D'),1,5) C_19,
		lpad(substr(coalesce(get_info_end_endereco(c.nr_seq_pessoa_endereco,'TIPO_BAIRRO','C'),'99'),1,2),2,'0') C_20,
		substr(coalesce(get_info_end_endereco(c.nr_seq_pessoa_endereco,'TIPO_BAIRRO','D'),'SIN INFORMACIÓN'),1,60) C_21,
		SUBSTR(trim(both coalesce(get_info_end_endereco(c.nr_seq_pessoa_endereco,'CODIGO_POSTAL','D'),'99999')),1,5) C_22,
		lpad(substr(coalesce(get_info_end_endereco(c.nr_seq_pessoa_endereco,'ESTADO_PROVINCI','C'),'99'),1,2),2,'0') C_23,
		lpad(substr(coalesce(get_info_end_endereco(c.nr_seq_pessoa_endereco,'MUNICIPIO','C'),'999'),1,3),3,'0') C_24,
		lpad(substr(coalesce(get_info_end_endereco(c.nr_seq_pessoa_endereco,'LOCALIDADE_AREA','C'),'9999'),1,4),4,'0') C_25,
		substr(coalesce(obter_telefone_pf_html5(b.cd_pessoa_fisica, 13),'999999999999999'),1,15) C_26,
		coalesce(f.qt_gestacoes,0)+1 C_27,
		coalesce(f.qt_natimortos,'99') C_28,
		(select CASE WHEN count(*)=0 THEN 99  ELSE count(*) END  FROM	nascimento x where	x.nr_atendimento= a.nr_atendimento and x.ie_unico_nasc_vivo = 'S') C_29,
		coalesce(f.qt_filhos_vivos + (select count(n.nr_sequencia) from nascimento n where n.nr_atendimento = a.nr_atendimento and n.dt_inativacao is null and n.dt_liberacao is not null),'99') C_30,
		coalesce(f.ie_cond_ult_nasc,'9') C_31,
		CASE WHEN f.ie_cond_ult_nasc='2' THEN '0' WHEN f.ie_cond_ult_nasc='3' THEN '0'  ELSE CASE WHEN f.ie_ult_filho_vivo='S' THEN '1' WHEN f.ie_ult_filho_vivo='N' THEN '2'  ELSE '9' END  END  C_32,
		'99/99/9999' C_33,
		coalesce(g.nr_sequencia,'1') C_34,
		CASE WHEN f.ie_pre_natal='S' THEN '1'  ELSE '2' END  C_35,
		CASE WHEN f.ie_pre_natal='N' THEN '0'  ELSE (							CASE								WHEN(f.qt_sem_ig_ini_pre_natal < 14) THEN '1'								WHEN(f.qt_sem_ig_ini_pre_natal < 27) THEN '2'								WHEN(f.qt_sem_ig_ini_pre_natal < 42) THEN '3'								ELSE '9'								END) END  C_36,
		CASE WHEN coalesce(f.ie_pre_natal,'N')='N' THEN '0'  ELSE coalesce(f.qt_consultas,0) END  C_37,
		CASE WHEN OBTER_DECLARACAO_OBITO(a.nr_atendimento) IS NULL THEN '1'  ELSE '2' END  C_38,
		substr(CASE WHEN OBTER_DECLARACAO_OBITO(a.nr_atendimento) IS NULL THEN ''  ELSE coalesce(OBTER_DECLARACAO_OBITO(a.nr_atendimento), '999999999') END ,1,9) C_39,
		LPAD(coalesce(obter_convenio_atend_mx(a.nr_atendimento,1,'CD_DER_NACIMIENTO'),'01'),2,'0') C_40,
		CASE WHEN obter_convenio_atend_mx(a.nr_atendimento,1,'CD_DER_NACIMIENTO')='07' THEN  ''  ELSE lpad(b.nr_spss,18,'0') END  C_41,
		lpad(CASE WHEN coalesce(obter_convenio_atend_mx(a.nr_atendimento,1,'CD_DER_NACIMIENTO'),'01')='01' THEN '00'  ELSE obter_convenio_atend_mx(a.nr_atendimento,2,'CD_DER_NACIMIENTO') END , 2, '0') C_42,
		CASE WHEN b.ie_grau_instrucao='1' THEN '01' WHEN b.ie_grau_instrucao='2' THEN '03' WHEN b.ie_grau_instrucao='3' THEN '05' WHEN b.ie_grau_instrucao='4' THEN '07' WHEN b.ie_grau_instrucao='5' THEN '10' WHEN b.ie_grau_instrucao='6' THEN '10' WHEN b.ie_grau_instrucao='7' THEN '02' WHEN b.ie_grau_instrucao='8' THEN '05' WHEN b.ie_grau_instrucao='9' THEN '06' WHEN b.ie_grau_instrucao='10' THEN '03' WHEN b.ie_grau_instrucao='11' THEN '01' WHEN b.ie_grau_instrucao='12' THEN '10' WHEN b.ie_grau_instrucao='13' THEN '10' WHEN b.ie_grau_instrucao='14' THEN '88' WHEN b.ie_grau_instrucao='15' THEN '08'  ELSE '99' END  C_43,
		SUBSTR(coalesce(obter_desc_cargo(b.cd_cargo),'SIN INFORMACIÓN'),1,40) C_44,
		coalesce((SELECT max(t.cd_ocupacao_nascimento) FROM cargo w, cat_ocupacao_hab t WHERE w.cd_cargo = b.cd_cargo and t.cd_ocupacao = w.cd_externo),'99') C_45,
		CASE WHEN(SELECT max(t.cd_ocupacao_nascimento) FROM cargo w, cat_ocupacao_hab t WHERE w.cd_cargo = b.cd_cargo and t.cd_ocupacao = w.cd_externo)='01' THEN '0' WHEN(SELECT max(t.cd_ocupacao_nascimento) FROM cargo w, cat_ocupacao_hab t WHERE w.cd_cargo = b.cd_cargo and t.cd_ocupacao = w.cd_externo)='02' THEN '0' WHEN(SELECT max(t.cd_ocupacao_nascimento) FROM cargo w, cat_ocupacao_hab t WHERE w.cd_cargo = b.cd_cargo and t.cd_ocupacao = w.cd_externo)='03' THEN '0' WHEN(SELECT max(t.cd_ocupacao_nascimento) FROM cargo w, cat_ocupacao_hab t WHERE w.cd_cargo = b.cd_cargo and t.cd_ocupacao = w.cd_externo)='04' THEN '0'  ELSE CASE WHEN b.cd_cargo IS NULL THEN '2'  ELSE '1' END  END  C_46,
	a.nr_atendimento nr_atendimento,
	g.nr_sequencia nr_seq_nascimento
FROM person_name z, parto f, compl_pessoa_fisica c, pessoa_fisica b, atendimento_paciente a
LEFT OUTER JOIN nascimento g ON (a.nr_atendimento = g.nr_atendimento)
WHERE a.cd_pessoa_fisica	= b.cd_pessoa_fisica AND b.nr_seq_person_name	= z.nr_sequencia and z.ds_type = 'main' AND a.cd_pessoa_fisica	= c.cd_pessoa_fisica AND c.ie_tipo_complemento	= 1 AND a.nr_atendimento	= f.nr_atendimento;

