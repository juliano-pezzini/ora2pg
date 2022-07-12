-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dt_antes_entre_periodo (dt_base_p timestamp, dt_inicial_p timestamp, dt_final_p timestamp) RETURNS varchar AS $body$
BEGIN

if (dt_base_p < dt_inicial_p) then
	return 'S';
end if;

if (dt_base_p >= dt_inicial_p) and (dt_base_p <= dt_final_p) then
		return 'S';
end if;

return  'N';

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dt_antes_entre_periodo (dt_base_p timestamp, dt_inicial_p timestamp, dt_final_p timestamp) FROM PUBLIC;

