-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reabrir_inutilizacao ( nr_seq_inutilizacao_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_seq_inutilizacao_p IS NOT NULL AND nr_seq_inutilizacao_p::text <> '') then

	update	san_inutilizacao
	set	dt_fechamento		 = NULL,
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p,
		nm_usuario_fechamento 	 = NULL
	where 	nr_sequencia		= nr_seq_inutilizacao_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reabrir_inutilizacao ( nr_seq_inutilizacao_p bigint, nm_usuario_p text) FROM PUBLIC;

