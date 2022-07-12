-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_lote_pagamento_pck.grava_lista_prest_evento ( tb_nr_seq_item_lote_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_valor_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_item_valor_p INOUT pls_util_cta_pck.t_number_table, tb_vl_glosa_p INOUT pls_util_cta_pck.t_number_table, tb_vl_item_p INOUT pls_util_cta_pck.t_number_table, tb_vl_negativo_p INOUT pls_util_cta_pck.t_number_table, tb_vl_tributo_p INOUT pls_util_cta_pck.t_number_table, tb_vl_liquido_p INOUT pls_util_cta_pck.t_number_table, nr_idx_update_p INOUT integer, nr_idx_insert_p INOUT integer) AS $body$
BEGIN

if (tb_nr_seq_item_lote_p.count > 0) then
	forall i in tb_nr_seq_item_lote_p.first..tb_nr_seq_item_lote_p.last
		insert into pls_pp_it_prest_event_val(	nr_sequencia,
							nr_seq_item_lote, 
							nr_seq_prest_even_val)
						values (	nextval('pls_pp_it_prest_event_val_seq'), 
							tb_nr_seq_item_lote_p(i), 
							tb_nr_seq_valor_p(i));
	commit;
end if;

if (tb_nr_seq_item_valor_p.count > 0) then
	forall i in tb_nr_seq_item_valor_p.first..tb_nr_seq_item_valor_p.last
		update	pls_pp_prest_evento_valor
		set	vl_glosa = tb_vl_glosa_p(i),
			vl_item = tb_vl_item_p(i),
			vl_acao_negativo = tb_vl_negativo_p(i),
			vl_tributo = tb_vl_tributo_p(i),
			vl_liquido = tb_vl_liquido_p(i)
		where	nr_sequencia = tb_nr_seq_item_valor_p(i);
	commit;
end if;

tb_nr_seq_item_lote_p.delete;
tb_nr_seq_valor_p.delete;
tb_nr_seq_item_valor_p.delete;
tb_vl_glosa_p.delete;
tb_vl_item_p.delete;
tb_vl_negativo_p.delete;
tb_vl_tributo_p.delete;
tb_vl_liquido_p.delete;
nr_idx_update_p := 0;
nr_idx_insert_p := 0;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_lote_pagamento_pck.grava_lista_prest_evento ( tb_nr_seq_item_lote_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_valor_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_item_valor_p INOUT pls_util_cta_pck.t_number_table, tb_vl_glosa_p INOUT pls_util_cta_pck.t_number_table, tb_vl_item_p INOUT pls_util_cta_pck.t_number_table, tb_vl_negativo_p INOUT pls_util_cta_pck.t_number_table, tb_vl_tributo_p INOUT pls_util_cta_pck.t_number_table, tb_vl_liquido_p INOUT pls_util_cta_pck.t_number_table, nr_idx_update_p INOUT integer, nr_idx_insert_p INOUT integer) FROM PUBLIC;