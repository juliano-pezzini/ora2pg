-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION se_n1_neg_inverte_n2 (se_campo_p bigint, vl_campo_p bigint) RETURNS varchar AS $body$
DECLARE


vl_campo_w	double precision	:= vl_campo_p;


BEGIN

if (se_campo_p < 0) then
	vl_campo_w := vl_campo_p * -1;
end if;

return vl_campo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION se_n1_neg_inverte_n2 (se_campo_p bigint, vl_campo_p bigint) FROM PUBLIC;
