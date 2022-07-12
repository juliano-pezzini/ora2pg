-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerar_pre_estab_ans_pck.carregar_lotes_a800 ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


tb_nr_seq_fatura_pre_w		pls_util_cta_pck.t_number_table;
tb_cd_cooperativa_w		pls_util_cta_pck.t_varchar2_table_10;

C01 CURSOR(	dt_inicio_pc		pls_monitor_tiss_lote.dt_mes_competencia%type,
		dt_fim_pc		pls_monitor_tiss_lote.dt_mes_competencia%type,
		ie_monitoramento_ans_pc	pls_controle_estab.ie_monitoramento_ans%type,
		cd_estabelecimento_pc	estabelecimento.cd_estabelecimento%type) FOR
	SELECT	a.nr_sequencia nr_seq_fatura_pre,
		a.cd_unimed_origem
	from	ptu_fatura_pre a
	where	a.dt_competencia between dt_inicio_pc and dt_fim_pc
	and	a.ie_envio_recebimento = 'R'
	and	a.ie_status_monitoramento in ('P', 'N')
	and	ie_monitoramento_ans_pc = 'N'
	
union all

	SELECT	a.nr_sequencia nr_seq_fatura_pre,
		a.cd_unimed_origem
	from	ptu_fatura_pre a
	where	a.dt_competencia between dt_inicio_pc and dt_fim_pc
	and	a.ie_envio_recebimento = 'R'
	and	a.ie_status_monitoramento in ('P', 'N')
	and	a.cd_estabelecimento = cd_estabelecimento_pc
	and	ie_monitoramento_ans_pc = 'S';


BEGIN

Open C01(current_setting('pls_gerar_pre_estab_ans_pck.dt_inicio_ref_w')::pls_monitor_tiss_lote.dt_mes_competencia%type, current_setting('pls_gerar_pre_estab_ans_pck.dt_fim_ref_w')::pls_monitor_tiss_lote.dt_mes_competencia%type, current_setting('pls_gerar_pre_estab_ans_pck.ie_monitoramento_ans_w')::pls_controle_estab.ie_monitoramento_ans%type, cd_estabelecimento_p);
loop
	tb_nr_seq_fatura_pre_w.delete;
	tb_cd_cooperativa_w.delete;

	fetch C01 bulk collect into tb_nr_seq_fatura_pre_w, tb_cd_cooperativa_w
	limit current_setting('pls_gerar_pre_estab_ans_pck.qt_transacao_w')::integer;

	exit when tb_nr_seq_fatura_pre_w.count = 0;

	forall i in tb_nr_seq_fatura_pre_w.first .. tb_nr_seq_fatura_pre_w.last
		insert	into	pls_monit_tiss_pre_est_val(	dt_atualizacao, dt_atualizacao_nrec, nm_usuario,
				nm_usuario_nrec, nr_seq_fatura_pre, nr_seq_lote_monitor,
				cd_cooperativa, nr_sequencia)
		values (	clock_timestamp(), clock_timestamp(), nm_usuario_p,
				nm_usuario_p, tb_nr_seq_fatura_pre_w(i), nr_seq_lote_p,
				tb_cd_cooperativa_w(i), nextval('pls_monit_tiss_pre_est_val_seq'));
	commit;
end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_pre_estab_ans_pck.carregar_lotes_a800 ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;