-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcula_result_qtkcal_md (qt_kcal_kg_dia_p bigint, qt_peso_p bigint, qt_proteina_p bigint, qt_lipidio_p bigint, qt_kcal_total_p INOUT bigint, qt_kcal_proteina_p INOUT bigint, qt_kcal_lipidio_p INOUT bigint, qt_kcal_carboidrato_p INOUT bigint ) AS $body$
BEGIN
  qt_kcal_total_p       := coalesce(qt_kcal_kg_dia_p, 0) *  coalesce(qt_peso_p, 0);

  qt_kcal_proteina_p    := dividir_sem_round_md(coalesce(qt_kcal_total_p, 0) * coalesce(qt_proteina_p, 0), 100);
  qt_kcal_lipidio_p     := dividir_sem_round_md(coalesce(qt_kcal_total_p, 0) * coalesce(qt_lipidio_p, 0), 100);	
  qt_kcal_carboidrato_p := coalesce(qt_kcal_total_p, 0) - coalesce(qt_kcal_lipidio_p, 0) - coalesce(qt_kcal_proteina_p, 0);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcula_result_qtkcal_md (qt_kcal_kg_dia_p bigint, qt_peso_p bigint, qt_proteina_p bigint, qt_lipidio_p bigint, qt_kcal_total_p INOUT bigint, qt_kcal_proteina_p INOUT bigint, qt_kcal_lipidio_p INOUT bigint, qt_kcal_carboidrato_p INOUT bigint ) FROM PUBLIC;
