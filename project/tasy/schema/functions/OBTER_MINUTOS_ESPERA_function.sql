-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_minutos_espera (dt_inicial_p timestamp, dt_final_p timestamp) RETURNS bigint AS $body$
DECLARE


qt_min_espera_w	bigint := 0;


BEGIN

begin
	select	round((coalesce(dt_final_p, clock_timestamp()) -  dt_inicial_p) * 1440)
	into STRICT	qt_min_espera_w
	;
	exception
	when 	others then
		qt_min_espera_w	:= 0;
end;

RETURN	qt_min_espera_w;

END	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_minutos_espera (dt_inicial_p timestamp, dt_final_p timestamp) FROM PUBLIC;
