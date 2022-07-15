-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cobr_caixa_febra_150_v04 ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

/*	Versão 04 
	Data: 29/07/2011	*/
 
 
/* Geral */
 
ds_conteudo_w			varchar(150);
nr_seq_registro_w		bigint	:= 0;
nr_seq_apres_w			bigint	:= 0;
qt_registros_w			bigint	:= 0;

/* Header A*/
 
nm_empresa_w			varchar(20);
dt_geracao_w			varchar(8);
nr_seq_arquivo_w		varchar(6);
nm_banco_w			varchar(20);
cd_convenio_w			varchar(20);
ds_conta_comprom_w		varchar(16);

/* Transações C - D - E - J */
 
cd_agencia_bancaria_w		varchar(4);
ds_ocorrencia_1_w		varchar(40);
ds_ocorrencia_2_w		varchar(40);
ds_ocorrencia_w			varchar(60);
dt_vencimento_w			varchar(8);
vl_titulo_w			varchar(15);
cd_moeda_w			varchar(2);
ds_mensagen_w			varchar(26);
ds_uso_empresa_w		varchar(60);
ds_ident_cliente_emp_w		varchar(25);
ds_ident_cliente_emp_atual_w	varchar(25);
ds_ident_cliente_banco_w	varchar(14);

/* Brancos */
 
ds_brancos_27_w			varchar(27);
ds_brancos_119_w		varchar(119);
ds_brancos_19_w			varchar(19);
ds_brancos_8_w			varchar(8);
ds_brancos_1_w			varchar(1);
ds_brancos_14_w			varchar(14);

C01 CURSOR FOR 
	SELECT	lpad(substr(x.cd_agencia_bancaria,1,4),4,'0') cd_agencia_bancaria, 
		lpad(' ',40,' ') ds_ocorrencia_1, 
		lpad(' ',40,' ') ds_ocorrencia_2, 
		lpad(' ',60,' ') ds_ocorrencia, 
		substr(to_char(b.dt_vencimento,'YYYYMMDD'),1,8) dt_vencimento, 
		lpad(replace(to_char(b.vl_titulo, 'fm00000000000.00'),'.',''),15,'0') vl_titulo, 
		rpad(b.cd_moeda,2,' ') cd_moeda, 
		lpad(' ',60,' ') ds_uso_empresa, 
		lpad(' ',26,' ') ds_mensagen, 
		lpad(' ',25,' ') ds_ident_cliente_emp, /* identificacao do cliente na empresa */
 
		lpad(' ',25,' ') ds_ident_cliente_emp_atual, /* identificacao do cliente na empresa atual */
 
		lpad(coalesce( ' ' || substr(pls_obter_dados_pagador_fin(d.nr_seq_pagador,'C'),1,8) || 
			substr(pls_obter_dados_pagador_fin(d.nr_seq_pagador,'DC'),1,1) || lpad(' ',2,' '),' '),14,' ') /* falta o código da operação da conta */
 
	FROM banco_estabelecimento x, titulo_receber_cobr c, cobranca_escritural a, titulo_receber_v b
LEFT OUTER JOIN pls_mensalidade d ON (b.nr_seq_mensalidade = d.nr_sequencia)
LEFT OUTER JOIN banco_carteira e ON (b.nr_seq_carteira_cobr = e.nr_sequencia)
LEFT OUTER JOIN pls_contrato_pagador f ON (d.nr_seq_pagador = f.nr_sequencia)
WHERE a.nr_sequencia		= c.nr_seq_cobranca and c.nr_titulo		= b.nr_titulo and a.nr_seq_conta_banco	= x.nr_sequencia    and a.nr_sequencia		= nr_seq_cobr_escrit_p;


BEGIN 
delete from w_envio_banco where nm_usuario = nm_usuario_p;
 
select	lpad(' ',27,' '), 
	lpad(' ',1,' '), 
	lpad(' ',19,' '), 
	lpad(' ',14,' '), 
	lpad(' ',8,' '), 
	lpad(' ',119,' ') 
into STRICT	ds_brancos_27_w, 
	ds_brancos_1_w, 
	ds_brancos_19_w, 
	ds_brancos_14_w, 
	ds_brancos_8_w, 
	ds_brancos_119_w
;
 
/* Header */
 
select	rpad(upper(elimina_acentuacao(substr(obter_nome_pf_pj(null, b.cd_cgc),1,20))),20,' '), 
	to_char(a.dt_remessa_retorno,'YYYYMMDD'), 
	lpad(to_char(a.nr_sequencia),6,'0'), 
	rpad(substr(obter_nome_banco(a.cd_banco),1,20),20,' ') nm_banco, 
	lpad(coalesce(substr(c.cd_convenio_banco,1,20),'0'),20,'0') cd_convenio,   /* precisa verificar */
 
	substr(c.cd_agencia_bancaria,1,4) || ' ' || substr(c.cd_conta,1,8) || substr(c.ie_digito_conta,1,1) /* falta o código da operação da conta */
 
into STRICT	nm_empresa_w, 
	dt_geracao_w, 
	nr_seq_arquivo_w, 
	nm_banco_w, 
	cd_convenio_w, 
	ds_conta_comprom_w 
from	estabelecimento		b, 
	cobranca_escritural	a, 
	banco_estabelecimento	c 
where	a.cd_estabelecimento	= b.cd_estabelecimento 
and	a.nr_seq_conta_banco	= c.nr_sequencia 
and	a.nr_sequencia		= nr_seq_cobr_escrit_p;
 
ds_conteudo_w	:= 	'A'|| '1' || cd_convenio_w || nm_empresa_w || '104' || nm_banco_w || dt_geracao_w || lpad(nr_seq_arquivo_w,6,'0') || '04' || 
			rpad('DEB AUTOMAT',17,' ') || lpad(ds_conta_comprom_w,16,'0') || 'T' || 'T' || ds_brancos_27_w || '000000' || ds_brancos_1_w;
									/* quando valido alterar para 'P' */
 
									 
insert into w_envio_banco(	nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			cd_estabelecimento, 
			ds_conteudo, 
			nr_seq_apres) 
	values (	nextval('w_envio_banco_seq'), 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			cd_estabelecimento_p, 
			ds_conteudo_w, 
			1);
nr_seq_apres_w	:= nr_seq_apres_w + 1;
/* Fim Header */
 
 
/* Transação */
 
 
open C01;
loop 
fetch C01 into	 
	cd_agencia_bancaria_w, 
	ds_ocorrencia_1_w, 
	ds_ocorrencia_2_w, 
	ds_ocorrencia_w, 
	dt_vencimento_w, 
	vl_titulo_w, 
	cd_moeda_w, 
	ds_uso_empresa_w, 
	ds_mensagen_w, 
	ds_ident_cliente_emp_w, 
	ds_ident_cliente_emp_atual_w, 
	ds_ident_cliente_banco_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	nr_seq_apres_w	:= nr_seq_apres_w + 1;
	qt_registros_w	:= qt_registros_w + 1;
	 
	/* TIPO C */
 
	ds_conteudo_w	:= 	'C' || ds_ident_cliente_emp_w || cd_agencia_bancaria_w || ds_ident_cliente_banco_w || ds_ocorrencia_1_w || 
				ds_ocorrencia_2_w || ds_brancos_19_w || lpad(nr_seq_apres_w,6,'0') || '2';
	 
	insert into w_envio_banco(	nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				cd_estabelecimento, 
				ds_conteudo, 
				nr_seq_apres) 
		values (	nextval('w_envio_banco_seq'), 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				cd_estabelecimento_p, 
				ds_conteudo_w, 
				nr_seq_apres_w);
	/* FIM TIPO C */
 
	 
	nr_seq_apres_w	:= nr_seq_apres_w + 1;
	qt_registros_w	:= qt_registros_w + 1;
	 
	/* TIPO D */
 
	ds_conteudo_w	:= 	'D' || ds_ident_cliente_emp_w || cd_agencia_bancaria_w || ds_ident_cliente_banco_w || ds_ident_cliente_emp_atual_w || 
				ds_ocorrencia_w || ds_brancos_14_w || lpad(nr_seq_apres_w,6,'0') || '0';
	 
	insert into w_envio_banco(	nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				cd_estabelecimento, 
				ds_conteudo, 
				nr_seq_apres) 
		values (	nextval('w_envio_banco_seq'), 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				cd_estabelecimento_p, 
				ds_conteudo_w, 
				nr_seq_apres_w);
	/* FIM TIPO D */
 
	 
	nr_seq_apres_w	:= nr_seq_apres_w + 1;
	qt_registros_w	:= qt_registros_w + 1;
	 
	/* TIPO E */
 
	ds_conteudo_w	:= 	'E' || ds_ident_cliente_emp_w || cd_agencia_bancaria_w || ds_ident_cliente_banco_w || dt_vencimento_w || 
				vl_titulo_w || cd_moeda_w || ds_uso_empresa_w || lpad(nr_seq_apres_w,6,'0') || ds_brancos_8_w || 
				lpad(nr_seq_apres_w,6,'0') ||'0';
	 
	insert into w_envio_banco(	nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				cd_estabelecimento, 
				ds_conteudo, 
				nr_seq_apres) 
		values (	nextval('w_envio_banco_seq'), 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				cd_estabelecimento_p, 
				ds_conteudo_w, 
				nr_seq_apres_w);
	/* FIM TIPO E */
 
	 
	nr_seq_apres_w	:= nr_seq_apres_w + 1;
	qt_registros_w	:= qt_registros_w + 1;
	 
	/* TIPO J */
 
	ds_conteudo_w	:= 	'J' || ds_mensagen_w || lpad('0',123,'0');
	 
	insert into w_envio_banco(	nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				cd_estabelecimento, 
				ds_conteudo, 
				nr_seq_apres) 
		values (	nextval('w_envio_banco_seq'), 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				cd_estabelecimento_p, 
				ds_conteudo_w, 
				nr_seq_apres_w);
	/* FIM TIPO J */
 
	end;				
end loop;
close C01;
/* Fim Transação */
 
 
/* Trailler */
 
select	nextval('w_envio_banco_seq') 
into STRICT	nr_seq_registro_w
;
 
nr_seq_apres_w	:= nr_seq_apres_w + 1;
 
ds_conteudo_w	:= 	'Z' || lpad(nr_seq_apres_w,6,'0') || lpad(qt_registros_w,17,'0') || ds_brancos_119_w || substr(nr_seq_registro_w,1,6) || 
			ds_brancos_1_w;	
 
insert into w_envio_banco(	nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			cd_estabelecimento, 
			ds_conteudo, 
			nr_seq_apres) 
	values (	nextval('w_envio_banco_seq'), 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			cd_estabelecimento_p, 
			ds_conteudo_w, 
			nr_seq_apres_w);
/* Fim Trailler*/
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cobr_caixa_febra_150_v04 ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

