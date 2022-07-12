-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_envio_ans_extra_pck.atualiza_flag_tabela ( tb_seq_proc_p pls_util_cta_pck.t_number_table, tb_tx_ie_pacote_ausente_p pls_util_cta_pck.t_varchar2_table_1, tb_ie_item_comp_sispac_p pls_util_cta_pck.t_varchar2_table_1) AS $body$
BEGIN

	if (tb_seq_proc_p.count > 0) then
	forall i in tb_seq_proc_p.first .. tb_seq_proc_p.last
		update  pls_monitor_tiss_proc_val
		set		ie_item_comp_sispac_invalido = tb_ie_item_comp_sispac_p(i),
				ie_pacote_ausente_sispac = tb_tx_ie_pacote_ausente_p(i)
		where 	nr_sequencia = tb_seq_proc_p(i);
		
	end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_envio_ans_extra_pck.atualiza_flag_tabela ( tb_seq_proc_p pls_util_cta_pck.t_number_table, tb_tx_ie_pacote_ausente_p pls_util_cta_pck.t_varchar2_table_1, tb_ie_item_comp_sispac_p pls_util_cta_pck.t_varchar2_table_1) FROM PUBLIC;