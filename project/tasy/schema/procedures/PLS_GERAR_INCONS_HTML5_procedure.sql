-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_incons_html5 ( nr_seq_lote_lanc_prog_p PLS_LANC_PROG_IMPORT_LOTE.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

CALL PLS_GERAR_INCO_LANC_IMP_PCK.pls_gerar_inconsistencias(nr_seq_lote_lanc_prog_p, nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_incons_html5 ( nr_seq_lote_lanc_prog_p PLS_LANC_PROG_IMPORT_LOTE.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

