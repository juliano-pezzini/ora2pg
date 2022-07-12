-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION wheb_assist_pck.get_nivel_atencao_perfil () RETURNS varchar AS $body$
DECLARE

		cd_perfil_atencao_w bigint;
	
BEGIN
		select	obter_perfil_ativo
		into STRICT	cd_perfil_atencao_w
		;
		
		if (current_setting('wheb_assist_pck.cd_perfil_nivel_atencao_w')::coalesce(bigint::text, '') = '' or current_setting('wheb_assist_pck.ie_nivel_atencao_perfil_w')::coalesce(varchar(1)::text, '') = '' or current_setting('wheb_assist_pck.cd_perfil_nivel_atencao_w')::bigint <> cd_perfil_atencao_w) then
			select	coalesce(max(a.ie_nivel_atencao),'T')
			into STRICT	current_setting('wheb_assist_pck.ie_nivel_atencao_perfil_w')::varchar(1) 
			from	perfil a
			where	a.cd_perfil = cd_perfil_atencao_w;
			PERFORM set_config('wheb_assist_pck.cd_perfil_nivel_atencao_w', cd_perfil_atencao_w, false);
		else
			
			if (obter_funcao_ativa = 381) /* Prontuario Eletronico de Paciente Ambulatorial - PEPA */
 then
				return coalesce(get_nivel_atencao_pepa, current_setting('wheb_assist_pck.ie_nivel_atencao_perfil_w')::varchar(1));
			else
				return  current_setting('wheb_assist_pck.ie_nivel_atencao_perfil_w')::varchar(1);
			end if;
			
		end if;
			
		if (obter_funcao_ativa = 381) /* Prontuario Eletronico de Paciente Ambulatorial - PEPA */
 then
			return coalesce(get_nivel_atencao_pepa, current_setting('wheb_assist_pck.ie_nivel_atencao_perfil_w')::varchar(1));
		else
			return  current_setting('wheb_assist_pck.ie_nivel_atencao_perfil_w')::varchar(1);
		end if;
		
	end;
	
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION wheb_assist_pck.get_nivel_atencao_perfil () FROM PUBLIC;
