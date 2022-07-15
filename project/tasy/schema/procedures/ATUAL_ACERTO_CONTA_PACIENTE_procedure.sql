-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atual_acerto_conta_paciente (nr_interno_conta_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '') then 
	begin 
	update	conta_paciente 
	set	ie_status_acerto = 1, 
		dt_atualizacao = clock_timestamp(), 
		nm_usuario = nm_usuario_p 
		where nr_interno_conta = nr_interno_conta_p;
	commit;
	end;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atual_acerto_conta_paciente (nr_interno_conta_p bigint, nm_usuario_p text) FROM PUBLIC;

