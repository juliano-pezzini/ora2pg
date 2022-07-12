-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_exp_ben_fsfx_santa_clara_v (ie_tipo, tipo_pessoa, ie_tipo_movimentacao, nm_beneficiario, nm_sobrenome_pai, nm_sobrenome_mae, nr_cpf, nr_identidade, ds_orgao_emissor_ci, dt_nascimento, ie_sexo, ie_estado_civil, ie_tipo_usuario, nr_seq_parentesco, nr_seq_plano, ds_endereco, nr_endereco, ds_complemento, ds_bairro, ds_municipio, sg_estado, cd_cep, nr_ddd_telefone, nr_telefone, nr_cartao_nac_sus, dt_contratacao, cd_custo, dt_adesao, cd_matricula, cd_matricula_empresa, nr_seq_lote) AS select	'1' ie_tipo,
	'Tipo' tipo_pessoa,
	'Movimento' ie_tipo_movimentacao,
	'Nome' nm_beneficiario,
	'Pai' nm_sobrenome_pai,
	'Mãe' nm_sobrenome_mae,
	'CPF' nr_cpf,
	'RG' nr_identidade,
	'Órgão' ds_orgao_emissor_ci,
	'Nascimento' dt_nascimento,
	'Sexo' ie_sexo,
	'Estado Civil' ie_estado_civil,
	'Tipo de Usuário' ie_tipo_usuario,
	'Parentesco' nr_seq_parentesco,
	'Plano' nr_seq_plano,
	'Endereço'ds_endereco,
	'Número' nr_endereco,
	'Complemento' ds_complemento,
	'Bairro' ds_bairro,
	'Cidade' ds_municipio,
	'UF' sg_estado,
	'CEP' cd_cep,
	'DDD' nr_ddd_telefone,
	'Telefone' nr_telefone,
	'CARTAO_SAUDE' nr_cartao_nac_sus,
	'Admissão' dt_contratacao,
	'Centro e custo' cd_custo,
	'Adesão'  dt_adesao,
	'Matrícula' cd_matricula,
	'Empresa' cd_matricula_empresa,
	nr_sequencia nr_seq_lote
FROM 	pls_lote_mov_benef

union all

select	'2' ie_tipo,
	'  'tipo_pessoa,
	CASE WHEN a.ie_tipo_movimentacao='I' THEN '1' WHEN a.ie_tipo_movimentacao='A' THEN '2' WHEN a.ie_tipo_movimentacao='E' THEN '3' WHEN a.ie_tipo_movimentacao='B' THEN 4 END ie_tipo_movimentacao,
	a.nm_beneficiario,
	obter_nome_pai_mae(c.cd_pessoa_fisica,'P')nm_sobrenome_pai,
	obter_nome_pai_mae(c.cd_pessoa_fisica,'M')nm_sobrenome_mae,
	a.nr_cpf,
	a.nr_identidade,
	c.ds_orgao_emissor_ci,
	to_char(a.dt_nascimento,'dd/mm/yyyy') dt_nascimento,
	a.ie_sexo,
	CASE WHEN a.nr_seq_parentesco='124' THEN 'T'  ELSE 'D' END  ie_tipo_usuario,
	CASE WHEN a.ie_estado_civil='1' THEN 'S' WHEN a.ie_estado_civil='2' THEN 'C' WHEN a.ie_estado_civil='3' THEN 'R' WHEN a.ie_estado_civil='4' THEN 'D' WHEN a.ie_estado_civil='5' THEN 'V' WHEN a.ie_estado_civil='6' THEN 'P' WHEN a.ie_estado_civil='7' THEN 'M' WHEN a.ie_estado_civil='9' THEN 'O' END ie_estado_civil,
	CASE WHEN a.nr_seq_parentesco='124' THEN 'T' WHEN a.nr_seq_parentesco='130' THEN 'A' WHEN a.nr_seq_parentesco='4' THEN 'A'  ELSE 'D' END nr_seq_parentesco,
	to_char(d.nr_seq_plano) nr_seq_plano,
	a.ds_endereco,
	to_char(a.nr_endereco) nr_endereco,
	a.ds_complemento,
	a.ds_bairro,
	a.ds_municipio,
	a.sg_estado,
	a.cd_cep,
	f.nr_ddd_telefone,
	f.nr_telefone,
	c.nr_cartao_nac_sus,
	to_char(d.dt_contratacao, 'dd/mm/yyyy')dt_contratacao,
	'  'cd_custo,
	to_char(g.dt_admissao, 'dd/mm/yyyy') dt_adesao,
	'  'cd_matricula,
	to_char(f.cd_empresa_refer) cd_matricula_empresa,
	nr_seq_lote
FROM compl_pessoa_fisica f, pessoa_fisica c, pls_lote_mov_benef b, pls_movimentacao_benef a, pls_segurado d
LEFT OUTER JOIN pls_segurado_compl g ON (d.nr_sequencia = g.nr_seq_segurado)
WHERE b.nr_sequencia		= a.nr_seq_lote and a.nr_seq_segurado	= d.nr_sequencia and d.cd_pessoa_fisica	= c.cd_pessoa_fisica and c.cd_pessoa_fisica	= f.cd_pessoa_fisica  and f.ie_tipo_complemento 	= '1';

