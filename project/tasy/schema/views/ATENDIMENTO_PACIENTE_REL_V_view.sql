-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW atendimento_paciente_rel_v (nr_atendimento, nr_atend_original, dt_entrada, cd_pessoa_fisica, cd_procedencia, ie_tipo_atendimento, cd_medico_resp, dt_alta, cd_motivo_alta, ie_clinica, nm_usuario_atend, cd_estabelecimento, cd_setor_atendimento, cd_convenio, cd_categoria, cd_usuario_convenio, cd_senha, cd_empresa, nr_doc_convenio, nr_guia_atend, dt_validade_carteira, ds_motivo_alta, ds_convenio, ds_categoria, nm_medico, nm_paciente, nm_paciente_assinatura, nr_prontuario, dt_nascimento, ds_anos_meses_dias, ie_sexo, nr_cpf, nr_identidade, nr_telefone_celular, cd_proc_principal, ds_proc_principal, cd_cid_principal, cd_cid_secundario, ds_clinica, ds_origem_usuario, nm_responsavel, ds_plano, ds_declaracao, nr_dec_obito, ds_end_compl, nm_medico_conta, nm_medico_crm, nr_ramal, nr_dia_internado, ie_tipo_guia, ds_endereco, cd_cep, ds_bairro, ds_setor_internacao, ds_setor_entrada, nr_gestante_pre_natal, ds_tipo_acomod_conv, nr_doc_conv_principal, nr_dnv, cd_cid_atend, ds_dnv_atend, ds_queixa, nm_medico_atendimento, ie_tipo_atend_tiss, ie_atend_retorno, dt_internacao, ie_trata_ultima_banda, nm_medico_conselho, nm_pai, nm_mae, cd_senha_conta, ds_agrup_setor, ds_procedencia, cd_senha_autor_conta, cd_senha_atend, ds_anos_meses_dias_ob) AS SELECT A.NR_ATENDIMENTO,
	A.NR_ATEND_ORIGINAL, 
	A.DT_ENTRADA, 
	A.CD_PESSOA_FISICA, 
	A.CD_PROCEDENCIA, 
	A.IE_TIPO_ATENDIMENTO, 
	A.CD_MEDICO_RESP, 
	A.DT_ALTA, 
	--A.DT_ALTA_INTERNO, 
	A.CD_MOTIVO_ALTA, 
	--A.IE_FIM_CONTA, 
	A.IE_CLINICA, 
	--A.IE_VINCULO_SUS, 
	--A.IE_CARATER_INTER_SUS, 
	--SUBSTR(OBTER_VALOR_DOMINIO(802,A.IE_CARATER_INTER_SUS),1,40) DS_CARATER_INTER_SUS, 
	A.NM_USUARIO_ATEND, 
	--A.DS_OBSERVACAO     DS_OBS_ATENDIMENTO, 
	A.CD_ESTABELECIMENTO, 
	--A.DT_FIM_CONTA, 
	--A.IE_TIPO_ATEND_BPA, 
	--A.IE_TIPO_CONVENIO, 
	--A.IE_PERMITE_VISITA, 
	--A.IE_STATUS_ATENDIMENTO, 
	--A.DS_SINTOMA_PACIENTE, 
	--decode(A.DT_ALTA,null,'N','S') ie_com_alta, 
	--B.DT_ENTRADA_UNIDADE, 
	--B.DT_SAIDA_UNIDADE, 
	B.CD_SETOR_ATENDIMENTO, 
	--B.CD_UNIDADE_BASICA, 
	--B.CD_UNIDADE_COMPL, 
	--B.CD_UNIDADE_BASICA || ' ' ||B.CD_UNIDADE_COMPL cd_unidade, 
	--B.CD_TIPO_ACOMODACAO   CD_TIPO_ACOMOD_UNID, 
	--B.DS_OBSERVACAO     DS_OBS_UNIDADE, 
	C.CD_CONVENIO, 
	C.CD_CATEGORIA, 
	C.CD_USUARIO_CONVENIO, 
	C.CD_SENHA, 
	C.CD_EMPRESA, 
	--substr(Obter_Empresa_Atend(c.nr_atendimento,'A','D'),1,80) NM_EMPRESA, 
	--C.CD_TIPO_ACOMODACAO   CD_TIPO_ACOMOD_CONV, 
	--C.CD_DEPENDENTE, 
	--SUBSTR(OBTER_VALOR_DOMINIO(1034, C.CD_DEPENDENTE),1,30) DS_DEPENDENTE, 
	C.NR_DOC_CONVENIO, 
	C.NR_DOC_CONVENIO NR_GUIA_ATEND, 
	--C.DT_INICIO_VIGENCIA, 
	--C.DT_FINAL_VIGENCIA, 
	C.DT_VALIDADE_CARTEIRA, 
	--C.CD_PLANO_CONVENIO, 
	D.DS_MOTIVO_ALTA, 
	--SUBSTR(OBTER_VALOR_DOMINIO(12, a.ie_tipo_atendimento),1,30) DS_TIPO_ATENDIMENTO, 
	--S.DS_SETOR_ATENDIMENTO, 
	--S.NM_UNIDADE_BASICA, 
	--S.NM_UNIDADE_COMPL, 
	--S.NM_UNIDADE_BASICA || ' ' ||S.NM_UNIDADE_COMPL nm_unidade, 
	--S.CD_CLASSIF_SETOR, 
	--S.HR_INICIO_PRESCRICAO, 
	V.DS_CONVENIO, 
	T.DS_CATEGORIA, 
	M.NM_PESSOA_FISICA NM_MEDICO, 
	P.NM_PESSOA_FISICA NM_PACIENTE, 
	P.NM_PESSOA_FISICA NM_PACIENTE_ASSINATURA, 
	--P.NR_PRONTUARIO NR_PRONTUARIO_PAC, 
	(substr(obter_prontuario_pf(A.cd_estabelecimento,A.cd_pessoa_fisica),1,10))::numeric  NR_PRONTUARIO, 
	P.DT_NASCIMENTO, 
	/*decode(Trunc((sysdate - p.dt_nascimento)/365.25), 0, 
	Trunc((sysdate - p.dt_nascimento)/30) || ' Meses', 
		Trunc((sysdate - p.dt_nascimento)/365.25) || ' Anos') ds_idade,*/
 
	--Trunc((sysdate - p.dt_nascimento)/365.25) nr_anos, 
	--Trunc((a.dt_entrada - p.dt_nascimento)/365.25) nr_anos_atendimento, 
	--substr(obter_idade(p.dt_nascimento, sysdate, 'C'),1,40) ds_anos, 
	substr(obter_idade(P.dt_nascimento, LOCALTIMESTAMP, 'S'),1,40) ds_anos_meses_dias, 
	--substr(obter_idade(p.dt_nascimento, sysdate, 'AM'),1,40) ds_anos_meses, 
	--P.CD_RELIGIAO, 
	P.IE_SEXO, 
	--DECODE(P.ie_sexo,'F', 'Feminino', 'M','Masculino','Indefinido') ds_Sexo, 
	--P.IE_ESTADO_CIVIL, 
	P.NR_CPF, 
	P.NR_IDENTIDADE, 
	P.NR_TELEFONE_CELULAR, 
	--P.IE_GRAU_INSTRUCAO, 
	--P.NR_CEP_CIDADE_NASC, 
	--p.cd_municipio_ibge, 
	--P.IE_TIPO_SANGUE||P.IE_FATOR_RH DS_SANGUE, 
	substr(OBTER_PROC_PRINCIPAL(A.NR_ATENDIMENTO, V.CD_CONVENIO, A.IE_TIPO_ATENDIMENTO,0,'C'),1,10) CD_PROC_PRINCIPAL, 
	substr(OBTER_PROC_PRINCIPAL(A.NR_ATENDIMENTO, V.CD_CONVENIO, A.IE_TIPO_ATENDIMENTO,0,'D'),1,240) DS_PROC_PRINCIPAL, 
	--substr(obter_valor_dominio(1267,a.ie_probabilidade_alta),1,40) ds_probabilidade, 
	substr(OBTER_CID_ATENDIMENTO(A.NR_ATENDIMENTO,'P'),1,10) CD_CID_PRINCIPAL, 
	substr(OBTER_CID_ATENDIMENTO(A.NR_ATENDIMENTO,'S'),1,10) CD_CID_SECUNDARIO, 
	SUBSTR(OBTER_VALOR_DOMINIO(17, ie_clinica),1, 30) DS_CLINICA, 
	K.DS_ORIGEM DS_ORIGEM_USUARIO, 
	--substr(obter_valor_dominio(1060,A.IE_STATUS_ATENDIMENTO),1,30) DS_STATUS_PACIENTE, 
	--N.NR_CRM, 
	--A.DT_PREVISTO_ALTA, 
	--(NVL(A.DT_ALTA, SYSDATE) - A.DT_ENTRADA) QT_DIA_INTERNADO, 
	--C.QT_DIA_INTERNACAO, 
	--(A.DT_ENTRADA + QT_DIA_INTERNACAO) DT_ALTA_CONVENIO, 
	--C.DS_OBSERVACAO DS_OBS_CONVENIO, 
	--b.nr_seq_interno nr_seq_atepacu, 
	--S.DS_SETOR_ATENDIMENTO||' - '||B.CD_UNIDADE_BASICA||' '||B.CD_UNIDADE_COMPL  DS_SETOR_LEITO, 
	--a.ie_responsavel, 
	--a.cd_pessoa_responsavel, 
	substr(obter_nome_responsavel(A.nr_atendimento),1,60) nm_responsavel, 
	--a.nm_usuario_alta, 
	--c.dt_ultimo_pagto, 
	--A.IE_PACIENTE_ISOLADO, 
	--A.IE_PERMITE_VISITA_REL, 
	substr(obter_desc_plano(C.cd_convenio, C.cd_plano_convenio),1,40) ds_plano, 
	--c.dt_aceite_dif_acomod, 
	--a.nr_seq_unid_int, 
	--p.ie_tipo_sangue, 
	--p.ie_fator_rh, 
	' ' ds_declaracao, 
	' ' NR_DEC_OBITO, 
	' ' ds_end_compl, 
	' ' nm_medico_conta, 
	--nr_seq_indicacao, 
	substr(obter_nome_medico(M.cd_pessoa_fisica,'P'),1,100) nm_medico_crm, 
	obter_ramal_unidade(B.cd_unidade_basica, B.cd_unidade_compl) nr_ramal, 
	--a.ds_senha, 
	trunc(coalesce(A.DT_ALTA, LOCALTIMESTAMP) - A.DT_ENTRADA) NR_DIA_INTERNADO, 
	--ds_obs_alta, 
	--a.nr_seq_forma_chegada, 
	--p.nr_cartao_nac_sus, 
	C.ie_tipo_guia, 
	substr(obter_compl_pf(P.cd_pessoa_fisica, 1, 'E'),1,120) ds_endereco, 
	substr(obter_compl_pf(P.cd_pessoa_fisica, 1, 'CEP'),1,15) cd_cep, 
	substr(obter_compl_pf(P.cd_pessoa_fisica, 1, 'B'),1,40) ds_bairro, 
	substr(obter_setor_atepacu(obter_atepacu_paciente(A.nr_atendimento, 'PI'),1),1,100) ds_setor_internacao, 
	substr(obter_setor_atepacu(obter_atepacu_paciente(A.nr_atendimento, 'P'),1),1,100) ds_setor_entrada, 
	--p.cd_sistema_ant cd_sistema_ant, 
	--a.ie_probabilidade_alta, 
	A.NR_GESTANTE_PRE_NATAL, 
	--a.nr_seq_classificacao, 
	--A.NR_SEQ_QUEIXA, 
	--substr(Obter_Pagador_Atend(a.nr_atendimento),1,255) ds_pagador, to_char(dt_entrada, 'hh24') hr_entrada, 
	substr(OBTER_DESC_TIPO_ACOMOD(C.cd_tipo_acomodacao),1,100) DS_TIPO_ACOMOD_CONV, 
	--A.NR_SEQ_TIPO_ACIDENTE, 
	C.NR_DOC_CONV_PRINCIPAL, 
	substr(obter_dnv_nascimento(A.nr_atendimento),1,40) nr_dnv, 
	'' cd_cid_atend, 
	substr(obter_dnvs_nascimento(A.nr_atendimento),1,255) ds_dnv_atend, 
	substr(obter_desc_queixa(A.NR_SEQ_QUEIXA),1,80) ds_queixa, 
	--A.NM_MEDICO_EXTERNO, 
	substr(obter_nome_pessoa_fisica(A.cd_medico_atendimento, null),1,40) nm_medico_atendimento, 
	--A.IE_DIVULGAR_OBITO, 
	A.ie_tipo_atend_tiss, 
	CASE WHEN  A.nr_atend_original IS NULL THEN  'N'  ELSE 'S' END  ie_atend_retorno, 
	CASE WHEN obter_classif_setor_min(B.nr_atendimento)=1 THEN  		CASE WHEN A.ie_tipo_atendimento=1 THEN  Obter_Unidade_Atendimento(B.nr_atendimento,'PI','DT')  ELSE to_char(A.dt_entrada, 'dd/mm/yyyy hh24:mi:ss') END   ELSE to_char(A.dt_entrada, 'dd/mm/yyyy hh24:mi:ss') END  dt_internacao, 
	--c.nr_seq_origem, 
	--b.ie_calcular_dif_diaria, 
	--nvl(d.IE_CANCELADO,'N') IE_CANCELADO, 
	--substr(Obter_Unidade_Atendimento(b.nr_atendimento,'IA','CS'),1,50) cd_unidade_atual, 
	--substr(Obter_Unidade_Atendimento(b.nr_atendimento,'IA','UB'),1,50) cd_unidade_basica_atual, 
	'S' ie_trata_ultima_banda, 
	--a.dt_cancelamento, 
	--a.dt_saida_real, 
	--a.nm_usuario_saida, 
	--a.nr_seq_grau_parentesco, 
	substr(obter_nome_medico(M.cd_pessoa_fisica,'PC'),1,60) nm_medico_conselho, 
	--substr(nvl(obter_nivel_urgencia(a.nr_atendimento),'Não informado'),1,100) ds_nivel_urgencia, 
	substr(obter_compl_pf(A.cd_pessoa_fisica,4,'N'),1,60) nm_pai, 
	substr(obter_compl_pf(A.cd_pessoa_fisica,5,'N'),1,60) nm_mae, 
	-- Os campos em branco ('') são tratados diretamente dentro dos relatórios (FatAct_R7 e FatAct_R9) 
	'' cd_senha_conta, 
	coalesce(substr(obter_agrup_setor(S.cd_setor_atendimento,'D'),1,50),'Não Informado') ds_agrup_setor, 
	substr(obter_desc_procedencia(A.cd_procedencia),1,40) ds_procedencia, 
	'' cd_senha_autor_conta, 
	'' cd_senha_atend, 
	'' ds_anos_meses_dias_ob 
FROM convenio v, categoria_convenio t, setor_atendimento s, pessoa_fisica p, pessoa_fisica m, atend_paciente_unidade b, atend_categoria_convenio c
LEFT OUTER JOIN convenio_origem_usuario k ON (C.NR_SEQ_ORIGEM = K.NR_SEQUENCIA)
, atendimento_paciente a
LEFT OUTER JOIN motivo_alta d ON (A.CD_MOTIVO_ALTA = D.CD_MOTIVO_ALTA)
LEFT OUTER JOIN medico n ON (A.CD_MEDICO_RESP = N.CD_PESSOA_FISICA)
WHERE (A.NR_ATENDIMENTO = B.NR_ATENDIMENTO) AND (B.NR_SEQ_INTERNO = OBTER_ATEPACU_PACIENTE(A.NR_ATENDIMENTO, 'A')) AND (A.NR_ATENDIMENTO = C.NR_ATENDIMENTO) AND (C.NR_SEQ_INTERNO = OBTER_ATECACO_ATENDIMENTO(A.NR_ATENDIMENTO)) /* Retirado por Elemar em 17/02/03 
 AND	(B.DT_ENTRADA_UNIDADE = 
	(SELECT MAX(X.DT_ENTRADA_UNIDADE) 
	FROM  ATEND_PACIENTE_UNIDADE X 
	WHERE X.NR_ATENDIMENTO = A.NR_ATENDIMENTO 
     AND NVL(X.DT_SAIDA_UNIDADE, X.DT_ENTRADA_UNIDADE + 99999) = 
       (SELECT MAX(NVL(Y.DT_SAIDA_UNIDADE, Y.DT_ENTRADA_UNIDADE + 99999)) 
        FROM  ATEND_PACIENTE_UNIDADE Y 
        WHERE Y.NR_ATENDIMENTO = A.NR_ATENDIMENTO))) 
 AND	(C.DT_INICIO_VIGENCIA = 
	(SELECT MAX(W.DT_INICIO_VIGENCIA) DT_PRIMEIRA_VIGENCIA 
	FROM ATEND_CATEGORIA_CONVENIO W 
	WHERE W.NR_ATENDIMENTO	= A.NR_ATENDIMENTO) ) 
*/
  AND (B.CD_SETOR_ATENDIMENTO	= S.CD_SETOR_ATENDIMENTO) AND (C.CD_CONVENIO		= V.CD_CONVENIO) and (A.CD_MEDICO_RESP	= M.CD_PESSOA_FISICA)  AND (A.CD_PESSOA_FISICA	= P.CD_PESSOA_FISICA)  AND (C.CD_CONVENIO		= T.CD_CONVENIO) AND (C.CD_CATEGORIA		= T.CD_CATEGORIA);
