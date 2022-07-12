-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_titulos_protocolo (nr_seq_protocolo_p bigint) RETURNS varchar AS $body$
DECLARE


ds_titulos_w	varchar(1000)	:= null;
nr_titulo_w	bigint;

c01 CURSOR FOR
SELECT	a.nr_titulo
from	titulo_pagar a,
	pls_prot_conta_titulo b
where	b.nr_sequencia	= a.nr_seq_prot_conta
and	b.nr_seq_protocolo = nr_seq_protocolo_p;

BEGIN

open c01;
loop
fetch c01 into
	nr_titulo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	if (coalesce(ds_titulos_w::text, '') = '') then
		ds_titulos_w	:= nr_titulo_w;
	else
		ds_titulos_w	:= ds_titulos_w || ',' || nr_titulo_w;
	end if;
end loop;
close c01;

return	ds_titulos_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_titulos_protocolo (nr_seq_protocolo_p bigint) FROM PUBLIC;
