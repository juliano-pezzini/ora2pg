-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.descartar_pag_red_propria ( nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


tb_nr_sequencia_w	pls_util_cta_pck.t_number_table;
j			integer := 0;

C01 CURSOR(	dt_inicio_pc		pls_monitor_tiss_lote.dt_mes_competencia%type,
		dt_fim_pc		pls_monitor_tiss_lote.dt_mes_competencia%type,
		cd_estabelecimento_pc	estabelecimento.cd_estabelecimento%type,
		ie_controla_estab_pc	pls_controle_estab.ie_monitoramento_ans%type) FOR
	SELECT	/*+ PARALLEL(a)*/ a.nr_sequencia,
		a.nr_seq_conta
	from	pls_monitor_tiss_alt a
	where	a.dt_evento between dt_inicio_pc and dt_fim_pc
	and 	a.ie_status in ('P', 'N')
	and	a.ie_tipo_evento in ('PC','PR')
	and	ie_controla_estab_pc = 'N'
	
union all

	SELECT	/*+ PARALLEL(a)*/ a.nr_sequencia,
		a.nr_seq_conta
	from	pls_monitor_tiss_alt a
	where	a.dt_evento between dt_inicio_pc and dt_fim_pc
	and 	a.ie_status in ('P', 'N')
	and	a.ie_tipo_evento in ('PC','PR','PD')
	and	ie_controla_estab_pc = 'S'
	and	a.cd_estabelecimento = cd_estabelecimento_pc;

BEGIN

for r_C01_w in C01(current_setting('pls_gerencia_envio_ans_pck.dt_mes_competencia_ini_w')::pls_monitor_tiss_lote.dt_mes_competencia%type, current_setting('pls_gerencia_envio_ans_pck.dt_mes_competencia_fim_w')::pls_monitor_tiss_lote.dt_mes_competencia%type, cd_estabelecimento_p, current_setting('pls_gerencia_envio_ans_pck.ie_controla_estab_w')::pls_controle_estab.ie_monitoramento_ans%type) loop

	if (pls_gerencia_envio_ans_pck.obter_se_envia_pagamento('PC', r_c01_w.nr_seq_conta, cd_estabelecimento_p) = 'N') then

		tb_nr_sequencia_w(j) := r_C01_w.nr_sequencia;

		if (tb_nr_sequencia_w.count > current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer) then
			forall i in tb_nr_sequencia_w.first .. tb_nr_sequencia_w.last
				update	pls_monitor_tiss_alt
				set	ie_status = 'D',
					dt_atualizacao = clock_timestamp(),
					nm_usuario = nm_usuario_p
				where	nr_sequencia = tb_nr_sequencia_w(i);
			commit;

			tb_nr_sequencia_w.delete;
			j := 0;
		else
			j := j + 1;
		end if;
	end if;
end loop;

if (tb_nr_sequencia_w.count > 0) then
	forall i in tb_nr_sequencia_w.first .. tb_nr_sequencia_w.last
		update	pls_monitor_tiss_alt
		set	ie_status = 'D',
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p
		where	nr_sequencia = tb_nr_sequencia_w(i);
	commit;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.descartar_pag_red_propria ( nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;