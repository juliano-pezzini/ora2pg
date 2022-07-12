-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_mat_comercial_mais_inf ( cd_material_p bigint, ie_cod_desc_p text) RETURNS varchar AS $body$
DECLARE


cd_material_w		varchar(06);
ds_material_w		varchar(255);
ds_retorno_w		varchar(255);

C01 CURSOR FOR
SELECT	cd_material,
	substr(ds_material,1,255)
from	material
where	cd_material_generico	= cd_material_p
order by ie_situacao desc,
	coalesce(qt_prioridade_coml,0),
	coalesce(ie_padronizado,'N');


BEGIN

open c01;
loop
fetch c01 into
	cd_material_w,
	ds_material_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	cd_material_w	:= cd_material_w;
end loop;
close c01;

if (coalesce(cd_material_w::text, '') = '') then

	cd_material_w	:= cd_material_p;

	select	substr(max(ds_material),1,255)
	into STRICT	ds_material_w
	from	material
	where	cd_material	= cd_material_p;

end if;

if (substr(ie_cod_desc_p,1,1) = 'C') then
   	ds_retorno_w := cd_material_w;
else
   	ds_retorno_w := ds_material_w;
end if;

return substr(ds_retorno_w,1,255);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_mat_comercial_mais_inf ( cd_material_p bigint, ie_cod_desc_p text) FROM PUBLIC;
