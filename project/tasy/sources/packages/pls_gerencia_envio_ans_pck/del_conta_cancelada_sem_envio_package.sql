-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- tira fora todas as contas que esto canceladas e que nunca foram enviadas



CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.del_conta_cancelada_sem_envio ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type) AS $body$
DECLARE


tb_seq_w	pls_util_cta_pck.t_number_table;

dados_cta_alt_guia CURSOR(	nr_seq_lote_pc	pls_monitor_tiss_cta_val.nr_sequencia%type) FOR
	SELECT 	x.nr_sequencia
	from   	pls_monitor_tiss_cta_val x
	where  	x.nr_seq_lote_monitor = nr_seq_lote_pc
	and    	x.ie_conta_atualizada = 'S'
	and    	x.ie_tipo_evento = 'CC'
	and (SELECT 	count(z.nr_sequencia)
		from   	pls_monitor_tiss_guia z
		where  	z.nr_seq_conta = x.nr_seq_conta) = 0;

--Cursor utilizado para deletar as contas que geraram log de incluso, mas esto canceladas e nunca foram enviadas para ANS

dados_conta_cancelada CURSOR(	nr_seq_lote_pc	pls_monitor_tiss_cta_val.nr_sequencia%type) FOR
	SELECT 	x.nr_sequencia
	from   	pls_monitor_tiss_cta_val x,
		pls_conta a
	where  	x.nr_seq_conta = a.nr_sequencia
	and	x.nr_seq_lote_monitor = nr_seq_lote_pc
	and    	x.ie_conta_atualizada = 'S'
	and	a.ie_status = 'C'
	and (SELECT 	count(z.nr_sequencia)
		from   	pls_monitor_tiss_guia z
		where  	z.nr_seq_conta = x.nr_seq_conta) = 0;


BEGIN

-- apagar registros da tabela pls_monitor_tiss_alt_guia

open dados_cta_alt_guia(nr_seq_lote_p);
loop
	tb_seq_w.delete;

	fetch dados_cta_alt_guia bulk collect into tb_seq_w
	limit current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer;

	exit when tb_seq_w.count = 0;

	forall i in tb_seq_w.first .. tb_seq_w.last
		update pls_monitor_tiss_cta_val set
			ie_conta_atualizada = 'N'
		where	nr_sequencia = tb_seq_w(i);

	commit;
end loop;
close dados_cta_alt_guia;

-- apagar registros da tabela pls_monitor_tiss_alt_guia

open dados_conta_cancelada(nr_seq_lote_p);
loop
	tb_seq_w.delete;

	fetch dados_conta_cancelada bulk collect into tb_seq_w
	limit current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer;

	exit when tb_seq_w.count = 0;

	forall i in tb_seq_w.first .. tb_seq_w.last
		update 	pls_monitor_tiss_cta_val set
			ie_conta_atualizada = 'N'
		where	nr_sequencia = tb_seq_w(i);

	commit;
end loop;
close dados_conta_cancelada;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.del_conta_cancelada_sem_envio ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type) FROM PUBLIC;