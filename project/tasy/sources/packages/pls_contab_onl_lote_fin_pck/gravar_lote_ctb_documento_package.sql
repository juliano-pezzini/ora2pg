-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_contab_onl_lote_fin_pck.gravar_lote_ctb_documento ( doc_p ctb_documento, nm_usuario_p text) AS $body$
BEGIN
	update	ctb_documento	
	set	nr_lote_contabil	= doc_p.nr_lote_contabil,
		ie_situacao_ctb		= 'C',
		ds_inconsistencia	= '',
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_sequencia		= doc_p.nr_sequencia;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_contab_onl_lote_fin_pck.gravar_lote_ctb_documento ( doc_p ctb_documento, nm_usuario_p text) FROM PUBLIC;
