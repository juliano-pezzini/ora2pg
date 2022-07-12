-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_volume_sne ( nr_prescricao_p bigint, nr_sequencia_p bigint, cd_unidade_medida_dose_p text, qt_dose_p bigint, cd_material_p bigint) RETURNS bigint AS $body$
DECLARE


qt_dose_w		double precision;
qt_volume_w		double precision;
qt_vol_diluicao_w	double precision;

BEGIN

qt_vol_diluicao_w	:= somente_numero(Obter_Volume_Diluicao(nr_sequencia_p, nr_prescricao_p));

if (upper(cd_unidade_medida_dose_p) = upper(obter_unid_med_usua('ml'))) then
	if (coalesce(qt_vol_diluicao_w,0) > 0) then
		qt_volume_w	:= qt_vol_diluicao_w;
	else
		qt_volume_w	:= qt_dose_p + qt_vol_diluicao_w;
	end if;
else
	if (coalesce(qt_vol_diluicao_w,0) > 0) then
		qt_volume_w	:= qt_vol_diluicao_w;
	else
		select	max(Obter_dose_convertida(cd_material_p, qt_dose_p, cd_unidade_medida_dose_p, obter_unid_med_usua('ml')))
		into STRICT	qt_dose_w
		;

		qt_volume_w	:= qt_dose_w + qt_vol_diluicao_w;
	end if;

end if;

return	qt_volume_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_volume_sne ( nr_prescricao_p bigint, nr_sequencia_p bigint, cd_unidade_medida_dose_p text, qt_dose_p bigint, cd_material_p bigint) FROM PUBLIC;
