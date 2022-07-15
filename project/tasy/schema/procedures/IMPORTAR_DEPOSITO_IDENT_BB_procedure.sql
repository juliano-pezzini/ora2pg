-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE importar_deposito_ident_bb ( nr_seq_lote_dep_ident_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_deposito_w		timestamp;
dt_credito_w		timestamp;
vl_deposito_w		double precision;
vl_deposito_cheque_w	double precision;
vl_deposito_especie_w	double precision;
nr_sequencia_w		bigint;
nr_seq_lote_w		integer;
nr_seq_lote_ww		integer;
ds_dt_deposito_w		varchar(10);
ds_dt_credito_w		varchar(10);
cd_identificacao_w		varchar(15);
cd_agencia_w		varchar(4);
dt_geracao_arquivo_w	timestamp;
ds_dt_geracao_arquivo_w	varchar(10);
cd_agencia_header_w	varchar(4);
cd_conta_header_w	varchar(10);
cd_banco_lote_w		smallint;
cd_agencia_lote_w		varchar(10);
cd_conta_lote_w		varchar(10);

c01 CURSOR FOR
	SELECT	substr(ds_string,2,8) ds_dt_deposito,
		substr(ds_string,153,8) ds_dt_credito,
		(substr(ds_string,55,10) || ',' || substr(ds_string,65,2))::numeric   vl_deposito_especie,
		(substr(ds_string,97,15) || ',' || substr(ds_string,112,2))::numeric   vl_deposito_cheque,
		(substr(ds_string,80,15) || ',' || substr(ds_string,95,2))::numeric   vl_deposito,
		(substr(ds_string,10,6))::numeric  nr_seq_lote,
		(substr(ds_string,118,17))::numeric  cd_identificacao,
		substr(ds_string,114,4) cd_agencia
	from	w_retorno_banco
	where	nr_seq_lote_dep_ident = nr_seq_lote_dep_ident_p
	and	substr(ds_string,1,1) = '1'
	and	nm_usuario = nm_usuario_p;


BEGIN

delete	FROM lote_ret_dep_ident_item
where	nr_seq_lote = nr_seq_lote_dep_ident_p;

/* Obter informações do Header */

select	max(substr(ds_string,2,8)) ds_dt_geracao,
	max(substr(ds_string,19,4)) cd_agencia,
	max(substr(ds_string,23,10)) cd_conta
into STRICT	ds_dt_geracao_arquivo_w,
	cd_agencia_header_w,
	cd_conta_header_w
from	w_retorno_banco a
where	a.nr_seq_lote_dep_ident	= nr_seq_lote_dep_ident_p
and	substr(ds_string,1,1) = '0';

if (length(ds_dt_geracao_arquivo_w) = 8) then
	dt_geracao_arquivo_w	:= to_date(ds_dt_geracao_arquivo_w,'DDMMYYYY');
end if;

/* Obter dados bancários do lote */

select	max(b.cd_banco),
	max(b.cd_agencia_bancaria),
	max(b.cd_conta)
into STRICT	cd_banco_lote_w,
	cd_agencia_lote_w,
	cd_conta_lote_w
from	banco_estabelecimento b,
	lote_ret_deposito_ident a
where	a.nr_seq_conta_banco	= b.nr_sequencia
and	a.nr_sequencia		= nr_seq_lote_dep_ident_p;


/* Consistências */

open c01;
loop
fetch c01 into
	ds_dt_deposito_w,
	ds_dt_credito_w,
	vl_deposito_especie_w,
	vl_deposito_cheque_w,
	vl_deposito_w,
	nr_seq_lote_w,
	cd_identificacao_w,
	cd_agencia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	nextval('lote_ret_dep_ident_item_seq')
	into STRICT	nr_sequencia_w
	;

	dt_deposito_w	:= to_date(ds_dt_deposito_w,'YYYYMMDD');
	dt_credito_w	:= to_date(ds_dt_credito_w,'YYYYMMDD');

	insert into lote_ret_dep_ident_item(nr_sequencia,
				dt_deposito,
				vl_deposito,
				vl_deposito_cheque,
				nm_usuario,
				dt_atualizacao,
				nr_seq_lote,
				vl_deposito_especie,
				cd_identificacao,
				dt_credito,
				cd_agencia_recebedora)
			values (nr_sequencia_w,
				dt_deposito_w,
				vl_deposito_w,
				vl_deposito_cheque_w,
				nm_usuario_p,
				clock_timestamp(),
				nr_seq_lote_dep_ident_p,
				vl_deposito_especie_w,
				cd_identificacao_w,
				dt_credito_w,
				cd_agencia_w);
	end;

end loop;

/* Atualizar data de geração do arquivo */

update	lote_ret_deposito_ident
set	dt_geracao_arquivo	= dt_geracao_arquivo_w,
	dt_importacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp()
where	nr_sequencia		= nr_seq_lote_dep_ident_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE importar_deposito_ident_bb ( nr_seq_lote_dep_ident_p bigint, nm_usuario_p text) FROM PUBLIC;

