-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_dosagem_med ( cd_material_p bigint, qt_dose_p INOUT bigint, cd_unid_med_dose_p text, qt_dose_diluente_p bigint, qt_peso_p bigint, qt_dose_manutencao_p INOUT bigint, ie_unidade_manutencao_p text, qt_velocidade_p INOUT bigint, ie_unidade_p text) AS $body$
DECLARE


qt_vol_total_w			double precision;
qt_concent_med_w		double precision;
qt_concent_med_mg_w		double precision;
qt_concent_med_ml_w		double precision := 1;
qt_concent_dose_total_w		double precision;
qt_velocidade_w			double precision;
qt_dose_w			double precision;
qt_dose_peso_w			double precision;
qt_dose_mg_w			double precision;
qt_dose_direta_w		double precision;
qt_dose_ml_w			double precision;
cd_unid_med_concetracao_w	varchar(30);
cd_unid_med_base_conc_w		varchar(30);


BEGIN

qt_dose_p	:= obter_conversao_ml(cd_material_p,qt_dose_p,cd_unid_med_dose_p);
qt_vol_total_w	:= qt_dose_p + qt_dose_diluente_p;

select	max(coalesce(qt_conversao_mg,1)),
	max(upper(cd_unid_med_concetracao)),
	max(upper(cd_unid_med_base_conc))
into STRICT	qt_concent_med_w,
	cd_unid_med_concetracao_w,
	cd_unid_med_base_conc_w
from	material
where	cd_material	= cd_material_p;

/*Converter concentração para mg/ml*/

if (cd_unid_med_concetracao_w = 'KG') then
	qt_concent_med_mg_w	:= qt_concent_med_w * 1000 * 1000;
elsif (cd_unid_med_concetracao_w = 'G') then
	qt_concent_med_mg_w	:= qt_concent_med_w * 1000;
elsif (cd_unid_med_concetracao_w = 'MCG') then
	qt_concent_med_mg_w	:= dividir(qt_concent_med_w,1000);
elsif (cd_unid_med_concetracao_w = 'MG') then
	qt_concent_med_mg_w	:= qt_concent_med_w;
end if;

if (cd_unid_med_base_conc_w = 'L') then
	qt_concent_med_ml_w	:= qt_concent_med_w * 1000;
end if;

qt_concent_med_w	:= dividir(qt_concent_med_mg_w,qt_concent_med_ml_w) * qt_dose_p;

/*Obter a concentração da dose total com base na unidade selecionada pelo médico */

if (position('MCG' in ie_unidade_manutencao_p) > 0) then
	qt_concent_dose_total_w	:= dividir(qt_concent_med_w,qt_vol_total_w) * 1000;
elsif (position('MG' in ie_unidade_manutencao_p) > 0) then
	qt_concent_dose_total_w	:= dividir(qt_concent_med_w,qt_vol_total_w);
end if;

if (qt_dose_manutencao_p <> 0) then
	begin
	qt_dose_direta_w	:= qt_dose_manutencao_p;

	/*Conversão p/ unidade direta do elemento se for por peso*/

	if (position('KG' in ie_unidade_manutencao_p) > 0) then
		qt_dose_direta_w	:= qt_peso_p * qt_dose_manutencao_p;
	end if;

	qt_dose_ml_w	:= dividir(qt_dose_direta_w,qt_concent_dose_total_w);

	if (position('/MIN' in ie_unidade_manutencao_p) > 0) or (position('/H' in ie_unidade_manutencao_p) > 0) then
		begin
		/*Transformar em ml/hora */

		if (upper(ie_unidade_p) = 'MLH') then
			if (position('MIN' in ie_unidade_manutencao_p) > 0) then
				qt_dose_ml_w	:= qt_dose_ml_w * 60;
			end if;
		end if;

		/*Transformar em gotas/minuto */

		if (upper(ie_unidade_p) = 'GTM') then
			qt_dose_ml_w	:= qt_dose_ml_w * 20;
			if (position('/H' in ie_unidade_manutencao_p) > 0) then
				qt_dose_ml_w	:= dividir(qt_dose_ml_w,60);
			end if;
		end if;

		/*Transformar em microgotas/minuto */

		if (upper(ie_unidade_p) = 'MGM') then
			qt_dose_ml_w	:= qt_dose_ml_w * 60;
			if (position('/H' in ie_unidade_manutencao_p) > 0) then
				qt_dose_ml_w	:= dividir(qt_dose_ml_w,60);
			end if;
		end if;
		qt_velocidade_p	:= qt_dose_ml_w;
		end;
	else
		qt_velocidade_p	:= qt_dose_ml_w;
	end if;
	end;
else
	begin
	qt_velocidade_w		:= qt_velocidade_p;
	if (upper(ie_unidade_p) = 'GTM') then
		qt_velocidade_w	:= dividir(qt_velocidade_p,20) * 60;
	end if;

	qt_dose_manutencao_p	:= qt_concent_dose_total_w * qt_velocidade_w;
	if (position('KG' in ie_unidade_manutencao_p) > 0) then
		qt_dose_manutencao_p	:= dividir(qt_dose_manutencao_p,qt_peso_p);
	end if;
	if (position('MIN' in ie_unidade_manutencao_p) > 0) then
		qt_dose_manutencao_p	:= dividir(qt_dose_manutencao_p,60);
	end if;
	end;
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_dosagem_med ( cd_material_p bigint, qt_dose_p INOUT bigint, cd_unid_med_dose_p text, qt_dose_diluente_p bigint, qt_peso_p bigint, qt_dose_manutencao_p INOUT bigint, ie_unidade_manutencao_p text, qt_velocidade_p INOUT bigint, ie_unidade_p text) FROM PUBLIC;
