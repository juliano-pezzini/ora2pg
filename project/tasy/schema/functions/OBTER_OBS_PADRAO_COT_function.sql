-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_obs_padrao_cot ( cd_material_p bigint, cd_estabelecimento_p bigint, nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE




ie_retorno_w			varchar(1);
nr_sequencia_w			bigint;
cd_grupo_material_w		smallint;
cd_subgrupo_material_w		smallint;
cd_classe_material_w		integer;
ie_existe_w			bigint;


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
into STRICT	ie_existe_w
from	observacao_padrao_compras a
where	cd_estabelecimento = cd_estabelecimento_p
and	a.nr_sequencia = nr_sequencia_p
and	coalesce(cd_grupo_material, cd_grupo_material_w)		= cd_grupo_material_w
and	coalesce(cd_subgrupo_material, cd_subgrupo_material_w)	= cd_subgrupo_material_w
and	a.ie_situacao = 'A'
and	a.ie_cotacao = 'S'
and	coalesce(cd_classe_material, cd_classe_material_w)		= cd_classe_material_w
and (coalesce(cd_material, cd_material_p) 			= cd_material_p or cd_material_p = 0)
order by
	coalesce(cd_material, 0),
	coalesce(cd_classe_material, 0),
	coalesce(cd_subgrupo_material, 0),
	coalesce(cd_grupo_material, 0);



if (ie_existe_w > 0) then
	ie_retorno_w := 'S';
end if;
if (ie_existe_w = 0) then
	ie_retorno_w := 'N';
end if;



return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_obs_padrao_cot ( cd_material_p bigint, cd_estabelecimento_p bigint, nr_sequencia_p bigint) FROM PUBLIC;
