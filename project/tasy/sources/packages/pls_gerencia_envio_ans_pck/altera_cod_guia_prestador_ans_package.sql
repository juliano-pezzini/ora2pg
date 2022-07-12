-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.altera_cod_guia_prestador_ans ( nr_seq_lote_monitor_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_guia_alterada_p INOUT bigint) AS $body$
DECLARE


nr_seq_processo_exec_w	pls_monitor_tiss_processo.nr_sequencia%type;
tb_nr_sequencia_w	pls_util_cta_pck.t_number_table;
i			integer;

C01 CURSOR(nr_seq_lote_monitor_pc		pls_monitor_tiss_lote.nr_sequencia%type) FOR
	SELECT	a.nr_seq_conta,
		(SELECT	count(1)
		 from	pls_monitor_tiss_cta_val b
		 where	a.cd_guia_operadora = b.cd_guia_operadora
		 and	a.cd_guia_prestador = b.cd_guia_prestador
		 and	a.nr_seq_conta != b.nr_seq_conta) qt_envios
	from	pls_monitor_tiss_cta_val a
	where	a.nr_seq_lote_monitor = nr_seq_lote_monitor_pc;

BEGIN
ie_guia_alterada_p := 0;
i := 0;

nr_seq_processo_exec_w := pls_gerencia_envio_ans_pck.grava_processo(	nr_seq_lote_monitor_p, 7, nm_usuario_p, null, nr_seq_processo_exec_w);

for r_C01_w in C01(nr_seq_lote_monitor_p) loop
	if (r_C01_w.qt_envios > 0) then

		tb_nr_sequencia_w(i) := r_C01_w.nr_seq_conta;
		ie_guia_alterada_p := ie_guia_alterada_p + 1;

		if (i >= pls_util_pck.qt_registro_transacao_w) then
			forall j in tb_nr_sequencia_w.first .. tb_nr_sequencia_w.last
				update	pls_conta
				set	cd_guia_prestador_ans = nr_sequencia
				where	nr_sequencia = tb_nr_sequencia_w(j);
			commit;

			i := 0;
			tb_nr_sequencia_w.delete;
		else
			i := i + 1;
		end if;
	end if;
end loop;

if (tb_nr_sequencia_w.count > 0) then
	forall j in tb_nr_sequencia_w.first .. tb_nr_sequencia_w.last
		update	pls_conta
		set	cd_guia_prestador_ans = nr_sequencia
		where	nr_sequencia = tb_nr_sequencia_w(j);
	commit;
end if;

CALL pls_gerencia_envio_ans_pck.atualiza_cd_guia_prestador(nr_seq_lote_monitor_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.altera_cod_guia_prestador_ans ( nr_seq_lote_monitor_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_guia_alterada_p INOUT bigint) FROM PUBLIC;