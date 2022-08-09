-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_clinica_paciente_pa ( nr_atendimento_p bigint, ie_clinica_p bigint, cd_medico_p text, ie_executa_p text, nm_usuario_p text, cd_estabelecimento_p bigint ) AS $body$
DECLARE

 
cd_medico_w	varchar(10);


BEGIN 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (ie_clinica_p IS NOT NULL AND ie_clinica_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	begin 
	cd_medico_w := cd_medico_p;
	 
	if (coalesce(cd_medico_w::text, '') = '') then 
		begin 
		select 	cd_medico_resp 
		into STRICT	cd_medico_w 
		from	atendimento_paciente 
		where	nr_atendimento = nr_atendimento_p;
		end;
	end if;
	 
	update	atendimento_paciente 
	set	ie_clinica 	= ie_clinica_p, 
		cd_medico_resp 	= cd_medico_w, 
		nm_usuario 	= nm_usuario_p 
	where	nr_atendimento 	= nr_atendimento_p;
	end;
end if;
 
if (coalesce(ie_executa_p, 'N') = 'S') then 
	CALL altera_medico_resp_escala(cd_estabelecimento_p, ie_clinica_p, nr_atendimento_p);
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_clinica_paciente_pa ( nr_atendimento_p bigint, ie_clinica_p bigint, cd_medico_p text, ie_executa_p text, nm_usuario_p text, cd_estabelecimento_p bigint ) FROM PUBLIC;
