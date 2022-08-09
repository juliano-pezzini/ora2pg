-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sec_transferir_paciente ( cd_medico_origem_p text, cd_medico_destino_p text, cd_pessoa_fisica_p text, ie_todos_paciente_p text, nm_usuario_p text) AS $body$
BEGIN

if (cd_medico_origem_p > 0) and (cd_medico_destino_p > 0) then


	if (ie_todos_paciente_p	= 'S') then

		update	med_cliente
		set	cd_medico		=	cd_medico_destino_p,
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp()
		where	cd_medico		=	cd_medico_origem_p;


	else

		update	med_cliente
		set	cd_medico		=	cd_medico_destino_p,
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp()
		where	cd_medico		=	cd_medico_origem_p
		and	cd_pessoa_fisica	=	cd_pessoa_fisica_p;

	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sec_transferir_paciente ( cd_medico_origem_p text, cd_medico_destino_p text, cd_pessoa_fisica_p text, ie_todos_paciente_p text, nm_usuario_p text) FROM PUBLIC;
