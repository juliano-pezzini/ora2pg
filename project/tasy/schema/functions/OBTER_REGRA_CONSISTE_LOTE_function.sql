-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_consiste_lote (cd_material_p bigint) RETURNS varchar AS $body$
DECLARE


ie_consiste_w		varchar(1);
cd_classe_material_w	integer;
cd_grupo_material_w	smallint;
cd_subgrupo_material_w	smallint;

BEGIN

select	coalesce(max(a.cd_classe_material),0),
	coalesce(max(b.cd_subgrupo_material),0),
	coalesce(max(c.cd_grupo_material),0)
into STRICT	cd_classe_material_w,
	cd_subgrupo_material_w,
	cd_grupo_material_w
from	material a,
	classe_material b,
	subgrupo_material c
where	a.cd_material          = cd_material_p
and 	a.cd_classe_material   = b.cd_classe_material
and 	b.cd_subgrupo_material = c.cd_subgrupo_material;


select 	coalesce(max('S'),'N')
into STRICT	ie_consiste_w
from 	regra_matmed_lote_cabine
where 	coalesce(cd_classe_material,cd_classe_material_w)	 = cd_classe_material_w
and	coalesce(cd_grupo_material,cd_grupo_material_w)	 = cd_grupo_material_w
and	coalesce(cd_material,cd_material_p) 	 		 = cd_material_p
and	coalesce(cd_subgrupo_material,cd_subgrupo_material_w) = cd_subgrupo_material_w;

return	ie_consiste_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_consiste_lote (cd_material_p bigint) FROM PUBLIC;
