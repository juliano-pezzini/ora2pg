-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hsl_obter_se_hor_vigente ( ds_horarios_p text, ie_administracao_p text, dt_inicio_p timestamp, dt_fim_p timestamp, dt_inicial_p timestamp, dt_final_p timestamp) RETURNS varchar AS $body$
DECLARE


ds_hora_w				varchar(07);
ds_horarios_w				varchar(2000);
ds_horarios_fixo_w			varchar(2000);
ie_operacao_w				varchar(1);
mascara_data_w				varchar(10);
ds_horarios_aux_w			varchar(255);
dt_validade_prescr_w			timestamp;
dt_medic_w				timestamp;
dt_horario_w				timestamp;
dt_prescr_w				timestamp;
dt_prescr_w				timestamp;
k					integer;
qt_dia_adic_w				bigint := 0;
qt_pertence_w				bigint;
dt_inicio_prescr_w			timestamp;
qt_min_intervalo_w			double precision;
qt_caracter_espaco_w			integer;
ds_caracter_espaco_w			varchar(10);


BEGIN

if (pkg_date_utils.extract_field('MINUTE', dt_inicio_p, 0) <> 0) or
	((position(':1' in ds_horarios_p) > 0)  or (position(':2' in ds_horarios_p) > 0)  or (position(':3' in ds_horarios_p) > 0)  or (position(':4' in ds_horarios_p) > 0)  or (position(':5' in ds_horarios_p) > 0)) then
	Mascara_data_w 			:= 'hh24:mi';
else
	Mascara_data_w 			:= 'hh24';
end if;

ds_horarios_w	:= replace(replace(replace(ds_horarios_p,'  ',' '),'  ',' '),'  ',' ');

if (ie_administracao_p = 'P') and (dt_fim_p IS NOT NULL AND dt_fim_p::text <> '') and (dt_fim_p < dt_final_p) then
	
	select	padroniza_horario_prescr(ds_horarios_w, to_char(dt_inicial_p,'dd/mm/yyyy hh24:mi:ss')) || ' '
	into STRICT	ds_horarios_w
	;
	
	while (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') LOOP
		begin
		select	position(' ' in ds_horarios_w)
		into STRICT	k
		;
		
		if (k > 1) and ((substr(ds_horarios_w, 1, k -1) IS NOT NULL AND (substr(ds_horarios_w, 1, k -1))::text <> '')) then
			begin
			ds_hora_w		:= substr(ds_horarios_w, 1, k-1);
			ds_hora_w		:= replace(ds_hora_w, ' ','');
			ds_horarios_w		:= substr(ds_horarios_w, k + 1, 2000);
			
			if (position('A' in ds_hora_w) > 0) and (qt_dia_adic_w	= 0) then
				qt_dia_adic_w	:= 1;
			elsif (position('AA' in ds_hora_w) > 0) then
				qt_dia_adic_w	:= qt_dia_adic_w + 1;
			end if;
			ds_hora_w	:= replace(ds_hora_w,'A','');
			ds_hora_w	:= replace(ds_hora_w,'A','');
			
			dt_horario_w	:= 	pkg_date_utils.get_time(dt_inicial_p + qt_dia_adic_w, replace(ds_hora_w,'A',''), 0);
						
			select	count(*)
			into STRICT	qt_pertence_w
			
			where	dt_horario_w >= dt_inicial_p
			and 	dt_horario_w < dt_final_p
			and 	dt_horario_w < dt_fim_p;
			
			if (qt_pertence_w > 0) then
				ds_horarios_fixo_w	:= ds_horarios_fixo_w || to_char(dt_horario_w,Mascara_data_w) ||' ';
			end if;

			end;
		elsif (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') then
			begin
			ds_horarios_w		:= '';
			end;
		end if;
		
		end;
	END LOOP;

	ds_horarios_w	:= ds_horarios_fixo_w;
end if;

return	ds_horarios_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hsl_obter_se_hor_vigente ( ds_horarios_p text, ie_administracao_p text, dt_inicio_p timestamp, dt_fim_p timestamp, dt_inicial_p timestamp, dt_final_p timestamp) FROM PUBLIC;

