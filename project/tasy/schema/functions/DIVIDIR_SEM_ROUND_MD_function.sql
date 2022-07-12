-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION dividir_sem_round_md ( dividendo_p bigint, divisor_p bigint ) RETURNS bigint AS $body$
BEGIN
  if (coalesce(divisor_p, 0) = 0) then
    return 0;
  else
    return dividendo_p / divisor_p;
  end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION dividir_sem_round_md ( dividendo_p bigint, divisor_p bigint ) FROM PUBLIC;

