-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION vipe_gerar_horarios_pck.get_ie_agrupar_acm_sn () RETURNS varchar AS $body$
BEGIN
		if (current_setting('vipe_gerar_horarios_pck.ie_agrupar_acm_sn_w')::coalesce(varchar(15)::text, '') = '' ) then
			Obter_Param_Usuario(8030, 17, current_setting('vipe_gerar_horarios_pck.cd_perfil_w')::bigint, current_setting('vipe_gerar_horarios_pck.nm_usuario_w')::varchar(15), current_setting('vipe_gerar_horarios_pck.cd_estabelecimento_w')::smallint, current_setting('vipe_gerar_horarios_pck.ie_agrupar_acm_sn_w')::varchar(15));
		end if;
		return current_setting('vipe_gerar_horarios_pck.ie_agrupar_acm_sn_w')::varchar(15);
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION vipe_gerar_horarios_pck.get_ie_agrupar_acm_sn () FROM PUBLIC;
