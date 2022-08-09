-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_nr_tel_agendas ( cd_pessoa_fisica_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
ie_atual_pac_ageint_w		parametro_agenda.ie_atual_pac_ageint%type;
ie_atual_pac_agecon_ageserv_w	parametro_agenda.ie_atual_pac_agecon_ageserv%type;			
ie_cad_completo_w		funcao_parametro.vl_parametro_padrao%type;
ie_cad_simplif_w		funcao_parametro.vl_parametro_padrao%type;			
 

BEGIN 
 
ie_cad_completo_w := Obter_param_Usuario(5, 164, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_cad_completo_w);
ie_cad_simplif_w := Obter_param_Usuario(32, 44, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_cad_simplif_w);
 
select coalesce(max(ie_atual_pac_ageint), 'N'), 
	coalesce(max(ie_atual_pac_agecon_ageserv), 'N') 
into STRICT	ie_atual_pac_ageint_w, 
	ie_atual_pac_agecon_ageserv_w 
from 	parametro_agenda 
where 	cd_estabelecimento = cd_estabelecimento_p;
 
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then 
	begin 
		CALL wheb_usuario_pck.set_ie_executar_trigger('N');
		 
		update	agenda_paciente 
		set	nr_telefone		= substr(obter_fone_pac_agenda(cd_pessoa_fisica_p),1,255) 
		where	cd_pessoa_fisica	= cd_pessoa_fisica_p 
		and	dt_agenda		> clock_timestamp() - interval '30 days';
		 
		if (ie_cad_completo_w = 'N') and (ie_cad_simplif_w = 'N') then			 
			if (ie_atual_pac_agecon_ageserv_w = 'S') then 
				update	agenda_consulta 
				set	nr_telefone		= substr(obter_fone_pac_agenda(cd_pessoa_fisica_p),1,80) 
				where	cd_pessoa_fisica	= cd_pessoa_fisica_p 
				and	dt_agenda		> clock_timestamp() - interval '30 days';		
			end if;
		end if;
		if (ie_atual_pac_ageint_w = 'S') then 
			update	agenda_integrada 
			set	nr_telefone		= substr(obter_fone_pac_agenda(cd_pessoa_fisica_p),1,60) 
			where	cd_pessoa_fisica	= cd_pessoa_fisica_p 
			and	dt_inicio_agendamento	> clock_timestamp() - interval '30 days';
		end if;					
		CALL wheb_usuario_pck.set_ie_executar_trigger('S');
	end;		
end if;		
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_nr_tel_agendas ( cd_pessoa_fisica_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
