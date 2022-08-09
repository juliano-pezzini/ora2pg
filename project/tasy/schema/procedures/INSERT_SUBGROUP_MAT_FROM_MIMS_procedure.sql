-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_subgroup_mat_from_mims ( cd_subgrupo_material_w INOUT subgrupo_material.cd_subgrupo_material%type, cd_imp_material_p imp_material.cd_material%type, nm_usuario_p text, group_p bigint ) AS $body$
DECLARE
					
imp_subgrupo_material_w  imp_subgrupo_material%rowtype;
cd_subgrupo_mat_w subgrupo_material.cd_subgrupo_material%type;
group_w bigint;

BEGIN

select a.*
into STRICT	imp_subgrupo_material_w 
from	imp_subgrupo_material a, 
        imp_classe_material b, 
	imp_material c 
where	c.cd_material = cd_imp_material_p 
and	c.cd_classe_material = b.cd_classe_material 
and	b.cd_subgrupo_material = a.cd_subgrupo_material;


if (imp_subgrupo_material_w.cd_subgrupo_material IS NOT NULL AND imp_subgrupo_material_w.cd_subgrupo_material::text <> '') then

select max(cd_subgrupo_material)
into STRICT cd_subgrupo_mat_w
from subgrupo_material where ds_subgrupo_material in (SELECT ds_subgrupo_material from imp_subgrupo_material where cd_subgrupo_material = imp_subgrupo_material_w.cd_subgrupo_material);

if (coalesce(cd_subgrupo_mat_w,0) <> 0) then
  cd_subgrupo_material_w := cd_subgrupo_mat_w;
else

	select	coalesce(max(cd_subgrupo_material),0)+1
    	into STRICT	cd_subgrupo_material_w
    	from	subgrupo_material;
      -- insert into subgrupo_material        
	insert into	subgrupo_material(cd_subgrupo_material,
			dt_atualizacao, 
			nm_usuario,  
			ds_subgrupo_material, 
			cd_grupo_material, 
			ie_situacao, 
			cd_sistema_ant) 
	SELECT	cd_subgrupo_material_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		a.ds_subgrupo_material, 
		group_p, 
		a.ie_situacao, 
		a.cd_sistema_ant 
	from	imp_subgrupo_material a 
	where	a.cd_subgrupo_material = 
		imp_subgrupo_material_w.cd_subgrupo_material;

   end if;
end if;

exception
when	no_data_found then 
	imp_subgrupo_material_w := null;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_subgroup_mat_from_mims ( cd_subgrupo_material_w INOUT subgrupo_material.cd_subgrupo_material%type, cd_imp_material_p imp_material.cd_material%type, nm_usuario_p text, group_p bigint ) FROM PUBLIC;
