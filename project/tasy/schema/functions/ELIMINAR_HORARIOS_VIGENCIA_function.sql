-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION eliminar_horarios_vigencia ( ds_horarios_p text, cd_intervalo_p text, dt_Hora_Inicio_p timestamp, dt_prim_horario_presc_p timestamp, qt_hora_intervalo_p bigint, qt_min_intervalo_p bigint, nr_prescricao_p bigint) RETURNS varchar AS $body$
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
k					integer;
qt_dia_adic_w				bigint := 0;
qt_pertence_w				bigint;
dt_inicio_prescr_w			timestamp;
qt_min_intervalo_w			double precision;
qt_caracter_espaco_w			integer;
ds_caracter_espaco_w			varchar(10);


BEGIN

qt_min_intervalo_w	:= (coalesce(qt_hora_intervalo_p,0) * 60) + coalesce(qt_min_intervalo_p,0);

select	pkg_date_utils.start_of(coalesce(dt_inicio_prescr,dt_prescricao),'DD',0),
	coalesce(dt_validade_prescr,dt_prescricao + nr_horas_validade/24),
	dt_inicio_prescr,
	coalesce(qt_caracter_espaco,1)
into STRICT	dt_prescr_w,
	dt_validade_prescr_w,
	dt_inicio_prescr_w,
	qt_caracter_espaco_w
from	prescr_medica
where	nr_prescricao	= nr_prescricao_p;

ds_caracter_espaco_w	:= ' ';
if (qt_caracter_espaco_w = 2) then
	ds_caracter_espaco_w	:= '  ';
elsif (qt_caracter_espaco_w = 3) then
	ds_caracter_espaco_w	:= '   ';
elsif (qt_caracter_espaco_w = 4) then
	ds_caracter_espaco_w	:= '    ';
elsif (qt_caracter_espaco_w > 4) then
	ds_caracter_espaco_w	:= '     ';
end if;

dt_medic_w := ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_prescr_w, dt_Hora_Inicio_p);

if (to_char(dt_prim_horario_presc_p,'hh24:mi') > to_char(dt_Hora_Inicio_p,'hh24:mi')) then
	dt_medic_w	:= dt_medic_w + 1;
end if;

select	coalesce(max(ie_operacao),'')
into STRICT	ie_operacao_w
from	intervalo_prescricao
where	cd_intervalo = cd_intervalo_p;

if (pkg_date_utils.extract_field('MINUTE', dt_Hora_Inicio_p, 0) <> 0) or
	((coalesce(qt_min_intervalo_w,0) > 0) and (ie_operacao_w = 'X')) or
	((position(':1' in ds_horarios_p) > 0)  or (position(':2' in ds_horarios_p) > 0)  or (position(':3' in ds_horarios_p) > 0)  or (position(':4' in ds_horarios_p) > 0)  or (position(':5' in ds_horarios_p) > 0)) then
	Mascara_data_w 			:= 'hh24:mi';
else
	Mascara_data_w 			:= 'hh24';
end if;

ds_horarios_w	:= replace(replace(replace(ds_horarios_p,'  ',' '),'  ',' '),'  ',' ');


if (ds_horarios_w <> 'ACM') and (ds_horarios_w <> 'SN') then
	
	select	padroniza_horario_prescr(ds_horarios_w, to_char(dt_inicio_prescr_w,'dd/mm/yyyy hh24:mi:ss')) || ' '
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

			dt_horario_w	:= 	pkg_date_utils.get_time(
						dt_inicio_prescr_w + qt_dia_adic_w,
						replace(ds_hora_w,'A',''),
						0);

			select	count(*)
			into STRICT	qt_pertence_w
			
			where	dt_horario_w >= dt_inicio_prescr_w--dt_medic_w 
			and 	dt_horario_w < dt_validade_prescr_w;

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

	ds_horarios_w	:= replace(ds_horarios_fixo_w,' ',ds_caracter_espaco_w);
end if;

return	ds_horarios_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION eliminar_horarios_vigencia ( ds_horarios_p text, cd_intervalo_p text, dt_Hora_Inicio_p timestamp, dt_prim_horario_presc_p timestamp, qt_hora_intervalo_p bigint, qt_min_intervalo_p bigint, nr_prescricao_p bigint) FROM PUBLIC;
