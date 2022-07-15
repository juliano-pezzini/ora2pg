-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_minutos ( dt_inicial_p timestamp, dt_final_p timestamp, qt_min_intervalo_p bigint, qt_minutos_p INOUT bigint) AS $body$
BEGIN

qt_minutos_p := round((dt_inicial_p - dt_final_p) * 1440) - qt_min_intervalo_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_minutos ( dt_inicial_p timestamp, dt_final_p timestamp, qt_min_intervalo_p bigint, qt_minutos_p INOUT bigint) FROM PUBLIC;

