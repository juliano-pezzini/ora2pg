-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerencia_autogerado_pck.pls_atualiza_status_lote_auto ( nr_seq_lote_p pls_lote_auto_gerado.nr_sequencia%type, ie_status_p pls_lote_auto_gerado.ie_status%type, nm_usuario_p text) AS $body$
BEGIN

update	pls_lote_auto_gerado
set	ie_status	= ie_status_p,
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp()
where	nr_sequencia	= nr_seq_lote_p;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_autogerado_pck.pls_atualiza_status_lote_auto ( nr_seq_lote_p pls_lote_auto_gerado.nr_sequencia%type, ie_status_p pls_lote_auto_gerado.ie_status%type, nm_usuario_p text) FROM PUBLIC;