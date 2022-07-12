-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_gera_mat_grupo_pj ( nr_seq_regra_pj_p bigint, cd_material_p bigint) RETURNS varchar AS $body$
DECLARE



cd_grupo_material_w			smallint;
cd_subgrupo_material_w			smallint;
cd_classe_material_w			integer;
ie_gerar_w				varchar(1) := 'S';

c01 CURSOR FOR
SELECT	coalesce(ie_gerar,'S')
from	grupo_pj_compras_for_est
where	nr_seq_fornec = nr_seq_regra_pj_p
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

select	a.cd_grupo_material,
	a.cd_subgrupo_material,
	a.cd_classe_material
into STRICT	cd_grupo_material_w,
	cd_subgrupo_material_w,
	cd_classe_material_w
from	estrutura_material_v a
where	a.cd_material = cd_material_p;


open C01;
loop
fetch C01 into
	ie_gerar_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ie_gerar_w	:= ie_gerar_w;
	end;
end loop;
close C01;


return coalesce(ie_gerar_w,'S');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_gera_mat_grupo_pj ( nr_seq_regra_pj_p bigint, cd_material_p bigint) FROM PUBLIC;
