-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cobranca_santander_240 ( nr_seq_cobr_escrit_p bigint, nm_usuario_p text) AS $body$
DECLARE

					 
 
cd_banco_w			smallint;		
cd_agencia_bancaria_w		varchar(8);
cd_conta_w			varchar(15);
nr_titulo_w			bigint;
dt_vencimento_w			timestamp;
vl_titulo_w			double precision;
dt_emissao_w			timestamp;
nr_seq_reg_lote_w			integer;
qt_registros_1_3_5_w		integer;		
 
					 
C01 CURSOR FOR 
	SELECT	c.cd_banco, 
		c.cd_agencia_bancaria, 
		substr(c.cd_conta,1,15), 
		d.nr_titulo, 
		d.dt_vencimento, 
		d.vl_titulo, 
		d.dt_emissao		 
	FROM banco_estabelecimento c, titulo_receber_cobr b, cobranca_escritural a, titulo_receber d
LEFT OUTER JOIN pls_mensalidade e ON (d.nr_seq_mensalidade = e.nr_sequencia)
WHERE a.nr_seq_conta_banco	= c.nr_sequencia and b.nr_seq_cobranca		= a.nr_sequencia and b.nr_titulo			= d.nr_titulo  and a.nr_sequencia		= nr_seq_cobr_escrit_p;

					 

BEGIN 
delete from w_cobranca_banco;
 
/*####	HEADER	####*/
 
insert into	w_cobranca_banco(nr_sequencia, 
	nm_usuario, 
	dt_atualizacao, 
	nm_usuario_nrec, 
	dt_atualizacao_nrec, 
	ie_tipo_registro, 
	ie_tipo_pessoa, 
	ds_cgc_cpf, 
	cd_convenio_banco, 
	cd_agencia_bancaria, 
	cd_conta, 
	ie_digito_conta, 
	nm_empresa, 
	ds_banco, 
	dt_geracao, 
	nr_seq_reg_lote) 
SELECT	nextval('w_cobranca_banco_seq'), 
	nm_usuario_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp(), 
	'0', --ie_tipo_registro 
	'2', --ie_tipo_pessoa 
	b.cd_cgc, 
	c.cd_agencia_bancaria||c.cd_conta, --cd_convenio 
	c.cd_agencia_bancaria, 
	c.cd_conta, 
	c.ie_digito_conta, 
	substr(obter_nome_pf_pj(null,b.cd_cgc),1,255), --nm_empresa 
	substr(obter_nome_banco(c.cd_banco),1,255), --nm_banco 
	clock_timestamp(), --dt_geração 
	'000001' --número sequencial do arquivo 
from	estabelecimento b, 
	banco_estabelecimento c, 
	cobranca_escritural a 
where	a.cd_estabelecimento	= b.cd_estabelecimento 
and	a.nr_seq_conta_banco	= c.nr_sequencia 
and	a.nr_sequencia		= nr_seq_cobr_escrit_p;
 
 
/*####	HEADER DO LOTE	####*/
 
qt_registros_1_3_5_w	:= 1;
insert into	w_cobranca_banco(nr_sequencia, 
	nm_usuario, 
	dt_atualizacao, 
	nm_usuario_nrec, 
	dt_atualizacao_nrec, 
	ie_tipo_registro, 
	ie_tipo_pessoa, 
	ds_cgc_cpf, 
	cd_agencia_bancaria, 
	cd_conta, 
	nm_empresa, 
	dt_geracao) 
SELECT	nextval('w_cobranca_banco_seq'), 
	nm_usuario_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp(), 
	'1', --ie_tipo_registro 
	'2', --ie_tipo_pessoa 
	b.cd_cgc, 
	c.cd_agencia_bancaria, 
	c.cd_conta, 
	substr(obter_nome_pf_pj(null,b.cd_cgc),1,255), --nm_empresa 
	clock_timestamp() --dt_geração 
from	estabelecimento b, 
	banco_estabelecimento c, 
	cobranca_escritural a 
where	a.cd_estabelecimento	= b.cd_estabelecimento 
and	a.nr_seq_conta_banco	= c.nr_sequencia 
and	a.nr_sequencia		= nr_seq_cobr_escrit_p;
 
 
/*####	DETALHE - SEGMENTO 'P'   ####*/
 
nr_seq_reg_lote_w	:= 0;
open C01;
loop 
fetch C01 into	 
	cd_banco_w, 
	cd_agencia_bancaria_w, 
	cd_conta_w, 
	nr_titulo_w, 
	dt_vencimento_w, 
	vl_titulo_w, 
	dt_emissao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	nr_seq_reg_lote_w	:= nr_seq_reg_lote_w + 1;
 
	insert into	w_cobranca_banco(nr_sequencia, 
		nm_usuario,	 
		dt_atualizacao, 
		nm_usuario_nrec, 
		dt_atualizacao_nrec, 
		ie_tipo_registro, 
		nr_seq_reg_lote, 
		cd_banco, 
		cd_agencia_bancaria, 
		cd_conta, 
		nr_titulo, 
		dt_vencimento, 
		vl_titulo, 
		dt_emissao) 
	values (nextval('w_cobranca_banco_seq'), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		'3', -- ie_tipo_registro 
		nr_seq_reg_lote_w, 
		cd_banco_w, 
		cd_agencia_bancaria_w, 
		cd_conta_w, 
		nr_titulo_w, 
		dt_vencimento_w, 
		vl_titulo_w, 
		dt_emissao_w);	
	 
	 
	/*####	DETALHE - SEGMENTO 'Q'   ####*/
 
	 
	insert into	w_cobranca_banco(nr_sequencia, 
		nm_usuario,	 
		dt_atualizacao, 
		nm_usuario_nrec, 
		dt_atualizacao_nrec, 
		ie_tipo_registro, 
		nr_seq_reg_lote, 
		cd_banco, 
		ie_tipo_pessoa, 
		ds_cgc_cpf, 
		nm_pagador, 
		ds_endereco, 
		ds_bairro, 
		cd_cep, 
		ds_cidade, 
		sg_estado, 
		cd_cgc_cedente, 
		nm_empresa)		 
	SELECT	nextval('w_cobranca_banco_seq'), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(),	 
		'4', -- ie_tipo_registro, 
		nr_seq_reg_lote_w, 
		d.cd_banco, 
		CASE WHEN coalesce(b.cd_cgc::text, '') = '' THEN  '1'  ELSE '2' END , --tipo pessoa		 
		coalesce(b.cd_cgc, b.cd_pessoa_fisica), 
		b.nm_pessoa, 
		obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'EC') ds_endereco, 
		substr(obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc,'B'),1,40) ds_bairro, 
		obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'CEP') cd_cep, 
		obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'CI') ds_cidade, 
		obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'UF') ds_uf, 
		e.cd_cgc, 
		substr(obter_razao_social(e.cd_cgc),1,255)		 
	from	estabelecimento e, 
		banco_estabelecimento d, 
		titulo_receber_v b, 
		titulo_receber_cobr c, 
		cobranca_escritural a 
	where	a.nr_sequencia		= c.nr_seq_cobranca 
	and	a.nr_seq_conta_banco	= d.nr_Sequencia 
	and	c.nr_titulo		= b.nr_titulo 
	and	e.cd_estabelecimento	= a.cd_estabelecimento 
	and	a.nr_sequencia		= nr_seq_cobr_escrit_p 
	and	b.nr_titulo		= nr_titulo_w;
	 
	 
	 
	end;
end loop;
close C01;
qt_registros_1_3_5_w	:= qt_registros_1_3_5_w + nr_seq_reg_lote_w;
 
 
/*####	TRAILER DO LOTE   ####*/
 
qt_registros_1_3_5_w	:= qt_registros_1_3_5_w + 1;
insert into	w_cobranca_banco(nr_sequencia, 
	nm_usuario,	 
	dt_atualizacao, 
	nm_usuario_nrec, 
	dt_atualizacao_nrec, 
	ie_tipo_registro, 
	qt_reg_lote) 
values (nextval('w_cobranca_banco_seq'), 
	nm_usuario_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp(), 
	'5', -- ie_tipo_registro 
	qt_registros_1_3_5_w);
 
	 
/*####	TRAILER DE ARQUIVO   ####*/
 
qt_registros_1_3_5_w	:= qt_registros_1_3_5_w + 2; --Qt registros 1,3,5 mais os tipos 0 e 9 
insert into	w_cobranca_banco(nr_sequencia,
	nm_usuario,	 
	dt_atualizacao, 
	nm_usuario_nrec, 
	dt_atualizacao_nrec, 
	ie_tipo_registro, 
	qt_registros) 
values (nextval('w_cobranca_banco_seq'), 
	nm_usuario_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp(), 
	'10', -- ie_tipo_registro 
	qt_registros_1_3_5_w);
	 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cobranca_santander_240 ( nr_seq_cobr_escrit_p bigint, nm_usuario_p text) FROM PUBLIC;

