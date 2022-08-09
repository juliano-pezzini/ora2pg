-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE presc_medic_horario_focuslost ( ds_horario_p text, nr_prescricao_p bigint, cd_intervalo_p text, dt_prim_horario_presc_p timestamp, nr_hora_validade_p bigint, cd_material_p bigint, qt_hora_intervalo_p bigint, qt_min_intervalo_p bigint, ie_solucao_p text, ds_dose_diferenciada_p text, nr_intervalo_p INOUT bigint, ds_horarios_p INOUT text, ds_horarios2_p INOUT text, ds_retorno_p INOUT text, nr_seq_item_p bigint) AS $body$
DECLARE


ds_retorno_w	varchar(5) := '';
nr_intervalo_w	smallint := 0;
ds_horarios_w	varchar(2000) := '';
ds_horarios2_w	varchar(2000) := '';
ds_hora_w		timestamp;
ie_tipo_item_w	varchar(1);



BEGIN

if (ds_horario_p IS NOT NULL AND ds_horario_p::text <> '') then
	
	ds_retorno_w := formatar_primeiro_horario(ds_horario_p, ds_retorno_w);

	if (ds_retorno_w <> 'N')then
		begin
		
		nr_intervalo_w 	:= nr_intervalo_p;
		ds_horarios_w 	:= ds_horarios_p;
	
		select	to_date('18/12/1899 ' || ds_retorno_w || ':00', 'dd/mm/yyyy hh24:mi:ss')
		into STRICT	ds_hora_w
		;
		
		select 	CASE WHEN ie_Solucao_p='N' THEN  'M'  ELSE null END
		into STRICT	ie_tipo_item_w	
		;
		
		SELECT * FROM calcular_horario_prescricao(nr_prescricao_p, cd_intervalo_p, dt_prim_horario_presc_p, ds_hora_w, nr_hora_validade_p, cd_material_p, qt_hora_intervalo_p, qt_min_intervalo_p, nr_intervalo_w, ds_horarios_w, ds_horarios2_w, ie_Solucao_p, ds_dose_diferenciada_p, null, null, null, null, ie_tipo_item_w, nr_seq_item_p) INTO STRICT nr_intervalo_w, ds_horarios_w, ds_horarios2_w;
		
		end;
	end if;
	
elsif ((trim(both ds_horarios_p) IS NOT NULL AND (trim(both ds_horarios_p))::text <> '')) and (obter_funcao_ativa = 7010) then
	
	  nr_intervalo_w := obter_ocorrencias_horarios_rep(ds_horarios_p);
end if;	

ds_retorno_p 	:= ds_retorno_w;
nr_intervalo_p	:= nr_intervalo_w;
ds_horarios_p	:= ds_horarios_w;
ds_horarios2_p	:= ds_horarios2_w;
	
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE presc_medic_horario_focuslost ( ds_horario_p text, nr_prescricao_p bigint, cd_intervalo_p text, dt_prim_horario_presc_p timestamp, nr_hora_validade_p bigint, cd_material_p bigint, qt_hora_intervalo_p bigint, qt_min_intervalo_p bigint, ie_solucao_p text, ds_dose_diferenciada_p text, nr_intervalo_p INOUT bigint, ds_horarios_p INOUT text, ds_horarios2_p INOUT text, ds_retorno_p INOUT text, nr_seq_item_p bigint) FROM PUBLIC;
