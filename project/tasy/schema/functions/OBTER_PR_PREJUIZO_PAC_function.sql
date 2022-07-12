-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pr_prejuizo_pac ( vl_pacote_p bigint, vl_aberto_p bigint) RETURNS bigint AS $body$
DECLARE


pr_retorno	double precision;

BEGIN

if (vl_pacote_p >= vl_aberto_p) then
  pr_retorno:= 0;
else
  pr_retorno:= abs(((dividir(vl_pacote_p,vl_aberto_p)*100)-100));
end if;

return	pr_retorno;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pr_prejuizo_pac ( vl_pacote_p bigint, vl_aberto_p bigint) FROM PUBLIC;

