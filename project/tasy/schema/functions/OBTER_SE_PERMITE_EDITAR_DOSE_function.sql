-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_permite_editar_dose ( cd_material_p bigint, cd_intervalo_p text) RETURNS varchar AS $body$
DECLARE


ie_permite_editar_w		char(1) := 'S';
ie_dose_diferenciada_w	intervalo_prescricao.ie_dose_diferenciada%type;


BEGIN
if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') and (cd_intervalo_p IS NOT NULL AND cd_intervalo_p::text <> '') then
	begin

	select	coalesce(max(ie_editar_dose),'S')
	into STRICT	ie_permite_editar_w
	from	material
	where	cd_material = cd_material_p;

	if (ie_permite_editar_w = 'S') then
		ie_permite_editar_w	:= 'N';

		select	coalesce(max(ie_dose_diferenciada),'N')
		into STRICT	ie_dose_diferenciada_w
		from	intervalo_prescricao
		where	cd_intervalo = cd_intervalo_p;

		if (coalesce(ie_dose_diferenciada_w,'XPTO') in ('N','P','XPTO')) then
			ie_permite_editar_w	:= 'S';
		end if;
	else
		ie_permite_editar_w	:= 'N';
	end if;
	end;
end if;

return	ie_permite_editar_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_permite_editar_dose ( cd_material_p bigint, cd_intervalo_p text) FROM PUBLIC;

