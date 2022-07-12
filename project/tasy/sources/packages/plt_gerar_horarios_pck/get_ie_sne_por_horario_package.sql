-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION plt_gerar_horarios_pck.get_ie_sne_por_horario () RETURNS varchar AS $body$
BEGIN
		/*if	(ie_SNE_horario_w is null ) then
			obter_param_usuario(950, 52, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_SNE_horario_w);
		end if;*/

		PERFORM set_config('plt_gerar_horarios_pck.ie_sne_horario_w', 'S', false);
		return current_setting('plt_gerar_horarios_pck.ie_sne_horario_w')::varchar(15);
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION plt_gerar_horarios_pck.get_ie_sne_por_horario () FROM PUBLIC;
