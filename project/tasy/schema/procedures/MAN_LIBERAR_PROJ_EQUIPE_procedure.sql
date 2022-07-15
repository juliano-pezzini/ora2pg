-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_liberar_proj_equipe ( nr_seq_equipe_p bigint, ie_opcao_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (ie_opcao_p = 1) then

	update	proj_equipe
	set	dt_liberacao	= clock_timestamp(),
		dt_atualizacao	= clock_timestamp(),
		nm_usuario 	= nm_usuario_p
	where	nr_sequencia 	= nr_seq_equipe_p;

else

	update	proj_equipe
	set	dt_liberacao	 = NULL,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario 	= nm_usuario_p
	where	nr_sequencia 	= nr_seq_equipe_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_liberar_proj_equipe ( nr_seq_equipe_p bigint, ie_opcao_p bigint, nm_usuario_p text) FROM PUBLIC;

