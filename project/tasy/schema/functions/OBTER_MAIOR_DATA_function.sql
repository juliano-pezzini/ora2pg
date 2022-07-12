-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_maior_data ( dt_param1_p timestamp, dt_param2_p timestamp) RETURNS timestamp AS $body$
BEGIN
if (dt_param1_p > dt_param2_p) then
	return dt_param1_p;
else
	return dt_param2_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_maior_data ( dt_param1_p timestamp, dt_param2_p timestamp) FROM PUBLIC;

