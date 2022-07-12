-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_valor_proporcional ( vl_total_1_p bigint, vl_proporcional_1_p bigint, vl_total_2_p bigint ) RETURNS bigint AS $body$
BEGIN

return	dividir_sem_round(coalesce(vl_total_2_p,0)*coalesce(vl_proporcional_1_p,0),vl_total_1_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_valor_proporcional ( vl_total_1_p bigint, vl_proporcional_1_p bigint, vl_total_2_p bigint ) FROM PUBLIC;
