-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_dose_especial ( cd_intervalo_p text) RETURNS varchar AS $body$
DECLARE


ie_dose_especial_w	varchar(1) := 'N';


BEGIN
if (cd_intervalo_p IS NOT NULL AND cd_intervalo_p::text <> '') then
	begin

	select	ie_dose_especial
	into STRICT	ie_dose_especial_w
	from	intervalo_prescricao
	where	cd_intervalo = cd_intervalo_p;
	end;
end if;
return	ie_dose_especial_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_dose_especial ( cd_intervalo_p text) FROM PUBLIC;

