-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cobranca_escritural_bradesco_v (tp_registro, nr_seq_envio, dt_remessa_retorno, dt_credito, cd_banco, cd_cgc, cd_convenio_banco, cd_agencia_bancaria, nr_digito_agencia, nr_conta_corrente, nm_empresa, cd_movimento, nr_titulo, cd_carteira, nr_doc_cobranca, dt_vencimento, dt_emissao, dt_desconto, dt_juros_mora, nr_operacao_credito, vl_cobranca, vl_juros_mora, vl_desconto, ie_tipo_inscricao, nr_inscricao, nm_pessoa, ds_endereco, ds_bairro, cd_cep, ds_cidade, ds_uf, qt_cobranca_simples, vl_carteira_simples, ie_emissao_bloqueto, ds_nosso_numero, qt_cobranca_vinculada, qt_lote_arquivo, qt_reg_arquivo) AS select	1 tp_registro,
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
	0 nr_titulo, 
	' ' cd_carteira, 
	0 nr_doc_cobranca, 
	LOCALTIMESTAMP dt_vencimento, 
	LOCALTIMESTAMP dt_emissao, 
	a.dt_remessa_retorno dt_desconto, 
	LOCALTIMESTAMP dt_juros_mora, 
	0 nr_operacao_credito, 
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
	0 qt_reg_arquivo 
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
	0 nr_titulo, 
	' ' cd_carteira, 
	0 nr_doc_cobranca, 
	LOCALTIMESTAMP dt_vencimento, 
	LOCALTIMESTAMP dt_emissao, 
	a.dt_remessa_retorno dt_desconto, 
	LOCALTIMESTAMP dt_juros_mora, 
	0 nr_operacao_credito, 
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
	0 qt_reg_arquivo 
from	estabelecimento b, 
	banco_estabelecimento c, 
	cobranca_escritural a 
where	a.cd_estabelecimento	= b.cd_estabelecimento 
and	a.nr_seq_conta_banco	= c.nr_sequencia 

union
 
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
	c.nr_titulo, 
	'1' cd_carteira, 
	c.nr_titulo nr_doc_cobranca, 
	b.dt_pagamento_previsto dt_vencimento, 
	b.dt_emissao, 
	a.dt_remessa_retorno dt_desconto, 
	LOCALTIMESTAMP dt_juros_mora, 
	c.nr_titulo nr_operacao_credito, 
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
	Obter_Nosso_Numero_Banco(a.cd_banco, b.nr_titulo) ds_nosso_numero, 
	0 qt_cobranca_vinculada, 
	0 qt_lote_arquivo, 
	0 qt_reg_arquivo 
from	titulo_receber_v b, 
	titulo_receber_cobr c, 
	cobranca_escritural a 
where	a.nr_sequencia		= c.nr_seq_cobranca 
and	c.nr_titulo		= b.nr_titulo 

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
	0 nr_titulo, 
	' ' cd_carteira, 
	0 nr_doc_cobranca, 
	LOCALTIMESTAMP dt_vencimento, 
	LOCALTIMESTAMP dt_emissao, 
	a.dt_remessa_retorno dt_desconto, 
	LOCALTIMESTAMP dt_juros_mora, 
	0 nr_operacao_credito, 
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
	0 qt_reg_arquivo 
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
	0 nr_titulo, 
	' ' cd_carteira, 
	0 nr_doc_cobranca, 
	LOCALTIMESTAMP dt_vencimento, 
	LOCALTIMESTAMP dt_emissao, 
	a.dt_remessa_retorno dt_desconto, 
	LOCALTIMESTAMP dt_juros_mora, 
	0 nr_operacao_credito, 
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
	0 qt_lote_arquivo, 
	0 qt_reg_arquivo 
from	titulo_receber_cobr b, 
	cobranca_escritural a 
where	a.nr_sequencia		= b.nr_seq_cobranca 
group by a.nr_sequencia, 
 	 a.dt_remessa_retorno, 
	 a.dt_remessa_retorno, 
	 a.cd_banco;

