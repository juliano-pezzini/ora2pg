-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_descricao_mat_prescr (cd_material_p bigint) RETURNS varchar AS $body$
DECLARE


ds_material_w		varchar(255);
ie_reduzida_w		varchar(255);
ds_reduzida_w		varchar(255);

--pragma autonomous_transaction;
BEGIN

ie_reduzida_w	:= WHEB_ASSIST_PCK.get_obter_desc_reduzida;

select 	substr(ds_material,1,80),
	substr(ds_reduzida,1,80)
into STRICT	ds_material_w,
	ds_reduzida_w
from 	material
where 	cd_material = cd_material_p;

if (ie_reduzida_w	= 'S') then
	ds_material_w	:= coalesce(ds_reduzida_w, ds_material_w);
end if;

return	ds_material_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_descricao_mat_prescr (cd_material_p bigint) FROM PUBLIC;
