-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION calcular_saude_mental_md ( qt_questao_9_saude_mental_p bigint ) RETURNS bigint AS $body$
BEGIN
  return dividir_md((coalesce(qt_questao_9_saude_mental_p, 0) - 5), 25) * 100;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION calcular_saude_mental_md ( qt_questao_9_saude_mental_p bigint ) FROM PUBLIC;
