-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_intervalo_material ( cd_material_p bigint, cd_intervalo_p text) RETURNS varchar AS $body$
DECLARE


ie_exibir_w	varchar(1) := 'S';
cont_w		bigint;


BEGIN

select	count(*)
into STRICT	cont_w
from	lib_material_intervalo
where	cd_material	= cd_material_p
and	coalesce(ie_tipo,'I') = 'I';

if (cont_w	> 0) then
	select	count(*)
	into STRICT	cont_w
	from	lib_material_intervalo
	where	cd_material	= cd_material_p
	and	cd_intervalo	= cd_intervalo_p
	and	coalesce(ie_tipo,'I') = 'I';

	if (cont_w = 0) then
		ie_exibir_w	:= 'N';
	end if;
end if;

return	ie_exibir_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_intervalo_material ( cd_material_p bigint, cd_intervalo_p text) FROM PUBLIC;

