-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION calcular_escala_balthazar_md ( ie_grau_balthazar_p bigint, ie_necrose_p bigint ) RETURNS bigint AS $body$
BEGIN
  return coalesce(ie_grau_balthazar_p, 0) + coalesce(ie_necrose_p, 0);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION calcular_escala_balthazar_md ( ie_grau_balthazar_p bigint, ie_necrose_p bigint ) FROM PUBLIC;

