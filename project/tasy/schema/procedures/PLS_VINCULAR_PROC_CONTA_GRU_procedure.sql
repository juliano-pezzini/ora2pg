-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_vincular_proc_conta_gru ( nr_seq_proc_conta_p pls_processo_conta.nr_sequencia%type, nr_seq_proc_gru_p pls_processo_gru.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

update	pls_processo_conta
set	nr_seq_proc_gru	= nr_seq_proc_gru_p
where	nr_sequencia	= nr_seq_proc_conta_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_vincular_proc_conta_gru ( nr_seq_proc_conta_p pls_processo_conta.nr_sequencia%type, nr_seq_proc_gru_p pls_processo_gru.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
