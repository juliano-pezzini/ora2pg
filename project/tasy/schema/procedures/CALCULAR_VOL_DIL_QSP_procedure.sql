-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_vol_dil_qsp ( nr_prescricao_p bigint, nr_seq_itm_principal_p bigint, qt_qsp_diluente_p bigint, cd_unidade_medida_dil_p text, cd_material_diluente_p bigint, qt_dose_diluente_p INOUT bigint, ds_erro_p INOUT text) AS $body$
DECLARE


qt_vol_ml_medic_w	double precision;
qt_vol_ml_dil_w		double precision;

BEGIN

qt_vol_ml_medic_w	:= obter_volume_ml_medic_agrup( nr_prescricao_p, nr_seq_itm_principal_p, 'N');

qt_vol_ml_dil_w		:= obter_dose_convertida(cd_material_diluente_p, qt_qsp_diluente_p, cd_unidade_medida_dil_p, lower(obter_unid_med_usua('ml')));

if (qt_vol_ml_dil_w < qt_vol_ml_medic_w) and (coalesce(qt_qsp_diluente_p,0) > 0)then
	ds_erro_p	:= wheb_mensagem_pck.get_texto(278812);
end if;

qt_dose_diluente_p	:= obter_dose_convertida(cd_material_diluente_p, qt_vol_ml_dil_w - qt_vol_ml_medic_w, lower(obter_unid_med_usua('ml')), cd_unidade_medida_dil_p);

if (qt_dose_diluente_p <= 0) then
	qt_dose_diluente_p := null;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_vol_dil_qsp ( nr_prescricao_p bigint, nr_seq_itm_principal_p bigint, qt_qsp_diluente_p bigint, cd_unidade_medida_dil_p text, cd_material_diluente_p bigint, qt_dose_diluente_p INOUT bigint, ds_erro_p INOUT text) FROM PUBLIC;

