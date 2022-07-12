-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_phase_hour_md (qt_solucao_total_p bigint, nr_etapas_p bigint) RETURNS bigint AS $body$
DECLARE

  nr_etapas_w bigint;

BEGIN

  if (nr_etapas_p = 0) then
    nr_etapas_w := 1;
  else
    nr_etapas_w := nr_etapas_p;
  end if;
  return dividir_sem_round_md(qt_solucao_total_p, nr_etapas_w);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_phase_hour_md (qt_solucao_total_p bigint, nr_etapas_p bigint) FROM PUBLIC;

