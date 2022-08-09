-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cobranca_hsbc_400 (nr_seq_cobr_escrit_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
 
ie_tipo_registro_w		smallint;
nr_registro_w		integer;
cd_agencia_bancaria_w	varchar(8);
cd_conta_w		varchar(15);
nm_empresa_w		varchar(80);
dt_geracao_w		timestamp;
ie_tipo_pessoa_w		varchar(1);
ds_cgc_cpf_w		varchar(14);
nr_titulo_w		bigint;
vl_titulo_w		double precision;
dt_emissao_w		timestamp;
vl_juros_w		double precision;
vl_multa_w		double precision;
dt_vencimento_w		timestamp;
vl_desconto_w		double precision;
nm_pagador_w		varchar(80);
ds_endereco_w		varchar(255);
ds_bairro_w		varchar(80);
cd_cep_w		varchar(10);
ds_cidade_w		varchar(40);
sg_estado_w		varchar(15);
nr_nosso_numero_w	varchar(20);

nr_seq_reg_lote_w	integer := 2;

c01 CURSOR FOR 
SELECT 	ie_tipo_registro, 
	nr_registro, 
	cd_agencia_bancaria, 
	cd_conta, 
	nm_empresa, 
	dt_geracao, 
	ie_tipo_inscricao, 
	nr_inscricao, 
	nr_titulo, 
	vl_titulo, 
	dt_emissao, 
	vl_juros, 
	vl_multa, 
	dt_vencimento, 
	vl_desconto, 
	nm_fornecedor, 
	ds_endereco, 
	ds_bairro, 
	cd_cep, 
	ds_cidade, 
	sg_estado, 
	nr_nosso_numero 
FROM ( 
	SELECT	0 ie_tipo_registro, 
		1 nr_registro, 
		to_char(somente_numero(c.cd_agencia_bancaria)) cd_agencia_bancaria, 
		substr(to_char(somente_numero(c.cd_conta||c.ie_digito_conta)),1,15) cd_conta, 
		SUBSTR(obter_razao_social(b.cd_cgc),1,30) nm_empresa, 
		clock_timestamp() dt_geracao, 
		'0' ie_tipo_inscricao, 
		' ' nr_inscricao, 
		0 nr_titulo, 
		0 vl_titulo, 
		clock_timestamp() dt_emissao, 
		'0' vl_juros, 
		'0' vl_multa, 
		clock_timestamp() dt_vencimento, 
		0 vl_desconto, 
		' ' nm_fornecedor, 
		' ' ds_endereco, 
		' ' ds_bairro, 
		' ' cd_cep, 
		' ' ds_cidade, 
		' ' sg_estado, 
		' ' nr_nosso_numero 
	FROM	estabelecimento b, 
		banco_estabelecimento c, 
		cobranca_escritural a 
	WHERE	a.cd_estabelecimento	= b.cd_estabelecimento 
	AND	a.nr_seq_conta_banco	= c.nr_sequencia 
	AND	a.nr_sequencia = nr_seq_cobr_escrit_p 
	
UNION
 
	SELECT	1 ie_tipo_registro, 
		0 nr_registro, 
		to_char(somente_numero(e.cd_agencia_bancaria)) cd_agencia_bancaria, 
		substr(to_char(somente_numero(e.cd_conta||e.ie_digito_conta)),1,15) cd_conta, 
		' ' nm_empresa, 
		clock_timestamp() dt_geracao, 
		CASE WHEN coalesce(b.cd_cgc::text, '') = '' THEN '1'  ELSE '2' END  ie_tipo_inscricao, 
		to_char(somente_numero(b.cd_cgc_cpf)) nr_inscricao, 
		--DECODE(b.ie_tipo_pessoa,2,b.cd_cgc_cpf,1,(SUBSTR(b.cd_cgc_cpf,1,9) || '0000' || SUBSTR(b.cd_cgc_cpf,10,2)),'00000000000000') nr_inscricao, 
		c.nr_titulo nr_titulo, 
		c.vl_cobranca vl_titulo, 
		b.dt_emissao dt_emissao, 
		substr(obter_juros_multa_titulo(b.nr_titulo,clock_timestamp(),'R','J'),1,20) vl_juros, 
		substr(obter_juros_multa_titulo(b.nr_titulo,clock_timestamp(),'R','M'),1,20) vl_multa, 
		b.dt_vencimento dt_vencimento, 
		Obter_Desconto_tit_rec(c.nr_titulo) vl_desconto, 
		b.nm_pessoa nm_fornecedor, 
		substr(obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'EC'),1,255) ds_endereco, 
		substr(obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'B'),1,255) ds_bairro, 
		to_char(somente_numero(substr(obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'CEP'),1,255))) cd_cep, 
		substr(obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'CI'),1,255) ds_cidade, 
		substr(obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'UF'),1,255) sg_estado, 
		lpad(b.nr_nosso_numero,11,0) nr_nosso_numero 
	FROM	banco_estabelecimento e, 
		titulo_receber_v b, 
		titulo_receber_cobr c, 
		cobranca_escritural a 
	WHERE	a.nr_sequencia		= c.nr_seq_cobranca 
	AND	c.nr_titulo		= b.nr_titulo 
	and	e.nr_sequencia		= a.nr_seq_conta_banco 
	AND	a.nr_sequencia = nr_seq_cobr_escrit_p 
	
UNION
 
	SELECT	9 ie_tipo_registro, 
		0 nr_registro, 
		' ' cd_agencia_bancaria, 
		' ' cd_conta, 
		' ' nm_empresa, 
		clock_timestamp() dt_geracao, 
		'0' ie_tipo_inscricao, 
		' ' nr_inscricao, 
		0 nr_titulo, 
		0 vl_titulo, 
		clock_timestamp() dt_emissao, 
		'0' vl_juros, 
		'0' vl_multa, 
		clock_timestamp() dt_vencimento, 
		0 vl_desconto, 
		' ' nm_fornecedor, 
		' ' ds_endereco, 
		' ' ds_bairro, 
		' ' cd_cep, 
		' ' ds_cidade, 
		' ' sg_estado, 
		' ' nr_nosso_numero 
	FROM	estabelecimento b, 
		banco_estabelecimento c, 
		cobranca_escritural a 
	WHERE	a.cd_estabelecimento	= b.cd_estabelecimento 
	AND	a.nr_seq_conta_banco	= c.nr_sequencia 
	AND	a.nr_sequencia = nr_seq_cobr_escrit_p 
	) alias42 
order by 1;


BEGIN 
 
delete	from w_cobranca_banco;
commit;
 
open c01;
loop 
fetch c01 into 
	ie_tipo_registro_w, 
	nr_registro_w, 
	cd_agencia_bancaria_w, 
	cd_conta_w, 
	nm_empresa_w, 
	dt_geracao_w, 
	ie_tipo_pessoa_w, 
	ds_cgc_cpf_w, 
	nr_titulo_w, 
	vl_titulo_w, 
	dt_emissao_w, 
	vl_juros_w, 
	vl_multa_w, 
	dt_vencimento_w, 
	vl_desconto_w, 
	nm_pagador_w, 
	ds_endereco_w, 
	ds_bairro_w, 
	cd_cep_w, 
	ds_cidade_w, 
	sg_estado_w, 
	nr_nosso_numero_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
 
insert	into	w_cobranca_banco(nr_sequencia, 
		nm_usuario, 
		dt_atualizacao, 
		nm_usuario_nrec, 
		dt_atualizacao_nrec, 
		ie_tipo_registro, 
		nr_registro, 
		cd_agencia_bancaria, 
		cd_conta, 
		nm_empresa, 
		dt_geracao, 
		ie_tipo_pessoa, 
		ds_cgc_cpf, 
		nr_titulo, 
		vl_titulo, 
		dt_emissao, 
		vl_juros, 
		vl_multa, 
		dt_vencimento, 
		vl_desconto, 
		nm_pagador, 
		ds_endereco, 
		ds_bairro, 
		cd_cep, 
		ds_cidade, 
		sg_estado, 
		nr_seq_reg_lote, 
		nr_seq_envio, 
		nr_nosso_numero) 
	values (nextval('w_interf_itau_seq'), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		ie_tipo_registro_w, 
		nr_registro_w, 
		cd_agencia_bancaria_w, 
		cd_conta_w, 
		nm_empresa_w, 
		dt_geracao_w, 
		ie_tipo_pessoa_w, 
		ds_cgc_cpf_w, 
		nr_titulo_w, 
		vl_titulo_w, 
		dt_emissao_w, 
		vl_juros_w, 
		vl_multa_w, 
		dt_vencimento_w, 
		vl_desconto_w, 
		nm_pagador_w, 
		ds_endereco_w, 
		substr(ds_bairro_w,1,40), 
		cd_cep_w, 
		ds_cidade_w, 
		substr(sg_estado_w,1,2), 
		nr_seq_reg_lote_w, 
		nr_seq_cobr_escrit_p, 
		nr_nosso_numero_w);
 
	/* Incrementa o número do registro do arquivo */
 
	if (ie_tipo_registro_w in ('1','9')) then 
		nr_seq_reg_lote_w := nr_seq_reg_lote_w + 1;
	end if;
 
end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cobranca_hsbc_400 (nr_seq_cobr_escrit_p bigint, nm_usuario_p text) FROM PUBLIC;
