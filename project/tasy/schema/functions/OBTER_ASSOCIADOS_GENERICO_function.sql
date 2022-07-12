-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_associados_generico ( cd_material_generico_p bigint, cd_local_estoque_p bigint) RETURNS varchar AS $body$
DECLARE


ie_return_w	varchar(1);


BEGIN

select	coalesce(max('S'),'N')
into STRICT	ie_return_w
from  	material a
where (a.cd_material_generico = cd_material_generico_p
or	a.cd_material = cd_material_generico_p)
and	obter_se_mat_existe_padrao_loc(a.cd_material, cd_local_estoque_p) = 'S';

return	ie_return_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_associados_generico ( cd_material_generico_p bigint, cd_local_estoque_p bigint) FROM PUBLIC;

