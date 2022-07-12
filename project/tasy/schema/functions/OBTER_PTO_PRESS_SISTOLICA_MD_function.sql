-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pto_press_sistolica_md ( qt_pa_sistolica_p bigint, nr_idade_meses_p bigint) RETURNS bigint AS $body$
DECLARE


qt_pto_pa_sistolica_w smallint;


BEGIN

if (coalesce(qt_pa_sistolica_p::text, '') = '') then
	qt_pto_pa_sistolica_w := 0;
elsif (nr_idade_meses_P < 1) then
	if (qt_pa_sistolica_p > 65) then
		qt_pto_pa_sistolica_w := 0;
	elsif (qt_pa_sistolica_p >= 35) and (qt_pa_sistolica_p <= 65) then
		qt_pto_pa_sistolica_w := 10;
	elsif (qt_pa_sistolica_p < 35) then
		qt_pto_pa_sistolica_w := 20;
	end if;

elsif (nr_idade_meses_P >= 1) and (nr_idade_meses_P < 12) then
	if (qt_pa_sistolica_p > 75) then
		qt_pto_pa_sistolica_w := 0;
	elsif (qt_pa_sistolica_p >= 35) and (qt_pa_sistolica_p <= 75) then
		qt_pto_pa_sistolica_w := 10;
	elsif (qt_pa_sistolica_p < 35) then
		qt_pto_pa_sistolica_w := 20;
	end if;

elsif (nr_idade_meses_P >= 12) and (nr_idade_meses_P < 144) then
	if (qt_pa_sistolica_p > 85) then
		qt_pto_pa_sistolica_w := 0;
	elsif (qt_pa_sistolica_p >= 45) and (qt_pa_sistolica_p <= 85) then
		qt_pto_pa_sistolica_w := 10;
	elsif (qt_pa_sistolica_p < 45) then
		qt_pto_pa_sistolica_w := 20;
	end if;

elsif (nr_idade_meses_P >= 144) then
	if (qt_pa_sistolica_p > 95) then
		qt_pto_pa_sistolica_w := 0;
	elsif (qt_pa_sistolica_p >= 55) and (qt_pa_sistolica_p <= 95) then
		qt_pto_pa_sistolica_w := 10;
	elsif (qt_pa_sistolica_p < 55) then
		qt_pto_pa_sistolica_w := 20;
	end if;

end if;


  return qt_pto_pa_sistolica_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pto_press_sistolica_md ( qt_pa_sistolica_p bigint, nr_idade_meses_p bigint) FROM PUBLIC;

