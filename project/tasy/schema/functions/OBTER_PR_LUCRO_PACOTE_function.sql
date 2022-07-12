-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pr_lucro_pacote (vl_conta_p bigint, vl_custo_p bigint) RETURNS bigint AS $body$
DECLARE


pr_lucro_w	double precision;
vl_conta_w	double precision;


BEGIN

vl_conta_w:= coalesce(vl_conta_p,0);

if  vl_conta_w = 0 then
   vl_conta_w:= 1;
end if;

pr_lucro_w:= (vl_conta_p - vl_custo_p) * 100 / vl_conta_w;

return pr_lucro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pr_lucro_pacote (vl_conta_p bigint, vl_custo_p bigint) FROM PUBLIC;

