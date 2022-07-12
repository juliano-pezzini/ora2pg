-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_permite_qtd_barras ( cd_material_p bigint, cd_perfil_p bigint) RETURNS varchar AS $body$
DECLARE


cd_grupo_mat_w		smallint;
cd_subgrupo_mat_w	smallint;
cd_classe_mat_w		integer;
cd_grupo_proc_w		bigint;
ie_existe_w		varchar(1);


BEGIN

select	max(cd_grupo_material),
	max(cd_subgrupo_material),
	max(cd_classe_material)
into STRICT	cd_grupo_mat_w,
	cd_subgrupo_mat_w,
	cd_classe_mat_w
from 	estrutura_material_v
where 	cd_material = cd_material_p;

select	coalesce(max('S'),'N')
into STRICT	ie_existe_w
from	regra_altera_qt_barras
where	coalesce(cd_material,cd_material_p) = cd_material_p
and	coalesce(cd_grupo_material,cd_grupo_mat_w) = cd_grupo_mat_w
and	coalesce(cd_subgrupo_material,cd_subgrupo_mat_w) = cd_subgrupo_mat_w
and	coalesce(cd_classe_material,cd_classe_mat_w) = cd_classe_mat_w
and	coalesce(cd_perfil, coalesce(cd_perfil_p,0)) = coalesce(cd_perfil_p,0)
and	(cd_material_p IS NOT NULL AND cd_material_p::text <> '')
and	ie_situacao = 'A'
order by
	coalesce(cd_material,0),
	coalesce(cd_grupo_material,0),
	coalesce(cd_subgrupo_material,0),
	coalesce(cd_classe_material,0),
	coalesce(cd_perfil, 0);

return	ie_existe_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_permite_qtd_barras ( cd_material_p bigint, cd_perfil_p bigint) FROM PUBLIC;
