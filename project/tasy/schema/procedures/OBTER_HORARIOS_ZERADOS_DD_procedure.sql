-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_horarios_zerados_dd ( nr_prescricao_p bigint, nr_seq_item_p bigint, dt_hora_inicio_p timestamp, ds_horarios_p text, hr_prim_horario_p text, ds_dose_dif_p text, ds_horarios_ajustados_p out text ) is /*  ========================================================================================
  *  Objetivo :	Gerar horario da dose diferencia excluidos na prescricao por terem dose zerada.
  *  ========================================================================================
  *  Usuario		| OS		| Descricao
  *  ------------------------------------------------------------------------------------------------------------------------------------
  *  Vhkrausser   	| OS 263574 	| Criacao da rotina
  * 		| 		|
  *  ------------------------------------------------------------------------------------------------------------------------------------
  */

  
/* Vetor  de Doses diferenciadas X Horarios*/

 type rDoses_dd is record (qt_dose varchar(10), ie_possui_horario boolean) AS $body$
DECLARE

dsValor_w 	varchar(30);
i		integer;

BEGIN
dsValor_w := '';
i := 1;
while  i <= length(String_pp) loop
	if (substr(String_pp,i,1) <> ds_separador_pp) then
		dsValor_w	:=  dsValor_w||substr(String_pp,i,1);
	else
		String_pp		:= substr(String_pp,i+1, length(String_pp));
		return;
	end if;
	i:= i+1;
end loop;

String_pp := null;
return;
end;

begin

ds_horarios_ajustados_p := ds_horarios_p;
k := 1;

/*Popupla o vetor  das doses*/

ds_doses_dif_w := ds_dose_dif_p;
while(ds_doses_dif_w IS NOT NULL AND ds_doses_dif_w::text <> '') loop
	vtDose_w[k].qt_dose	:= pushVlString(ds_doses_dif_w, '-');
	k	:= k + 1;
end loop;

ds_horarios_w	:= replace(padroniza_horario_prescr(ds_horarios_p, dt_hora_inicio_p), 'A','');
k := 1;
while(ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') loop
	vtHorario_temp_w[k].ds_hora := pushVlString(ds_horarios_w, ' ');
	k	:= k + 1;
end loop;
k := 1;

/* Executa apenas se faltarem horarios */

if (vtHorario_temp_w.count < vtDose_w.count) then
	/* Gera vetor de horarios com a espacamento para os faltantes */

	for i in 1..vtDose_w.count loop
		if (coalesce(vtDose_w[i].qt_dose,'0') = '0') or (K > vtHorario_temp_w.count)then
			vtHorario_def_w[i].ds_hora	:= null;
			vtDose_w[i].ie_possui_horario	:= false;
		else
			vtHorario_def_w[i].ds_hora	:= vtHorario_temp_w[k].ds_hora;
			k	:= k + 1;
			vtDose_w[i].ie_possui_horario	:= true;
		end if;
	end loop;

	Select	max(cd_intervalo),
		max(cd_material)
	into STRICT	cd_intervalo_w,
		cd_material_w
	from	prescr_material
	where	nr_prescricao 	= nr_prescricao_p
	and	nr_sequencia	= nr_seq_item_p;

	--Calcula novamente os horarios
	select	nr_horas_validade,
		trunc(ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_prescricao, coalesce(hr_prim_horario_p,to_char(coalesce(dt_primeiro_horario,dt_prescricao)))), 'mi'),
		coalesce(dt_primeiro_horario,dt_prescricao)
	into STRICT	nr_horas_validade_w,
		dt_primeiro_horario_w,
		dt_inicio_prescr_w
	from	prescr_medica
	where	nr_prescricao = nr_prescricao_p;
	
	SELECT * FROM Calcular_Horario_Prescricao(nr_prescricao_p, cd_intervalo_w, dt_inicio_prescr_w, dt_primeiro_horario_w, nr_horas_validade_w, cd_material_w, 0, 0, nr_ocorrencias_w, ds_horarios1_w, ds_horarios2_w, 'N', ds_dose_dif_p, 'N') INTO STRICT nr_ocorrencias_w, ds_horarios1_w, ds_horarios2_w;
	ds_horarios_w	:= replace(padroniza_horario_prescr( ds_horarios1_w || ds_horarios2_w, dt_hora_inicio_p), 'A','');

	/* Repopula o vetor com todos os horarios */

	k := 1;
	vtHorario_temp_w.delete;

	while(ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') loop
		vtHorario_temp_w[k].ds_hora := pushVlString(ds_horarios_w, ' ');
		k	:= k + 1;
	end loop;

	/* Preenche os horarios que estavam vazios e gera a saida */

	for i in 1..vtHorario_def_w.count loop
		if (vtHorario_def_w[i]coalesce(.ds_hora::text, '') = '') and (vtHorario_temp_w.count >= i) then
			vtHorario_def_w[i].ds_hora	:= vtHorario_temp_w[i].ds_hora;
		end if;
		ds_horarios_w := ds_horarios_w || vtHorario_def_w[i].ds_hora || ' ';
	end loop;
	ds_horarios_ajustados_p := padroniza_horario_prescr(ds_horarios_w, dt_hora_inicio_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_horarios_zerados_dd ( nr_prescricao_p bigint, nr_seq_item_p bigint, dt_hora_inicio_p timestamp, ds_horarios_p text, hr_prim_horario_p text, ds_dose_dif_p text, ds_horarios_ajustados_p out text ) is  type rDoses_dd is record (qt_dose varchar(10), ie_possui_horario boolean) FROM PUBLIC;
