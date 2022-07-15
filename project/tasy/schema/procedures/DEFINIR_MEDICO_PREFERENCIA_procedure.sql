-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE definir_medico_preferencia (nr_atendimento_p bigint, cd_medico_preferencia_p text, nm_usuario_p text) AS $body$
BEGIN
 
update	atendimento_paciente 
set	cd_medico_preferencia	= cd_medico_preferencia_p, 
	nm_usuario	= nm_usuario_p, 
	dt_atualizacao	= clock_timestamp() 
where	nr_atendimento 	= nr_atendimento_p;
 
commit;
	 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE definir_medico_preferencia (nr_atendimento_p bigint, cd_medico_preferencia_p text, nm_usuario_p text) FROM PUBLIC;

