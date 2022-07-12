-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_material_prescricao ( cd_estabelecimento_p bigint, cd_material_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(1);


BEGIN

begin
select	ie_prescricao
into STRICT	ds_retorno_w
from	material_estab
where	cd_material = cd_material_p
and	cd_estabelecimento = cd_estabelecimento_p;
exception
when others then
	begin
	select	ie_prescricao
	into STRICT	ds_retorno_w
	from	material
	where	cd_material = cd_material_p;
	exception
	when others then
		ds_retorno_w := null;
	end;
end;

RETURN ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_material_prescricao ( cd_estabelecimento_p bigint, cd_material_p bigint) FROM PUBLIC;

