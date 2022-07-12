-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Procedure utilizada para atualizar o vnculo das guias de homologao com as definitivas para envio na gerao do XML



CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.atualiza_vinculo_tiss_alt_guia ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


tb_nr_seq_w			pls_util_cta_pck.t_number_table;
tb_nr_seq_guia_monitor_w	pls_util_cta_pck.t_number_table;

c01 CURSOR(nr_seq_lote_pc		pls_monitor_tiss_lote.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia,
		c.nr_sequencia nr_seq_guia_monitor
	from	pls_monitor_tiss_alt_guia a,
		pls_monitor_tiss_cta_val b,
		pls_monitor_tiss_guia c
	where	a.nr_seq_lote_monitor = nr_seq_lote_pc
	and	coalesce(a.nr_seq_guia_monitor::text, '') = ''
	and	b.nr_sequencia = a.nr_seq_cta_val
	and	c.nr_seq_lote_monitor = b.nr_seq_lote_monitor
	and	c.nr_seq_conta = b.nr_seq_conta;


BEGIN

open C01(nr_seq_lote_p);
loop
	tb_nr_seq_w.delete;
	tb_nr_seq_guia_monitor_w.delete;

	fetch C01 bulk collect into tb_nr_seq_w, tb_nr_seq_guia_monitor_w
	limit current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer;

	exit when tb_nr_seq_w.count = 0;

	forall i in tb_nr_seq_w.first .. tb_nr_seq_w.last

		update	pls_monitor_tiss_alt_guia set
			nr_seq_guia_monitor 	= tb_nr_seq_guia_monitor_w(i),
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p
		where	nr_sequencia = tb_nr_seq_w(i);

	commit;
end loop;
close C01;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.atualiza_vinculo_tiss_alt_guia ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
