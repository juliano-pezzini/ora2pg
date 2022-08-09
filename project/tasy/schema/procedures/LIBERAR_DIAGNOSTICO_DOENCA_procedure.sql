-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_diagnostico_doenca ( nm_usuario_p text, nr_atendimento_p bigint, nr_seq_interno_p bigint) AS $body$
BEGIN

if (coalesce(nr_atendimento_p,0) > 0) and (coalesce(nr_seq_interno_p,0) > 0) then

	update	diagnostico_doenca
	set	dt_atualizacao = clock_timestamp(),
		nm_usuario     = nm_usuario_p,
		dt_liberacao   = clock_timestamp()
	where	nr_atendimento = nr_atendimento_p
	and 	nr_seq_interno = nr_seq_interno_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_diagnostico_doenca ( nm_usuario_p text, nr_atendimento_p bigint, nr_seq_interno_p bigint) FROM PUBLIC;
