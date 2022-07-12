-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION dividir_18_6 ( Dividendo_p bigint, Divisor_p bigint) RETURNS bigint AS $body$
DECLARE


Resultado_w		double precision;


BEGIN
if (coalesce(divisor_p,0) = 0) then
	Resultado_w		:= 0;
else
	Resultado_w		:= round((Dividendo_p / divisor_p)::numeric,4);
end if;
RETURN Resultado_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION dividir_18_6 ( Dividendo_p bigint, Divisor_p bigint) FROM PUBLIC;

