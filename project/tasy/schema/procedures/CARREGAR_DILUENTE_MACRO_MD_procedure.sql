-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE carregar_diluente_macro_md (cd_consulta_p bigint, ds_conv_ml_p text, ds_aux_diluir_p text, ds_additional_item_p text, ds_dose_diluicao_p text, ds_material_p text, ds_diluir_p INOUT text) AS $body$
BEGIN

  ds_diluir_p := ds_diluir_p ||
                 wheb_mensagem_pck.get_texto(cd_consulta_p,
                                             'DS_VOLUME=' || ds_conv_ml_p ||
                                             ';DS_TIPO_DIL=' ||
                                             ds_aux_diluir_p ||
                                             ';DS_ADDITIONAL_ITEM=' ||
                                             ds_additional_item_p ||
                                             ';DS_DOSE_DIL=' ||
                                             ds_dose_diluicao_p ||
                                             ';DS_MATERIAL=' ||
                                             ds_material_p) || chr(13) ||
                 chr(10);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE carregar_diluente_macro_md (cd_consulta_p bigint, ds_conv_ml_p text, ds_aux_diluir_p text, ds_additional_item_p text, ds_dose_diluicao_p text, ds_material_p text, ds_diluir_p INOUT text) FROM PUBLIC;
