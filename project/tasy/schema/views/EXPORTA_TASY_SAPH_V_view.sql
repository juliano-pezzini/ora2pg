-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW exporta_tasy_saph_v (linha, nr_sequencia, singular, cod_unimed_contrato, cod_unimed_familia, cod_unimed_dep, cod_digito_verific, nome, sexo, est_civil, data_nasc, tipo_cliente, cpf, plano_unimed, lar_homecare, plano_regulamentado, tipo_acomodacao, cartao_facil, possui_sos, plano_sos, data_inclusao_sos, data_exclusao_sos, tabela_unisanta, data_inclusao_transp, periodo_inclusao_transp, data_exclusao_transp, periodo_exclusao_transp, data_term_carencia_transp, cod_tabela_preco, gera_comissao_vendedor, cod_unimed_atend, cooperado, cod_medico_unimed, colaborador, ddd_celular, nro_celular, contato, ddd_contato, fone_contato, endereco_res, bairro_res, cep_res, cidade_res, uf_res, complemento_res, ddd_res, fone_res, endereco_com, bairro_com, cep_com, cidade_com, uf_com, complemento_com, ddd_com, fone_com, filiacao_mae, data_atualizacao, possui_unimed, cod_unimed_origem, ativo, ie_nivel_dependencia) AS SELECT	Distinct
	row_number() OVER () AS linha,
	A.nr_sequencia,
	SUBSTR(A.cd_codigo_convenio,1,4) singular,
	SUBSTR(A.cd_codigo_convenio,5,4) cod_unimed_contrato,
	SUBSTR(A.cd_codigo_convenio,9,6) cod_unimed_familia,
	SUBSTR(A.cd_codigo_convenio,15,2) cod_unimed_dep,
	SUBSTR(calcula_digito('Modulo11', A.cd_codigo_convenio),1,2) cod_digito_verific,
	SUBSTR(B.nm_pessoa_fisica,1,60) nome,
	B.ie_sexo sexo,
	CASE WHEN B.ie_estado_civil='2' THEN 'C' WHEN B.ie_estado_civil='3' THEN 'D' WHEN B.ie_estado_civil='1' THEN 'S' WHEN B.ie_estado_civil='5' THEN 'V' WHEN B.ie_estado_civil='9' THEN 'O'  ELSE 'O' END  est_civil,
	B.dt_nascimento data_nasc,
	CASE WHEN C.nr_seq_cobertura=11 THEN  2  ELSE 1 END  tipo_cliente,
	B.nr_cpf cpf,
	C.nm_contrato plano_unimed,
	CASE WHEN EXISTS (SELECT DISTINCT(D.cd_pessoa_fisica) FROM PACIENTE_HOME_CARE D WHERE D.cd_pessoa_fisica = coalesce(A.cd_pf_titular, A.cd_pessoa_fisica)) THEN 'S' ELSE 'N' END lar_homecare,
	CASE WHEN C.cd_categoria IS NULL THEN  'N'  ELSE 'S' END  plano_regulamentado,
	coalesce(C.ie_tipo_acom_integ,'0') tipo_acomodacao,
	'N' cartao_facil,
	CASE WHEN C.nr_seq_cobertura=31 THEN  'N'  ELSE 'S' END  possui_sos,
	C.nr_seq_cobertura plano_sos,
	A.dt_inclusao_sos data_inclusao_sos,
	coalesce(C.dt_cancelamento, A.dt_cancelamento) data_exclusao_sos,
	a.cd_unisanta tabela_unisanta,
	a.dt_inclusao_transporte data_inclusao_transp,
	'' periodo_inclusao_transp,
	a.dt_exclusao_transporte data_exclusao_transp,
	'' periodo_exclusao_transp,
	'' data_term_carencia_transp,
	'0000' cod_tabela_preco,
	'S' gera_comissao_vendedor,
	'0025' cod_unimed_atend,
	CASE WHEN I.ie_vinculo_medico=8 THEN  'S'  ELSE CASE WHEN I.nr_seq_categoria=9 THEN  'S'  ELSE 'N' END  END  cooperado,
	LPAD(coalesce(CASE WHEN I.ie_vinculo_medico=8 THEN  B.ds_codigo_prof  ELSE CASE WHEN I.nr_seq_categoria=9 THEN  B.ds_codigo_prof  ELSE '' END  END ,0),9,0) cod_medico_unimed,
	coalesce(B.ie_funcionario, 'N') colaborador,
	B.nr_ddd_celular ddd_celular,
	B.nr_telefone_celular nro_celular,
	E.nm_contato contato,
	E.nr_ddd_telefone ddd_contato,
	E.nr_telefone fone_contato,
	SUBSTR(F.ds_endereco || F.nr_endereco,1,60) endereco_res,
	F.ds_bairro bairro_res,
	F.cd_cep cep_res,
	F.ds_municipio cidade_res,
	F.sg_estado uf_res,
	F.ds_complemento complemento_res,
	F.nr_ddd_telefone ddd_res,
	F.nr_telefone fone_res,
	SUBSTR(G.ds_endereco || F.nr_endereco,1,60) endereco_com,
	G.ds_bairro bairro_com,
	G.cd_cep cep_com,
	G.ds_municipio cidade_com,
	G.sg_estado uf_com,
	G.ds_complemento complemento_com,
	G.nr_ddd_telefone ddd_com,
	G.nr_telefone fone_com,
	H.nm_contato filiacao_mae,
	LOCALTIMESTAMP data_atualizacao,
	CASE WHEN C.ie_origem=1 THEN  'S'  ELSE 'N' END  possui_unimed,
	CASE WHEN C.ie_origem=1 THEN  ''  ELSE '0025' END  cod_unimed_origem,
	CASE WHEN A.dt_cancelamento IS NULL THEN  CASE WHEN C.dt_cancelamento IS NULL THEN  'S'  ELSE 'N' END   ELSE 'N' END  ativo,
	null ie_nivel_dependencia
FROM EME_PF_CONTRATO A
	Inner Join PESSOA_FISICA       B ON B.cd_pessoa_fisica = coalesce(A.cd_pf_titular, A.cd_pessoa_fisica)
	Inner Join EME_CONTRATO        C ON C.nr_sequencia = A.nr_seq_contrato
	Left Join COMPL_PESSOA_FISICA E ON E.cd_pessoa_fisica = coalesce(A.cd_pf_titular, A.cd_pessoa_fisica) AND E.ie_tipo_complemento = 9
	Left Join COMPL_PESSOA_FISICA F ON F.cd_pessoa_fisica = coalesce(A.cd_pf_titular, A.cd_pessoa_fisica) AND F.ie_tipo_complemento = 1
	Left Join COMPL_PESSOA_FISICA G ON G.cd_pessoa_fisica = coalesce(A.cd_pf_titular, A.cd_pessoa_fisica) AND G.ie_tipo_complemento = 2
	Left Join COMPL_PESSOA_FISICA H ON H.cd_pessoa_fisica = coalesce(A.cd_pf_titular, A.cd_pessoa_fisica) AND H.ie_tipo_complemento = 5
	Left Join MEDICO              I ON I.cd_pessoa_fisica = coalesce(A.cd_pf_titular, A.cd_pessoa_fisica)

UNION

SELECT	Distinct
	row_number() OVER () AS * -1 linha,
	A.nr_sequencia,
	SUBSTR(A.cd_codigo_convenio,1,4) singular,
	SUBSTR(A.cd_codigo_convenio,5,4) cod_unimed_contrato,
	SUBSTR(A.cd_codigo_convenio,9,6) cod_unimed_familia,
	SUBSTR(A.cd_codigo_convenio,15,2) cod_unimed_dep,
	SUBSTR(calcula_digito('Modulo11', A.cd_codigo_convenio),1,2) cod_digito_verific,
	SUBSTR(B.ds_razao_social,1,60) nome,
	null sexo,
	null est_civil,
	null data_nasc,
	CASE WHEN C.nr_seq_cobertura=11 THEN  2  ELSE 1 END  tipo_cliente,
	B.cd_cgc cpf,
	C.nm_contrato plano_unimed,
	'N' lar_homecare,
	CASE WHEN C.cd_categoria IS NULL THEN  'N'  ELSE 'S' END  plano_regulamentado,
	coalesce(C.ie_tipo_acom_integ,'0') tipo_acomodacao,
	'N' cartao_facil,
	CASE WHEN C.nr_seq_cobertura=31 THEN  'N'  ELSE 'S' END  possui_sos,
	C.nr_seq_cobertura plano_sos,
	A.dt_inclusao_sos data_inclusao_sos,
	coalesce(C.dt_cancelamento, A.dt_cancelamento) data_exclusao_sos,
	a.cd_unisanta tabela_unisanta,
	a.dt_inclusao_transporte data_inclusao_transp,
	'' periodo_inclusao_transp,
	a.dt_exclusao_transporte data_exclusao_transp,
	'' periodo_exclusao_transp,
	'' data_term_carencia_transp,
	'0000' cod_tabela_preco,
	'S' gera_comissao_vendedor,
	'0025' cod_unimed_atend,
	'N' cooperado,
	'000000000' cod_medico_unimed,
	'N' colaborador,
	B.nr_ddd_telefone ddd_celular,
	B.nr_telefone nro_celular,
	null contato,
	null ddd_contato,
	null fone_contato,
	null endereco_res,
	null bairro_res,
	null cep_res,
	null cidade_res,
	null uf_res,
	null complemento_res,
	null ddd_res,
	null fone_res,
	null endereco_com,
	null bairro_com,
	null cep_com,
	null cidade_com,
	null uf_com,
	null complemento_com,
	null ddd_com,
	null fone_com,
	null filiacao_mae,
	LOCALTIMESTAMP data_atualizacao,
	CASE WHEN C.ie_origem=1 THEN  'S'  ELSE 'N' END  possui_unimed,
	CASE WHEN C.ie_origem=1 THEN  ''  ELSE '0025' END  cod_unimed_origem,
	CASE WHEN A.dt_cancelamento IS NULL THEN  CASE WHEN C.dt_cancelamento IS NULL THEN  'S'  ELSE 'N' END   ELSE 'N' END  ativo,
	' ' ie_nivel_dependencia
FROM EME_PF_CONTRATO A
	Inner Join PESSOA_JURIDICA     B ON B.cd_cgc = coalesce(A.cd_cgc_titular, A.cd_cgc)
	Inner Join EME_CONTRATO        C ON C.nr_sequencia = A.nr_seq_contrato
WHERE	C.cd_pessoa_fisica is null
ORDER BY 1,2,3,4,5;

