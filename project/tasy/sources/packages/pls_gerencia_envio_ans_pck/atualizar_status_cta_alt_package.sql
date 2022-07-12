-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.atualizar_status_cta_alt ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE



tb_nr_seq_cta_alt_w		pls_util_cta_pck.t_number_table;
ie_fornec_lote_w		pls_monitor_tiss_lote.ie_fornec_direto%type;

C01 CURSOR( nr_seq_lote_pc	pls_monitor_tiss_lote.nr_sequencia%type ) FOR
	SELECT 	nr_seq_cta_alt
	from	pls_monitor_tiss_alt_guia p
	where	p.nr_seq_lote_monitor 	= nr_seq_lote_pc;

C02 CURSOR( 	nr_seq_lote_pc		pls_monitor_tiss_lote.nr_sequencia%type,
		dt_inicio_pc		pls_monitor_tiss_lote.dt_mes_competencia%type,
		dt_fim_pc		pls_monitor_tiss_lote.dt_mes_competencia%type,
		cd_estabelecimento_pc	estabelecimento.cd_estabelecimento%type,
		ie_controla_estab_pc	pls_controle_estab.ie_monitoramento_ans%type) FOR
	SELECT	/*+ PARALLEL(a)*/ a.nr_sequencia
	from	pls_monitor_tiss_alt a,
		pls_conta b,
		pls_protocolo_conta c
	where	a.nr_seq_conta = b.nr_sequencia
	and	b.nr_seq_protocolo = c.nr_sequencia
	and	a.dt_evento between dt_inicio_pc and dt_fim_pc
	and	a.ie_status = 'P'
	and	ie_controla_estab_pc = 'N'
	and 	ie_fornec_lote_w = 'N'
	and 	c.ie_fornec_direto = 'N'
	
union all

	SELECT	/*+ PARALLEL(a)*/ a.nr_sequencia
	from	pls_monitor_tiss_alt a,
		pls_conta b,
		pls_protocolo_conta c
	where	a.nr_seq_conta = b.nr_sequencia
	and	b.nr_seq_protocolo = c.nr_sequencia
	and	dt_evento between dt_inicio_pc and dt_fim_pc
	and	a.ie_status = 'P'
	and	ie_controla_estab_pc = 'S'
	and	a.cd_estabelecimento = cd_estabelecimento_pc
	and 	ie_fornec_lote_w = 'N'
	and 	c.ie_fornec_direto = 'N'
	
union all

	select	/*+ PARALLEL(a)*/ a.nr_sequencia
	from	pls_monitor_tiss_alt a,
		pls_conta b,
		pls_protocolo_conta c
	where	a.nr_seq_conta = b.nr_sequencia
	and	b.nr_seq_protocolo = c.nr_sequencia
	and	a.dt_evento between dt_inicio_pc and dt_fim_pc
	and	a.ie_status = 'P'
	and	ie_controla_estab_pc = 'N'
	and 	ie_fornec_lote_w = 'N'
	and 	coalesce(c.ie_fornec_direto::text, '') = ''
	
union all

	select	/*+ PARALLEL(a)*/ a.nr_sequencia
	from	pls_monitor_tiss_alt a,
		pls_conta b,
		pls_protocolo_conta c
	where	a.nr_seq_conta = b.nr_sequencia
	and	b.nr_seq_protocolo = c.nr_sequencia
	and	dt_evento between dt_inicio_pc and dt_fim_pc
	and	a.ie_status = 'P'
	and	ie_controla_estab_pc = 'S'
	and	a.cd_estabelecimento = cd_estabelecimento_pc
	and 	ie_fornec_lote_w = 'N'
	and 	coalesce(c.ie_fornec_direto::text, '') = '';
	
C03 CURSOR( 	nr_seq_lote_pc		pls_monitor_tiss_lote.nr_sequencia%type,
		dt_inicio_pc		pls_monitor_tiss_lote.dt_mes_competencia%type,
		dt_fim_pc		pls_monitor_tiss_lote.dt_mes_competencia%type,
		cd_estabelecimento_pc	estabelecimento.cd_estabelecimento%type,
		ie_controla_estab_pc	pls_controle_estab.ie_monitoramento_ans%type) FOR
	SELECT	/*+ PARALLEL(a)*/ a.nr_sequencia
	from	pls_monitor_tiss_alt a,
		pls_conta b,
		pls_protocolo_conta c
	where	a.nr_seq_conta = b.nr_sequencia
	and	b.nr_seq_protocolo = c.nr_sequencia
	and	a.dt_evento between dt_inicio_pc and dt_fim_pc
	and	a.ie_status = 'P'
	and	ie_controla_estab_pc = 'N'
	and 	ie_fornec_lote_w = 'S'
	and 	c.ie_fornec_direto = 'S'
	
union all

	SELECT	/*+ PARALLEL(a)*/ a.nr_sequencia
	from	pls_monitor_tiss_alt a,
		pls_conta b,
		pls_protocolo_conta c
	where	a.nr_seq_conta = b.nr_sequencia
	and	b.nr_seq_protocolo = c.nr_sequencia
	and	dt_evento between dt_inicio_pc and dt_fim_pc
	and	a.ie_status = 'P'
	and	ie_controla_estab_pc = 'S'
	and	a.cd_estabelecimento = cd_estabelecimento_pc
	and 	ie_fornec_lote_w = 'S'
	and 	c.ie_fornec_direto = 'S';


BEGIN

select coalesce(max(ie_fornec_direto),'N')
into STRICT	ie_fornec_lote_w
from	pls_monitor_tiss_lote
where 	nr_sequencia = nr_seq_lote_p;

-- Carrega as declares de nascido vivos

open C01( nr_seq_lote_p );
loop
	tb_nr_seq_cta_alt_w.delete;

	fetch  C01 bulk collect into tb_nr_seq_cta_alt_w
	limit current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer;

	exit when tb_nr_seq_cta_alt_w.count = 0;

	forall i in tb_nr_seq_cta_alt_w.first .. tb_nr_seq_cta_alt_w.last

		--Setar o log de alterao para Processado, ou seja, o item j foi utilizado  PR - Processado

		update	pls_monitor_tiss_alt a
		set	a.ie_status 		= 'PR',
			a.dt_atualizacao 	= clock_timestamp(),
			a.nm_usuario 		= nm_usuario_p
		where	a.nr_sequencia		= tb_nr_seq_cta_alt_w(i);
	commit;
end loop;
close C01;

--Carrega as declares de bito

open C02( nr_seq_lote_p, current_setting('pls_gerencia_envio_ans_pck.dt_mes_competencia_ini_w')::pls_monitor_tiss_lote.dt_mes_competencia%type, current_setting('pls_gerencia_envio_ans_pck.dt_mes_competencia_fim_w')::pls_monitor_tiss_lote.dt_mes_competencia%type, cd_estabelecimento_p, current_setting('pls_gerencia_envio_ans_pck.ie_controla_estab_w')::pls_controle_estab.ie_monitoramento_ans%type );
loop
	tb_nr_seq_cta_alt_w.delete;

	fetch  C02 bulk collect into tb_nr_seq_cta_alt_w
	limit current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer;

	exit when tb_nr_seq_cta_alt_w.count = 0;

	forall i in tb_nr_seq_cta_alt_w.first .. tb_nr_seq_cta_alt_w.last

		update	pls_monitor_tiss_alt
		set	ie_status 	= 'D',
			dt_atualizacao 	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	ie_status  	= 'P'
		and	nr_sequencia	= tb_nr_seq_cta_alt_w(i);

	commit;
end loop;
close C02;

open C03( nr_seq_lote_p, current_setting('pls_gerencia_envio_ans_pck.dt_mes_competencia_ini_w')::pls_monitor_tiss_lote.dt_mes_competencia%type, current_setting('pls_gerencia_envio_ans_pck.dt_mes_competencia_fim_w')::pls_monitor_tiss_lote.dt_mes_competencia%type, cd_estabelecimento_p, current_setting('pls_gerencia_envio_ans_pck.ie_controla_estab_w')::pls_controle_estab.ie_monitoramento_ans%type );
loop
	tb_nr_seq_cta_alt_w.delete;

	fetch  C03 bulk collect into tb_nr_seq_cta_alt_w
	limit current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer;

	exit when tb_nr_seq_cta_alt_w.count = 0;

	forall i in tb_nr_seq_cta_alt_w.first .. tb_nr_seq_cta_alt_w.last

		update	pls_monitor_tiss_alt
		set	ie_status 	= 'D',
			dt_atualizacao 	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	ie_status  	= 'P'
		and	nr_sequencia	= tb_nr_seq_cta_alt_w(i);

	commit;
end loop;
close C03;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.atualizar_status_cta_alt ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
