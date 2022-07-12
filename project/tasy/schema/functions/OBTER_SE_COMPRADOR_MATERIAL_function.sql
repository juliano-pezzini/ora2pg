-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_comprador_material ( cd_material_p bigint, ie_urgente_p text, cd_comprador_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


cd_grupo_material_ww		estrutura_material_v.cd_grupo_material%type;
cd_subgrupo_material_ww		estrutura_material_v.cd_subgrupo_material%type;
cd_classe_material_ww		estrutura_material_v.cd_classe_material%type;
qt_regra_w					integer;


BEGIN

select	cd_grupo_material,
		cd_subgrupo_material,
		cd_classe_material
into STRICT	cd_grupo_material_ww,
	cd_subgrupo_material_ww,
	cd_classe_material_ww
from	estrutura_material_v
where	cd_material = cd_material_p;

select count(*)
into STRICT qt_regra_w
from sup_regra_resp_compras
where (cd_estabelecimento_p = 0 or coalesce(cd_estabelecimento, cd_estabelecimento_p) = cd_estabelecimento_p)
	and coalesce(cd_grupo_material,cd_grupo_material_ww) = cd_grupo_material_ww
	and coalesce(cd_subgrupo_material,cd_subgrupo_material_ww) = cd_subgrupo_material_ww
	and coalesce(cd_classe_material,cd_classe_material_ww) = cd_classe_material_ww
	and coalesce(cd_material, cd_material_p) = cd_material_p
	and (ie_urgente = 'T' or ie_urgente = ie_urgente_p)
	and cd_comprador = cd_comprador_p;

if (qt_regra_w > 0)then
	return 'S';
else
	return 'N';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_comprador_material ( cd_material_p bigint, ie_urgente_p text, cd_comprador_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
