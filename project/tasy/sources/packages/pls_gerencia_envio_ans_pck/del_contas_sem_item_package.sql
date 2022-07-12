-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




--Deletar as contas que no possuem nenhum procedimento e nenhum material



CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.del_contas_sem_item ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type) AS $body$
DECLARE


tb_seq_w	pls_util_cta_pck.t_number_table;

dados_cta_item CURSOR(	nr_seq_lote_pc	pls_monitor_tiss_cta_val.nr_sequencia%type) FOR
	SELECT 	x.nr_sequencia
	from   	pls_monitor_tiss_cta_val x
	where  	x.nr_seq_lote_monitor = nr_seq_lote_pc
	and    	x.ie_conta_atualizada = 'S'
	and (SELECT 	count(z.nr_sequencia)
		from   	pls_monitor_tiss_proc_val z
		where  	z.nr_seq_cta_val = x.nr_sequencia
		and	z.ie_item_atualizado = 'S') = 0
	and (select count(z.nr_sequencia)
		from   	pls_monitor_tiss_mat_val z
		where  	z.nr_seq_cta_val = x.nr_sequencia
		and	z.ie_item_atualizado = 'S') = 0;


BEGIN

--Atualiza a conta para 'N' para poder excluir as que no possuem itens

open dados_cta_item(nr_seq_lote_p);
loop
	tb_seq_w.delete;

	fetch dados_cta_item bulk collect into tb_seq_w
	limit current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer;

	exit when tb_seq_w.count = 0;

	forall i in tb_seq_w.first .. tb_seq_w.last
		update 	pls_monitor_tiss_cta_val
		set	ie_conta_atualizada = 'N'
		where	nr_sequencia = tb_seq_w(i);

	commit;
end loop;
close dados_cta_item;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.del_contas_sem_item ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type) FROM PUBLIC;
