-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION converter_numero_string (number_p bigint) RETURNS varchar AS $body$
BEGIN
if (number_p > 0) and (number_p < 1) then
	return	regexp_replace(number_p, '^,|^\.', '0' || regexp_substr(number_p, '.', 1, 1, 'i'), '1');
else
	return 	number_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION converter_numero_string (number_p bigint) FROM PUBLIC;
