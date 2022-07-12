-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_material_disp_pepo ( cd_material_p bigint) RETURNS varchar AS $body$
DECLARE


ie_permite_w		varchar(1) := 'S';
ie_possui_regra_w	varchar(1) := 'S';
cd_grupo_material_w	smallint;
cd_subgrupo_material_w	smallint;
cd_classe_material_w	integer;


BEGIN

if (coalesce(cd_material_p,0) > 0) then
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_possui_regra_w
	from	regra_dispensacao_pepo;

	if (ie_possui_regra_w = 'S') then
		select	coalesce(cd_grupo_material,0),
			coalesce(cd_subgrupo_material,0),
			coalesce(cd_classe_material,0)
		into STRICT	cd_grupo_material_w,
			cd_subgrupo_material_w,
			cd_classe_material_w
		from	estrutura_material_v
		where	cd_material	= cd_material_p;

		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_permite_w
		from	regra_dispensacao_pepo
		where	coalesce(cd_grupo_material, cd_grupo_material_w)     	= cd_grupo_material_w
		and	coalesce(cd_subgrupo_material, cd_subgrupo_material_w)	= cd_subgrupo_material_w
		and	coalesce(cd_classe_material, cd_classe_material_w)		= cd_classe_material_w
		and	coalesce(cd_material, cd_material_p) 			= cd_material_p
		and	coalesce(ie_nao_permite,'N')					= 'N'
		and	not exists (	SELECT	1
					from	regra_dispensacao_pepo
					where	coalesce(cd_grupo_material, cd_grupo_material_w)     	= cd_grupo_material_w
					and	coalesce(cd_subgrupo_material, cd_subgrupo_material_w)	= cd_subgrupo_material_w
					and	coalesce(cd_classe_material, cd_classe_material_w)		= cd_classe_material_w
					and	coalesce(cd_material, cd_material_p) 			= cd_material_p
					and	coalesce(ie_nao_permite,'N')					= 'S');

	end if;
end if;

return	ie_permite_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_material_disp_pepo ( cd_material_p bigint) FROM PUBLIC;
