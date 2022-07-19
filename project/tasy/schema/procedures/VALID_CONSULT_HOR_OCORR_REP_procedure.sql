-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE valid_consult_hor_ocorr_rep ( ds_horarios_p text, cd_intervalo_p text, dt_inicio_prescr_p timestamp, dt_prim_horario_p timestamp, qt_hora_intervalo_p bigint, qt_min_intervalo_p bigint, nr_prescricao_p bigint, ie_urgencia_p text, dt_prev_execucao_p timestamp, ds_horarios_out_p INOUT text, nr_ocorrencia_p INOUT bigint) AS $body$
DECLARE


ds_horarios_w	varchar(2000);
nr_ocorrencia_w	double precision;

BEGIN
if (ds_horarios_p IS NOT NULL AND ds_horarios_p::text <> '') and (cd_intervalo_p IS NOT NULL AND cd_intervalo_p::text <> '') and (dt_inicio_prescr_p IS NOT NULL AND dt_inicio_prescr_p::text <> '') and (dt_prim_horario_p IS NOT NULL AND dt_prim_horario_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (ie_urgencia_p IS NOT NULL AND ie_urgencia_p::text <> '') and (dt_prev_execucao_p IS NOT NULL AND dt_prev_execucao_p::text <> '') then
	begin

	ds_horarios_w := eliminar_hor_vigencia_proc(
				ds_horarios_p,
				cd_intervalo_p,
				dt_inicio_prescr_p,
				dt_prim_horario_p,
				qt_hora_intervalo_p,
				qt_min_intervalo_p,
				nr_prescricao_p,
				ie_urgencia_p,
				dt_prev_execucao_p);

	if (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') then
		begin
		nr_ocorrencia_w := obter_ocorrencias_horarios_rep(ds_horarios_w);
		end;
	end if;
	end;
end if;
ds_horarios_out_p	:= ds_horarios_w;
nr_ocorrencia_p		:= nr_ocorrencia_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE valid_consult_hor_ocorr_rep ( ds_horarios_p text, cd_intervalo_p text, dt_inicio_prescr_p timestamp, dt_prim_horario_p timestamp, qt_hora_intervalo_p bigint, qt_min_intervalo_p bigint, nr_prescricao_p bigint, ie_urgencia_p text, dt_prev_execucao_p timestamp, ds_horarios_out_p INOUT text, nr_ocorrencia_p INOUT bigint) FROM PUBLIC;

