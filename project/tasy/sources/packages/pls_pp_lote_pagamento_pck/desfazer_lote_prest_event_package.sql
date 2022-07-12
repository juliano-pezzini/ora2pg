-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_lote_pagamento_pck.desfazer_lote_prest_event ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type) AS $body$
DECLARE


tb_sequencia_w		pls_util_cta_pck.t_number_table;

C01 CURSOR(	nr_seq_lote_pc	pls_pp_lote.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia
	from	pls_pp_lote_prest_event a
	where	a.nr_seq_lote = nr_seq_lote_pc;
	

BEGIN
-- percorre o cursor e apaga os itens retornados

open C01( nr_seq_lote_p );
loop
	fetch c01 bulk collect into tb_sequencia_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_sequencia_w.count = 0;
	
	forall i in tb_sequencia_w.first..tb_sequencia_w.last
		delete 	from pls_pp_lote_prest_event
		where	nr_sequencia = tb_sequencia_w(i);
	commit;
end loop;
close C01;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_lote_pagamento_pck.desfazer_lote_prest_event ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type) FROM PUBLIC;
