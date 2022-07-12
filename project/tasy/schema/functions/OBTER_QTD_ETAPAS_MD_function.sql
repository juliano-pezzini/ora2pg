-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qtd_etapas_md (qt_volume_total_di_p bigint, qt_sum_volume_p bigint) RETURNS bigint AS $body$
BEGIN
  return dividir_sem_round_md(qt_volume_total_di_p, qt_sum_volume_p);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qtd_etapas_md (qt_volume_total_di_p bigint, qt_sum_volume_p bigint) FROM PUBLIC;

