-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION adep_obter_se_gerar_sol_hor ( dt_horario_p timestamp, dt_instalacao_p timestamp, dt_administracao_p timestamp, dt_suspensao_p timestamp, dt_inicial_param_p timestamp, dt_final_param_p timestamp) RETURNS varchar AS $body$
DECLARE


ie_gerar_w	varchar(1) := 'N';


BEGIN
if (dt_instalacao_p IS NOT NULL AND dt_instalacao_p::text <> '') and	-- se não tiver terminada
	(coalesce(dt_administracao_p::text, '') = '') and (coalesce(dt_suspensao_p::text, '') = '') then
	begin
	ie_gerar_w := 'S';
	end;
elsif (dt_administracao_p IS NOT NULL AND dt_administracao_p::text <> '') and -- se tiver terminada e a data estiver entre o período do filtro
	(coalesce(dt_suspensao_p::text, '') = '') and (dt_administracao_p between dt_inicial_param_p and dt_final_param_p) then
	begin
	ie_gerar_w := 'S';
	end;
elsif (coalesce(dt_administracao_p::text, '') = '') and -- se tiver suspensa e a data estiver entre o período do filtro
	(dt_suspensao_p IS NOT NULL AND dt_suspensao_p::text <> '') and (dt_suspensao_p between dt_inicial_param_p and dt_final_param_p) then
	begin
	ie_gerar_w := 'S';
	end;
elsif (dt_horario_p between dt_inicial_param_p and dt_final_param_p) then -- Se o horário tiver entre o período do filtro
	begin
	ie_gerar_w := 'S';
	end;
end if;
return ie_gerar_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION adep_obter_se_gerar_sol_hor ( dt_horario_p timestamp, dt_instalacao_p timestamp, dt_administracao_p timestamp, dt_suspensao_p timestamp, dt_inicial_param_p timestamp, dt_final_param_p timestamp) FROM PUBLIC;
