-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE verificar_se_validade_md ( ds_dose_diferenciada_p text, ie_dose_diferenciada_p text, ie_operacao_p text, dt_medic_p timestamp, ds_caracter_espaco_p text, dt_inicio_prescr_p timestamp, dt_validade_prescr_p timestamp, ds_horarios_fixo_p text, nr_intervalo_p INOUT bigint, ds_horarios_p INOUT text ) AS $body$
DECLARE


ds_hora_w                  varchar(7);
ie_controle_w              smallint := 0;
qt_dia_adic_w              bigint := 0;
ds_horarios_fixo_aux_w     varchar(255) := ds_horarios_fixo_p;
k                          integer;
dt_horario_w               timestamp;


BEGIN
if (ds_dose_diferenciada_p IS NOT NULL AND ds_dose_diferenciada_p::text <> '') and (ie_dose_diferenciada_p in ('O','P','S')) and (ie_operacao_p	= 'V') then
	begin
	ds_horarios_p	:= padroniza_horario_md(reordenar_horarios_md(dt_medic_p, ds_horarios_p)) || ds_caracter_espaco_p;

	nr_Intervalo_p	:= 0;
	
	while (ds_horarios_p IS NOT NULL AND ds_horarios_p::text <> '') LOOP
		begin
		k	:= position(ds_caracter_espaco_p in ds_horarios_p);
		
		if (k > 1) and ((substr(ds_horarios_p, 1, k -1) IS NOT NULL AND (substr(ds_horarios_p, 1, k -1))::text <> '')) then
			begin
			ds_hora_w		:= substr(ds_horarios_p, 1, k-1);
			ds_hora_w		:= replace(ds_hora_w, ds_caracter_espaco_p,'');
			ds_horarios_p		:= substr(ds_horarios_p, k + 1, 2000);
			
			if (ie_controle_w = 0) and (ds_hora_w < to_char(dt_inicio_prescr_p,'hh24:mi')) then
				qt_dia_adic_w	:= 1;
			elsif (position('A' in ds_hora_w) > 0) and (qt_dia_adic_w = 0) then
				qt_dia_adic_w	:= 1;
			elsif (position('AA' in ds_hora_w) > 0) then
				qt_dia_adic_w	:= qt_dia_adic_w + 1;
			end if;
			ie_controle_w	:= 1;
			ds_hora_w	:= replace(ds_hora_w,'A','');
			ds_hora_w	:= replace(ds_hora_w,'A','');

			dt_horario_w	:= to_date(to_char(dt_inicio_prescr_p + qt_dia_adic_w,'dd/mm/yyyy')||' '||replace(ds_hora_w,'A','')||':00','dd/mm/yyyy hh24:mi:ss');
			
			if (dt_horario_w >= dt_medic_p) and (dt_horario_w < dt_validade_prescr_p) then
				begin
				ds_horarios_fixo_aux_w	:= ds_horarios_fixo_aux_w || ds_hora_w ||ds_caracter_espaco_p;
				nr_Intervalo_p		:= nr_Intervalo_p + 1;
				end;
			end if;

			end;
		elsif (ds_horarios_p IS NOT NULL AND ds_horarios_p::text <> '') then
			begin
			ds_horarios_p		:= '';
			end;
		end if;
		
		end;
	end loop;

	ds_horarios_p	:= ds_horarios_fixo_aux_w;
	end;
end if;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verificar_se_validade_md ( ds_dose_diferenciada_p text, ie_dose_diferenciada_p text, ie_operacao_p text, dt_medic_p timestamp, ds_caracter_espaco_p text, dt_inicio_prescr_p timestamp, dt_validade_prescr_p timestamp, ds_horarios_fixo_p text, nr_intervalo_p INOUT bigint, ds_horarios_p INOUT text ) FROM PUBLIC;
