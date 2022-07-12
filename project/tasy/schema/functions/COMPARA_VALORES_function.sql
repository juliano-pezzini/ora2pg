-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION compara_valores (nr_inicial_p bigint, nr_operando_p text, nr_final_p bigint) RETURNS bigint AS $body$
BEGIN

if (nr_operando_p like '=') then
	if (nr_inicial_p = nr_final_p) then
		return 1;
	else
		return 0;
	end if;
elsif (nr_operando_p like '>') then
	if (nr_inicial_p > nr_final_p) then
		return 1;
	else
		return 0;
	end if;
elsif (nr_operando_p like '<') then
	if (nr_inicial_p < nr_final_p) then
		return 1;
	else
		return 0;
	end if;
elsif (nr_operando_p like '>=') then
	if (nr_inicial_p >= nr_final_p) then
		return 1;
	else
		return 0;
	end if;
elsif (nr_operando_p like '<=') then
	if (nr_inicial_p <= nr_final_p) then
		return 1;
	else
		return 0;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION compara_valores (nr_inicial_p bigint, nr_operando_p text, nr_final_p bigint) FROM PUBLIC;

