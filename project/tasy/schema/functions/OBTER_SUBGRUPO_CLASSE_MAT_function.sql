-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_subgrupo_classe_mat ( cd_classe_material_p bigint) RETURNS bigint AS $body$
DECLARE


cd_subgrupo_material_w  smallint;


BEGIN
if (cd_classe_material_p IS NOT NULL AND cd_classe_material_p::text <> '') then
	select	cd_subgrupo_material
	into STRICT	cd_subgrupo_material_w
	from	classe_material
	where	cd_classe_material = cd_classe_material_p;
end if;
return cd_subgrupo_material_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_subgrupo_classe_mat ( cd_classe_material_p bigint) FROM PUBLIC;

