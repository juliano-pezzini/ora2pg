-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_sol_acm_sn_vig_adep ( nr_prescricao_p bigint, ie_status_p text, dt_status_p timestamp, ie_acm_p text, ie_se_necessario_p text, qt_hora_anterior_p bigint, qt_hora_adicional_p bigint) RETURNS varchar AS $body$
DECLARE


ie_vigente_w		varchar(1) := 'N';
dt_inicio_prescr_w		timestamp;
dt_validade_prescr_w	timestamp;
dt_inicial_w		timestamp;
dt_final_w		timestamp;


BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (coalesce(dt_status_p::text, '') = '') and (ie_status_p in ('N','S')) and
	((ie_acm_p = 'S') or (ie_se_necessario_p = 'S')) and (qt_hora_anterior_p IS NOT NULL AND qt_hora_anterior_p::text <> '') and (qt_hora_adicional_p IS NOT NULL AND qt_hora_adicional_p::text <> '') then

	select	max(dt_inicio_prescr),
		max(dt_validade_prescr)
	into STRICT	dt_inicio_prescr_w,
		dt_validade_prescr_w
	from	prescr_medica
	where	nr_prescricao = nr_prescricao_p;

	if (qt_hora_anterior_p > 0) then
		select	to_date(to_char(trunc(clock_timestamp() - qt_hora_anterior_p/24, 'hh24'), 'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
		into STRICT	dt_inicial_w
		;
	else
		select	to_date(to_char(trunc(clock_timestamp(), 'hh24'), 'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
		into STRICT	dt_inicial_w
		;
	end if;

	if (qt_hora_adicional_p > 0) then
		select	to_date(to_char(trunc(clock_timestamp() + qt_hora_adicional_p/24, 'hh24'), 'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
		into STRICT	dt_final_w
		;
	else
		select	to_date(to_char(trunc(clock_timestamp(), 'hh24'), 'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
		into STRICT	dt_final_w
		;
	end if;

	select	coalesce(obter_se_prescr_vig_adep(dt_inicio_prescr_w, dt_validade_prescr_w, dt_inicial_w, dt_final_w),'N')
	into STRICT	ie_vigente_w
	;

end if;

return ie_vigente_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_sol_acm_sn_vig_adep ( nr_prescricao_p bigint, ie_status_p text, dt_status_p timestamp, ie_acm_p text, ie_se_necessario_p text, qt_hora_anterior_p bigint, qt_hora_adicional_p bigint) FROM PUBLIC;
