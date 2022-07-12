-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_permite_material_req ( cd_centro_custo_p bigint, cd_material_p bigint) RETURNS varchar AS $body$
DECLARE


cd_grupo_material_w		smallint;
cd_subgrupo_material_w		smallint;
cd_classe_material_w		integer;
ie_requisicao_w			varchar(1) := 'S';
ie_exclui_w			varchar(1);
qt_existe_w			bigint;


BEGIN

select	cd_grupo_material,
	cd_subgrupo_material,
	cd_classe_material
into STRICT	cd_grupo_material_w,
	cd_subgrupo_material_w,
	cd_classe_material_w
from	estrutura_material_v
where	cd_material = cd_material_p;

select	count(*)
into STRICT	qt_existe_w
from	centro_custo_material
where	cd_centro_custo = cd_centro_custo_p;

if (qt_existe_w > 0) and (cd_centro_custo_p IS NOT NULL AND cd_centro_custo_p::text <> '') then

	begin
	select	ie_exclui
	into STRICT	ie_exclui_w
	from	centro_custo_material
	where	coalesce(cd_grupo_material, cd_grupo_material_w)		= cd_grupo_material_w
	and	coalesce(cd_subgrupo_material, cd_subgrupo_material_w)	= cd_subgrupo_material_w
	and	coalesce(cd_classe_material, cd_classe_material_w)		= cd_classe_material_w
	and (coalesce(cd_material, cd_material_p) = cd_material_p or cd_material_p = 0)
	and	cd_centro_custo = cd_centro_custo_p
	and	ie_requisicao = 'S'
	order by
		coalesce(cd_material, 0),
		coalesce(cd_classe_material, 0),
		coalesce(cd_subgrupo_material, 0),
		coalesce(cd_grupo_material, 0);
	exception when others then
		ie_exclui_w	:= 'N';
	end;

end if;

ie_requisicao_w	:= 'S';
if (ie_exclui_w = 'S') then
	ie_requisicao_w	:= 'N';
end if;

return ie_requisicao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_permite_material_req ( cd_centro_custo_p bigint, cd_material_p bigint) FROM PUBLIC;
