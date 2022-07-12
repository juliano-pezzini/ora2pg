-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION plt_obter_status_hor_proc_lib ( dt_administracao_p timestamp, dt_suspensao_p timestamp, ie_dose_especial_p text, dt_inicio_proc_p timestamp, dt_lib_horario_p timestamp) RETURNS varchar AS $body$
DECLARE


ie_status_w	varchar(15);


BEGIN
if (coalesce(dt_administracao_p::text, '') = '') and (coalesce(dt_suspensao_p::text, '') = '') and (coalesce(dt_inicio_proc_p::text, '') = '') and (dt_lib_horario_p IS NOT NULL AND dt_lib_horario_p::text <> '')then
	begin
	if (ie_dose_especial_p = 'S') then
		begin
		ie_status_w	:= 'E';
		end;
	else
		begin
		ie_status_w	:= 'N';
		end;
	end if;
	end;
elsif (dt_inicio_proc_p IS NOT NULL AND dt_inicio_proc_p::text <> '') and (coalesce(dt_suspensao_p::text, '') = '') and (coalesce(dt_administracao_p::text, '') = '') and (dt_lib_horario_p IS NOT NULL AND dt_lib_horario_p::text <> '') then
	begin
	ie_status_w	:= 'Z';
	end;
elsif (dt_administracao_p IS NOT NULL AND dt_administracao_p::text <> '') and (coalesce(dt_suspensao_p::text, '') = '') and (dt_lib_horario_p IS NOT NULL AND dt_lib_horario_p::text <> '')	then
	begin
	ie_status_w	:= 'A';
	end;
elsif (coalesce(dt_administracao_p::text, '') = '') and (dt_suspensao_p IS NOT NULL AND dt_suspensao_p::text <> '') then
	begin
	ie_status_w	:= 'S';
	end;
elsif (coalesce(dt_administracao_p::text, '') = '') and (coalesce(dt_suspensao_p::text, '') = '') and (coalesce(dt_lib_horario_p::text, '') = '')then
	begin
	ie_status_w	:= 'W';
	end;
end if;

return ie_status_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION plt_obter_status_hor_proc_lib ( dt_administracao_p timestamp, dt_suspensao_p timestamp, ie_dose_especial_p text, dt_inicio_proc_p timestamp, dt_lib_horario_p timestamp) FROM PUBLIC;

