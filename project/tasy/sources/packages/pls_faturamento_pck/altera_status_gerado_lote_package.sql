-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_faturamento_pck.altera_status_gerado_lote ( nr_seq_lote_p pls_lote_faturamento.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

update	pls_lote_faturamento
set	nm_usuario_ger_lote	= nm_usuario_p,
	nm_id_sid		 = NULL,
	nm_id_serial		 = NULL,
	ie_status		= 3, -- Finalizado
	dt_fim_ger_lote		= clock_timestamp(),
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p
where	nr_sequencia		= nr_seq_lote_p;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_faturamento_pck.altera_status_gerado_lote ( nr_seq_lote_p pls_lote_faturamento.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;