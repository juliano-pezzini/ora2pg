-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cobranca_escrit_santander_v (tp_registro, nr_seq_envio, dt_remessa_retorno, dt_credito, cd_banco, cd_cgc, cd_convenio_banco, cd_agencia_bancaria, nr_digito_agencia, nr_conta_corrente, nm_empresa, cd_movimento, nr_titulo, cd_carteira, nr_doc_cobranca, dt_vencimento, dt_emissao, dt_desconto, dt_juros_mora, nr_operacao_credito, vl_cobranca, vl_juros_mora, vl_desconto, ie_tipo_inscricao, nr_inscricao, nm_pessoa, ds_endereco, ds_bairro, cd_cep, ds_cidade, ds_uf, qt_cobranca_simples, vl_carteira_simples, ie_emissao_bloqueto, ds_nosso_numero, qt_cobranca_vinculada, qt_lote_arquivo, qt_reg_arquivo, nm_banco) AS select	1 tp_registro,
	a.nr_sequencia nr_seq_envio, 
	a.dt_remessa_retorno, 
	a.dt_remessa_retorno dt_credito, 
	a.cd_banco, 
	b.cd_cgc, 
	' ' cd_convenio_banco, 
	c.cd_agencia_bancaria, 
	calcula_digito('Modulo11',c.cd_agencia_bancaria) nr_digito_agencia, 
	c.cd_conta nr_conta_corrente, 
	substr(obter_razao_social(b.cd_cgc),1,100) nm_empresa, 
	' ' cd_movimento, 
	'' nr_titulo, 
	' ' cd_carteira, 
	'' nr_doc_cobranca, 
	LOCALTIMESTAMP dt_vencimento, 
	LOCALTIMESTAMP dt_emissao, 
	a.dt_remessa_retorno dt_desconto, 
	LOCALTIMESTAMP dt_juros_mora, 
	'' nr_operacao_credito, 
	0 vl_cobranca, 
	0 vl_juros_mora, 
	0 vl_desconto, 
	0 ie_tipo_inscricao, 
	' ' nr_inscricao, 
	' ' nm_pessoa, 
	' ' ds_endereco, 
	' ' ds_bairro, 
	' ' cd_cep, 
	' ' ds_cidade, 
	' ' ds_uf, 
	0 qt_cobranca_simples, 
	0 vl_carteira_simples, 
	'' ie_emissao_bloqueto, 
	'' ds_nosso_numero, 
	0 qt_cobranca_vinculada, 
	0 qt_lote_arquivo, 
	0 qt_reg_arquivo, 
	substr(obter_nome_banco(a.cd_banco),1,100) nm_banco 
FROM	estabelecimento b, 
	banco_estabelecimento c, 
	cobranca_escritural a 
where	a.cd_estabelecimento	= b.cd_estabelecimento 
and	a.nr_seq_conta_banco	= c.nr_sequencia 

UNION
 
select	2 tp_registro, 
	a.nr_sequencia nr_seq_envio, 
	a.dt_remessa_retorno, 
	a.dt_remessa_retorno dt_credito, 
	a.cd_banco, 
	b.cd_cgc, 
	' ' cd_convenio_banco, 
	c.cd_agencia_bancaria, 
	calcula_digito('Modulo11',c.cd_agencia_bancaria) nr_digito_agencia, 
	c.cd_conta nr_conta_corrente, 
	substr(obter_razao_social(b.cd_cgc),1,100) nm_empresa, 
	' ' cd_movimento, 
	'' nr_titulo, 
	' ' cd_carteira, 
	'' nr_doc_cobranca, 
	LOCALTIMESTAMP dt_vencimento, 
	LOCALTIMESTAMP dt_emissao, 
	a.dt_remessa_retorno dt_desconto, 
	LOCALTIMESTAMP dt_juros_mora, 
	'' nr_operacao_credito, 
	0 vl_cobranca, 
	0 vl_juros_mora, 
	0 vl_desconto, 
	0 ie_tipo_inscricao, 
	' ' nr_inscricao, 
	' ' nm_pessoa, 
	' ' ds_endereco, 
	' ' ds_bairro, 
	' ' cd_cep, 
	' ' ds_cidade, 
	' ' ds_uf, 
	0 qt_cobranca_simples, 
	0 vl_carteira_simples, 
	a.ie_emissao_bloqueto, 
	'' ds_nosso_numero, 
	0 qt_cobranca_vinculada, 
	0 qt_lote_arquivo, 
	0 qt_reg_arquivo, 
	' ' nm_banco 
from	estabelecimento b, 
	banco_estabelecimento c, 
	cobranca_escritural a 
where	a.cd_estabelecimento	= b.cd_estabelecimento 
and	a.nr_seq_conta_banco	= c.nr_sequencia 

union
 
/* Pessoa Física */
 
select	3 tp_registro, 
	a.nr_sequencia nr_seq_envio, 
	LOCALTIMESTAMP dt_remessa_retorno, 
	LOCALTIMESTAMP dt_credito, 
	a.cd_banco, 
	' ' cd_cgc, 
	' ' cd_convenio_banco, 
	c.cd_agencia_bancaria, 
	calcula_digito('Modulo11',c.cd_agencia_bancaria) nr_digito_agencia, 
	c.nr_conta nr_conta_corrente, 
	' ' nm_empresa, 
	'01' cd_movimento, 
	coalesce(b.nr_titulo_externo,c.nr_titulo), 
	'1' cd_carteira, 
	coalesce(b.nr_titulo_externo,c.nr_titulo) nr_doc_cobranca, 
	b.dt_pagamento_previsto dt_vencimento, 
	b.dt_emissao, 
	a.dt_remessa_retorno dt_desconto, 
	LOCALTIMESTAMP dt_juros_mora, 
	coalesce(b.nr_titulo_externo,c.nr_titulo) nr_operacao_credito, 
	c.vl_cobranca, 
	0 vl_juros_mora, 
	b.TX_DESC_ANTECIPACAO vl_desconto, 
	b.ie_tipo_pessoa ie_tipo_inscricao, 
	b.cd_cgc_cpf nr_inscricao, 
	b.nm_pessoa, 
	CASE WHEN e.cd_pessoa_fisica IS NULL THEN d.ds_endereco  ELSE e.ds_endereco END  ds_endereco, 
	substr(CASE WHEN e.cd_pessoa_fisica IS NULL THEN d.ds_bairro  ELSE e.ds_bairro END ,1,40) ds_bairro, 
	CASE WHEN e.cd_pessoa_fisica IS NULL THEN d.cd_cep  ELSE e.cd_cep END  cd_cep, 
	CASE WHEN e.cd_pessoa_fisica IS NULL THEN d.ds_municipio  ELSE e.ds_municipio END  ds_cidade, 
	CASE WHEN e.cd_pessoa_fisica IS NULL THEN d.sg_estado  ELSE e.sg_estado END  ds_uf, 
	0 qt_cobranca_simples, 
	0 vl_carteira_simples, 
	a.ie_emissao_bloqueto, 
	lpad(Obter_Nosso_Numero_Banco(a.cd_banco, b.nr_titulo),13,'0') ds_nosso_numero, 
	0 qt_cobranca_vinculada, 
	0 qt_lote_arquivo, 
	0 qt_reg_arquivo, 
	substr(obter_nome_banco(a.cd_banco),1,100) nm_banco 
FROM titulo_receber_cobr c, cobranca_escritural a, titulo_receber_v b
LEFT OUTER JOIN (SELECT x.* 
	 FROM compl_pessoa_fisica x 
	 WHERE x.ie_tipo_complemento = 1) d ON (b.cd_pessoa_fisica = d.cd_pessoa_fisica)
LEFT OUTER JOIN (SELECT x.* 
	 FROM compl_pessoa_fisica x 
	 WHERE x.ie_tipo_complemento = 8) e ON (b.cd_pessoa_fisica = e.cd_pessoa_fisica)
WHERE a.nr_sequencia		= c.nr_seq_cobranca AND c.nr_titulo		= b.nr_titulo AND b.cd_pessoa_fisica IS NOT NULL   
union
 
/* Pessoa jurídica */
 
select	3 tp_registro, 
	a.nr_sequencia nr_seq_envio, 
	LOCALTIMESTAMP dt_remessa_retorno, 
	LOCALTIMESTAMP dt_credito, 
	a.cd_banco, 
	' ' cd_cgc, 
	' ' cd_convenio_banco, 
	c.cd_agencia_bancaria, 
	calcula_digito('Modulo11',c.cd_agencia_bancaria) nr_digito_agencia, 
	c.nr_conta nr_conta_corrente, 
	' ' nm_empresa, 
	'01' cd_movimento, 
	coalesce(b.nr_titulo_externo,c.nr_titulo), 
	'1' cd_carteira, 
	coalesce(b.nr_titulo_externo,c.nr_titulo) nr_doc_cobranca, 
	b.dt_pagamento_previsto dt_vencimento, 
	b.dt_emissao, 
	a.dt_remessa_retorno dt_desconto, 
	LOCALTIMESTAMP dt_juros_mora, 
	coalesce(b.nr_titulo_externo,c.nr_titulo) nr_operacao_credito, 
	c.vl_cobranca, 
	0 vl_juros_mora, 
	b.TX_DESC_ANTECIPACAO vl_desconto, 
	b.ie_tipo_pessoa ie_tipo_inscricao, 
	b.cd_cgc_cpf nr_inscricao, 
	b.nm_pessoa, 
	obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'EC') ds_endereco, 
	substr(obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'B'),1,40) ds_bairro, 
	obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'CEP') cd_cep, 
	obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'CI') ds_cidade, 
	obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'UF') ds_uf, 
	0 qt_cobranca_simples, 
	0 vl_carteira_simples, 
	a.ie_emissao_bloqueto, 
	lpad(Obter_Nosso_Numero_Banco(a.cd_banco, b.nr_titulo),13,'0') ds_nosso_numero, 
	0 qt_cobranca_vinculada, 
	0 qt_lote_arquivo, 
	0 qt_reg_arquivo, 
	substr(obter_nome_banco(a.cd_banco),1,100) nm_banco 
from	titulo_receber_v b, 
	titulo_receber_cobr c, 
	cobranca_escritural a 
where	a.nr_sequencia		= c.nr_seq_cobranca 
and	c.nr_titulo		= b.nr_titulo 
and	b.cd_cgc is not null 

union
 
select	5 tp_registro, 
	a.nr_sequencia nr_seq_envio, 
	a.dt_remessa_retorno, 
	a.dt_remessa_retorno dt_credito, 
	a.cd_banco, 
	' ' cd_cgc, 
	' ' cd_convenio_banco, 
	' ' cd_agencia_bancaria, 
	0 nr_digito_agencia, 
	' ' nr_conta_corrente, 
	' ' nm_empresa, 
	' ' cd_movimento, 
	'' nr_titulo, 
	' ' cd_carteira, 
	'' nr_doc_cobranca, 
	LOCALTIMESTAMP dt_vencimento, 
	LOCALTIMESTAMP dt_emissao, 
	a.dt_remessa_retorno dt_desconto, 
	LOCALTIMESTAMP dt_juros_mora, 
	'' nr_operacao_credito, 
	0 vl_cobranca, 
	0 vl_juros_mora, 
	0 vl_desconto, 
	0 ie_tipo_inscricao, 
	' ' nr_inscricao, 
	' ' nm_pessoa, 
	' ' ds_endereco, 
	' ' ds_bairro, 
	' ' cd_cep, 
	' ' ds_cidade, 
	' ' ds_uf, 
	((count(*) * 2) + 2) qt_cobranca_simples, 
	sum(b.vl_cobranca) vl_carteira_simples, 
	'' ie_emissao_bloqueto, 
	'' ds_nosso_numero, 
	0 qt_cobranca_vinculada, 
	0 qt_lote_arquivo, 
	0 qt_reg_arquivo, 
	' ' nm_banco 
from	titulo_receber_cobr b, 
	cobranca_escritural a 
where	a.nr_sequencia		= b.nr_seq_cobranca 
group by a.nr_sequencia, 
 	 a.dt_remessa_retorno, 
	 a.dt_remessa_retorno, 
	 a.cd_banco 

union
 
select	9 tp_registro, 
	a.nr_sequencia nr_seq_envio, 
	a.dt_remessa_retorno, 
	a.dt_remessa_retorno dt_credito, 
	a.cd_banco, 
	' ' cd_cgc, 
	' ' cd_convenio_banco, 
	' ' cd_agencia_bancaria, 
	0 nr_digito_agencia, 
	' ' nr_conta_corrente, 
	' ' nm_empresa, 
	' ' cd_movimento, 
	'' nr_titulo, 
	' ' cd_carteira, 
	'' nr_doc_cobranca, 
	LOCALTIMESTAMP dt_vencimento, 
	LOCALTIMESTAMP dt_emissao, 
	a.dt_remessa_retorno dt_desconto, 
	LOCALTIMESTAMP dt_juros_mora, 
	'' nr_operacao_credito, 
	0 vl_cobranca, 
	0 vl_juros_mora, 
	0 vl_desconto, 
	0 ie_tipo_inscricao, 
	' ' nr_inscricao, 
	' ' nm_pessoa, 
	' ' ds_endereco, 
	' ' ds_bairro, 
	' ' cd_cep, 
	' ' ds_cidade, 
	' ' ds_uf, 
	count(*) qt_cobranca_simples, 
	sum(b.vl_cobranca) vl_carteira_simples, 
	'' ie_emissao_bloqueto, 
	'' ds_nosso_numero, 
	0 qt_cobranca_vinculada, 
	000001 qt_lote_arquivo, 
	count(*) qt_reg_arquivo, 
	' ' nm_banco 
from	titulo_receber_cobr b, 
	cobranca_escritural a 
where	a.nr_sequencia		= b.nr_seq_cobranca 
group by a.nr_sequencia, 
 	 a.dt_remessa_retorno, 
	 a.dt_remessa_retorno, 
	 a.cd_banco;

