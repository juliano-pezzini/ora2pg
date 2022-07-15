-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cobranca_real_240 ( nr_seq_cobr_escrit_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ie_reg_w		bigint;
tp_registro_w		bigint;
nr_seq_envio_w		bigint;
dt_remessa_retorno_w	timestamp;
dt_credito_w		timestamp;
cd_banco_w		integer;
cd_cgc_w		varchar(255);
cd_agencia_bancaria_w	varchar(8);
nr_conta_corrente_w	varchar(15);
nm_empresa_w		varchar(80);
nr_titulo_w		bigint;
nr_doc_cobranca_w	bigint;
dt_vencimento_w		timestamp;
dt_emissao_w		timestamp;
dt_desconto_w		timestamp;
dt_juros_mora_w		timestamp;
vl_cobranca_w		double precision;
vl_juros_mora_w		double precision;
vl_desconto_w		double precision;
ie_tipo_inscricao_w	varchar(2);
nr_inscricao_w		varchar(14);
nm_pessoa_w		varchar(80);
ds_endereco_w		varchar(255);
ds_endereco_compl_w	varchar(255);
nr_endereco_w		varchar(10);
ds_bairro_w		varchar(40);
cd_cep_w		varchar(10);
ds_cidade_w		varchar(40);
ds_uf_w			varchar(15);
qt_cobranca_simples_w	bigint;
vl_carteira_simples_w	double precision;
ie_emissao_bloqueto_w	varchar(1);
ds_nosso_numero_w	varchar(20);
qt_lote_arquivo_w	bigint;
qt_reg_arquivo_w	bigint;
nm_banco_w		varchar(40);
ds_mensagem_w		varchar(255);
ds_mensagem_2_w		varchar(255);
ds_mensagem_3_w		varchar(255);
ds_mensagem_4_w		varchar(255);
ds_mensagem_5_w		varchar(255);
ds_mensagem_6_w		varchar(255);
vl_multa_w		double precision;
ie_ordem_int_w		smallint;
qt_reg_lote_w		bigint;

qt_reg_seg_3_w		bigint;
qt_reg_seg_6_w		bigint;
cd_convenio_banco_w	varchar(100);

c01 CURSOR FOR 
 
SELECT	ie_reg, 
	tp_registro, 
	nr_seq_envio, 
	dt_remessa_retorno, 
	dt_credito, 
	cd_banco, 
	cd_cgc, 
	cd_agencia_bancaria, 
	nr_conta_corrente, 
	nm_empresa, 
	nr_titulo, 
	nr_doc_cobranca, 
	dt_vencimento, 
	dt_emissao, 
	dt_desconto, 
	dt_juros_mora, 
	vl_cobranca, 
	vl_juros_mora, 
	vl_desconto, 
	ie_tipo_inscricao, 
	nr_inscricao, 
	nm_pessoa, 
	ds_endereco, 
	ds_endereco_compl, 
	nr_endereco, 
	ds_bairro, 
	cd_cep, 
	ds_cidade, 
	ds_uf, 
	qt_cobranca_simples, 
	vl_carteira_simples, 
	ie_emissao_bloqueto, 
	ds_nosso_numero, 
	qt_lote_arquivo, 
	qt_reg_arquivo, 
	nm_banco, 
	ds_mensagem, 
	ds_mensagem_2, 
	ds_mensagem_3, 
	ds_mensagem_4, 
	ds_mensagem_5, 
	ds_mensagem_6, 
	vl_multa, 
	ie_ordem_int, 
	cd_convenio_banco 
FROM	( 
	SELECT	1 ie_reg, 
	1 tp_registro, 
	a.nr_sequencia nr_seq_envio, 
	a.dt_remessa_retorno, 
	a.dt_remessa_retorno dt_credito, 
	a.cd_banco, 
	b.cd_cgc, 
	c.cd_agencia_bancaria, 
	c.cd_conta nr_conta_corrente, 
	SUBSTR(obter_razao_social(b.cd_cgc),1,50) nm_empresa, 
	0 nr_titulo, 
	0 nr_doc_cobranca, 
	clock_timestamp() dt_vencimento, 
	clock_timestamp() dt_emissao, 
	TO_CHAR(a.dt_remessa_retorno,'ddmmyyyy') dt_desconto, 
	clock_timestamp() dt_juros_mora, 
	0 vl_cobranca, 
	0 vl_juros_mora, 
	0 vl_desconto, 
	'0' ie_tipo_inscricao, 
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
	SUBSTR(obter_nome_banco(a.cd_banco),1,30) nm_banco, 
	'' ds_mensagem, 
	'' ds_mensagem_2, 
	'' ds_mensagem_3, 
	'' ds_mensagem_4, 
	'' ds_mensagem_5, 
	'' ds_mensagem_6, 
	0 vl_multa, 
	0 ie_ordem_int, 
	c.cd_convenio_banco cd_convenio_banco 
FROM	banco_estabelecimento c, 
	estabelecimento b, 
	cobranca_escritural a 
WHERE	a.cd_estabelecimento	= b.cd_estabelecimento 
AND	a.nr_seq_conta_banco	= c.nr_sequencia 

UNION
 
/*	Header do Lote	*/
 
SELECT	2 ie_reg, 
	2 tp_registro, 
	a.nr_sequencia nr_seq_envio, 
	a.dt_remessa_retorno, 
	a.dt_remessa_retorno dt_credito, 
	a.cd_banco, 
	b.cd_cgc, 
	c.cd_agencia_bancaria, 
	c.cd_conta nr_conta_corrente, 
	SUBSTR(obter_razao_social(b.cd_cgc),1,50) nm_empresa, 
	0 nr_titulo, 
	0 nr_doc_cobranca, 
	clock_timestamp() dt_vencimento, 
	clock_timestamp() dt_emissao, 
	TO_CHAR(a.dt_remessa_retorno,'ddmmyyyy') dt_desconto, 
	clock_timestamp() dt_juros_mora, 
	0 vl_cobranca, 
	0 vl_juros_mora, 
	0 vl_desconto, 
	'0' ie_tipo_inscricao, 
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
	'' ds_mensagem_2, 
	'' ds_mensagem_3, 
	'' ds_mensagem_4, 
	'' ds_mensagem_5, 
	'' ds_mensagem_6, 
	0 vl_multa, 
	0 ie_ordem_int, 
	c.cd_convenio_banco cd_convenio_banco 
FROM	estabelecimento b, 
	banco_estabelecimento c, 
	cobranca_escritural a 
WHERE	a.cd_estabelecimento	= b.cd_estabelecimento 
AND	a.nr_seq_conta_banco	= c.nr_sequencia 

UNION
 
/*	Segmento P	,	Segmento Q	,	Segmento R	*/
 
SELECT	DISTINCT 3 ie_reg, 
	3 tp_registro, 
	a.nr_sequencia nr_seq_envio, 
	clock_timestamp() dt_remessa_retorno, 
	clock_timestamp() dt_credito, 
	a.cd_banco, 
	REPLACE(REPLACE(REPLACE(CASE WHEN CASE WHEN coalesce(b.cd_pessoa_fisica::text, '') = '' THEN  2  ELSE 1 END =2 THEN obter_cgc_cpf_editado(coalesce(obter_dados_pf(b.cd_pessoa_fisica,'CPF'), b.cd_cgc)) WHEN CASE WHEN coalesce(b.cd_pessoa_fisica::text, '') = '' THEN  2  ELSE 1 END =1 THEN (SUBSTR(obter_cgc_cpf_editado(coalesce(obter_dados_pf(b.cd_pessoa_fisica,'CPF'), b.cd_cgc)),1,9) || SUBSTR(obter_cgc_cpf_editado(coalesce(obter_dados_pf(b.cd_pessoa_fisica,'CPF'), b.cd_cgc)),10,10))  ELSE '000000000000000' END ,'.',''),'-',''),'/','') cd_cgc, 
	c.cd_agencia_bancaria, 
	c.nr_conta nr_conta_corrente, 
	'' nm_empresa, 
	c.nr_titulo, 
	c.nr_titulo nr_doc_cobranca, 
	b.dt_pagamento_previsto dt_vencimento, 
	b.dt_emissao, 
	TO_CHAR(a.dt_remessa_retorno,'ddmmyyyy') dt_desconto, 
	b.dt_pagamento_previsto dt_juros_mora, 
	c.vl_cobranca, 
	b.tx_juros vl_juros_mora, 
	b.TX_DESC_ANTECIPACAO vl_desconto, 
	coalesce(CASE WHEN coalesce(b.cd_pessoa_fisica::text, '') = '' THEN  '2'  ELSE '1' END ,'0') ie_tipo_inscricao, 
	''nr_inscricao, 
	SUBSTR(obter_nome_pf_pj(b.cd_pessoa_fisica,b.cd_cgc),1,150) nm_pessoa, 
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
	LPAD(SUBSTR(Obter_Nosso_Numero_Banco(a.cd_banco, b.nr_titulo),1,40),13,'0') ds_nosso_numero, 
	0 qt_lote_arquivo, 
	0 qt_reg_arquivo, 
	SUBSTR(obter_nome_banco(a.cd_banco),1,40) nm_banco, 
	SUBSTR('Após venc. Juros ' || TO_CHAR(b.tx_juros) || '% e Multa ' || TO_CHAR(b.tx_multa) || '% ' || b.ds_observacao_titulo,1,40) ds_mensagem, 
	'' ds_mensagem_2, 
	'' ds_mensagem_3, 
	'' ds_mensagem_4, 
	'' ds_mensagem_5, 
	'' ds_mensagem_6, 
	b.tx_multa vl_multa, 
	0 ie_ordem_int, 
	'' cd_convenio_banco 
FROM	cobranca_escritural a, 
	titulo_receber_cobr c, 
	titulo_receber b 
WHERE	a.nr_sequencia		= c.nr_seq_cobranca 
AND	c.nr_titulo		= b.nr_titulo 

UNION
 
/*	Trailer do Lote	*/
 
SELECT	4 ie_reg, 
	7 tp_registro, 
	nr_seq_envio, 
	dt_remessa_retorno, 
	dt_credito, 
	cd_banco, 
	'' cd_cgc, 
	'' cd_agencia_bancaria, 
	'' nr_conta_corrente, 
	'' nm_empresa, 
	0 nr_titulo, 
	0 nr_doc_cobranca, 
	clock_timestamp() dt_vencimento, 
	clock_timestamp() dt_emissao, 
	TO_CHAR(clock_timestamp(),'ddmmyyyy') dt_desconto, 
	clock_timestamp() dt_juros_mora, 
	0 vl_cobranca, 
	0 vl_juros_mora, 
	0 vl_desconto, 
	'0' ie_tipo_inscricao, 
	'' nr_inscricao, 
	'' nm_pessoa, 
	'' ds_endereco, 
	'' ds_endereco_compl, 
	'' nr_endereco, 
	'' ds_bairro, 
	'' cd_cep, 
	'' ds_cidade, 
	'' ds_uf, 
	(( COUNT(*) + (COUNT(DISTINCT nr_titulo) * 3) ) + 2) qt_cobranca_simples, 
	0 vl_carteira_simples, 
	'' ie_emissao_bloqueto, 
	'' ds_nosso_numero, 
	0 qt_lote_arquivo, 
	0 qt_reg_arquivo, 
	'' nm_banco, 
	'' ds_mensagem, 
	'' ds_mensagem_2, 
	'' ds_mensagem_3, 
	'' ds_mensagem_4, 
	'' ds_mensagem_5, 
	'' ds_mensagem_6, 
	0 vl_multa, 
	0 ie_ordem_int, 
	'' cd_convenio_banco 
FROM (SELECT	1 ie_ordem, 
		a.nr_sequencia nr_seq_envio, 
		a.dt_remessa_retorno, 
		a.dt_remessa_retorno dt_credito, 
		a.cd_banco, 
		b.nr_titulo, 
		e.nr_sequencia nr_seq_seg, 
		d.nr_parcela, 
		d.qt_idade, 
		c.nr_seq_contrato, 
		e.nr_seq_plano, 
		d.nr_seq_segurado, 
		d.nr_sequencia, 
		d.vl_mensalidade 
	FROM	pls_segurado e, 
		pls_mensalidade c, 
		cobranca_escritural a, 
		titulo_receber_cobr b, 
		pls_mensalidade_segurado d 
		WHERE	a.nr_sequencia     = b.nr_seq_cobranca 
		AND	d.nr_seq_mensalidade  = c.nr_sequencia 
		AND	e.nr_sequencia     = d.nr_seq_segurado 
		AND	b.nr_titulo 	IN (	SELECT MAX(t.nr_titulo) 
						FROM	titulo_receber t 
						WHERE	t.nr_seq_mensalidade	= c.nr_sequencia 
						AND	coalesce(t.nr_seq_mens_segurado::text, '') = '') 
		AND	d.nr_sequencia IN (	SELECT f.nr_sequencia 
										FROM  pls_mensalidade_segurado f 
										WHERE  f.nr_seq_mensalidade = c.nr_sequencia  LIMIT 4) 
	
UNION ALL
 
	SELECT	2 ie_ordem, 
		a.nr_sequencia nr_seq_envio, 
		a.dt_remessa_retorno, 
		a.dt_remessa_retorno dt_credito, 
		a.cd_banco, 
		b.nr_titulo, 
		0 nr_sequencia, 
		0 nr_parcela, 
		0 qt_idade, 
		0 nr_seq_contrato, 
		0 nr_seq_plano, 
		0 nr_seq_segurado, 
		0 nr_sequencia, 
		SUM(d.vl_mensalidade) 
	FROM	pls_segurado e, 
		pls_mensalidade c, 
		cobranca_escritural a, 
		titulo_receber_cobr b, 
		pls_mensalidade_segurado d 
	WHERE	a.nr_sequencia     = b.nr_seq_cobranca 
	AND	d.nr_seq_mensalidade  = c.nr_sequencia 
	AND	e.nr_sequencia     = d.nr_seq_segurado 
	AND	b.nr_titulo 		IN (	SELECT 	MAX(t.nr_titulo) 
						FROM	titulo_receber t 
						WHERE	t.nr_seq_mensalidade	= c.nr_sequencia 
						AND	coalesce(t.nr_seq_mens_segurado::text, '') = '') 
	AND	d.nr_sequencia 		NOT IN (	SELECT f.nr_sequencia 
							FROM  pls_mensalidade_segurado f 
							WHERE  f.nr_seq_mensalidade = c.nr_sequencia  LIMIT 4) 
	GROUP BY	a.nr_sequencia, 
			a.dt_remessa_retorno, 
			a.dt_remessa_retorno, 
			a.cd_banco, 
			b.nr_titulo) alias79 
GROUP BY nr_seq_envio, 
	dt_remessa_retorno, 
	dt_credito, 
	cd_banco 

UNION
 
/*	Trailer do Arquivo	*/
 
SELECT	5 ie_reg, 
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
	clock_timestamp() dt_vencimento, 
	clock_timestamp() dt_emissao, 
	TO_CHAR(a.dt_remessa_retorno,'ddmmyyyy') dt_desconto, 
	clock_timestamp() dt_juros_mora, 
	0 vl_cobranca, 
	0 vl_juros_mora, 
	0 vl_desconto, 
	'0' ie_tipo_inscricao, 
	'' nr_inscricao, 
	'' nm_pessoa, 
	'' ds_endereco, 
	'' ds_endereco_compl, 
	'' nr_endereco, 
	'' ds_bairro, 
	'' cd_cep, 
	'' ds_cidade, 
	'' ds_uf, 
	COUNT(*) qt_cobranca_simples, 
	SUM(b.vl_cobranca) vl_carteira_simples, 
	'' ie_emissao_bloqueto, 
	'' ds_nosso_numero, 
	000001 qt_lote_arquivo, 
	COUNT(*) qt_reg_arquivo, 
	'' nm_banco, 
	'' ds_mensagem, 
	'' ds_mensagem_2, 
	'' ds_mensagem_3, 
	'' ds_mensagem_4, 
	'' ds_mensagem_5, 
	'' ds_mensagem_6, 
	0 vl_multa, 
	0 ie_ordem_int, 
	'' cd_convenio_banco 
FROM	titulo_receber_cobr b, 
	cobranca_escritural a 
WHERE	a.nr_sequencia		= b.nr_seq_cobranca 
GROUP BY a.nr_sequencia, 
 	 a.dt_remessa_retorno, 
	 a.dt_remessa_retorno, 
	 a.cd_banco 
) alias87 
where nr_seq_envio = nr_seq_cobr_escrit_p 
ORDER BY ie_reg,nr_titulo,tp_registro;


BEGIN 
 
DELETE	FROM w_cobranca_banco;
COMMIT;
 
OPEN c01;
LOOP 
FETCH c01 INTO 
	ie_reg_w, 
	tp_registro_w, 
	nr_seq_envio_w, 
	dt_remessa_retorno_w, 
	dt_credito_w, 
	cd_banco_w, 
	cd_cgc_w, 
	cd_agencia_bancaria_w, 
	nr_conta_corrente_w, 
	nm_empresa_w, 
	nr_titulo_w, 
	nr_doc_cobranca_w, 
	dt_vencimento_w, 
	dt_emissao_w, 
	dt_desconto_w, 
	dt_juros_mora_w, 
	vl_cobranca_w, 
	vl_juros_mora_w, 
	vl_desconto_w, 
	ie_tipo_inscricao_w, 
	nr_inscricao_w, 
	nm_pessoa_w, 
	ds_endereco_w, 
	ds_endereco_compl_w, 
	nr_endereco_w, 
	ds_bairro_w, 
	cd_cep_w, 
	ds_cidade_w, 
	ds_uf_w, 
	qt_cobranca_simples_w, 
	vl_carteira_simples_w, 
	ie_emissao_bloqueto_w, 
	ds_nosso_numero_w, 
	qt_lote_arquivo_w, 
	qt_reg_arquivo_w, 
	nm_banco_w, 
	ds_mensagem_w, 
	ds_mensagem_2_w, 
	ds_mensagem_3_w, 
	ds_mensagem_4_w, 
	ds_mensagem_5_w, 
	ds_mensagem_6_w, 
	vl_multa_w, 
	ie_ordem_int_w, 
	cd_convenio_banco_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
 
INSERT	INTO	w_cobranca_banco(nr_sequencia, 
		nm_usuario, 
		dt_atualizacao, 
		nm_usuario_nrec, 
		dt_atualizacao_nrec, 
		ie_tipo_registro, 
		nr_seq_envio, 
		dt_geracao, 
		dt_recebimento, 
		cd_banco, 
		ds_cgc_cpf, 
		cd_agencia_bancaria, 
		cd_conta, 
		nm_empresa, 
		nr_titulo, 
		dt_vencimento, 
		dt_emissao, 
		vl_titulo, 
		vl_juros, 
		vl_desconto, 
		ie_tipo_pessoa, 
		nm_pagador, 
		ds_endereco, 
		nr_endereco, 
		ds_bairro, 
		cd_cep, 
		ds_cidade, 
		sg_estado, 
		qt_reg_lote, 
		vl_tot_registros, 
		nr_nosso_numero, 
		qt_lotes, 
		qt_registros, 
		ds_banco, 
		ds_mensagem, 
		ds_mensagem_2, 
		ds_mensagem_3, 
		ds_mensagem_4, 
		ds_mensagem_5, 
		ds_mensagem_6, 
		vl_multa, 
		ds_endereco_compl, 
		cd_convenio_banco) 
	VALUES (nextval('w_interf_itau_seq'), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		tp_registro_w, 
		nr_seq_envio_w, 
		dt_remessa_retorno_w, 
		dt_credito_w, 
		cd_banco_w, 
		cd_cgc_w, 
		cd_agencia_bancaria_w, 
		nr_conta_corrente_w, 
		nm_empresa_w, 
		nr_titulo_w, 
		dt_vencimento_w, 
		dt_emissao_w, 
		vl_cobranca_w, 
		vl_juros_mora_w, 
		vl_desconto_w, 
		ie_tipo_inscricao_w, 
		nm_pessoa_w, 
		ds_endereco_w, 
		nr_endereco_w, 
		ds_bairro_w, 
		cd_cep_w, 
		ds_cidade_w, 
		substr(ds_uf_w,1,2), 
		qt_cobranca_simples_w, 
		vl_carteira_simples_w, 
		ds_nosso_numero_w, 
		qt_lote_arquivo_w, 
		qt_reg_arquivo_w, 
		nm_banco_w, 
		ds_mensagem_w, 
		ds_mensagem_2_w, 
		ds_mensagem_3_w, 
		ds_mensagem_4_w, 
		ds_mensagem_5_w, 
		ds_mensagem_6_w, 
		vl_multa_w, 
		ds_endereco_compl_w, 
		cd_convenio_banco_w);
 
END LOOP;
CLOSE c01;
 
/* OS - 130153 - 27/02/2009 */
 
select	count(*) 
into STRICT	qt_reg_seg_3_w 
from	w_cobranca_banco 
where	ie_tipo_registro = '3';
 
select	count(*) 
into STRICT	qt_reg_seg_6_w 
from	w_cobranca_banco 
where	ie_tipo_registro = '6';
 
/* O tipo de registro 3 só insere 1 linha na tabela w mas no arquivo tem 3 linhas cada */
 
/* Mais 2 de header e trailler do lote */
 
qt_reg_lote_w	:= (qt_reg_seg_3_w * 3) + qt_reg_seg_6_w + 2;
 
update	w_cobranca_banco 
set	qt_reg_lote	= qt_reg_lote_w 
where	ie_tipo_registro	= '7';
 
qt_reg_arquivo_w	:= qt_reg_lote_w + 2;
 
update	w_cobranca_banco 
set	qt_registros	= qt_reg_arquivo_w 
where	ie_tipo_registro	= '9';
/* Fim OS - 130153 - 27/02/2009 */
 
 
COMMIT;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cobranca_real_240 ( nr_seq_cobr_escrit_p bigint, nm_usuario_p text) FROM PUBLIC;

