-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_execucao_teste ( nm_usuario_p text, nr_seq_p bigint) AS $body$
BEGIN
update	teste_software_execucao
set	dt_liberacao   = clock_timestamp(),
	dt_atualizacao = clock_timestamp(),
	nm_usuario_lib = nm_usuario_p,
	nm_usuario     = nm_usuario_p
where    	nr_sequencia   = nr_seq_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_execucao_teste ( nm_usuario_p text, nr_seq_p bigint) FROM PUBLIC;

