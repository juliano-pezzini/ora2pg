-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_creden_prestador_pck.solicitar_revisao ( nr_seq_credenciamento_p pls_creden_prestador.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

update	pls_creden_prestador
set	ie_status	= 3,
	dt_atualizacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p
where	nr_sequencia	= nr_seq_credenciamento_p;

CALL CALL pls_creden_prestador_pck.gerar_alerta_evento(	nr_seq_credenciamento_p => nr_seq_credenciamento_p,
			ie_tipo_processo_p => 3,
			nm_usuario_p => nm_usuario_p,
			ie_commit_p => 'S' );

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_creden_prestador_pck.solicitar_revisao ( nr_seq_credenciamento_p pls_creden_prestador.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
