-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_venc_oc ( cd_material_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE



ie_data_base_venc_ordem_w		regra_venc_ordem_compra.ie_data_base_venc_ordem%type := 'E';
cd_material_w			material.cd_material%type;
cd_grupo_material_w		grupo_material.cd_grupo_material%type;
cd_subgrupo_material_w		subgrupo_material.cd_subgrupo_material%type;
cd_classe_material_w		classe_material.cd_classe_material%type;

c01 CURSOR FOR
SELECT	coalesce(ie_data_base_venc_ordem,'S')
from	regra_venc_ordem_compra
where	cd_estabelecimento = cd_estabelecimento_p
and	ie_situacao = 'A'
and	coalesce(cd_grupo_material, cd_grupo_material_w)		= cd_grupo_material_w
and	coalesce(cd_subgrupo_material, cd_subgrupo_material_w)	= cd_subgrupo_material_w
and	coalesce(cd_classe_material, cd_classe_material_w)		= cd_classe_material_w
and (coalesce(cd_material, cd_material_p) 			= cd_material_p or cd_material_p = 0)
order by
	coalesce(cd_material, 0),
	coalesce(cd_classe_material, 0),
	coalesce(cd_subgrupo_material, 0),
	coalesce(cd_grupo_material, 0);


BEGIN

select	cd_grupo_material,
	cd_subgrupo_material,
	cd_classe_material
into STRICT	cd_grupo_material_w,
	cd_subgrupo_material_w,
	cd_classe_material_w
from	estrutura_material_v
where	cd_material = cd_material_p;

open C01;
loop
fetch C01 into
	ie_data_base_venc_ordem_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ie_data_base_venc_ordem_w := ie_data_base_venc_ordem_w;
	end;
end loop;
close C01;

return	ie_data_base_venc_ordem_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_venc_oc ( cd_material_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
