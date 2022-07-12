-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_generico_igual (cd_material_p bigint, cd_mat_substituto_p bigint) RETURNS varchar AS $body$
DECLARE


cd_mat_generico_w	integer;
cd_mat_generico_subst_w	integer;
ie_generico_igual_w	varchar(1) := 'N';


BEGIN

select	max(cd_material_generico)
into STRICT	cd_mat_generico_w
from	material
where	cd_material = cd_material_p;

select	max(cd_material_generico)
into STRICT	cd_mat_generico_subst_w
from	material
where	cd_material = cd_mat_substituto_p;

if (cd_mat_generico_w = cd_mat_generico_subst_w) then
	ie_generico_igual_w := 'S';
end if;

if (cd_material_p = cd_mat_substituto_p) then
	ie_generico_igual_w := 'S';
end if;

return	ie_generico_igual_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_generico_igual (cd_material_p bigint, cd_mat_substituto_p bigint) FROM PUBLIC;

