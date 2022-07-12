-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_interv_kit ( cd_kit_material_p bigint, cd_material_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);
cd_intervalo_w	intervalo_prescricao.cd_intervalo%type;


BEGIN

ds_retorno_w	:= 'N';

if	(cd_kit_material_p IS NOT NULL AND cd_kit_material_p::text <> '' AND cd_material_p IS NOT NULL AND cd_material_p::text <> '') then

	select	max(cd_intervalo)
	into STRICT	cd_intervalo_w
	from	componente_kit
	where	cd_kit_material	= cd_kit_material_p
	and	cd_material	= cd_material_p;

	if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') then
		ds_retorno_w := 'S';
	end if;

end if;

return ds_retorno_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_interv_kit ( cd_kit_material_p bigint, cd_material_p bigint) FROM PUBLIC;

