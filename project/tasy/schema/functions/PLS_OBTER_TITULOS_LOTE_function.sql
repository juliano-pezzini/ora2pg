-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_titulos_lote ( nr_seq_lote_p bigint) RETURNS varchar AS $body$
DECLARE


ds_titulos_w			varchar(1000)	:= null;
nr_titulo_w			bigint;

c01 CURSOR FOR
	SELECT	b.nr_titulo
	from	titulo_pagar 		b,
		pls_lote_protocolo	a
	where	a.nr_sequencia		= b.nr_seq_lote_res_pls
	and	a.nr_sequencia		= nr_seq_lote_p
	and	b.ie_situacao		<> 'C';


BEGIN

open C01;
loop
fetch C01 into
	nr_titulo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (coalesce(ds_titulos_w::text, '') = '') then
		ds_titulos_w	:= nr_titulo_w;
	else
		ds_titulos_w	:= ds_titulos_w || ',' || nr_titulo_w;
	end if;
	end;
end loop;
close C01;

return	ds_titulos_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_titulos_lote ( nr_seq_lote_p bigint) FROM PUBLIC;

