-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_visita_tecnica_prest_pck.aprovar_inconsistencia ( nr_seq_incons_p pls_visita_tecnica_inco.nr_sequencia%type, ds_justificativa_p pls_visita_tecnica_inco.ds_justificativa%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) AS $body$
BEGIN

if (coalesce(ds_justificativa_p::text, '') = '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1211194);
end if;

update	pls_visita_tecnica_inco
set	ie_status		= 4,
	ds_justificativa	= ds_justificativa_p,
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p
where	nr_sequencia		= nr_seq_incons_p;

if (ie_commit_p = 'S') then
	commit;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_visita_tecnica_prest_pck.aprovar_inconsistencia ( nr_seq_incons_p pls_visita_tecnica_inco.nr_sequencia%type, ds_justificativa_p pls_visita_tecnica_inco.ds_justificativa%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) FROM PUBLIC;
