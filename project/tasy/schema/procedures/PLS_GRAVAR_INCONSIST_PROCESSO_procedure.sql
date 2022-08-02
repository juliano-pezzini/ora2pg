-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gravar_inconsist_processo ( nr_seq_proc_conta_p pls_processo_conta.nr_sequencia%type, nr_seq_inconsistencia_p pls_inconsist_processo.nr_sequencia%type, ds_acao_p pls_proc_conta_inconsist.ds_acao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

insert into pls_proc_conta_inconsist(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_proc_conta,
	nr_seq_inconsistencia,
	ds_acao)
SELECT	nextval('pls_proc_conta_inconsist_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_proc_conta_p,
	nr_seq_inconsistencia_p,
	ds_acao_p
;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gravar_inconsist_processo ( nr_seq_proc_conta_p pls_processo_conta.nr_sequencia%type, nr_seq_inconsistencia_p pls_inconsist_processo.nr_sequencia%type, ds_acao_p pls_proc_conta_inconsist.ds_acao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

