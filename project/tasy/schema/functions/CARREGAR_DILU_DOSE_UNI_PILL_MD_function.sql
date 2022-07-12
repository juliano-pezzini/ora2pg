-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION carregar_dilu_dose_uni_pill_md (cd_unid_med_dose_p text, ds_unit_pill_p text, qt_dose_p bigint, qt_dose_mat_str_p text, ds_volume_ml_p text, ds_aux_diluir_p text, ds_additional_item_p text, ds_dose_diluicao_p text, ds_material_p text) RETURNS varchar AS $body$
DECLARE


  ds_retorno_w varchar(5000);

BEGIN

  ds_retorno_w := wheb_mensagem_pck.get_texto(307092) || ' ';
  if (cd_unid_med_dose_p = ds_unit_pill_p) then
    ds_retorno_w := ds_retorno_w || qt_dose_p || ' ' || ds_unit_pill_p;

  else
    ds_retorno_w := ds_retorno_w || qt_dose_mat_str_p || ' ' ||
                    ds_volume_ml_p;
  end if;

  ds_retorno_w := ds_retorno_w || ds_aux_diluir_p || ds_additional_item_p || ' ';

  ds_retorno_w := ds_retorno_w || wheb_mensagem_pck.get_texto(307087) || ' ' ||
                  ds_dose_diluicao_p || ' ';

  ds_retorno_w := ds_retorno_w || wheb_mensagem_pck.get_texto(307090) || ' ' ||
                  ds_material_p || chr(10);

  return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION carregar_dilu_dose_uni_pill_md (cd_unid_med_dose_p text, ds_unit_pill_p text, qt_dose_p bigint, qt_dose_mat_str_p text, ds_volume_ml_p text, ds_aux_diluir_p text, ds_additional_item_p text, ds_dose_diluicao_p text, ds_material_p text) FROM PUBLIC;
