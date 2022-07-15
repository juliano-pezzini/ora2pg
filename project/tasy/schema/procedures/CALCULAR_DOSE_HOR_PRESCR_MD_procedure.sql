-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_dose_hor_prescr_md ( nr_intervalo_p bigint, ds_horarios_p text, ds_dose_diferenciada_p text, ie_exclui_hor_dd_zerados_p text, ie_dose_diferenciada_p text, ie_operacao_p text, qt_operacao_p bigint, ds_caracter_espaco_w text, dt_hora_inicio_p timestamp, dt_medic_p timestamp, qt_min_intervalo_regra_list_p text, qt_doses_p bigint, ds_dt_prescr_p text, mascara_data_p text, dt_inicio_prescr_p timestamp, nr_hora_validade_p bigint, ie_utiliza_quantidade_p text, qt_min_intervalo_p bigint, qt_dia_adic_p bigint, dt_validade_prescr_p timestamp, qt_hora_intervalo_p INOUT bigint, ds_horarios_out_p INOUT text, nr_intervalo_out_p INOUT bigint, ie_controle_p INOUT bigint, hr_prescricao_out_p INOUT timestamp, qt_dia_adic_out_p INOUT bigint ) AS $body$
WITH RECURSIVE cte AS (
DECLARE

  c01 CURSOR FOR
    SELECT level as id, regexp_substr(qt_min_intervalo_regra_list_p, '[^,]+', 1, level) as val
      
    (regexp_substr(qt_min_intervalo_regra_list_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(qt_min_intervalo_regra_list_p, '[^,]+', 1, level))::text <> '')  UNION ALL
DECLARE

  c01 CURSOR FOR 
    SELECT level as id, regexp_substr(qt_min_intervalo_regra_list_p, '[^,]+', 1, level) as val
      
    (regexp_substr(qt_min_intervalo_regra_list_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(qt_min_intervalo_regra_list_p, '[^,]+', 1, level))::text <> '') JOIN cte c ON ()

) SELECT * FROM cte;
;

	ds_hora_w varchar(07);
	ds_dose_diferenciada_w varchar(255);
	qt_operacao_w real;
	dt_prox_horario_w timestamp;
	ds_horarios_ww varchar(2000);
	ds_horarios_param_w	varchar(2000);
	c01_w c01%rowtype;
	qt_min_interv_regra_result_w bigint := 0;
	qt_min_intervalo_regra_w bigint;
	ie_utiliza_mascara_w varchar(1);
	ie_virgula_w varchar(1);
	ds_dose_w varchar(255);
	ds_hora_aux_w varchar(255);
	ds_horarios_aux_w varchar(255);
	hr_dose_w timestamp;
	if_cont_w integer;
	qt_doses_w integer;
	k integer;
	ds_horarios_fixo_w varchar(2000);
	nr_horas_intervalo_w double precision;
	dt_horario_w timestamp;
	qt_dia_adic_w bigint := 0;
	qt_pertence_w bigint;
BEGIN
	nr_intervalo_out_p := nr_intervalo_p;
	ds_horarios_out_p := ds_horarios_out_p;
	hr_prescricao_out_p := dt_hora_inicio_p;
	ie_controle_p := 0;
	qt_doses_w := qt_doses_p;

	if (ds_dose_diferenciada_p IS NOT NULL AND ds_dose_diferenciada_p::text <> '') and (ie_dose_diferenciada_p in ('O','P','S')) then	
		if (ie_operacao_p	= 'V') then
			qt_hora_intervalo_p	:= (24 / qt_operacao_p);
		elsif (ie_operacao_p	= 'H') then
			qt_hora_intervalo_p	:= qt_operacao_p;
		elsif (ie_operacao_p	= 'X') then
			qt_hora_intervalo_p	:= (24 / qt_operacao_p);
		end if;

		if (ie_operacao_p	= 'V') then
			select	padroniza_horario_md(reordenar_horarios_md(dt_medic_p, ds_horarios_out_p)) || ds_caracter_espaco_w
			into STRICT	ds_horarios_out_p
			;
		end if;

		if (ie_operacao_p	= 'F') or (ie_operacao_p	= 'V') or
			(ie_dose_diferenciada_p = 'S' AND ie_operacao_p	= 'X') then

			ds_horarios_param_w	:= '';
			if (nr_intervalo_out_p > qt_operacao_p) then
				qt_operacao_w	:= nr_intervalo_out_p;
			end if;

			ds_horarios_out_p		:= ds_horarios_out_p || ds_caracter_espaco_w;
			ds_dose_diferenciada_w	:= tiss_substituir_string_md(ds_dose_diferenciada_w,',','') || '-';

			for	z in 1..qt_operacao_p loop
				ds_dose_w		:= substr(ds_dose_diferenciada_w, 1, position('-' in ds_dose_diferenciada_w) - 1);
				ds_dose_diferenciada_w	:= substr(ds_dose_diferenciada_w, position('-' in ds_dose_diferenciada_w) + 1, 255);
				ds_hora_aux_w		:= substr(ds_horarios_out_p, 1, position(ds_caracter_espaco_w in ds_horarios_out_p) - 1);
				ds_horarios_out_p		:= substr(ds_horarios_out_p, position(ds_caracter_espaco_w in ds_horarios_out_p) + 1, 255);

				if (somente_numero_md(ds_dose_w) > 0) or (coalesce(ie_exclui_hor_dd_zerados_p,'S') = 'N') then
					ds_horarios_aux_w := ds_horarios_aux_w || ds_hora_aux_w || ds_caracter_espaco_w;
				end if;
			end loop;
			ds_horarios_out_p	:= ds_horarios_aux_w;
		else
			ds_horarios_out_p	:= '';
			hr_dose_w       := dt_hora_inicio_p;
			ie_virgula_w	:= 'N';
			if_cont_w	:= 0;
			ds_dose_diferenciada_w	:= tiss_substituir_string_md(ds_dose_diferenciada_w,',','') || '-';

			for	x in 1..length(ds_dose_diferenciada_w) loop
				if (substr(ds_dose_diferenciada_w, x, 1) = '-') then
					qt_doses_w	:= qt_doses_w + 1;
					ds_hora_w	:= to_char(hr_dose_w, mascara_data_p);

					if (substr(ds_dose_diferenciada_w, x, 1) <> '0') or (coalesce(ie_exclui_hor_dd_zerados_p,'S') = 'N') then
						ds_horarios_out_p		:= ds_horarios_out_p || ds_hora_w || ds_caracter_espaco_w;
					end if;

					hr_dose_w      		:= hr_dose_w + (qt_hora_intervalo_p / 24);

				end if;
			end loop;
			nr_intervalo_out_p			:= coalesce(qt_doses_w,0);
		end if;

	elsif (ie_operacao_p = 'D') then

		nr_intervalo_out_p		   	:= 1;

		if (coalesce(ds_horarios_out_p::text, '') = '') then
			if (to_char(dt_hora_inicio_p,'mi') = '00') then
				ds_horarios_out_p			:= to_char(dt_hora_inicio_p,'hh24');
			else
				ds_horarios_out_p			:= to_char(dt_hora_inicio_p,'hh24:mi');
			end if;
		else
			ds_horarios_out_p			:= ds_horarios_out_p;
		end if;
	elsif (ie_operacao_p = 'M') then

		nr_intervalo_out_p		:= 1;
		ds_horarios_out_p		:= to_char(dt_hora_inicio_p,'hh24:mi');
		dt_prox_horario_w	:= to_date(ds_dt_prescr_p ||' '||to_char(dt_hora_inicio_p,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');

		open c01;
		loop
		fetch c01 into c01_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			qt_min_intervalo_regra_w := ((c01_w.val)::numeric );
			nr_intervalo_out_p	:= nr_intervalo_out_p + 1;
			dt_prox_horario_w := dt_prox_horario_w + (qt_min_intervalo_regra_w/1440);
			ds_horarios_out_p	:= ds_horarios_out_p || ds_caracter_espaco_w || to_char(dt_prox_horario_w,'hh24:mi');		
		end loop;
		close c01;

	elsif (ie_operacao_p = 'F') and (ds_horarios_out_p IS NOT NULL AND ds_horarios_out_p::text <> '') then
		begin
				nr_intervalo_out_p		   	:= qt_operacao_p;
		end;
	elsif (ie_operacao_p = 'V') and (ds_horarios_out_p IS NOT NULL AND ds_horarios_out_p::text <> '') then
		begin

		ie_utiliza_mascara_w	:= 'S';
		if (position(':' in ds_horarios_out_p) = 0) then
			ie_utiliza_mascara_w	:= 'N';
		end if;
		ds_horarios_ww := replace(replace(replace(ds_horarios_out_p,'  ',' '),'  ',' '),'  ',' ');
		select	padroniza_horario_prescr_md(reordenar_horarios_md(dt_medic_p,ds_horarios_ww), to_char(dt_inicio_prescr_p,'dd/mm/yyyy hh24:mi:ss')) || ds_caracter_espaco_w
		into STRICT	ds_horarios_out_p
		;


		nr_intervalo_out_p	:= 0;

		while	(ds_horarios_out_p IS NOT NULL AND ds_horarios_out_p::text <> '') loop
			begin
			select	position(' ' in ds_horarios_out_p)
			into STRICT	k
			;

			if (k > 1) and ((substr(ds_horarios_out_p, 1, k -1) IS NOT NULL AND (substr(ds_horarios_out_p, 1, k -1))::text <> '')) then
				begin
				ds_hora_w := substr(ds_horarios_out_p, 1, k-1);
				ds_hora_w := replace(ds_hora_w, ds_caracter_espaco_w, '');
				ds_horarios_out_p := substr(ds_horarios_out_p, k + 1, 2000);

				if (ie_controle_p = 0) and (ds_hora_w < to_char(dt_inicio_prescr_p,'hh24:mi')) then
					qt_dia_adic_w := 1;
				elsif (position('A' in ds_hora_w) > 0) and (qt_dia_adic_p = 0) then
					qt_dia_adic_w := 1;
				elsif (position('AA' in ds_hora_w) > 0) then
					qt_dia_adic_w := qt_dia_adic_w + 1;
				end if;
				ie_controle_p := 1;
				ds_hora_w := replace(ds_hora_w,'A','');
				ds_hora_w := replace(ds_hora_w,'A','');

				dt_horario_w := to_date(to_char(dt_inicio_prescr_p + qt_dia_adic_w,'dd/mm/yyyy')||' '||replace(ds_hora_w,'A','')||':00','dd/mm/yyyy hh24:mi:ss');
				qt_dia_adic_out_p := qt_dia_adic_w;
				select	count(*)
				into STRICT	qt_pertence_w
				
				where	dt_horario_w >= dt_medic_p
				and 	dt_horario_w < dt_validade_prescr_p;

				if (qt_pertence_w > 0) then
					begin
					if (ie_utiliza_mascara_w	= 'N') then
						ds_hora_w	:= substr(ds_hora_w,1,2);
					end if;
					ds_horarios_fixo_w	:= ds_horarios_fixo_w || ds_hora_w ||ds_caracter_espaco_w;
					nr_intervalo_out_p		:= nr_intervalo_out_p + 1;
					end;
				end if;

				end;
			elsif (ds_horarios_out_p IS NOT NULL AND ds_horarios_out_p::text <> '') then
				begin
				ds_horarios_out_p		:= '';
				end;
			end if;

			end;
		end loop;
		ds_horarios_out_p	:= ds_horarios_fixo_w;
		end;
	else
		begin
					if (nr_intervalo_out_p > 0) then
				if (ie_operacao_p = 'H') then
					nr_horas_intervalo_w := qt_operacao_p;
				else
					if (coalesce(ie_utiliza_quantidade_p,'N') = 'N') then
						nr_horas_intervalo_w := trunc(nr_hora_validade_p / nr_intervalo_out_p);
					else
						nr_horas_intervalo_w := nr_intervalo_out_p;
					end if;
				end if;
			elsif (ie_operacao_p = 'H') then
				begin
					nr_horas_intervalo_w := qt_operacao_p;
					nr_intervalo_out_p := ceil(nr_hora_validade_p / nr_horas_intervalo_w);
				end;
			elsif (ie_operacao_p = 'X') then
				begin
					if (coalesce(ie_utiliza_quantidade_p,'N') = 'N') then
						nr_intervalo_out_p := ceil(nr_hora_validade_p / (24 / qt_operacao_p));
					else
						nr_intervalo_out_p := qt_operacao_p;
					end if;				
					nr_horas_intervalo_w := floor(24/qt_operacao_p);				
					if (coalesce(qt_min_intervalo_p,0) > 0) and (nr_horas_intervalo_w >= floor(dividir(qt_min_intervalo_p,60))) then
						nr_horas_intervalo_w := qt_min_intervalo_p / 60;
					end if;

					if (nr_intervalo_out_p = 0) or (coalesce(nr_intervalo_out_p::text, '') = '') then
						nr_intervalo_out_p := 1;
					end if;
				end;
			else
				begin
					nr_intervalo_out_p := 1;
					nr_horas_intervalo_w := 0;
				end;
			end if;


			ds_horarios_out_p := '';
			hr_prescricao_out_p := dt_hora_inicio_p;

			for i in 1.. nr_intervalo_out_p loop
				begin
					ds_hora_w := to_char(hr_prescricao_out_p, mascara_data_p);
					ds_horarios_out_p := ds_horarios_out_p || ds_hora_w || ds_caracter_espaco_w;

					hr_prescricao_out_p := hr_prescricao_out_p + (nr_horas_intervalo_w / 24);

				end;
			end loop;
		end;
	end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_dose_hor_prescr_md ( nr_intervalo_p bigint, ds_horarios_p text, ds_dose_diferenciada_p text, ie_exclui_hor_dd_zerados_p text, ie_dose_diferenciada_p text, ie_operacao_p text, qt_operacao_p bigint, ds_caracter_espaco_w text, dt_hora_inicio_p timestamp, dt_medic_p timestamp, qt_min_intervalo_regra_list_p text, qt_doses_p bigint, ds_dt_prescr_p text, mascara_data_p text, dt_inicio_prescr_p timestamp, nr_hora_validade_p bigint, ie_utiliza_quantidade_p text, qt_min_intervalo_p bigint, qt_dia_adic_p bigint, dt_validade_prescr_p timestamp, qt_hora_intervalo_p INOUT bigint, ds_horarios_out_p INOUT text, nr_intervalo_out_p INOUT bigint, ie_controle_p INOUT bigint, hr_prescricao_out_p INOUT timestamp, qt_dia_adic_out_p INOUT bigint ) FROM PUBLIC;

