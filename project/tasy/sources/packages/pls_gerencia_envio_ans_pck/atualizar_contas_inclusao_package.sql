-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.atualizar_contas_inclusao ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


tb_seq_w		pls_util_cta_pck.t_number_table;
tb_seq_chave_w		pls_util_cta_pck.t_number_table;
tb_dt_evento_w		pls_util_cta_pck.t_date_table;

-- retorna todas as contas que possuem registro de excluso e possuem um registro de alterao

C01 CURSOR( nr_seq_lote_pc	pls_monitor_tiss_lote.nr_sequencia%type	) FOR
	SELECT 	a.nr_sequencia,
		a.nr_seq_chave_guia,
		(SELECT	trunc(z.dt_evento)
		 from	pls_monitor_tiss_cta_val z
		 where	z.nr_seq_lote_monitor = nr_seq_lote_pc
		 and	z.nr_seq_conta = a.nr_seq_conta) dt_evento
	from   	pls_monitor_tiss_guia a
	where  	a.nr_seq_lote_monitor 	= nr_seq_lote_pc
	and    	a.ie_tipo_registro 	= '2'
	and    	exists (select 	1
			from	pls_monitor_tiss_guia b
			where	b.nr_seq_lote_monitor 	= a.nr_seq_lote_monitor
			and	b.nr_seq_conta 		= a.nr_seq_conta
			and	b.ie_tipo_registro 	= '3');

BEGIN

--Atualiza todas as contas para incluso que possuem um registro de excluso gerado

open C01( nr_seq_lote_p );
loop
	tb_seq_w.delete;
	tb_seq_chave_w.delete;
	tb_dt_evento_w.delete;

	fetch C01 bulk collect into tb_seq_w, tb_seq_chave_w, tb_dt_evento_w
	limit current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer;

	exit when tb_seq_w.count = 0;

	-- manda para o banco (redundncia)

	forall i in tb_seq_w.first .. tb_seq_w.last

		update 	pls_monitor_tiss_guia
		set	ie_tipo_registro = '1',
			dt_processamento = tb_dt_evento_w(i),
			dt_atualizacao = clock_timestamp(),
			nm_usuario 	= nm_usuario_p
		where	nr_sequencia = tb_seq_w(i);

		commit;

	-- manda para o banco (informao original)

	forall i in tb_seq_chave_w.first .. tb_seq_chave_w.last

		update	pls_moni_tiss_chave_guia
		set	ie_tipo_registro = '1',
			dt_processamento = tb_dt_evento_w(i),
			dt_atualizacao = clock_timestamp(),
			nm_usuario 	= nm_usuario_p
		where	nr_sequencia = tb_seq_chave_w(i);

		commit;
end loop;

close C01;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.atualizar_contas_inclusao ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;