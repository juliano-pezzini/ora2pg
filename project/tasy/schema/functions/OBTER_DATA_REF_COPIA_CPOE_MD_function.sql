-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_ref_copia_cpoe_md ( dt_referencia_p timestamp, qt_hors_before_p bigint, nr_horas_copia_p bigint ) RETURNS timestamp AS $body$
BEGIN
  return ((dt_referencia_p - (dividir_sem_round_md(qt_hors_before_p, 24))) + (dividir_sem_round_md(nr_horas_copia_p, 24)));
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_ref_copia_cpoe_md ( dt_referencia_p timestamp, qt_hors_before_p bigint, nr_horas_copia_p bigint ) FROM PUBLIC;
