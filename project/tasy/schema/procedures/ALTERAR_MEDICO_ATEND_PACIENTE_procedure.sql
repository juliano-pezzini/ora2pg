-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_medico_atend_paciente ( cd_medico_p text, nr_atendimento_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (cd_medico_p IS NOT NULL AND cd_medico_p::text <> '') and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	begin 
	update	atendimento_paciente 
	set	cd_medico_resp	= cd_medico_p, 
		nm_usuario	= nm_usuario_p 
	where	nr_atendimento	= nr_atendimento_p;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_medico_atend_paciente ( cd_medico_p text, nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

