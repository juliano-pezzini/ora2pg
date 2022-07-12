-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION check_med_suspended_intervals ( cd_intervalo_p intervalo_prescricao.cd_intervalo%type ) RETURNS varchar AS $body$
DECLARE

ie_exist_medicine_w char(1);												

BEGIN
	ie_exist_medicine_w := 'N';
	if (cd_intervalo_p IS NOT NULL AND cd_intervalo_p::text <> '') then
		begin
			select	coalesce(max('S'), 'N') ie_exist_medicine_w
			into STRICT ie_exist_medicine_w
			from    lib_material_intervalo  a
			where  a.cd_intervalo = cd_intervalo_p;

		end;

	end if;

return ie_exist_medicine_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION check_med_suspended_intervals ( cd_intervalo_p intervalo_prescricao.cd_intervalo%type ) FROM PUBLIC;
