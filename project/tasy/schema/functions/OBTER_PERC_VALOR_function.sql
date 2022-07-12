-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_perc_valor ( vl_dividendo_p bigint, vl_divisor_p bigint) RETURNS bigint AS $body$
DECLARE



pr_valor_w		double precision;


BEGIN

pr_valor_w		:= round((dividir(vl_dividendo_p*100,vl_divisor_p))::numeric,4);

RETURN pr_valor_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_perc_valor ( vl_dividendo_p bigint, vl_divisor_p bigint) FROM PUBLIC;
