-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE cpoe_calc_valores_sol_md_pck.calcula_volume_ds_dose_dif_md (qt_volume_etapa_p INOUT bigint, qt_volume_total_p INOUT bigint, qt_valor_p bigint, qt_posicao_p bigint, ds_dose_dif_p INOUT bigint ) AS $body$
BEGIN
    qt_volume_etapa_p := coalesce(qt_volume_etapa_p,0) + coalesce(qt_valor_p,0);
    qt_volume_total_p := coalesce(qt_volume_total_p,0) + coalesce(qt_valor_p,0);

    ds_dose_dif_p	:= substr(ds_dose_dif_p, qt_posicao_p+1);
  end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_calc_valores_sol_md_pck.calcula_volume_ds_dose_dif_md (qt_volume_etapa_p INOUT bigint, qt_volume_total_p INOUT bigint, qt_valor_p bigint, qt_posicao_p bigint, ds_dose_dif_p INOUT bigint ) FROM PUBLIC;
