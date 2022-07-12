-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_multiplo_numero ( qt_dose_p bigint, qt_multiplo_p bigint) RETURNS bigint AS $body$
DECLARE

nr_multiplo_w bigint;
qt_retorno_w bigint;

BEGIN

if ((trunc(qt_dose_p / qt_multiplo_p) * qt_multiplo_p) = qt_dose_p) then
 nr_multiplo_w := (qt_dose_p / qt_multiplo_p);
else
 nr_multiplo_w   := trunc(qt_dose_p / qt_multiplo_p);
end if;
qt_retorno_w := qt_multiplo_p * nr_multiplo_w;

return qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_multiplo_numero ( qt_dose_p bigint, qt_multiplo_p bigint) FROM PUBLIC;
