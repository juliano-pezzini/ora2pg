-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cobr_citibank_240 ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
 
ds_conteudo_w		varchar(243);
qt_lote_arquivo_w	varchar(6)	:= 0;
nr_seq_registro_w	bigint	:= 0;
nr_lote_w_w		bigint	:= 0;
qt_titulos_lote_w	bigint	:= 0;
cd_pf_pj_w		varchar(15);
nm_empresa_w 		varchar(30);
nm_banco_w		varchar(30);
dt_geracao_w		varchar(8);
hr_geracao_w		varchar(6);
nr_lote_w		bigint;
tipo_empresa_w		varchar(1);
nr_inscricao_w		varchar(15);
nm_pf_pj_w		varchar(40);
ds_endereco_sacado_w	varchar(40);
ds_bairro_sacado_w	varchar(15);
cd_cep_sacado_w		varchar(5);
cd_suf_cep_sacado_w	varchar(3);
ds_municipio_sacado_w	varchar(15);
ds_unidade_federacao_w	varchar(2);
ds_email_sacado_w	varchar(40);
tipo_empresa_lote_w	varchar(1);
cd_pf_pj_lote_w		varchar(15);
nm_empresa_lote_w	varchar(30);
dt_geracao_lote_w	varchar(8);
nr_seq_arquivo_lote_w	varchar(10);
tipo_inscricao_w	varchar(1);
nr_titulo_w		varchar(10);
dt_vencimento_w		varchar(8);
dt_emissao_w		varchar(8);
nr_seq_arquivo_w	cobranca_escritural.nr_remessa%type;
nr_nosso_numero_w	titulo_receber.nr_nosso_numero%type;
vl_nominal_titulo_w	titulo_receber.vl_titulo%type;
vl_abatimento_w		titulo_receber.vl_abatimento%type;

C01 CURSOR FOR  -- segmento P,Q,R 
	SELECT 	substr(a.nr_nosso_numero,1,20) nr_nosso_numero, 
		substr(b.nr_titulo,1,10) nr_titulo, 
		substr(to_char(a.dt_vencimento,'ddmmyyyy'),1,8) dt_vencimento, 
		substr(somente_numero(to_char(a.vl_titulo,'99999999990.00')),1,13) vl_titulo, 
		substr(to_char(a.dt_emissao,'ddmmyyyy'),1,8) dt_vencimento, 
		substr(somente_numero(to_char(a.vl_abatimento,'99999999990.00')),1,13) vl_abatimento, 
		substr(CASE WHEN coalesce(a.cd_cgc::text, '') = '' THEN '1'  ELSE '2' END ,1,1) tipo_inscricao, 
		elimina_caractere_especial(substr(CASE WHEN coalesce(a.cd_cgc::text, '') = '' THEN (	SELECT 	f.nr_cpf 										from	pessoa_fisica f 										where 	a.cd_pessoa_fisica = f.cd_pessoa_fisica)  ELSE a.cd_cgc END ,1,15)) nr_inscricao, 
		elimina_acentos(elimina_caractere_especial(substr(CASE WHEN coalesce(a.cd_cgc::text, '') = '' THEN obter_nome_pf_pj(a.cd_pessoa_fisica,null)  ELSE obter_nome_pf_pj(null,a.cd_cgc) END ,1,40)),'S') nm_pf_pj, 
		elimina_acentos(elimina_caractere_especial(substr(obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'R'),1,40)),'S') ds_endereco_sacado, 
		elimina_acentos(elimina_caractere_especial(substr(obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'B'),1,15)),'S') ds_bairro_sacado, 
		substr(obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'CEP'),1,5) cd_cep_sacado, 
		substr(obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'CEP'),6,8) cd_suf_cep_sacado, 
		elimina_acentos(elimina_caractere_especial(substr(obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'CI'),1,15)),'S') ds_municipio_sacado, 
		substr(obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'UF'),1,2) ds_unidade_federacao, 
		substr(CASE WHEN coalesce(a.cd_cgc::text, '') = '' THEN obter_email_pf(a.cd_pessoa_fisica)  ELSE (	select	d.ds_email 											from	pessoa_juridica d 											where	a.cd_cgc = d.cd_cgc) END ,1,40) ds_email_sacado 
	from 	titulo_receber a, 
		titulo_receber_cobr b, 
		cobranca_escritural c 
	where 	a.nr_titulo		= b.nr_titulo 
	and	b.nr_seq_cobranca 	= c.nr_sequencia 
	and 	b.nr_seq_cobranca 	= nr_seq_cobr_escrit_p;


BEGIN 
 
delete	from w_envio_banco 
where	nm_usuario	= nm_usuario_p;
 
/* Header Arquivo*/
 
 
select	max(substr(CASE WHEN coalesce(b.cd_cgc::text, '') = '' THEN '1'  ELSE '2' END ,1,1)) tipo_empresa, 
	max(substr(CASE WHEN coalesce(b.cd_cgc::text, '') = '' THEN (	select	x.cd_pessoa_fisica 					from	titulo_receber x, 						titulo_receber_cobr y 					where	x.nr_titulo = x.nr_titulo 					and	y.nr_seq_cobranca = a.nr_sequencia)  ELSE b.cd_cgc END ,1,14)) cd_pf_pj, 
	 
	max(substr(elimina_acentuacao(CASE WHEN coalesce(b.cd_cgc::text, '') = '' THEN  obter_nome_pf(	select	x.cd_pessoa_fisica 									from	titulo_receber x, 										titulo_receber_cobr y 									where	x.nr_titulo = x.nr_titulo 									and	y.nr_seq_cobranca = a.nr_sequencia)  ELSE obter_nome_pf_pj(null,b.cd_cgc) END ),1,30)) nm_empresa, 
	max(substr(obter_nome_banco(c.cd_banco),1,30)) nm_banco, 
	max(to_char(clock_timestamp(),'ddmmyyyy')) dt_geracao, 
	max(to_char(clock_timestamp(),'hh24mi')) hr_geracao, 
	max(lpad(substr(coalesce(a.nr_remessa,a.nr_sequencia),1,6),6,'0')) nr_seq_arquivo 
into STRICT	tipo_empresa_w, 
	cd_pf_pj_w, 
	nm_empresa_w,	 
	nm_banco_w, 
	dt_geracao_w, 
	hr_geracao_w, 
	nr_seq_arquivo_w 
FROM agencia_bancaria e, banco_estabelecimento c, estabelecimento b, cobranca_escritural a
LEFT OUTER JOIN banco_carteira d ON (a.nr_seq_carteira_cobr = d.nr_sequencia)
WHERE a.cd_estabelecimento	= b.cd_estabelecimento and a.nr_seq_conta_banco	= c.nr_sequencia  and c.cd_agencia_bancaria	= e.cd_agencia_bancaria and a.nr_sequencia		= nr_seq_cobr_escrit_p;
 
ds_conteudo_w	:=	'745' || 
			'0000' || 
			'0' || 
			rpad(' ',9,' ') || 
			rpad(coalesce(tipo_empresa_w,' '),1,' ') || 
			lpad(coalesce(cd_pf_pj_w,'0'),14,'0') || 
			rpad(' ',20,' ') || 
			rpad(' ',20,' ') || 
			rpad(coalesce(nm_empresa_w,'0'),30,' ') || 
			rpad(coalesce(nm_banco_w,'0'),30,' ') || 
			rpad(' ',10,' ') || 
			'1' || 
			lpad(coalesce(dt_geracao_w,'0'),8,'0') || 
			lpad(coalesce(hr_geracao_w,'0'),6,'0') || 
			lpad(coalesce(nr_seq_arquivo_w,'0'),6,'0') || 
			'083' || 
			'16000' || 
			rpad(' ',20,' ') || 
			rpad(' ',20,' ') || 
			rpad(' ',29,' ');
 
insert	into w_envio_banco(nr_sequencia, 
	dt_atualizacao, 
	nm_usuario, 
	dt_atualizacao_nrec, 
	nm_usuario_nrec, 
	cd_estabelecimento, 
	ds_conteudo, 
	nr_seq_apres, 
	nr_seq_apres_2) 
values (nextval('w_envio_banco_seq'), 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	cd_estabelecimento_p, 
	ds_conteudo_w, 
	1, 
	1);
 
/*Fim header arquivo*/
			 
 
/*Inicio header lote*/
 
 
select	max(substr(CASE WHEN coalesce(b.cd_cgc::text, '') = '' THEN '1'  ELSE '2' END ,1,1)) tipo_empresa, 
	max(substr(CASE WHEN coalesce(b.cd_cgc::text, '') = '' THEN (	select	x.cd_pessoa_fisica 					from	titulo_receber x, 						titulo_receber_cobr y 					where	x.nr_titulo = x.nr_titulo 					and	y.nr_seq_cobranca = a.nr_sequencia)  ELSE b.cd_cgc END ,1,15)) cd_pf_pj, 
	 
	max(substr(elimina_acentuacao(CASE WHEN coalesce(b.cd_cgc::text, '') = '' THEN  obter_nome_pf(	select	x.cd_pessoa_fisica 									from	titulo_receber x, 										titulo_receber_cobr y 									where	x.nr_titulo = x.nr_titulo 									and	y.nr_seq_cobranca = a.nr_sequencia)  ELSE obter_nome_pf_pj(null,b.cd_cgc) END ),1,30)) nm_empresa, 
	max(to_char(clock_timestamp(),'ddmmyyyy')) dt_geracao, 
	max(substr(coalesce(a.nr_remessa,a.nr_sequencia),1,6)) nr_seq_arquivo 
into STRICT	tipo_empresa_lote_w, 
	cd_pf_pj_lote_w, 
	nm_empresa_lote_w,	 
	dt_geracao_lote_w, 
	nr_seq_arquivo_lote_w 
FROM agencia_bancaria e, banco_estabelecimento c, estabelecimento b, cobranca_escritural a
LEFT OUTER JOIN banco_carteira d ON (a.nr_seq_carteira_cobr = d.nr_sequencia)
WHERE a.cd_estabelecimento	= b.cd_estabelecimento and a.nr_seq_conta_banco	= c.nr_sequencia  and c.cd_agencia_bancaria	= e.cd_agencia_bancaria and a.nr_sequencia		= nr_seq_cobr_escrit_p;
 
ds_conteudo_w 	:=	'745' || 
			lpad(coalesce(nr_lote_w,'0'),4,'0') || 
			'1' || 
			' ' || 
			'01' || 
			rpad(' ',2,' ') || 
			'041' || 
			' ' || 
			lpad(coalesce(tipo_empresa_lote_w,' '),1,' ') || 
			lpad(coalesce(cd_pf_pj_lote_w,'0'),15,'0') || 
			rpad('0',20,'0') || 
			'00000' || 
			'0' || 
			lpad('0',12,'0') || 
			' ' || 
			' ' || 
			rpad(coalesce(nm_empresa_lote_w,' '),30,' ') || 
			rpad(' ',40,' ') || --Identificação do Registro  
			rpad(' ',40,' ') || 
			lpad(coalesce(nr_seq_arquivo_lote_w,'0'),8,'0') || 
			lpad(coalesce(dt_geracao_lote_w,'9'),8,'9') || 
			lpad('0',8,'0') || 
			rpad(' ',33,' ');
			 
insert	into w_envio_banco(nr_sequencia, 
	dt_atualizacao, 
	nm_usuario, 
	dt_atualizacao_nrec, 
	nm_usuario_nrec, 
	cd_estabelecimento, 
	ds_conteudo, 
	nr_seq_apres, 
	nr_seq_apres_2) 
values (nextval('w_envio_banco_seq'), 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	cd_estabelecimento_p, 
	ds_conteudo_w, 
	2, 
	2);
 
qt_lote_arquivo_w	:= qt_lote_arquivo_w + 1;
/*Fim do header lote*/
 
 
/* Inicio dos Segmentos P,Q,R */
 
 
open	C01;
loop 
fetch	C01 into 
	nr_nosso_numero_w, 
	nr_titulo_w, 
	dt_vencimento_w, 
	vl_nominal_titulo_w, 
	dt_emissao_w, 
	vl_abatimento_w, 
	tipo_inscricao_w, 
	nr_inscricao_w, 
	nm_pf_pj_w, 
	ds_endereco_sacado_w, 
	ds_bairro_sacado_w, 
	cd_cep_sacado_w, 
	cd_suf_cep_sacado_w, 
	ds_municipio_sacado_w, 
	ds_unidade_federacao_w, 
	ds_email_sacado_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	nr_seq_registro_w	:= nr_seq_registro_w + 1;
	qt_titulos_lote_w	:= qt_titulos_lote_w + 1;
	 
	/*P*/
 
	nr_lote_w_w		:= coalesce(nr_lote_w_w,0) + 1;
	nr_lote_w		:= lpad(nr_lote_w_w,4,'0');
	ds_conteudo_w		:= null;
	 
	ds_conteudo_w 	:=	'745' || 
				lpad(coalesce(nr_lote_w,'0'),4,'0') || 
				'3' || 
				lpad(coalesce(nr_seq_registro_w,'0'),5,'0') || 
				'P' || 
				' ' || 
				'01' || -- Código de Movimento Remessa 
				lpad('0',5,'0') || 
				' ' || 
				lpad('0',12,'0') || 
				' ' || 
				' ' || 
				lpad(coalesce(nr_nosso_numero_w,'0'),20,'0') || 
				'1' || -- carteira simples 
				'1' || --Com Cadastramento (Cobrança Registrada) 
				' ' || 
				'1' || --  Banco Emite 
				'1' || --Banco Distribuição 
				rpad(coalesce(nr_titulo_w,' '),10,' ') || 
				rpad(' ',5,' ') || 
				lpad(coalesce(dt_vencimento_w,'0'),8,'0') || 
				lpad('0',2,'0') || 
				lpad(coalesce(vl_nominal_titulo_w,'0'),13,'0') || 
				lpad('0',5,'0') || 
				lpad('0',1,'0') || 
				'03' || 
				'A' || 
				lpad(coalesce(dt_emissao_w,'0'),8,'0') || 
				'1' || 
				lpad('0',8,'0') || 
				lpad('0',2,'0') || 
				lpad('0',13,'0') || 
				'1' || 
				lpad('0',8,'0') || 
				lpad('0',2,'0') || 
				lpad('0',13,'0') || 
				lpad('0',2,'0') || 
				lpad('0',13,'0') || 
				lpad('0',2,'0') || 
				lpad(coalesce(vl_abatimento_w,'0'),13,'0') || 
				rpad(' ',25,' ') || 
				'1' || 
				'02' || 
				'1' || 
				rpad(' ',3,' ') || 
				'09' || 
				lpad('0',10,'0') || 
				rpad(' ',1,' ');
	 
	insert	into w_envio_banco(nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		cd_estabelecimento, 
		ds_conteudo, 
		nr_seq_apres, 
		nr_seq_apres_2) 
	values (nextval('w_envio_banco_seq'), 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_estabelecimento_p, 
		ds_conteudo_w, 
		3, 
		nr_seq_registro_w);
	 
	/*Q*/
 
	nr_lote_w_w		:= coalesce(nr_lote_w_w,0) + 1;
	nr_lote_w		:= lpad(nr_lote_w_w,4,'0');
	ds_conteudo_w		:= null;
	 
	ds_conteudo_w	:=	'745' || 
				lpad(coalesce(nr_lote_w,'0'),4,'0')|| 
				'3' || 
				lpad(coalesce(nr_seq_registro_w,'0'),5,'0') || 
				'Q' || 
				' ' || 
				'01' || --Código de Movimento Remessa 
				rpad(coalesce(tipo_inscricao_w,' '),1,' ') || 
				lpad(coalesce(nr_inscricao_w,'0'),15,'0') || 
				rpad(coalesce(nm_pf_pj_w,' '),40,' ') || 
				rpad(coalesce(ds_endereco_sacado_w,' '),40,' ') || 
				rpad(coalesce(ds_bairro_sacado_w,' '),15,' ') || 
				lpad(coalesce(cd_cep_sacado_w,'0'),5,'0') || 
				lpad(coalesce(cd_suf_cep_sacado_w,'0'),3,'0') || 
				rpad(coalesce(ds_municipio_sacado_w,' '),15,' ') || 
				rpad(coalesce(ds_unidade_federacao_w,' '),2,' ') || 
				'0' || 
				lpad('0',15,'0') || 
				rpad(coalesce(nm_pf_pj_w,' '),40,' ') || -- sacador avalista 
				lpad('0',3,'0') || 
				lpad('0',3,'0') || 
				lpad('0',3,'0') || 
				rpad(' ',16,' ') || 
				lpad('0',8,'0');
				 
	insert	into w_envio_banco(nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		cd_estabelecimento, 
		ds_conteudo, 
		nr_seq_apres, 
		nr_seq_apres_2) 
	values (nextval('w_envio_banco_seq'), 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_estabelecimento_p, 
		ds_conteudo_w, 
		3, 
		nr_seq_registro_w);
	 
	/*R*/
 
	nr_lote_w_w		:= coalesce(nr_lote_w_w,0) + 1;
	nr_lote_w		:= lpad(nr_lote_w_w,4,'0');
	ds_conteudo_w		:= null;
	 
	ds_conteudo_w	:=	'745' || 
				lpad(coalesce(nr_lote_w,'0'),4,'0') || 
				'3' || 
				lpad(coalesce(nr_seq_registro_w,'0'),5,'0') || 
				'R' || 
				' ' || 
				'01' || --Código de Movimento Remessa 
				'01' || --Código do Desconto 2 
				lpad('0',8,'0') || 
				lpad('0',2,'0') || 
				lpad('0',13,'0') || 
				'01' || --Código do Desconto 3 
				lpad('0',8,'0') || 
				lpad('0',2,'0') || 
				lpad('0',13,'0') || 
				' ' || 
				lpad('0',8,'0') || 
				lpad('0',2,'0') || 
				lpad('0',13,'0') || 
				rpad(' ',10,' ') || 
				rpad(' ',40,' ') || 
				rpad(coalesce(ds_email_sacado_w,' '),40,' ') || 
				rpad(' ',20,' ') || 
				lpad('0',8,'0') || 
				lpad('0',3,'0') || 
				lpad('0',5,'0') || 
				'0' || 
				lpad('0',12,'0') || 
				'0' || 
				'0' || 
				'0' || 
				rpad(' ',9,' ');
		 
	insert	into w_envio_banco(nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		cd_estabelecimento, 
		ds_conteudo, 
		nr_seq_apres, 
		nr_seq_apres_2) 
	values (nextval('w_envio_banco_seq'), 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_estabelecimento_p, 
		ds_conteudo_w, 
		3, 
		nr_seq_registro_w);
	 
	end;
end	loop;
close	C01;		
/* Fim dos Segmentos P,Q,R*/
 
 
/*Inicio do trailer lote*/
 
 
ds_conteudo_w 	:=	'745' || 
			'9999' || 
			'5' || 
			rpad(' ',9,' ') || 
			lpad(coalesce(qt_titulos_lote_w,'0'), 6, '0') || 
			lpad(coalesce(qt_titulos_lote_w,'0'), 6, '0') || 
			rpad('0',17,'0') || 
			rpad('0',6,'0') || 
			rpad('0',17,'0') || 
			rpad('0',6,'0') || 
			rpad('0',17,'0') || 
			rpad('0',6,'0') || 
			rpad('0',17,'0') || 
			rpad('0',8,'0') || 
			rpad('0',117,'0');
			 
insert	into w_envio_banco(nr_sequencia, 
	dt_atualizacao, 
	nm_usuario, 
	dt_atualizacao_nrec, 
	nm_usuario_nrec, 
	cd_estabelecimento, 
	ds_conteudo, 
	nr_seq_apres, 
	nr_seq_apres_2) 
values (nextval('w_envio_banco_seq'), 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	cd_estabelecimento_p, 
	ds_conteudo_w, 
	5, 
	5);
 
/*Fim do trailer lote*/
 
 
/*Inicio do trailer arquivo*/
 
 
ds_conteudo_w	:=	'745' || 
			'9999' || 
			'9' || 
			rpad(' ',9,' ') || 
			lpad(coalesce(qt_titulos_lote_w,'0'), 6, '0') || 
			lpad(coalesce(qt_titulos_lote_w,'0'), 6, '0') || 
			lpad('0', 6, '0') || 
			rpad(' ', 205, ' ');
 
insert	into w_envio_banco(nr_sequencia, 
	dt_atualizacao, 
	nm_usuario, 
	dt_atualizacao_nrec, 
	nm_usuario_nrec, 
	cd_estabelecimento, 
	ds_conteudo, 
	nr_seq_apres, 
	nr_seq_apres_2) 
values (nextval('w_envio_banco_seq'), 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	cd_estabelecimento_p, 
	ds_conteudo_w, 
	4, 
	4);
 
/*Fim do trailer arquivo*/
 
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cobr_citibank_240 ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

