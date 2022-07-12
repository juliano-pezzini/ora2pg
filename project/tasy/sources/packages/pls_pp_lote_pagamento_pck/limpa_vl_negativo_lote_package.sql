-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_lote_pagamento_pck.limpa_vl_negativo_lote ( nr_seq_lote_p pls_pp_item_lote.nr_seq_lote%type) AS $body$
DECLARE


tb_nr_sequencia_w		pls_util_cta_pck.t_number_table;
	
c01 CURSOR(	nr_seq_lote_pc	pls_pp_item_lote.nr_seq_lote%type) FOR
	SELECT	a.nr_sequencia
	from	pls_pp_item_lote a
	where	a.nr_seq_lote = nr_seq_lote_pc;
	

BEGIN

open c01(nr_seq_lote_p);
loop
	fetch c01 bulk collect into tb_nr_sequencia_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_sequencia_w.count = 0;

	forall i in tb_nr_sequencia_w.first..tb_nr_sequencia_w.last
		update	pls_pp_item_lote
		set	vl_acao_negativo = 0,
			ie_acao_negativo = 'N',
			ie_acao_pgto_negativo  = NULL
		where	nr_sequencia = tb_nr_sequencia_w(i);
end loop;
close c01;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_lote_pagamento_pck.limpa_vl_negativo_lote ( nr_seq_lote_p pls_pp_item_lote.nr_seq_lote%type) FROM PUBLIC;