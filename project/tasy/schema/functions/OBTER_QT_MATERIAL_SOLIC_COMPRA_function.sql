-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_material_solic_compra ( nr_solic_compra_p bigint, cd_material_p bigint) RETURNS bigint AS $body$
DECLARE


qt_material_w			double precision;


BEGIN

select	coalesce(sum(qt_material),0)
into STRICT	qt_material_w
from	solic_compra_item
where	nr_solic_compra = nr_solic_compra_p
and	cd_material = cd_material_p;

return	qt_material_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_material_solic_compra ( nr_solic_compra_p bigint, cd_material_p bigint) FROM PUBLIC;
