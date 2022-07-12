-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_existe_cotacao_solic ( nr_solic_compra_p bigint) RETURNS varchar AS $body$
DECLARE


ie_existe_w			varchar(1) := 'N';
nr_solic_compra_w			bigint;

c01 CURSOR FOR
SELECT	nr_solic_compra
from	cot_compra_item
where	nr_solic_compra = nr_solic_compra_p

union

select	nr_solic_compra
from	cot_compra_solic_agrup
where	nr_solic_compra = nr_solic_compra_p;


BEGIN

open C01;
loop
fetch C01 into
	nr_solic_compra_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	nr_solic_compra_w := nr_solic_compra_w;

	if (nr_solic_compra_w > 0) then
		ie_existe_w := 'S';
		exit;
	end if;

	end;
end loop;
close C01;

return	ie_existe_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_existe_cotacao_solic ( nr_solic_compra_p bigint) FROM PUBLIC;
