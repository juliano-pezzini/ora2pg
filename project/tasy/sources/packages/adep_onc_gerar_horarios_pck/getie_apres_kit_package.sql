-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION adep_onc_gerar_horarios_pck.getie_apres_kit () RETURNS varchar AS $body$
BEGIN
		if (current_setting('adep_onc_gerar_horarios_pck.ie_mostrar_kit_w')::coalesce(varchar(1)::text, '') = '' ) then
			Obter_Param_Usuario(1113, 515, current_setting('adep_onc_gerar_horarios_pck.cd_perfil_w')::bigint, current_setting('adep_onc_gerar_horarios_pck.nm_usuario_w')::varchar(15), current_setting('adep_onc_gerar_horarios_pck.cd_estabelecimento_w')::smallint, current_setting('adep_onc_gerar_horarios_pck.ie_mostrar_kit_w')::varchar(1));
		end if;
		return current_setting('adep_onc_gerar_horarios_pck.ie_mostrar_kit_w')::varchar(1);
	end;	
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION adep_onc_gerar_horarios_pck.getie_apres_kit () FROM PUBLIC;
