-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION plt_gerar_horarios_pck.get_ie_sol_pendentes () RETURNS varchar AS $body$
BEGIN
		if (current_setting('plt_gerar_horarios_pck.ie_sol_pendentes_w')::coalesce(varchar(15)::text, '') = '' ) then
			obter_param_usuario(950, 46, current_setting('plt_gerar_horarios_pck.cd_perfil_w')::perfil.cd_perfil%type, current_setting('plt_gerar_horarios_pck.nm_usuario_w')::usuario.nm_usuario%type, current_setting('plt_gerar_horarios_pck.cd_estabelecimento_w')::estabelecimento.cd_estabelecimento%type, current_setting('plt_gerar_horarios_pck.ie_sol_pendentes_w')::varchar(15));
		end if;
		return current_setting('plt_gerar_horarios_pck.ie_sol_pendentes_w')::varchar(15);
	end;		
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION plt_gerar_horarios_pck.get_ie_sol_pendentes () FROM PUBLIC;
