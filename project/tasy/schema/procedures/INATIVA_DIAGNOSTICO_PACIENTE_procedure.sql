-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inativa_diagnostico_paciente (nr_atendimento_p bigint, dt_diagnostico_p timestamp, cd_doenca_p text, nm_usuario_p text) AS $body$
BEGIN

	update	diagnostico_doenca
	set	    dt_inativacao	        = clock_timestamp(),
            nm_usuario_inativacao   = nm_usuario_p
	where	nr_atendimento          = nr_atendimento_p
    and     dt_diagnostico          = dt_diagnostico_p
    and     cd_doenca               = cd_doenca_p;

	commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inativa_diagnostico_paciente (nr_atendimento_p bigint, dt_diagnostico_p timestamp, cd_doenca_p text, nm_usuario_p text) FROM PUBLIC;

