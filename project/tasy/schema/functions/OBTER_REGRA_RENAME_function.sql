-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_rename ( cd_material_p bigint, cd_estabelecimento_p bigint, cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, nr_seq_familia_p bigint ) RETURNS varchar AS $body$
DECLARE

ret_ie_classif_rename varchar(15);
ie_classif_rename_w	componentes_rename.ie_classif_rename%type;
cd_material_w 		componentes_rename.cd_material%type;
cd_classe_material_w 	componentes_rename.cd_classe_material%type;
cd_grupo_material_w 	componentes_rename.cd_grupo_material%type;
cd_subgrupo_material_w 	componentes_rename.cd_subgrupo_material%type;
nr_seq_familia_w 	componentes_rename.nr_seq_familia%type;

c01 CURSOR FOR
SELECT	
cd_material,
cd_classe_material,
cd_grupo_material,
cd_subgrupo_material,
nr_seq_familia,
ie_classif_rename
from	componentes_rename
where (
    (cd_estabelecimento = cd_estabelecimento_p or coalesce(cd_estabelecimento::text, '') = '')
or (cd_grupo_material	= cd_grupo_material_p or cd_grupo_material_p = 0)
or (cd_subgrupo_material	= cd_subgrupo_material_p or cd_subgrupo_material_p = 0)
or (cd_classe_material	= cd_classe_material_p or cd_classe_material_p = 0)
or (cd_material = cd_material_p or cd_material_p= 0)
or (nr_seq_familia	= nr_seq_familia_p or nr_seq_familia_p = 0)
)
order by
cd_material,
cd_classe_material,
cd_subgrupo_material,
cd_grupo_material;


BEGIN

open c01;
loop
fetch c01 into
cd_material_w,
cd_classe_material_w,
cd_grupo_material_w,
cd_subgrupo_material_w,
nr_seq_familia_w,
ie_classif_rename_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
begin
if (cd_material_w = cd_material_p) THEN
ret_ie_classif_rename := ie_classif_rename_w;
exit;
elsif (cd_classe_material_w = cd_classe_material_p AND coalesce(cd_material_w::text, '') = '') THEN
ret_ie_classif_rename := ie_classif_rename_w;
exit;
elsif (cd_grupo_material_w = cd_grupo_material_p AND coalesce(cd_classe_material_w::text, '') = '') THEN
ret_ie_classif_rename := ie_classif_rename_w;
exit;
elsif (cd_subgrupo_material_w = cd_subgrupo_material_p AND coalesce(cd_grupo_material_w::text, '') = '') THEN
ret_ie_classif_rename := ie_classif_rename_w;
exit;
elsif (nr_seq_familia_w = nr_seq_familia_p AND coalesce(cd_subgrupo_material_w::text, '') = '') THEN
ret_ie_classif_rename := ie_classif_rename_w;
exit;
end if;
end;
end loop;
close c01;

return ret_ie_classif_rename;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_rename ( cd_material_p bigint, cd_estabelecimento_p bigint, cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, nr_seq_familia_p bigint ) FROM PUBLIC;
