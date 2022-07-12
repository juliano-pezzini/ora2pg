-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE cpoe_calc_valores_sol_md_pck.calcula_dose_dif_md (ds_dose_dif_p INOUT text, ie_div_padrao_p text, qt_posicao_p INOUT bigint, qt_valor_p INOUT bigint ) AS $body$
BEGIN
    if (substr(ds_dose_dif_p, length(ds_dose_dif_p)-1) <> ie_div_padrao_p) then
      ds_dose_dif_p	:= ds_dose_dif_p || ie_div_padrao_p;
    end if;

    qt_posicao_p := position(ie_div_padrao_p in ds_dose_dif_p);

    qt_valor_p := coalesce((substr(ds_dose_dif_p, 1, qt_posicao_p - 1))::numeric ,0);
  end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_calc_valores_sol_md_pck.calcula_dose_dif_md (ds_dose_dif_p INOUT text, ie_div_padrao_p text, qt_posicao_p INOUT bigint, qt_valor_p INOUT bigint ) FROM PUBLIC;
