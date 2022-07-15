-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cobr_deb_sant_150 ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ds_conteudo_w			varchar(150);
qt_registros_w			bigint	:= 0;
nr_seq_registro_w			bigint	:= 0;

/* Registro "A" - Header */
 
nr_remessa_w			bigint;
cd_convenio_banco_w		varchar(20);
nm_empresa_w			varchar(20);
dt_geracao_w			varchar(8);
nr_seq_arquivo_w			varchar(6);
nm_banco_w			varchar(20);
cd_convenio_w			varchar(20);
ds_conta_comprom_w		varchar(16);
cd_banco_w			varchar(3);

/* Registro "E" - Débito em conta corrente */
 
cd_agencia_bancaria_w		varchar(4);
dt_vencimento_w			varchar(8);
vl_titulo_w			double precision;
ds_uso_empresa_w			varchar(60);
ds_ident_cliente_emp_w		varchar(25);
ds_ident_cliente_banco_w		varchar(14);

/* Registro "Z" - Trailler */
 
vl_total_w			double precision	:= 0;
nr_seq_apres_w			bigint	:= 0;

/* Brancos */
 
ds_brancos_52_w			varchar(52);
ds_brancos_126_w			varchar(126);
ds_brancos_20_w			varchar(20);

/* consultar aqui os atributos provenientes dos títulos */
 
c01 CURSOR FOR 
	SELECT	lpad(substr(CASE WHEN coalesce(g.cd_agencia_bancaria::text, '') = '' THEN f.cd_agencia_bancaria  ELSE g.cd_agencia_bancaria END ,1,4),4,'0') cd_agencia_bancaria, 
		substr(to_char(b.dt_vencimento,'YYYYMMDD'),1,8) dt_vencimento, 
		b.vl_titulo vl_titulo, 
		rpad(b.nr_titulo,60,' ') ds_uso_empresa, 
		lpad(substr(cd_cgc_cpf,1,14),25,' ') ds_ident_cliente_emp,  
		lpad(coalesce(coalesce(substr(c.nr_conta,1,8) || substr(c.ie_digito_conta,1,1), 
			substr(pls_obter_dados_pagador_fin(d.nr_seq_pagador,'C'),1,8) || substr(pls_obter_dados_pagador_fin(d.nr_seq_pagador,'DC'),1,1)),' '),14,' ')			 
	FROM banco_estabelecimento x, titulo_receber_cobr c, cobranca_escritural a, titulo_receber_v b
LEFT OUTER JOIN pls_mensalidade d ON (b.nr_seq_mensalidade = d.nr_sequencia)
LEFT OUTER JOIN banco_carteira e ON (b.nr_seq_carteira_cobr = e.nr_sequencia)
LEFT OUTER JOIN pls_contrato_pagador f ON (d.nr_seq_pagador = f.nr_sequencia)
LEFT OUTER JOIN pls_contrato_pagador_fin g ON (d.nr_seq_pagador = g.nr_seq_pagador)
WHERE a.nr_sequencia		= c.nr_seq_cobranca and c.nr_titulo		= b.nr_titulo and a.nr_seq_conta_banco	= x.nr_sequencia     and a.nr_sequencia		= nr_seq_cobr_escrit_p;


BEGIN 
 
delete	from w_envio_banco 
where	nm_usuario	= nm_usuario_p;
 
select	lpad(' ',52,' '), 
	lpad(' ',20,' '), 
	lpad(' ',126,' ') 
into STRICT	ds_brancos_52_w, 
	ds_brancos_20_w, 
	ds_brancos_126_w
;
 
select	coalesce(max(a.nr_remessa),max(a.nr_sequencia)), 
	rpad(coalesce(substr(b.cd_convenio_banco,1,20),' '),20,' ') 
into STRICT	nr_remessa_w, 
	cd_convenio_banco_w 
from	banco_estabelecimento b, 
	cobranca_escritural a 
where	a.nr_seq_conta_banco	= b.nr_sequencia 
and	a.nr_sequencia		= nr_seq_cobr_escrit_p 
group by b.cd_convenio_banco;
 
/* Registro "A" - Header */
 
select	rpad(upper(elimina_acentuacao(substr(obter_nome_pf_pj(null, b.cd_cgc),1,20))),20,' '), 
	to_char(clock_timestamp(),'YYYYMMDD'), 
	lpad(to_char(a.nr_sequencia),6,'0'), 
	rpad(substr(obter_nome_banco(a.cd_banco),1,20),20,' ') nm_banco, 
	coalesce(rpad(substr(c.cd_conv_banco_deb,1,20),20,' '),' ') cd_convenio, 
	substr(c.cd_agencia_bancaria,1,4) || ' ' || substr(c.cd_conta,1,8) || substr(c.ie_digito_conta,1,1), 
	lpad(substr(a.cd_banco,1,3),3,'0') cd_banco 
into STRICT	nm_empresa_w, 
	dt_geracao_w, 
	nr_seq_arquivo_w, 
	nm_banco_w, 
	cd_convenio_w, 
	ds_conta_comprom_w, 
	cd_banco_w 
from	estabelecimento		b, 
	cobranca_escritural	a, 
	banco_estabelecimento	c 
where	a.cd_estabelecimento	= b.cd_estabelecimento 
and	a.nr_seq_conta_banco	= c.nr_sequencia 
and	a.nr_sequencia		= nr_seq_cobr_escrit_p;
 
ds_conteudo_w	:= 	'A'|| '1' || cd_convenio_w || upper(nm_empresa_w) || cd_banco_w || upper(nm_banco_w) || dt_geracao_w || 
			lpad(nr_seq_arquivo_w,6,'0') || '04' ||	rpad('DEBITO AUTOMATICO',17,' ') || ds_brancos_52_w;
			 
qt_registros_w	:= coalesce(qt_registros_w,0) + 1;
 
insert	into w_envio_banco(nr_sequencia, 
	dt_atualizacao, 
	nm_usuario, 
	dt_atualizacao_nrec, 
	nm_usuario_nrec, 
	cd_estabelecimento, 
	ds_conteudo, 
	nr_seq_apres) 
values (nextval('w_envio_banco_seq'), 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	cd_estabelecimento_p, 
	ds_conteudo_w, 
	1);
 
open	c01;
loop 
fetch	c01 into 
	cd_agencia_bancaria_w, 
	dt_vencimento_w, 
	vl_titulo_w, 
	ds_uso_empresa_w, 
	ds_ident_cliente_emp_w, 
	ds_ident_cliente_banco_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	/* Registro "E" - Débito em conta corrente */
 
	 
	nr_seq_apres_w	:= nr_seq_apres_w + 1;
	qt_registros_w	:= qt_registros_w + 1;
	vl_total_w	:= vl_total_w + vl_titulo_w;
	 
	ds_conteudo_w	:= 	'E' || ds_ident_cliente_emp_w || cd_agencia_bancaria_w || lpad(ds_ident_cliente_banco_w,14,'0') || 
				dt_vencimento_w || lpad(replace(to_char(vl_titulo_w, 'fm00000000000.00'),'.',''),15,'0') || '03' || 
				ds_uso_empresa_w || ds_brancos_20_w ||'0';
 
	insert	into w_envio_banco(nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		cd_estabelecimento, 
		ds_conteudo, 
		nr_seq_apres) 
	values (nextval('w_envio_banco_seq'), 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_estabelecimento_p, 
		ds_conteudo_w, 
		nr_seq_apres_w);
 
	end;				
end loop;
close C01;
 
--qt_registros_w	:= nvl(qt_registros_w,0) + 1; 
 
/* Registro "Z" - Trailler */
 
select	nextval('w_envio_banco_seq') 
into STRICT	nr_seq_registro_w
;
 
nr_seq_apres_w	:= nr_seq_apres_w + 1;
qt_registros_w	:= qt_registros_w + 1;
 
ds_conteudo_w	:= 	'Z' || lpad(qt_registros_w,6,'0') || lpad(replace(to_char(vl_total_w, 'fm00000000000.00'),'.',''),17,'0') || 
			ds_brancos_126_w;
 
insert into w_envio_banco(nr_sequencia, 
	dt_atualizacao, 
	nm_usuario, 
	dt_atualizacao_nrec, 
	nm_usuario_nrec, 
	cd_estabelecimento, 
	ds_conteudo, 
	nr_seq_apres) 
values (nextval('w_envio_banco_seq'), 
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
-- REVOKE ALL ON PROCEDURE gerar_cobr_deb_sant_150 ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

