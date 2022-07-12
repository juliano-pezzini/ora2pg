-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hsc_converte_horas_minutos ( qt_horas_p bigint) RETURNS bigint AS $body$
DECLARE

qt_minutos_w		double precision;
qt_horas_w		double precision;

BEGIN
qt_horas_w		:= trunc(qt_horas_p);
qt_minutos_w 		:= (qt_horas_p - qt_horas_w)*100;

return(qt_horas_w * 60) + qt_minutos_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hsc_converte_horas_minutos ( qt_horas_p bigint) FROM PUBLIC;

