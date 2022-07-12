-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION calcular_score_rel_pao2fio2_md ( qt_rel_pao2_fio2_p bigint ) RETURNS bigint AS $body$
DECLARE

	qt_pto_rel_pao2_fio2_w smallint;

BEGIN

	if (coalesce(qt_rel_pao2_fio2_p::text, '') = '') then
		qt_pto_rel_pao2_fio2_w := 0;
	elsif (qt_rel_pao2_fio2_p > 60) then
		qt_pto_rel_pao2_fio2_w := 0;
	else
		qt_pto_rel_pao2_fio2_w := 2;
	end if;
	return qt_pto_rel_pao2_fio2_w;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION calcular_score_rel_pao2fio2_md ( qt_rel_pao2_fio2_p bigint ) FROM PUBLIC;

