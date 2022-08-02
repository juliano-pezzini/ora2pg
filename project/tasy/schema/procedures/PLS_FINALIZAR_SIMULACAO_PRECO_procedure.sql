-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_finalizar_simulacao_preco ( nr_seq_simulacao_p pls_simulacao_preco.nr_sequencia%type, nm_usuario_p text) AS $body$
BEGIN

CALL pls_simulacao_preco_pck.finalizar_simulacao_preco(nr_seq_simulacao_p, nm_usuario_p);

update	pls_simulacao_preco
set	dt_finalizacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp()
where	nr_sequencia	= nr_seq_simulacao_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_finalizar_simulacao_preco ( nr_seq_simulacao_p pls_simulacao_preco.nr_sequencia%type, nm_usuario_p text) FROM PUBLIC;

