-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_horario_padrao_dd ( dt_hora_inicio_p timestamp, ie_operacao_p text, ie_reordena_fixo_p text, ds_horario_p INOUT text, ds_dose_dif_p INOUT text) is type rhorario_dd is record (ds_hora varchar(10), qt_dose varchar(10), ie_usado varchar(1)) AS $body$
DECLARE

dsvalor_w 	varchar(30);
i		integer;

BEGIN
dsvalor_w := '';
i := 1;
while  i <= length(string_pp) loop
	if (substr(string_pp,i,1) <> ds_separador_pp) then
		dsvalor_w	:=  dsvalor_w||substr(string_pp,i,1);
	else
		string_pp		:= substr(string_pp,i+1, length(string_pp));
		return;
	end if;
	i:= i+1;
end loop;
string_pp := null;
return;
end;

function getPositionHorario( ds_horario_pp	varchar2) return;
		return;
	end if;
end loop;
return;
end;
begin
if (ie_reordena_fixo_p	= 'S') and (ie_operacao_p		= 'F') and (ds_dose_dif_p IS NOT NULL AND ds_dose_dif_p::text <> '') then
	ds_dose_dif_w := replace(ds_dose_dif_p,' ','');
	k	:= 1;
	ds_horario_w := replace(padroniza_horario_prescr(ds_horario_p, dt_hora_inicio_p), 'A','');
	ds_horario_ww := ds_horario_w;
	while(ds_dose_dif_w IS NOT NULL AND ds_dose_dif_w::text <> '') and (k < 100) loop
		vthorario_dose_atual_w[k].qt_dose := pushVlString(ds_dose_dif_w, '-');
		if (coalesce(vthorario_dose_atual_w[k].qt_dose,'0') <> '0') then
			vthorario_dose_atual_w[k].ds_hora := pushVlString(ds_horario_ww, ' ');
			vthorario_dose_atual_w[k].ie_usado := 'N';
		else
			vthorario_dose_atual_w[k].ds_hora := null;
			vthorario_dose_atual_w[k].ie_usado := 'S';
		end if;

		k := k +1;
		ds_w := ds_w||ds_dose_dif_w ||'  && ';
	end loop;
	ds_horarios_ordenados_w := replace(padroniza_horario_prescr(reordenar_horarios( dt_hora_inicio_p, ds_horario_p), dt_hora_inicio_p), 'A','');
	k	:= 1;
	while(ds_horarios_ordenados_w IS NOT NULL AND ds_horarios_ordenados_w::text <> '') and (k < 100)  loop
		ds_hora_w	:= pushVlString(ds_horarios_ordenados_w, ' ');
		pos_hor_w	:= getPositionHorario(ds_hora_w);
		if (pos_hor_w IS NOT NULL AND pos_hor_w::text <> '') then
			vthorario_dose_ordenado_w[k].ds_hora := ds_hora_w;
			vthorario_dose_ordenado_w[k].qt_dose := vthorario_dose_atual_w[pos_hor_w].qt_dose;
			k := k +1;
		end if;
	end loop;
	ds_horario_p	:= '';
	ds_dose_dif_p	:= '';
	for i in 1..vthorario_dose_ordenado_w.count loop
		ds_horario_p	:= ds_horario_p  || vthorario_dose_ordenado_w[i].ds_hora||' ';
		ds_dose_dif_p	:= ds_dose_dif_p || vthorario_dose_ordenado_w[i].qt_dose||'-';
	end loop;
	ds_horario_p	:= padroniza_horario_prescr(ds_horario_p, dt_hora_inicio_p);
	ds_dose_dif_p	:= substr(ds_dose_dif_p,1, length(ds_dose_dif_p)-1);
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_horario_padrao_dd ( dt_hora_inicio_p timestamp, ie_operacao_p text, ie_reordena_fixo_p text, ds_horario_p INOUT text, ds_dose_dif_p INOUT text) is type rhorario_dd is record (ds_hora varchar(10), qt_dose varchar(10), ie_usado varchar(1)) FROM PUBLIC;

