-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION suep_obter_risco_escala ( qt_valor_p bigint, qt_risco_min_p bigint, qt_risco_max_p bigint) RETURNS varchar AS $body$
BEGIN


if (qt_valor_p	>=qt_risco_min_p and  qt_valor_p <=qt_risco_max_p) then
	return 'ALERT';
else
	return 'NORMAL';
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION suep_obter_risco_escala ( qt_valor_p bigint, qt_risco_min_p bigint, qt_risco_max_p bigint) FROM PUBLIC;

