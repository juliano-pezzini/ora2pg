-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_hor_sol_lib ( dt_instalacao_p timestamp, dt_administracao_p timestamp, dt_suspensao_p timestamp, dt_interrupcao_p timestamp, ie_dose_especial_p text, nr_seq_processo_p bigint, nr_seq_area_prep_p bigint, dt_lib_horario_p timestamp) RETURNS varchar AS $body$
DECLARE


ie_status_processo_w	varchar(15)	:= 'X';
ie_status_w		varchar(15);


BEGIN
if (coalesce(dt_instalacao_p::text, '') = '') and (coalesce(dt_administracao_p::text, '') = '') and (coalesce(dt_suspensao_p::text, '') = '') and (dt_lib_horario_p IS NOT NULL AND dt_lib_horario_p::text <> '') then
	begin
	if (nr_seq_processo_p IS NOT NULL AND nr_seq_processo_p::text <> '') then
		begin
		--ie_status_processo_w	:= obter_status_processo_area(nr_seq_processo_p,nr_seq_area_prep_p);
		ie_status_processo_w	:= obter_status_processo(nr_seq_processo_p);
		end;
	end if;
	if (ie_status_processo_w = 'D') then
		begin
		ie_status_w	:= ie_status_processo_w;
		end;
	elsif (ie_status_processo_w = 'H') then
		begin
		ie_status_w	:= ie_status_processo_w;
		end;
	elsif (ie_status_processo_w = 'P') then
		begin
		ie_status_w	:= 'P';
		end;
	elsif (ie_status_processo_w = 'L') then
		begin
		ie_status_w	:= 'L';
		end;
	elsif (ie_status_processo_w = 'R') then
		begin
		ie_status_w	:= ie_status_processo_w;
		end;
	elsif (ie_dose_especial_p = 'S') then
		begin
		ie_status_w	:= 'E';
		end;
	else
		begin
		ie_status_w	:= 'N';
		end;
	end if;
	end;
elsif (coalesce(dt_administracao_p::text, '') = '') and (coalesce(dt_suspensao_p::text, '') = '') and (coalesce(dt_interrupcao_p::text, '') = '') and (dt_instalacao_p IS NOT NULL AND dt_instalacao_p::text <> '') and (dt_lib_horario_p IS NOT NULL AND dt_lib_horario_p::text <> '')then
	begin
	ie_status_w	:= 'I';
	end;
elsif (dt_administracao_p IS NOT NULL AND dt_administracao_p::text <> '') and (coalesce(dt_suspensao_p::text, '') = '') and (dt_lib_horario_p IS NOT NULL AND dt_lib_horario_p::text <> '') then
	begin
	ie_status_w	:= 'A';
	end;
elsif (dt_interrupcao_p IS NOT NULL AND dt_interrupcao_p::text <> '') and (dt_lib_horario_p IS NOT NULL AND dt_lib_horario_p::text <> '') then
	ie_status_w	:= 'T';
elsif (coalesce(dt_administracao_p::text, '') = '') and (dt_suspensao_p IS NOT NULL AND dt_suspensao_p::text <> '') and (dt_lib_horario_p IS NOT NULL AND dt_lib_horario_p::text <> '')	then
	begin
	ie_status_w	:= 'S';
	end;
elsif (coalesce(dt_lib_horario_p::text, '') = '') then
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
-- REVOKE ALL ON FUNCTION obter_status_hor_sol_lib ( dt_instalacao_p timestamp, dt_administracao_p timestamp, dt_suspensao_p timestamp, dt_interrupcao_p timestamp, ie_dose_especial_p text, nr_seq_processo_p bigint, nr_seq_area_prep_p bigint, dt_lib_horario_p timestamp) FROM PUBLIC;

