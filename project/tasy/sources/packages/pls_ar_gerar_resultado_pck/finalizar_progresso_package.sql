-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_ar_gerar_resultado_pck.finalizar_progresso ( nr_seq_lote_p pls_ar_lote.nr_sequencia%type, vl_dominio_p valor_dominio.vl_dominio%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

	update pls_ar_lote_prc_exec_item
	set	dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p,
		dt_termino	= clock_timestamp()
	where	nr_seq_lote		= nr_seq_lote_p
	and	ie_tipo_processo	= vl_dominio_p;

	commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ar_gerar_resultado_pck.finalizar_progresso ( nr_seq_lote_p pls_ar_lote.nr_sequencia%type, vl_dominio_p valor_dominio.vl_dominio%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
