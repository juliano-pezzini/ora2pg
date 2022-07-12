-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_imc_dose_patient_md (qt_height_p bigint, qt_weight_p bigint) RETURNS bigint AS $body$
DECLARE

  qt_imc_w bigint;

BEGIN
  if (qt_height_p > 0) then
    qt_imc_w := dividir_sem_round_md(qt_weight_p, dividir_sem_round_md(qt_height_p, 100)) * dividir_sem_round_md(qt_height_p, 100);
    if (qt_imc_w < 0) then
      qt_imc_w := 0;
    end if;
  else
    qt_imc_w := 0;
  end if;
  return qt_imc_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_imc_dose_patient_md (qt_height_p bigint, qt_weight_p bigint) FROM PUBLIC;
