-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sbc_gerar_w_interf_itau_400 ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ds_endereco_w			varchar(255);
nm_pagador_w			varchar(80);
ds_bairro_w			varchar(40);
ds_municipio_w			varchar(40);
nr_nosso_numero_w		varchar(20);
nr_nosso_numero_ww		varchar(20);
cd_conta_w			varchar(15);
nr_digito_agencia_w		varchar(15);
ds_cgc_cpf_w			varchar(14);
cd_carteira_w			varchar(10);
cd_cep_w			varchar(10);
cd_agencia_bancaria_w		varchar(8);
ie_digito_conta_w		varchar(2);
sg_estado_w			varchar(15);
ie_dig_nosso_numero_w		varchar(2);
ie_tipo_pessoa_w		varchar(1);
vl_titulo_w			double precision;
nr_seq_cobr_w			bigint;
nr_sequencial_w			bigint	:= 2;	
nr_titulo_w			bigint;
cd_banco_w			smallint;
dt_vencimento_w			timestamp;
dt_emissao_w			timestamp;			
 
C01 CURSOR FOR 
	SELECT	c.nr_sequencia, 
		c.cd_agencia_bancaria, 
		substr(e.cd_conta,1,15), 
		c.ie_digito_conta, 
		substr(pls_obter_dados_segurado(pls_obter_segurado_pagador(d.nr_seq_pagador),'C'),1,10) cd_carteira_pag, 
		c.nr_titulo, 
		b.vl_titulo, 
		b.dt_vencimento, 
		b.dt_emissao, 
		CASE WHEN coalesce(b.cd_pessoa_fisica::text, '') = '' THEN  '2'  ELSE '1' END  ie_tipo_pessoa, 
		coalesce(obter_dados_pf(b.cd_pessoa_fisica,'CPF'),b.cd_cgc) cd_cgc_cpf, 
		substr(obter_nome_pf_pj(b.cd_pessoa_fisica,b.cd_cgc),1,255) nm_pagador, 
		substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN  			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'E')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'EN') END ,1,120) ds_endereco, 
		substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN  			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'B')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'B') END ,1,40) ds_bairro, 
		substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN  			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'CEP')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'CEP') END ,1,120) cd_cep, 
		substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN  			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'CI')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'CI') END ,1,40) ds_cidade, 
		substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN  			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'UF')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'UF') END ,1,2) ds_uf, 
		substr(obter_nosso_numero_banco(341,c.nr_titulo),5,length(obter_nosso_numero_banco(341,c.nr_titulo)) - 6) nr_nosso_numero, 
		substr(obter_nosso_numero_banco(341,c.nr_titulo),length(obter_nosso_numero_banco(341,c.nr_titulo)),1) nr_digito, 
		e.cd_banco 
	FROM banco_estabelecimento e, titulo_receber_cobr c, cobranca_escritural a, titulo_receber_v b
LEFT OUTER JOIN pls_mensalidade d ON (b.nr_seq_mensalidade = d.nr_sequencia)
WHERE a.nr_sequencia		= c.nr_seq_cobranca and c.nr_titulo		= b.nr_titulo and a.nr_seq_conta_banco	= e.nr_sequencia  and a.nr_sequencia		= nr_seq_cobr_escrit_p;
	

BEGIN 
delete from	w_cobranca_banco;
 
--REGISTRO HEADER 
insert into	w_cobranca_banco(nr_sequencia, 
	nm_usuario, 
	dt_atualizacao, 
	nm_usuario_nrec, 
	dt_atualizacao_nrec,	 
	ie_tipo_registro, 
	cd_banco, 
	cd_conta, 
	cd_agencia_bancaria, 
	ie_digito_conta, 
	dt_geracao, 
	nm_empresa) 
SELECT	nextval('w_cobranca_banco_seq'), 
	nm_usuario_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp(), 
	'0', 
	b.cd_banco, 
	substr(b.cd_conta,1,15), 
	b.cd_agencia_bancaria, 
	b.ie_digito_conta, 
	clock_timestamp(), 
	obter_nome_estabelecimento(cd_estabelecimento_p) 
from	banco_estabelecimento b, 
	cobranca_escritural a 
where	a.nr_seq_conta_banco	= b.nr_sequencia 
and	a.nr_sequencia		= nr_seq_cobr_escrit_p;
 
 
--REGISTRO EMISSÃO DE BOLETO 
open C01;
loop 
fetch C01 into	 
	nr_seq_cobr_w,	 
	cd_agencia_bancaria_w, 
	cd_conta_w, 
	ie_digito_conta_w, 
	cd_carteira_w,		 
	nr_titulo_w, 
	vl_titulo_w, 
	dt_vencimento_w, 
	dt_emissao_w, 
	ie_tipo_pessoa_w, 
	ds_cgc_cpf_w, 
	nm_pagador_w, 
	ds_endereco_w, 
	ds_bairro_w, 
	cd_cep_w, 
	ds_municipio_w, 
	sg_estado_w, 
	nr_nosso_numero_w, 
	nr_digito_agencia_w, 
	cd_banco_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	/* Diether - OS 327614 - Tratado para gerar o número do nosso número e dígito */
 
	select	nr_nosso_numero, 
		ie_dig_nosso_numero 
	into STRICT	nr_nosso_numero_ww, 
		ie_dig_nosso_numero_w 
	from	titulo_receber 
	where	nr_titulo	= nr_titulo_w;
	 
	if (coalesce(nr_nosso_numero_ww::text, '') = '') and (coalesce(ie_dig_nosso_numero_w::text, '') = '') then 
		update	titulo_receber 
		set	nr_nosso_numero		= nr_nosso_numero_w, 
			ie_dig_nosso_numero	= nr_digito_agencia_w 
		where	nr_titulo 		= nr_titulo_w 
		and	coalesce(nr_nosso_numero::text, '') = '';
		 
		update 	banco_regra_numero 
		set	nr_atual 		= to_char((nr_atual)::numeric  + 1) 
		where	cd_banco		= cd_banco_w 
		and	cd_estabelecimento	= cd_estabelecimento_p;
	else 
		nr_nosso_numero_w	:= nr_nosso_numero_ww;
		nr_digito_agencia_w	:= ie_dig_nosso_numero_w;
	end if;
	 
	insert into	w_cobranca_banco(nr_sequencia, 
		nm_usuario, 
		dt_atualizacao, 
		nm_usuario_nrec, 
		dt_atualizacao_nrec,	 
		ie_tipo_registro, 
		cd_agencia_bancaria, 
		cd_conta, 
		ie_digito_conta, 
		cd_carteira, 
		nr_titulo, 
		vl_titulo, 
		dt_vencimento, 
		dt_emissao, 
		ie_tipo_pessoa, 
		ds_cgc_cpf, 
		nm_pagador, 
		ds_endereco, 
		ds_bairro, 
		cd_cep, 
		ds_cidade, 
		sg_estado, 
		nr_seq_reg_lote, 
		nr_nosso_numero, 
		nr_digito_agencia) 
	values (nextval('w_cobranca_banco_seq'), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		'1', 
		cd_agencia_bancaria_w, 
		cd_conta_w, 
		ie_digito_conta_w, 
		cd_carteira_w,		 
		nr_titulo_w, 
		vl_titulo_w, 
		dt_vencimento_w, 
		dt_emissao_w, 
		ie_tipo_pessoa_w, 
		ds_cgc_cpf_w, 
		nm_pagador_w, 
		ds_endereco_w, 
		ds_bairro_w, 
		cd_cep_w, 
		ds_municipio_w, 
		substr(sg_estado_w,1,2), 
		nr_sequencial_w, 
		nr_nosso_numero_w, 
		nr_digito_agencia_w);
 
	nr_sequencial_w	:= nr_sequencial_w + 1;
 
	--REGISTRO EMISSÃO DE BOLETO 
	insert into	w_cobranca_banco(nr_sequencia, 
		nm_usuario, 
		dt_atualizacao, 
		nm_usuario_nrec, 
		dt_atualizacao_nrec,	 
		ie_tipo_registro, 
		ds_mensagem, 
		ds_mensagem_2, 
		ds_mensagem_3, 
		ds_mensagem_4, 
		ds_mensagem_5, 
		nr_seq_reg_lote) 
	SELECT	nextval('w_cobranca_banco_seq'), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		'6', 
		substr(obter_linha_texto(d.ds_observacao,1),1,40) ds_mensagem_1, 
		substr(obter_linha_texto(d.ds_observacao,2),1,40) ds_mensagem_2, 
		substr(obter_linha_texto(d.ds_observacao,3),1,40) ds_mensagem_3, 
		substr(obter_linha_texto(d.ds_observacao,4),1,40) ds_mensagem_4, 
		substr(obter_linha_texto(d.ds_observacao,5),1,40) ds_mensagem_5, 
		nr_sequencial_w 
	from	pls_mensalidade d, 
		titulo_receber_cobr c, 
		titulo_receber b, 
		cobranca_escritural a 
	where	a.nr_sequencia		= c.nr_seq_cobranca 
	and	c.nr_titulo		= b.nr_titulo 
	and	d.nr_sequencia		= b.nr_seq_mensalidade 
	and	c.nr_sequencia		= nr_seq_cobr_w;
 
	nr_sequencial_w	:= nr_sequencial_w + 1;
	end;
end loop;
close C01;
 
--REGISTRO TRAILER DE ARQUIVO 
insert into	w_cobranca_banco(nr_sequencia, 
	nm_usuario, 
	dt_atualizacao, 
	nm_usuario_nrec, 
	dt_atualizacao_nrec,	 
	ie_tipo_registro, 
	nr_seq_reg_lote) 
values (nextval('w_cobranca_banco_seq'), 
	nm_usuario_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp(), 
	'9', 
	nr_sequencial_w);
	 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sbc_gerar_w_interf_itau_400 ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
