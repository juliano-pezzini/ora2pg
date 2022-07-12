-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_minutos_intervalo (dt_inicial_p timestamp, dt_final_p timestamp, qt_min_intervalo_p bigint) RETURNS bigint AS $body$
DECLARE


ds_minutos_w		bigint;


BEGIN

ds_minutos_w := calcular_minutos( dt_inicial_p, dt_final_p, qt_min_intervalo_p, ds_minutos_w);

return	ds_minutos_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_minutos_intervalo (dt_inicial_p timestamp, dt_final_p timestamp, qt_min_intervalo_p bigint) FROM PUBLIC;

