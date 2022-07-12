-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_estrutura_mat ( cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, cd_material_estrut_p bigint, cd_material_p bigint, ie_acao_p text) RETURNS varchar AS $body$
DECLARE


cont_w		bigint;


BEGIN


if	((cd_grupo_material_p IS NOT NULL AND cd_grupo_material_p::text <> '') or (cd_subgrupo_material_p IS NOT NULL AND cd_subgrupo_material_p::text <> '') or (cd_classe_material_p IS NOT NULL AND cd_classe_material_p::text <> '') or (cd_material_estrut_p IS NOT NULL AND cd_material_estrut_p::text <> '')) and (ie_acao_p = 'S') then

	select	count(*)
	into STRICT	cont_w
	from	estrutura_material_v
	where	cd_grupo_material		= coalesce(cd_grupo_material_p, cd_grupo_material)
	and	cd_subgrupo_material	= coalesce(cd_subgrupo_material_p, cd_subgrupo_material)
	and	cd_classe_material		= coalesce(cd_classe_material_p, cd_classe_material)
	and	cd_material		= coalesce(cd_material_estrut_p, cd_material)
	and	cd_material		= cd_material_p;

	if (cont_w > 0) then
		return	'S';
	else
		return	'N';
	end if;

else

	return	'S';
end if;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_estrutura_mat ( cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, cd_material_estrut_p bigint, cd_material_p bigint, ie_acao_p text) FROM PUBLIC;
