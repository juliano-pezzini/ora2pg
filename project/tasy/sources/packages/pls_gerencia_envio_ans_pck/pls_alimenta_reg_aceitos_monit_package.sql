-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.pls_alimenta_reg_aceitos_monit (nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


tb_nr_seq_guia_w		pls_util_cta_pck.t_number_table;
tb_cd_guia_operadora_w		pls_util_cta_pck.t_varchar2_table_20;
tb_cd_guia_prestador_w		pls_util_cta_pck.t_varchar2_table_20;
tb_ie_tipo_registro_w		pls_util_cta_pck.t_varchar2_table_20;
tb_nr_seq_prestador_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_prest_inter_w		pls_util_cta_pck.t_number_table;
tb_cd_cpf_cgc_prest_exec_w	pls_util_cta_pck.t_varchar2_table_20;
tb_ie_identif_prest_exec_w	pls_util_cta_pck.t_varchar2_table_20;
tb_nr_seq_lote_ret_w		pls_util_cta_pck.t_number_table;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_monitor_tiss_lote
	order by nr_sequencia;

C02 CURSOR(nr_seq_lote_monitor_pc	pls_monitor_tiss_lote.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia,
		a.cd_guia_operadora,
		a.cd_guia_prestador,
		a.ie_tipo_registro,
		a.nr_seq_prestador,
		a.nr_seq_prest_inter,
		a.cd_cpf_cgc_prest_exec,
		a.ie_identif_prest_exec,
		(SELECT	max(x.nr_sequencia)
		 from	pls_monitor_tiss_lote_ret x
		 where	x.nr_seq_arquivo = a.nr_seq_arq_monitor) nr_seq_lote_ret
	from	pls_monitor_tiss_guia a
	where	a.nr_seq_lote_monitor = nr_seq_lote_monitor_pc
	and	not exists (	select	1
				from	pls_monitor_tiss_guia_ret x
				where	x.nr_seq_guia_monitor = a.nr_sequencia)
	and	not exists (	select	1
				from	pls_mon_tiss_guia_ret_act x
				where	x.nr_seq_guia_monitor = a.nr_sequencia)
	and	exists (	select	1
				from	pls_monitor_tiss_lote_ret x
				where	x.nr_seq_arquivo = a.nr_seq_arq_monitor
				and (x.qt_total_alterado > 0 or
					x.qt_total_excluido > 0 or
					x.qt_total_incluido > 0));

BEGIN

for r_C01_w in C01 loop

	Open C02(r_C01_w.nr_sequencia);
	loop
		fetch C02 bulk collect into 	tb_nr_seq_guia_w,
						tb_cd_guia_operadora_w,
						tb_cd_guia_prestador_w,
						tb_ie_tipo_registro_w,
						tb_nr_seq_prestador_w,
						tb_nr_seq_prest_inter_w,
						tb_cd_cpf_cgc_prest_exec_w,
						tb_ie_identif_prest_exec_w,
						tb_nr_seq_lote_ret_w
		limit 500;

		exit when tb_nr_seq_guia_w.count = 0;

		forall i in tb_nr_seq_guia_w.first .. tb_nr_seq_guia_w.last
			insert	into	pls_mon_tiss_guia_ret_act(	cd_cpf_cgc_prest_exec, cd_guia_operadora, cd_guia_prestador,
					dt_atualizacao, dt_atualizacao_nrec, ie_identif_prest_exec,
					ie_tipo_registro, nm_usuario, nm_usuario_nrec,
					nr_seq_guia_monitor, nr_seq_lote_monitor_ret, nr_seq_prestador,
					nr_seq_prest_inter, nr_sequencia)
			values (	tb_cd_cpf_cgc_prest_exec_w(i), tb_cd_guia_operadora_w(i), tb_cd_guia_prestador_w(i),
					clock_timestamp(), clock_timestamp(), tb_ie_identif_prest_exec_w(i),
					tb_ie_tipo_registro_w(i), nm_usuario_p, nm_usuario_p,
					tb_nr_seq_guia_w(i), tb_nr_seq_lote_ret_w(i), tb_nr_seq_prestador_w(i),
					tb_nr_seq_prest_inter_w(i), nextval('pls_mon_tiss_guia_ret_act_seq'));
		commit;
	end loop;

	if (C02%ISOPEN) then
		close C02;
	end if;
end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.pls_alimenta_reg_aceitos_monit (nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;