-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_encerrar_acordo_desenv ( nr_seq_acordo_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_seq_acordo_p IS NOT NULL AND nr_seq_acordo_p::text <> '') then
	begin

	update	desenv_acordo
	set	dt_fim_acordo = clock_timestamp(),
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_acordo_p;

	commit;

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_encerrar_acordo_desenv ( nr_seq_acordo_p bigint, nm_usuario_p text) FROM PUBLIC;

