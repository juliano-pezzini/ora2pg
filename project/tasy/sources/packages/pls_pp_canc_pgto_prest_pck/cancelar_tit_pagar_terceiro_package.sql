-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_canc_pgto_prest_pck.cancelar_tit_pagar_terceiro ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, nr_seq_pp_prest_p pls_pp_prestador.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


c01 CURSOR(	nr_seq_lote_pc		pls_pp_lote.nr_sequencia%type,
		nr_seq_pp_prest_pc	pls_pp_prestador.nr_sequencia%type) FOR
	SELECT	c.nr_tit_pagar_terceiro
	from	pls_pp_prest_event_prest a,
		pls_pp_it_prest_event_val b,
		pls_pp_item_lote c
	where	a.nr_seq_pp_prest = nr_seq_pp_prest_pc
	and	b.nr_seq_prest_even_val = a.nr_seq_pp_prest_even_val
	and	c.nr_seq_lote = nr_seq_lote_pc
	and	c.nr_sequencia = b.nr_seq_item_lote
	and	c.ie_tipo_item = '2'
	and	(c.nr_tit_pagar_terceiro IS NOT NULL AND c.nr_tit_pagar_terceiro::text <> '');

BEGIN
-- retorna todos os titulos a pagar para terceiros gerados para o prestador

for r_c01_w in c01(nr_seq_lote_p, nr_seq_pp_prest_p) loop

	-- cancela os titulos pagar

	CALL cancelar_titulo_pagar(r_c01_w.nr_tit_pagar_terceiro, nm_usuario_p, clock_timestamp());
end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_canc_pgto_prest_pck.cancelar_tit_pagar_terceiro ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, nr_seq_pp_prest_p pls_pp_prestador.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
