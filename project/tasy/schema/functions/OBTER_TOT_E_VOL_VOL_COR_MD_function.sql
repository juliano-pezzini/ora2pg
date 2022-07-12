-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tot_e_vol_vol_cor_md (qt_equipo_p bigint, qt_volume_p bigint) RETURNS bigint AS $body$
BEGIN
	return(coalesce(qt_equipo_p,0) + coalesce(qt_volume_p,0));

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tot_e_vol_vol_cor_md (qt_equipo_p bigint, qt_volume_p bigint) FROM PUBLIC;

