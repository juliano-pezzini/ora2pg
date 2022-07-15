-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_vol_dose_diluicao_md (cd_volume_final_p INOUT bigint, qt_dose_ml_p bigint, qt_solucao_p bigint, ds_dose_diluicao_p INOUT text, qt_dose_p bigint, cd_unid_med_dose_p text, ds_rediluir_p INOUT text, qt_solucao_str_p text, ds_material_p text, ds_unid_med_ml_p text) AS $body$
BEGIN

  cd_volume_final_p := coalesce(qt_dose_ml_p, 0) + coalesce(qt_solucao_p, 0);

  ds_dose_diluicao_p := replace(qt_dose_ml_p, '.', ',') || ' ' ||
                        ds_unid_med_ml_p;
  if (qt_dose_ml_p = 0) then
    begin
      ds_dose_diluicao_p := replace(qt_dose_p, '.', ',') || ' ' ||
                            cd_unid_med_dose_p;
    end;
  end if;

  ds_rediluir_p := ds_rediluir_p || Wheb_mensagem_pck.get_texto(307184) || ' '
                   || replace(qt_solucao_str_p, '.', ',') || ' ' ||
                   ds_unid_med_ml_p || ' ' ||
                   Wheb_mensagem_pck.get_texto(309433) || ' ' 
                   || ds_dose_diluicao_p || ' ' ||
                   Wheb_mensagem_pck.get_texto(307090) || ' '
                   || ds_material_p || chr(13) || chr(10);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_vol_dose_diluicao_md (cd_volume_final_p INOUT bigint, qt_dose_ml_p bigint, qt_solucao_p bigint, ds_dose_diluicao_p INOUT text, qt_dose_p bigint, cd_unid_med_dose_p text, ds_rediluir_p INOUT text, qt_solucao_str_p text, ds_material_p text, ds_unid_med_ml_p text) FROM PUBLIC;

