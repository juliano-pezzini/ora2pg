-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_hematologica_md ( qt_globulos_brancos_p bigint ) RETURNS bigint AS $body$
DECLARE

	qt_pto_glob_branco_w smallint;

BEGIN

	if (qt_globulos_brancos_p > 2) then
		qt_pto_glob_branco_w := 0;
	else
		qt_pto_glob_branco_w := 2;
	end if;
	return qt_pto_glob_branco_w;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_hematologica_md ( qt_globulos_brancos_p bigint ) FROM PUBLIC;
