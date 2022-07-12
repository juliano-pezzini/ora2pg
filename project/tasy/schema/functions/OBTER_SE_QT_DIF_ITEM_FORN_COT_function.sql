-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_qt_dif_item_forn_cot ( nr_cot_compra_p bigint, nr_item_cot_compra_p bigint) RETURNS varchar AS $body$
DECLARE


qt_registros_w		bigint;
ie_diferentes_w		varchar(1) := 'N';


BEGIN

select	count(distinct qt_material)
into STRICT	qt_registros_w
from	cot_compra_forn_item
where	nr_cot_compra = nr_cot_compra_p
and	nr_item_cot_compra = nr_item_cot_compra_p;

if (qt_registros_w > 1) then
	ie_diferentes_w := 'S';
end if;

return	ie_diferentes_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_qt_dif_item_forn_cot ( nr_cot_compra_p bigint, nr_item_cot_compra_p bigint) FROM PUBLIC;
