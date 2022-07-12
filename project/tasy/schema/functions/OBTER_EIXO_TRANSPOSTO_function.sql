-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_eixo_transposto ( vl_eixo_p bigint ) RETURNS bigint AS $body$
DECLARE


vl_eixo_w	smallint;


BEGIN

if (vl_eixo_p <= 90) then
	vl_eixo_w := vl_eixo_p + 90;
else
	vl_eixo_w := vl_eixo_p - 90;
end if;

return	vl_eixo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_eixo_transposto ( vl_eixo_p bigint ) FROM PUBLIC;

