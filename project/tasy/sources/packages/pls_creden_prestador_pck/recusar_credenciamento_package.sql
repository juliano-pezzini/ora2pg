-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_creden_prestador_pck.recusar_credenciamento ( nr_seq_credenciamento_p pls_creden_prestador.nr_sequencia%type, nr_seq_motivo_recusa_p pls_creden_prestador.nr_seq_motivo_recusa%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

nr_count_w	integer;


BEGIN
select	count(*)
into STRICT	nr_count_w
from	pls_cred_prest_revisao
where	coalesce(dt_liberacao::text, '') = ''
and	nr_seq_credenciamento = nr_seq_credenciamento_p;

if	nr_count_w >0	then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1209290);
end if;

update	pls_creden_prestador
set	ie_status_ant	= ie_status,
	ie_status	= 6,
	nr_seq_motivo_recusa = nr_seq_motivo_recusa_p,
	dt_atualizacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p
where	nr_sequencia	= nr_seq_credenciamento_p;

CALL CALL pls_creden_prestador_pck.gerar_alerta_evento(	nr_seq_credenciamento_p => nr_seq_credenciamento_p,
			ie_tipo_processo_p => 2,
			nm_usuario_p => nm_usuario_p,
			ie_commit_p => 'S');
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_creden_prestador_pck.recusar_credenciamento ( nr_seq_credenciamento_p pls_creden_prestador.nr_sequencia%type, nr_seq_motivo_recusa_p pls_creden_prestador.nr_seq_motivo_recusa%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;