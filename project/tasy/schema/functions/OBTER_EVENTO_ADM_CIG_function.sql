-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_evento_adm_cig ( qt_bolus_calc_p bigint, qt_bolus_adm_p bigint, qt_veloc_calc_p bigint, qt_veloc_adm_p bigint, qt_glicose_calc_p bigint, qt_glicose_adm_p bigint ) RETURNS bigint AS $body$
BEGIN
	if ( qt_bolus_calc_p 	= 0 and
		 qt_bolus_adm_p 	= 0 and
		 qt_veloc_calc_p 	= 0 and
		 qt_veloc_adm_p 	= 0	and
		 qt_glicose_calc_p 	= 0 and
		 qt_glicose_adm_p 	= 0) then
		return 14;
	else
		return 11;
	end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_evento_adm_cig ( qt_bolus_calc_p bigint, qt_bolus_adm_p bigint, qt_veloc_calc_p bigint, qt_veloc_adm_p bigint, qt_glicose_calc_p bigint, qt_glicose_adm_p bigint ) FROM PUBLIC;
