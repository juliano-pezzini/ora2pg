-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_portab_aceitar_solic ( nr_seq_portabilidade_p bigint, nm_usuario_p text) AS $body$
BEGIN

update	pls_portab_pessoa
set	ie_status	= 'A',
	dt_atualizacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p
where	nr_sequencia	= nr_seq_portabilidade_p;

CALL pls_envio_email_portabilidade(nr_seq_portabilidade_p, 1, nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_portab_aceitar_solic ( nr_seq_portabilidade_p bigint, nm_usuario_p text) FROM PUBLIC;

