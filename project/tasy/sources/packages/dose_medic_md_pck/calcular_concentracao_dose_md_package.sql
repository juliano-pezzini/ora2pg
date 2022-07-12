-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE dose_medic_md_pck.calcular_concentracao_dose_md (qt_concent_med_p INOUT bigint, qt_concent_med_mg_p bigint, qt_concent_med_ml_p bigint, qt_dose_p bigint, qt_dose_conv_p bigint, ie_unidade_p text, qt_vol_total_p bigint, qt_concent_dose_total_p INOUT bigint) AS $body$
BEGIN
    qt_concent_med_p := dividir_sem_round_md(qt_concent_med_mg_p, qt_concent_med_ml_p) * coalesce(qt_dose_conv_p, 0);
    if (ie_unidade_p = 'MCG') then
      qt_concent_dose_total_p := dividir_sem_round_md(qt_concent_med_p, qt_vol_total_p) * 1000;
    elsif (ie_unidade_p = 'MG') then
      qt_concent_dose_total_p := dividir_sem_round_md(qt_concent_med_p, qt_vol_total_p);
    elsif (ie_unidade_p = 'UI') then
	  qt_concent_dose_total_p := qt_dose_p * qt_vol_total_p;
    end if;

  end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dose_medic_md_pck.calcular_concentracao_dose_md (qt_concent_med_p INOUT bigint, qt_concent_med_mg_p bigint, qt_concent_med_ml_p bigint, qt_dose_p bigint, qt_dose_conv_p bigint, ie_unidade_p text, qt_vol_total_p bigint, qt_concent_dose_total_p INOUT bigint) FROM PUBLIC;
