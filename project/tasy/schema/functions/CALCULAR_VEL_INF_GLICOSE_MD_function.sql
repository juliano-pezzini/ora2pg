-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION calcular_vel_inf_glicose_md ( qt_hora_inf_p bigint, qt_min_inf_p bigint, qt_elem_kg_dia_p bigint ) RETURNS bigint AS $body$
BEGIN
  return dividir_md(qt_elem_kg_dia_p, coalesce(dividir_sem_round_md(((coalesce(qt_hora_inf_p, 24) * 60) + coalesce(qt_min_inf_p, 0)), 1000), 1.44));
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION calcular_vel_inf_glicose_md ( qt_hora_inf_p bigint, qt_min_inf_p bigint, qt_elem_kg_dia_p bigint ) FROM PUBLIC;
