-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_considera_ressup ( cd_estabelecimento_p bigint, cd_local_estoque_p bigint, cd_material_p bigint) RETURNS varchar AS $body$
DECLARE



cd_grupo_material_w		smallint;
cd_subgrupo_w			smallint;
cd_classe_material_w		integer;
ie_controlado_w			varchar(1);
nr_regras_w			integer;
ie_considera_w			varchar(01);
ie_consignado_w			material.ie_consignado%type;


c01 CURSOR FOR
	SELECT	ie_considera
	from	regra_estoque_ressup
	where	cd_estabelecimento = cd_estabelecimento_p
	and	coalesce(cd_local_estoque, cd_local_estoque_p)		= cd_local_estoque_p
	and	coalesce(cd_grupo_material, cd_grupo_material_w)		= cd_grupo_material_w
	and	coalesce(cd_subgrupo_material, cd_subgrupo_w)		= cd_subgrupo_w
	and	coalesce(cd_classe_material, cd_classe_material_w)		= cd_classe_material_w
	and	coalesce(cd_material, cd_material_p)			= cd_material_p
	and	((coalesce(ie_controlado,'A') = 'A') or (coalesce(ie_controlado, 'A') 	= ie_controlado_w))
	and	((coalesce(ie_consignado::text, '') = '') or (ie_consignado = ie_consignado_w))
	order by
		coalesce(cd_material, 0),
		coalesce(cd_classe_material, 0),
		coalesce(cd_subgrupo_material, 0),
		coalesce(cd_grupo_material, 0),
		coalesce(cd_local_estoque, 0);

BEGIN
ie_considera_w	:= 'S';

select	count(*)
into STRICT	nr_regras_w
from	regra_estoque_ressup LIMIT 1;

if (nr_regras_w > 0) then
	begin
	select	cd_grupo_material,
		cd_subgrupo_material,
		cd_classe_material,
		ie_consignado
	into STRICT	cd_grupo_material_w,
		cd_subgrupo_w,
		cd_classe_material_w,
		ie_consignado_w
	from	estrutura_material_v
	where 	cd_material	= cd_material_p  LIMIT 1;

	select	substr(obter_se_medic_controlado(cd_material_p),1,1)
	into STRICT	ie_controlado_w
	;

	open c01;
	loop
	fetch c01 into
		ie_considera_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	end loop;
	close c01;
	end;
end if;

return ie_considera_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_considera_ressup ( cd_estabelecimento_p bigint, cd_local_estoque_p bigint, cd_material_p bigint) FROM PUBLIC;
