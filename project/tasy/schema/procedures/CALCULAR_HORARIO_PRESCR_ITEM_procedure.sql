-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_horario_prescr_item ( nr_prescricao_p bigint, cd_intervalo_p text, dt_prim_horario_presc_p timestamp, dt_hora_inicio_p timestamp, nr_hora_validade_p bigint, cd_material_p bigint, qt_hora_intervalo_p bigint, qt_min_intervalo_p bigint, nr_intervalo_p INOUT bigint, ds_horarios_p INOUT text, ie_solucao_p text, ds_dose_diferenciada_p text, ie_exclui_hor_dd_zerados_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, ie_elimina_horarios_vig_p text default 'N') AS $body$
DECLARE

 
ds_horarios_aux_w		varchar(2000);


BEGIN 
 
nr_intervalo_p	:= coalesce(nr_intervalo_p,0);
 
SELECT * FROM calcular_horario_prescricao(	nr_prescricao_p, cd_intervalo_p, dt_prim_horario_presc_p, dt_hora_inicio_p, nr_hora_validade_p, cd_material_p, qt_hora_intervalo_p, qt_min_intervalo_p, nr_intervalo_p, ds_horarios_p, ds_horarios_aux_w, ie_solucao_p, ds_dose_diferenciada_p, ie_exclui_hor_dd_zerados_p, cd_procedimento_p, ie_origem_proced_p, nr_seq_proc_interno_p) INTO STRICT nr_intervalo_p, ds_horarios_p, ds_horarios_aux_w;
 
ds_horarios_p	:= ds_horarios_p || ds_horarios_aux_w;
 
-- Exclui horários fora da vigência 
if (ie_elimina_horarios_vig_p = 'S') then 
	ds_horarios_p	:= Eliminar_horarios_vigencia(	ds_horarios_p, 
													cd_intervalo_p, 
													dt_hora_inicio_p, 
													dt_prim_horario_presc_p, 
													qt_hora_intervalo_p, 
													qt_min_intervalo_p, 
													nr_prescricao_p);
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_horario_prescr_item ( nr_prescricao_p bigint, cd_intervalo_p text, dt_prim_horario_presc_p timestamp, dt_hora_inicio_p timestamp, nr_hora_validade_p bigint, cd_material_p bigint, qt_hora_intervalo_p bigint, qt_min_intervalo_p bigint, nr_intervalo_p INOUT bigint, ds_horarios_p INOUT text, ie_solucao_p text, ds_dose_diferenciada_p text, ie_exclui_hor_dd_zerados_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, ie_elimina_horarios_vig_p text default 'N') FROM PUBLIC;
