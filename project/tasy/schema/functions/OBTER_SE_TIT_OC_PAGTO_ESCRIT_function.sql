-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_tit_oc_pagto_escrit ( nr_ordem_compra_p bigint) RETURNS varchar AS $body$
DECLARE


nr_titulo_w		titulo_pagar.nr_titulo%Type;
ds_retorno_w		varchar(255) := '';

c01 CURSOR FOR
SELECT	nr_titulo
from	titulo_pagar
where	nr_ordem_compra = nr_ordem_compra_p;


BEGIN
open C01;
loop
fetch C01 into
	nr_titulo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	trim(both coalesce(trim(both obter_se_titulo_vinculado(nr_titulo_w)),pls_obter_camara_titulo(nr_titulo_w,null)))
	into STRICT	ds_retorno_w
	;

	if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
		exit;
	end if;

	end;
end loop;
close C01;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_tit_oc_pagto_escrit ( nr_ordem_compra_p bigint) FROM PUBLIC;
