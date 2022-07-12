-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_sol_vig_adep ( nr_prescricao_p bigint, ie_status_p text, qt_hora_anterior_p bigint, qt_hora_adicional_p bigint, dt_filtro_p timestamp, dt_suspensao_p timestamp, dt_status_p timestamp) RETURNS varchar AS $body$
DECLARE

			
ie_vigente_w			varchar(1) := 'N';
dt_inicio_prescr_w		timestamp;
dt_validade_prescr_w	timestamp;
dt_inicial_w			timestamp;
dt_final_w				timestamp;
dt_filtro_w				timestamp := dt_filtro_p;
			

BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then
		
	select	max(dt_inicio_prescr),
			max(dt_validade_prescr)
	into STRICT	dt_inicio_prescr_w,
			dt_validade_prescr_w
	from	prescr_medica
	where	nr_prescricao = nr_prescricao_p;
		
	if (dt_filtro_p IS NOT NULL AND dt_filtro_p::text <> '') then		
		dt_inicial_w := dt_filtro_p;		
	elsif (qt_hora_anterior_p > 0) then		
		select	to_date(to_char(trunc(clock_timestamp() - qt_hora_anterior_p/24, 'hh24'), 'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
		into STRICT	dt_inicial_w
		;
	else
		select	to_date(to_char(trunc(clock_timestamp(), 'hh24'), 'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
		into STRICT	dt_inicial_w
		;	
	end if;
	
	if (dt_filtro_p IS NOT NULL AND dt_filtro_p::text <> '') then			
		dt_final_w := to_date(to_char(trunc(dt_filtro_w + qt_hora_adicional_p/24, 'hh24'), 'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
	elsif (qt_hora_adicional_p > 0) then
		select	to_date(to_char(trunc(clock_timestamp() + qt_hora_adicional_p/24, 'hh24'), 'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
		into STRICT	dt_final_w
		;
	else
		select	to_date(to_char(trunc(clock_timestamp(), 'hh24'), 'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
		into STRICT	dt_final_w
		;
	end if;
	
	if (coalesce(dt_filtro_p::text, '') = '') and (dt_inicio_prescr_w between dt_inicial_w and dt_final_w) and (ie_status_p in ('N', 'I', 'INT', 'R', 'II', 'IT', 'DI', 'DT', 'DPAI')) then
		ie_vigente_w := 'S';
	elsif	((dt_inicial_w <= dt_inicio_prescr_w) or (dt_inicial_w >= dt_inicio_prescr_w)) and (ie_status_p in ('N', 'I', 'INT', 'R', 'II', 'IT', 'DI', 'DT', 'DPAI')) then
		ie_vigente_w := 'S';
	elsif	((ie_status_p = 'S' AND dt_inicial_w <= dt_inicio_prescr_w AND dt_suspensao_p <= dt_final_w) or
			 (ie_status_p = 'T' AND dt_inicial_w <= dt_inicio_prescr_w AND dt_status_p <= dt_final_w)) then
			ie_vigente_w := 'S';		
	else
		ie_vigente_w := 'N';
	end if;
	
end if;

return ie_vigente_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_sol_vig_adep ( nr_prescricao_p bigint, ie_status_p text, qt_hora_anterior_p bigint, qt_hora_adicional_p bigint, dt_filtro_p timestamp, dt_suspensao_p timestamp, dt_status_p timestamp) FROM PUBLIC;

