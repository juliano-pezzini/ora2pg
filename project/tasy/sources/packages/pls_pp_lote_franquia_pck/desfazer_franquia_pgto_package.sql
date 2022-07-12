-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_lote_franquia_pck.desfazer_franquia_pgto ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type) AS $body$
DECLARE

 
tb_nr_sequencia_w	pls_util_cta_pck.t_number_table;

c01 CURSOR(	nr_seq_lote_pc	pls_pp_lote.nr_sequencia%type) FOR 
	SELECT	nr_sequencia 
	from	pls_pp_item_lote 
	where	nr_seq_lote = nr_seq_lote_pc 
	and	ie_tipo_item = '9';


BEGIN 
-- retorna todos os registros de franquia do lote de pagamento 
open c01(nr_seq_lote_p);
loop 
	fetch c01 bulk collect into	tb_nr_sequencia_w 
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_sequencia_w.count = 0;
 
	-- exclui os registros da tabela n para n 
	forall i in tb_nr_sequencia_w.first..tb_nr_sequencia_w.last 
		delete 
		from	pls_pp_it_prest_event_val 
		where	nr_seq_item_lote = tb_nr_sequencia_w(i);
	commit;
 
	-- exclui os registros 
	forall i in tb_nr_sequencia_w.first..tb_nr_sequencia_w.last 
		delete 
		from	pls_pp_item_lote 
		where	nr_seq_lote = nr_seq_lote_p 
		and	nr_sequencia = tb_nr_sequencia_w(i);
	commit;
end loop;
close c01;
 
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_lote_franquia_pck.desfazer_franquia_pgto ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type) FROM PUBLIC;