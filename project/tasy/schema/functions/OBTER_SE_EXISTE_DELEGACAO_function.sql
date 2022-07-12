-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_existe_delegacao ( cd_pessoa_fisica_p text, cd_pessoa_substituta_p text, cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, cd_material_p bigint, ie_consignado_p text default null, ie_material_estoque_p text default null, ie_objetivo_p text default null, nr_sequencia_p text DEFAULT NULL) RETURNS varchar AS $body$
DECLARE


qt_existe_w		bigint;
ie_retorno_w		varchar(1)	:= 'N';


BEGIN


select	count(*)
into STRICT	qt_existe_w
from	pessoa_fisica_delegacao
where	cd_pessoa_fisica = cd_pessoa_fisica_p
and	cd_pessoa_substituta = cd_pessoa_substituta_p
and	coalesce(cd_grupo_material,0) = coalesce(cd_grupo_material_p,0)
and	coalesce(cd_subgrupo_material,0) = coalesce(cd_subgrupo_material_p,0)
and	coalesce(cd_classe_material,0) = coalesce(cd_classe_material_p,0)
and	coalesce(cd_material,0) = coalesce(cd_material_p,0)
and	coalesce(ie_consignado,'X') = coalesce(ie_consignado_p,'X')
and	ie_material_estoque = ie_material_estoque_p
and	dt_limite >= trunc(clock_timestamp(),'dd')
and	ie_objetivo = coalesce(ie_objetivo_p,ie_objetivo)
and	nr_sequencia <> nr_sequencia_p;


if (qt_existe_w > 0) then
	ie_retorno_w	:= 'S';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_existe_delegacao ( cd_pessoa_fisica_p text, cd_pessoa_substituta_p text, cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, cd_material_p bigint, ie_consignado_p text default null, ie_material_estoque_p text default null, ie_objetivo_p text default null, nr_sequencia_p text DEFAULT NULL) FROM PUBLIC;
