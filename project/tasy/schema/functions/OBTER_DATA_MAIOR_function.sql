-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_maior ( dt_um_p timestamp, dt_dois_p timestamp) RETURNS timestamp AS $body$
BEGIN

if (coalesce(dt_dois_p,clock_timestamp()) > coalesce(dt_um_p,clock_timestamp())) then
	return	dt_dois_p;
else
	return	dt_um_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_maior ( dt_um_p timestamp, dt_dois_p timestamp) FROM PUBLIC;
