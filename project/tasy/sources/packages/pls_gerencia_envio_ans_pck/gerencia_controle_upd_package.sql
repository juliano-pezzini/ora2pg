-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.gerencia_controle_upd ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, ie_tipo_processo_p text, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


tb_seq_w		pls_util_cta_pck.t_number_table;
nr_seq_processo_w	pls_monitor_tempo_lote.nr_sequencia%type;

dados_cta_val_up CURSOR(	nr_seq_lote_pc	pls_monitor_tiss_cta_val.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia
	from	pls_monitor_tiss_cta_val a
	where	a.nr_seq_lote_monitor = nr_seq_lote_pc;

dados_cta_proc_val_up CURSOR(	nr_seq_lote_pc	pls_monitor_tiss_cta_val.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia
	from	pls_monitor_tiss_cta_val b,
		pls_monitor_tiss_proc_val a
	where	b.nr_seq_lote_monitor 	= nr_seq_lote_pc
	and	a.nr_seq_cta_val 	= b.nr_sequencia;

dados_cta_mat_val_up CURSOR(	nr_seq_lote_pc	pls_monitor_tiss_cta_val.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia
	from	pls_monitor_tiss_cta_val b,
		pls_monitor_tiss_mat_val a
	where	b.nr_seq_lote_monitor 	= nr_seq_lote_pc
	and	a.nr_seq_cta_val 	= b.nr_sequencia;

dados_cta_inc_val CURSOR(	nr_seq_lote_pc	pls_monitor_tiss_cta_val.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia
	from	pls_monitor_tiss_cta_val b,
		pls_monitor_tiss_inc_val a
	where	b.nr_seq_lote_monitor 	= nr_seq_lote_pc
	and	b.ie_conta_atualizada 	= 'N'
	and	a.nr_seq_cta_val 	= b.nr_sequencia;

dados_cta_mat_val CURSOR(	nr_seq_lote_pc	pls_monitor_tiss_cta_val.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia
	from	pls_monitor_tiss_cta_val b,
		pls_monitor_tiss_mat_val a
	where	b.nr_seq_lote_monitor 	= nr_seq_lote_pc
	and	b.ie_conta_atualizada 	= 'N'
	and	a.nr_seq_cta_val 	= b.nr_sequencia
	
union all

	SELECT	a.nr_sequencia
	from	pls_monitor_tiss_cta_val b,
		pls_monitor_tiss_mat_val a
	where	b.nr_seq_lote_monitor 	= nr_seq_lote_pc
	and	b.ie_conta_atualizada 	= 'S'
	and	a.nr_seq_cta_val 	= b.nr_sequencia
	and	a.ie_item_atualizado	= 'N';

-- busca todas os itens de contas que devem ser excludas e os itens de contas que esto ativas

dados_cta_proc_val CURSOR(	nr_seq_lote_pc	pls_monitor_tiss_cta_val.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia
	from	pls_monitor_tiss_cta_val b,
		pls_monitor_tiss_proc_val a
	where	b.nr_seq_lote_monitor 	= nr_seq_lote_pc
	and	b.ie_conta_atualizada 	= 'N'
	and	a.nr_seq_cta_val 	= b.nr_sequencia
	
union all

	SELECT	a.nr_sequencia
	from	pls_monitor_tiss_cta_val b,
		pls_monitor_tiss_proc_val a
	where	b.nr_seq_lote_monitor 	= nr_seq_lote_pc
	and	b.ie_conta_atualizada 	= 'S'
	and	a.nr_seq_cta_val 	= b.nr_sequencia
	and	a.ie_item_atualizado	= 'N';

dados_cta_val_del CURSOR(	nr_seq_lote_pc	pls_monitor_tiss_cta_val.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia
	from	pls_monitor_tiss_cta_val a
	where	a.nr_seq_lote_monitor = nr_seq_lote_pc
	and	a.ie_conta_atualizada = 'N';


BEGIN

-- se for incio do processo

if (ie_tipo_processo_p = 'I') then

	nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	nr_seq_lote_p, 'Controle de atualizao inicial', 'I', nm_usuario_p, nr_seq_processo_w);

	-- Controle para excluir as contas que no so mais necessrias no envio para ANS,.

	-- Ao inserir ou alterar uma conta na tabela PLS_MONITOR_TISS_CTA_ALT o campo passar a ser 'S',

	-- as contas que ficarem com o valor 'N' sero excludas do lote

	open dados_cta_val_up(nr_seq_lote_p);
	loop
		tb_seq_w.delete;

		fetch dados_cta_val_up bulk collect into tb_seq_w
		limit current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer;

		exit when tb_seq_w.count = 0;

		forall i in tb_seq_w.first .. tb_seq_w.last
			update 	pls_monitor_tiss_cta_val
			set	ie_conta_atualizada = 'N'
			where	nr_sequencia = tb_seq_w(i);

		commit;
	end loop;
	close dados_cta_val_up;

	-- Controle para excluir os itens que no so mais necessrias no envio para ANS,.

	-- Ao inserir ou alterar uma conta na tabela PLS_MONITOR_TISS_PROC_VAL o campo passar a ser 'S',

	-- os itens que ficarem com o valor 'N' sero excludas do lote

	open dados_cta_proc_val_up(nr_seq_lote_p);
	loop
		tb_seq_w.delete;

		fetch dados_cta_proc_val_up bulk collect into tb_seq_w
		limit current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer;

		exit when tb_seq_w.count = 0;

		forall i in tb_seq_w.first .. tb_seq_w.last
			update 	pls_monitor_tiss_proc_val
			set	ie_item_atualizado = 'N'
			where	nr_sequencia = tb_seq_w(i);

		commit;
	end loop;
	close dados_cta_proc_val_up;

	-- Controle para excluir os itens que no so mais necessrias no envio para ANS,.

	-- Ao inserir ou alterar uma conta na tabela PLS_MONITOR_TISS_MAT_VAL o campo passar a ser 'S',

	-- os itens que ficarem com o valor 'N' sero excludas do lote

	open dados_cta_mat_val_up(nr_seq_lote_p);
	loop
		tb_seq_w.delete;

		fetch dados_cta_mat_val_up bulk collect into tb_seq_w
		limit current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer;

		exit when tb_seq_w.count = 0;

		forall i in tb_seq_w.first .. tb_seq_w.last
			update 	pls_monitor_tiss_mat_val
			set	ie_item_atualizado = 'N'
			where	nr_sequencia = tb_seq_w(i);

		commit;
	end loop;
	close dados_cta_mat_val_up;

	nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	null, null, 'F', null, nr_seq_processo_w);
else

	nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	nr_seq_lote_p, 'Controle de atualizao final', 'I', nm_usuario_p, nr_seq_processo_w);

	-- apagar registros da tabela pls_monitor_tiss_inc_val que no foram atualizados na gerao do lote

	open dados_cta_inc_val(nr_seq_lote_p);
	loop
		tb_seq_w.delete;

		fetch dados_cta_inc_val bulk collect into tb_seq_w
		limit current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer;

		exit when tb_seq_w.count = 0;

		forall i in tb_seq_w.first .. tb_seq_w.last
			delete from pls_monitor_tiss_inc_val
			where	nr_sequencia = tb_seq_w(i);

		commit;
	end loop;
	close dados_cta_inc_val;

	-- apagar registros da tabela pls_monitor_tiss_mat_val que no foram atualizados na gerao do lote

	open dados_cta_mat_val(nr_seq_lote_p);
	loop
		tb_seq_w.delete;

		fetch dados_cta_mat_val bulk collect into tb_seq_w
		limit current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer;

		exit when tb_seq_w.count = 0;

		forall i in tb_seq_w.first .. tb_seq_w.last
			delete from pls_monitor_tiss_mat_val
			where	nr_sequencia = tb_seq_w(i);

		commit;
	end loop;
	close dados_cta_mat_val;

	-- apagar registros da tabela pls_monitor_tiss_proc_val que no foram atualizados na gerao do lote

	open dados_cta_proc_val(nr_seq_lote_p);
	loop
		tb_seq_w.delete;

		fetch dados_cta_proc_val bulk collect into tb_seq_w
		limit current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer;

		exit when tb_seq_w.count = 0;

		forall i in tb_seq_w.first .. tb_seq_w.last
			delete from pls_monitor_tiss_proc_val
			where	nr_sequencia = tb_seq_w(i);

		commit;
	end loop;
	close dados_cta_proc_val;

	-- apagar registros da tabela pls_monitor_tiss_cta_val que no foram atualizados na gerao do lote

	open dados_cta_val_del(nr_seq_lote_p);
	loop
		tb_seq_w.delete;

		fetch dados_cta_val_del bulk collect into tb_seq_w
		limit current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer;

		exit when tb_seq_w.count = 0;

		forall i in tb_seq_w.first .. tb_seq_w.last
			delete from pls_monitor_tiss_cta_val
			where	nr_sequencia = tb_seq_w(i);

		commit;
	end loop;
	close dados_cta_val_del;

	nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	null, null, 'F', null, nr_seq_processo_w);
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.gerencia_controle_upd ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, ie_tipo_processo_p text, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
