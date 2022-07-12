-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cobranca_escrit_real_240_v (ie_reg, tp_registro, nr_seq_envio, dt_remessa_retorno, dt_credito, cd_banco, cd_cgc, cd_agencia_bancaria, nr_conta_corrente, nm_empresa, nr_titulo, nr_doc_cobranca, dt_vencimento, dt_emissao, dt_desconto, dt_juros_mora, vl_cobranca, vl_juros_mora, vl_desconto, ie_tipo_inscricao, nr_inscricao, nm_pessoa, ds_endereco, ds_endereco_compl, nr_endereco, ds_bairro, cd_cep, ds_cidade, ds_uf, qt_cobranca_simples, vl_carteira_simples, ie_emissao_bloqueto, ds_nosso_numero, qt_lote_arquivo, qt_reg_arquivo, nm_banco, ds_mensagem, ds_mensagem_1, ds_mensagem_2, ds_mensagem_3, ds_mensagem_4, ds_mensagem_5, vl_multa, ie_ordem_int, cd_convenio_banco) AS select	1 ie_reg,
	1 tp_registro,
	a.nr_sequencia nr_seq_envio,
	a.dt_remessa_retorno,
	a.dt_remessa_retorno dt_credito,
	a.cd_banco,
	b.cd_cgc,
	c.cd_agencia_bancaria,
	c.cd_conta nr_conta_corrente,
	substr(obter_razao_social(b.cd_cgc),1,50) nm_empresa,
	0 nr_titulo,
	0 nr_doc_cobranca,
	LOCALTIMESTAMP dt_vencimento,
	LOCALTIMESTAMP dt_emissao,
	to_char(a.dt_remessa_retorno,'ddmmyyyy') dt_desconto,
	LOCALTIMESTAMP dt_juros_mora,
	0 vl_cobranca,
	0 vl_juros_mora,
	0 vl_desconto,
	0 ie_tipo_inscricao,
	'' nr_inscricao,
	'' nm_pessoa,
	'' ds_endereco,
	'' ds_endereco_compl,
	'' nr_endereco,
	'' ds_bairro,
	'' cd_cep,
	'' ds_cidade,
	'' ds_uf,
	0 qt_cobranca_simples,
	0 vl_carteira_simples,
	'' ie_emissao_bloqueto,
	'' ds_nosso_numero,
	0 qt_lote_arquivo,
	0 qt_reg_arquivo,
	substr(obter_nome_banco(a.cd_banco),1,30) nm_banco,
	'' ds_mensagem,
	'' ds_mensagem_1,
	'' ds_mensagem_2,
	'' ds_mensagem_3,
	'' ds_mensagem_4,
	'' ds_mensagem_5,
	0 vl_multa,
	0 ie_ordem_int,
	c.cd_convenio_banco
FROM
	banco_estabelecimento c,
	estabelecimento b,
	cobranca_escritural a
where	a.cd_estabelecimento	= b.cd_estabelecimento
and	a.nr_seq_conta_banco	= c.nr_sequencia

UNION

/*	Header do Lote	*/

select	2 ie_reg,
	2 tp_registro,
	a.nr_sequencia nr_seq_envio,
	a.dt_remessa_retorno,
	a.dt_remessa_retorno dt_credito,
	a.cd_banco,
	b.cd_cgc,
	c.cd_agencia_bancaria,
	c.cd_conta nr_conta_corrente,
	substr(obter_razao_social(b.cd_cgc),1,50) nm_empresa,
	0 nr_titulo,
	0 nr_doc_cobranca,
	LOCALTIMESTAMP dt_vencimento,
	LOCALTIMESTAMP dt_emissao,
	to_char(a.dt_remessa_retorno,'ddmmyyyy') dt_desconto,
	LOCALTIMESTAMP dt_juros_mora,
	0 vl_cobranca,
	0 vl_juros_mora,
	0 vl_desconto,
	0 ie_tipo_inscricao,
	'' nr_inscricao,
	'' nm_pessoa,
	'' ds_endereco,
	'' ds_endereco_compl,
	'' nr_endereco,
	'' ds_bairro,
	'' cd_cep,
	'' ds_cidade,
	'' ds_uf,
	0 qt_cobranca_simples,
	0 vl_carteira_simples,
	a.ie_emissao_bloqueto,
	'' ds_nosso_numero,
	0 qt_lote_arquivo,
	0 qt_reg_arquivo,
	'' nm_banco,
	'' ds_mensagem,
	'' ds_mensagem_1,
	'' ds_mensagem_2,
	'' ds_mensagem_3,
	'' ds_mensagem_4,
	'' ds_mensagem_5,
	0 vl_multa,
	0 ie_ordem_int,
	c.cd_convenio_banco
from	estabelecimento b,
	banco_estabelecimento c,
	cobranca_escritural a
where	a.cd_estabelecimento	= b.cd_estabelecimento
and	a.nr_seq_conta_banco	= c.nr_sequencia

union

/*	Segmento P	,	Segmento Q	,	Segmento R	*/

select	distinct 3 ie_reg,
	3 tp_registro,
	a.nr_sequencia nr_seq_envio,
	LOCALTIMESTAMP dt_remessa_retorno,
	LOCALTIMESTAMP dt_credito,
	a.cd_banco,
	'' cd_cgc,
	c.cd_agencia_bancaria,
	c.nr_conta nr_conta_corrente,
	'' nm_empresa,
	c.nr_titulo,
	c.nr_titulo nr_doc_cobranca,
	b.dt_pagamento_previsto dt_vencimento,
	b.dt_emissao,
	to_char(a.dt_remessa_retorno,'ddmmyyyy') dt_desconto,
	b.dt_pagamento_previsto dt_juros_mora,
	c.vl_cobranca,
	b.tx_juros vl_juros_mora,
	b.TX_DESC_ANTECIPACAO vl_desconto,
	coalesce(b.ie_tipo_pessoa,0) ie_tipo_inscricao,
	CASE WHEN b.ie_tipo_pessoa=2 THEN b.cd_cgc_cpf WHEN b.ie_tipo_pessoa=1 THEN (substr(b.cd_cgc_cpf,1,9) || '0000' || substr(b.cd_cgc_cpf,10,2))  ELSE '000000000000000' END  nr_inscricao,
	b.nm_pessoa,
	substr(obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'E'),1,120) ds_endereco,
	substr(obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'EC'),1,120) ds_endereco_compl,
	substr(obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'NR'),1,120) nr_endereco,
	substr(obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'B'),1,40) ds_bairro,
	substr(obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'CEP'),1,8) cd_cep,
	substr(obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'CI'),1,40) ds_cidade,
	substr(obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'UF'),1,2) ds_uf,
	0 qt_cobranca_simples,
	0 vl_carteira_simples,
	a.ie_emissao_bloqueto,
	lpad(substr(Obter_Nosso_Numero_Banco(a.cd_banco, b.nr_titulo),1,40),13,'0') ds_nosso_numero,
	0 qt_lote_arquivo,
	0 qt_reg_arquivo,
	substr(obter_nome_banco(a.cd_banco),1,40) nm_banco,
	substr('Após venc. Juros ' || to_char(b.tx_juros) || '% e Multa ' || to_char(b.tx_multa) || '% ' || b.ds_observacao_titulo,1,40) ds_mensagem,
	'' ds_mensagem_1,
	'' ds_mensagem_2,
	'' ds_mensagem_3,
	'' ds_mensagem_4,
	'' ds_mensagem_5,
	b.tx_multa vl_multa,
	0 ie_ordem_int,
	'' cd_convenio_banco
from	titulo_receber_cobr c,
	titulo_receber_v b,
	cobranca_escritural a
where	a.nr_sequencia		= c.nr_seq_cobranca
and	c.nr_titulo		= b.nr_titulo

union

/*	Trailer do Lote	*/

select	4 ie_reg,
	7 tp_registro,
	a.nr_sequencia,
	dt_remessa_retorno,
	LOCALTIMESTAMP dt_credito,
	a.cd_banco,
	'' cd_cgc,
	'' cd_agencia_bancaria,
	'' nr_conta_corrente,
	'' nm_empresa,
	0 nr_titulo,
	0 nr_doc_cobranca,
	LOCALTIMESTAMP dt_vencimento,
	LOCALTIMESTAMP dt_emissao,
	to_char(LOCALTIMESTAMP,'ddmmyyyy') dt_desconto,
	LOCALTIMESTAMP dt_juros_mora,
	0 vl_cobranca,
	0 vl_juros_mora,
	0 vl_desconto,
	0 ie_tipo_inscricao,
	'' nr_inscricao,
	'' nm_pessoa,
	'' ds_endereco,
	'' ds_endereco_compl,
	'' nr_endereco,
	'' ds_bairro,
	'' cd_cep,
	'' ds_cidade,
	'' ds_uf,
	((count(*) * 2) + 2) qt_cobranca_simples,
	0 vl_carteira_simples,
	'' ie_emissao_bloqueto,
	'' ds_nosso_numero,
	0 qt_lote_arquivo,
	0 qt_reg_arquivo,
	'' nm_banco,
	'' ds_mensagem,
	'' ds_mensagem_1,
	'' ds_mensagem_2,
	'' ds_mensagem_3,
	'' ds_mensagem_4,
	''  ds_mensagem_5,
	0 vl_multa,
	0 ie_ordem_int,
	'' cd_convenio_banco
from	titulo_receber_cobr b,
	cobranca_escritural a
where	a.nr_sequencia		= b.nr_seq_cobranca
group by a.nr_sequencia,
	dt_remessa_retorno,
	a.cd_banco

union

/*	Trailer do Arquivo	*/

select	5 ie_reg,
	9 tp_registro,
	a.nr_sequencia nr_seq_envio,
	a.dt_remessa_retorno,
	a.dt_remessa_retorno dt_credito,
	a.cd_banco,
	'' cd_cgc,
	'' cd_agencia_bancaria,
	'' nr_conta_corrente,
	'' nm_empresa,
	0 nr_titulo,
	0 nr_doc_cobranca,
	LOCALTIMESTAMP dt_vencimento,
	LOCALTIMESTAMP dt_emissao,
	to_char(a.dt_remessa_retorno,'ddmmyyyy') dt_desconto,
	LOCALTIMESTAMP dt_juros_mora,
	0 vl_cobranca,
	0 vl_juros_mora,
	0 vl_desconto,
	0 ie_tipo_inscricao,
	'' nr_inscricao,
	'' nm_pessoa,
	'' ds_endereco,
	'' ds_endereco_compl,
	'' nr_endereco,
	'' ds_bairro,
	'' cd_cep,
	'' ds_cidade,
	'' ds_uf,
	count(*) qt_cobranca_simples,
	sum(b.vl_cobranca) vl_carteira_simples,
	'' ie_emissao_bloqueto,
	'' ds_nosso_numero,
	000001 qt_lote_arquivo,
	count(*) qt_reg_arquivo,
	'' nm_banco,
	'' ds_mensagem,
	'' ds_mensagem_1,
	'' ds_mensagem_2,
	'' ds_mensagem_3,
	'' ds_mensagem_4,
	'' ds_mensagem_5,
	0 vl_multa,
	0 ie_ordem_int,
	'' cd_convenio_banco
from	titulo_receber_cobr b,
	cobranca_escritural a
where	a.nr_sequencia		= b.nr_seq_cobranca
group by a.nr_sequencia,
 	 a.dt_remessa_retorno,
	 a.dt_remessa_retorno,
	 a.cd_banco;

