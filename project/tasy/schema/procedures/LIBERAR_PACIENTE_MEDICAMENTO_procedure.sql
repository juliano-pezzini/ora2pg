-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_paciente_medicamento ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN

update	paciente_medic_uso
set	dt_liberacao = clock_timestamp(),
	nm_usuario_liberacao	= nm_usuario_p
where	nr_sequencia		= nr_sequencia_p;

commit;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_paciente_medicamento ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
