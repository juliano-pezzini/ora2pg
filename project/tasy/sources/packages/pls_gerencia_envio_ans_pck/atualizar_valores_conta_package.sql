-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Procedure utilizada para atualizar os valores apresentados, de tabela prpria e valor pago



CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.atualizar_valores_conta ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type ) AS $body$
DECLARE


nr_seq_processo_w	pls_monitor_tempo_lote.nr_sequencia%type;

tb_sequencia_w			pls_util_cta_pck.t_number_table;
tb_total_apresentado_w		pls_util_cta_pck.t_number_table;
tb_total_tab_propria_w		pls_util_cta_pck.t_number_table;
tb_total_pago_w			pls_util_cta_pck.t_number_table;
tb_total_glosa_w		pls_util_cta_pck.t_number_table;
tb_total_fornecedor_w		pls_util_cta_pck.t_number_table;
tb_total_material_w		pls_util_cta_pck.t_number_table;
tb_total_opme_w			pls_util_cta_pck.t_number_table;
tb_total_taxas_w		pls_util_cta_pck.t_number_table;
tb_total_diaria_w		pls_util_cta_pck.t_number_table;
tb_total_procedimento_w		pls_util_cta_pck.t_number_table;
tb_total_medicamento_w		pls_util_cta_pck.t_number_table;
tb_total_copart_w		pls_util_cta_pck.t_number_table;
ie_fornec_direto_w		pls_monitor_tiss_lote.ie_fornec_direto%type;

C01 CURSOR( nr_seq_lote_pc	pls_monitor_tiss_lote.nr_sequencia%type)FOR
	SELECT	f.nr_sequencia,
		(SELECT	coalesce(sum(vl_procedimento), 0) vl_total
		 from	pls_monitor_tiss_proc_val
		 where	nr_seq_cta_val =  f.nr_sequencia
		 and	ie_item_atualizado = 'S')
		 +
		(select	coalesce(sum(vl_material), 0) vl_total
		from	pls_monitor_tiss_mat_val
		where	nr_seq_cta_val = f.nr_sequencia
		and	ie_item_atualizado = 'S') vl_total_apresentado,
		(select	coalesce(sum(vl_liberado), 0) vl_total
		 from	pls_monitor_tiss_proc_val
		 where	nr_seq_cta_val = f.nr_sequencia
		 and	cd_tabela_ref	in ('00','98')
		 and	ie_item_atualizado = 'S')
		 +
		(select	coalesce(sum(vl_liberado), 0) vl_total
		 from	pls_monitor_tiss_mat_val
		 where	nr_seq_cta_val = f.nr_sequencia
		 and	cd_tabela_ref	in ('00','98')
		 and	ie_item_atualizado = 'S') vl_total_tab_propria,
		(select	coalesce(sum(vl_liberado), 0) vl_total
		 from	pls_monitor_tiss_proc_val
		 where	nr_seq_cta_val = f.nr_sequencia
		 and	ie_item_atualizado = 'S')
		 +
		(select	coalesce(sum(vl_liberado), 0) vl_total
		 from	pls_monitor_tiss_mat_val
		 where	nr_seq_cta_val = f.nr_sequencia
		 and	ie_item_atualizado = 'S') vl_total_pago,
		(select	coalesce(sum(vl_glosa), 0) vl_total
		 from	pls_monitor_tiss_proc_val
		 where	nr_seq_cta_val = f.nr_sequencia
		 and	ie_item_atualizado = 'S')
		 +
		(select	coalesce(sum(vl_glosa), 0) vl_total
		 from	pls_monitor_tiss_mat_val
		 where	nr_seq_cta_val = f.nr_sequencia
		 and	ie_item_atualizado = 'S') vl_total_glosa,
		(select	coalesce(sum(vl_pago_fornecedor), 0) vl_total
		 from	pls_monitor_tiss_mat_val
		 where	nr_seq_cta_val = f.nr_sequencia
		 and	ie_item_atualizado = 'S') vl_total_fornecedor,
		(select coalesce(sum(x.vl_liberado), 0) vl_total
		 from	pls_monitor_tiss_mat_val	x,
			pls_conta_mat			y
		 where	x.nr_seq_cta_val 	= f.nr_sequencia
		 and	x.nr_seq_conta		= y.nr_seq_conta
		 and	x.nr_seq_conta_mat	= Y.nr_sequencia
		 and	y.ie_tipo_despesa	= '3'
		 and	x.cd_tabela_ref 	in ('19','00','98')) vl_total_material,
		 (select coalesce(sum(x.vl_liberado), 0) vl_total
		 from	pls_monitor_tiss_mat_val	x,
			pls_conta_mat			y
		 where	x.nr_seq_cta_val 	= f.nr_sequencia
		 and	x.nr_seq_conta		= y.nr_seq_conta
		 and	x.nr_seq_conta_mat	= Y.nr_sequencia
		 and	y.ie_tipo_despesa	= '7'
		 and	x.cd_tabela_ref 	in ('19','00','98')) vl_total_opme,
		 (select coalesce(sum(x.vl_liberado), 0) vl_total
		 from	pls_monitor_tiss_mat_val	x,
			pls_conta_mat			y
		 where	x.nr_seq_cta_val 	= f.nr_sequencia
		 and	x.nr_seq_conta		= y.nr_seq_conta
		 and	x.nr_seq_conta_mat	= Y.nr_sequencia
		 and (y.ie_tipo_despesa	= '2' and x.cd_tabela_ref in ('20','19','00','98')))
		 +
		(select coalesce(sum(x.vl_liberado), 0) vl_total
		 from	pls_monitor_tiss_mat_val	x,
			pls_conta_mat			y
		 where	x.nr_seq_cta_val 	= f.nr_sequencia
		 and	x.nr_seq_conta		= y.nr_seq_conta
		 and	x.nr_seq_conta_mat	= Y.nr_sequencia
		 and (y.ie_tipo_despesa	= '1' and x.cd_tabela_ref in ('18','00','98'))) vl_total_medicamento,
		 (select coalesce(sum(x.vl_liberado), 0) vl_total
		 from	pls_monitor_tiss_proc_val	x,
			pls_conta_proc			y
		 where	x.nr_seq_cta_val 	= f.nr_sequencia
		 and	x.nr_seq_conta		= y.nr_seq_conta
		 and	x.nr_seq_conta_proc	= Y.nr_sequencia
		 and	y.ie_tipo_despesa	= '2'
		 and	x.cd_tabela_ref 	in ('18','00','98')) vl_total_taxa,
		 (select coalesce(sum(x.vl_liberado), 0) vl_total
		 from	pls_monitor_tiss_proc_val	x,
			pls_conta_proc			y
		 where	x.nr_seq_cta_val 	= f.nr_sequencia
		 and	x.nr_seq_conta		= y.nr_seq_conta
		 and	x.nr_seq_conta_proc	= Y.nr_sequencia
		 and	y.ie_tipo_despesa	= '1'
		 and	x.cd_tabela_ref 	in ('22','00','98'))
		 +
		 (select coalesce(sum(x.vl_liberado), 0) vl_total
		 from	pls_monitor_tiss_proc_val	x,
			pls_conta_proc			y
		 where	x.nr_seq_cta_val 	= f.nr_sequencia
		 and	x.nr_seq_conta		= y.nr_seq_conta
		 and	x.nr_seq_conta_proc	= Y.nr_sequencia
		 and	y.ie_tipo_despesa	= '4'
		 and	x.cd_tabela_ref 	in ('98','00')) vl_total_procedimento,
		 (select coalesce(sum(x.vl_liberado), 0) vl_total
		 from	pls_monitor_tiss_proc_val	x,
			pls_conta_proc			y
		 where	x.nr_seq_cta_val 	= f.nr_sequencia
		 and	x.nr_seq_conta		= y.nr_seq_conta
		 and	x.nr_seq_conta_proc	= Y.nr_sequencia
		 and	y.ie_tipo_despesa	= '3'
		 and	x.cd_tabela_ref 	in ('18','00','98')) vl_total_diaria,
		( (select coalesce(sum(x.vl_coparticipacao), 0) vl_total
		 from	pls_monitor_tiss_proc_val	x
		 where	x.nr_seq_cta_val 	= f.nr_sequencia) +
		(select coalesce(sum(x.vl_coparticipacao), 0) vl_total
		 from	pls_monitor_tiss_mat_val	x
		 where	x.nr_seq_cta_val 	= f.nr_sequencia))vl_total_copart
	from	pls_monitor_tiss_cta_val f
	where	f.nr_seq_lote_monitor = nr_seq_lote_pc
	and	f.ie_conta_atualizada = 'S'
	and	f.ie_tipo_evento != 'AV';

-- evento de alterao de valor salvamos os itens da conta para possvel auditoria futura

C02 CURSOR( nr_seq_lote_pc	pls_monitor_tiss_lote.nr_sequencia%type)FOR
	SELECT	f.nr_sequencia,
		(SELECT	coalesce(sum(z.vl_cobranca_guia), 0) vl_total
		 from	pls_moni_tiss_cta_val_av z
		 where	z.nr_seq_cta_val =  f.nr_sequencia) vl_total_apresentado,
		(select	coalesce(sum(z.vl_total_tabela_propria), 0) vl_total
		 from	pls_moni_tiss_cta_val_av z
		 where	z.nr_seq_cta_val = f.nr_sequencia) vl_total_tab_propria,
		(select	coalesce(sum(z.vl_total_pago), 0) vl_total
		 from	pls_moni_tiss_cta_val_av z
		 where	z.nr_seq_cta_val = f.nr_sequencia) vl_total_pago,
		(select	coalesce(sum(z.vl_total_glosa), 0) vl_total
		 from	pls_moni_tiss_cta_val_av z
		 where	z.nr_seq_cta_val = f.nr_sequencia) vl_total_glosa,
		 (select coalesce(sum(z.vl_total_fornecedor), 0) vl_total
		 from	pls_moni_tiss_cta_val_av z
		 where	z.nr_seq_cta_val = f.nr_sequencia) vl_total_fornecedor
	from	pls_monitor_tiss_cta_val f
	where	f.nr_seq_lote_monitor = nr_seq_lote_pc
	and	f.ie_conta_atualizada = 'S'
	and	f.ie_tipo_evento = 'AV';

-- busca todas as contas que no foram pagas

C03 CURSOR( nr_seq_lote_pc	pls_monitor_tiss_lote.nr_sequencia%type)FOR
	SELECT	f.nr_sequencia
	from	pls_monitor_tiss_cta_val f
	where	f.nr_seq_lote_monitor = nr_seq_lote_pc
	and	f.ie_conta_atualizada = 'S'
	and	coalesce(f.dt_pagamento_recurso::text, '') = ''
	and	coalesce(f.dt_pagamento_previsto::text, '') = '';


BEGIN

select coalesce(ie_fornec_direto, 'N')
into STRICT	ie_fornec_direto_w
from 	pls_monitor_tiss_lote
where 	nr_sequencia =  nr_seq_lote_p;

nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	nr_seq_lote_p, 'Atualizao dos valores totais das contas (eventos gerais)', 'I', nm_usuario_p, nr_seq_processo_w);

open C01(nr_seq_lote_p);
loop
	tb_sequencia_w.delete;
	tb_total_apresentado_w.delete;
	tb_total_tab_propria_w.delete;
	tb_total_pago_w.delete;
	tb_total_glosa_w.delete;
	tb_total_fornecedor_w.delete;
	tb_total_material_w.delete;
	tb_total_opme_w.delete;
	tb_total_medicamento_w.delete;
	tb_total_taxas_w.delete;
	tb_total_procedimento_w.delete;
	tb_total_diaria_w.delete;
	tb_total_copart_w.delete;

	
	
	fetch C01 bulk collect into 	tb_sequencia_w, tb_total_apresentado_w,
					tb_total_tab_propria_w, tb_total_pago_w,
					tb_total_glosa_w, tb_total_fornecedor_w,
					tb_total_material_w,tb_total_opme_w,
					tb_total_medicamento_w,tb_total_taxas_w,
					tb_total_procedimento_w,tb_total_diaria_w,
					tb_total_copart_w
	limit current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer;

	exit when tb_sequencia_w.count = 0;

		if ( ie_fornec_direto_w = 'N') then
			forall i in tb_sequencia_w.first .. tb_sequencia_w.last
				update 	pls_monitor_tiss_cta_val
				set	vl_cobranca_guia 	= coalesce(tb_total_apresentado_w(i), 0),
					vl_total_tabela_propria = coalesce(tb_total_tab_propria_w(i), 0),
					vl_total_pago		= coalesce(tb_total_pago_w(i), 0),
					vl_total_glosa		= coalesce(tb_total_glosa_w(i), 0),
					vl_total_fornecedor	= coalesce(tb_total_fornecedor_w(i), 0),
					vl_total_material	= coalesce(tb_total_material_w(i),0),
					vl_total_opm		= coalesce(tb_total_opme_w(i),0),
					vl_total_medicamentos	= coalesce(tb_total_medicamento_w(i),0),
					vl_total_taxa		= coalesce(tb_total_taxas_w(i),0),
					vl_total_procedimento	= coalesce(tb_total_procedimento_w(i),0),
					vl_total_diaria		= coalesce(tb_total_diaria_w(i),0),
					vl_total_copart		= coalesce(tb_total_copart_w(i),0),
					dt_atualizacao		= clock_timestamp(),
					nm_usuario		= nm_usuario_p
				where	nr_sequencia		= tb_sequencia_w(i);

			commit;
		else
			forall i in tb_sequencia_w.first .. tb_sequencia_w.last
				update 	pls_monitor_tiss_cta_val
				set	vl_cobranca_guia 	= coalesce(tb_total_apresentado_w(i), 0),
					vl_total_tabela_propria = coalesce(tb_total_tab_propria_w(i), 0),
					vl_total_pago		= coalesce(tb_total_pago_w(i), 0),
					vl_total_glosa		= coalesce(tb_total_glosa_w(i), 0),
					vl_total_fornecedor	= coalesce(tb_total_apresentado_w(i), 0),
					vl_total_material	= coalesce(tb_total_material_w(i),0),
					vl_total_opm		= coalesce(tb_total_opme_w(i),0),
					vl_total_medicamentos	= coalesce(tb_total_medicamento_w(i),0),
					vl_total_taxa		= coalesce(tb_total_taxas_w(i),0),
					vl_total_procedimento	= coalesce(tb_total_procedimento_w(i),0),
					vl_total_diaria		= coalesce(tb_total_diaria_w(i),0),
					vl_total_copart		= coalesce(tb_total_copart_w(i),0),
					dt_atualizacao		= clock_timestamp(),
					nm_usuario		= nm_usuario_p
				where	nr_sequencia		= tb_sequencia_w(i);

			commit;
		end if;

end loop;
close C01;

nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	null, null, 'F', null, nr_seq_processo_w);

nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	nr_seq_lote_p, 'Atualizao dos valores totais das contas (evento alterao de valor)', 'I', nm_usuario_p, nr_seq_processo_w);

-- faz a atualizao de valores na conta com base em todos os procedimentos existentes na conta quando a conta tiver uma ao de alterao de valor

-- os dados so buscados da tabela pls_moni_tiss_cta_val_av para possvel futura auditoria

open C02(nr_seq_lote_p);
loop
	tb_sequencia_w.delete;
	tb_total_apresentado_w.delete;
	tb_total_tab_propria_w.delete;
	tb_total_pago_w.delete;
	tb_total_glosa_w.delete;
	tb_total_fornecedor_w.delete;
	
	fetch C02 bulk collect into 	tb_sequencia_w, tb_total_apresentado_w,
					tb_total_tab_propria_w, tb_total_pago_w,
					tb_total_glosa_w, tb_total_fornecedor_w
	limit current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer;

	exit when tb_sequencia_w.count = 0;

	if ( ie_fornec_direto_w = 'N') then
			forall i in tb_sequencia_w.first .. tb_sequencia_w.last
				update 	pls_monitor_tiss_cta_val
				set	vl_cobranca_guia 	= coalesce(tb_total_apresentado_w(i), 0),
					vl_total_tabela_propria = coalesce(tb_total_tab_propria_w(i), 0),
					vl_total_pago		= coalesce(tb_total_pago_w(i), 0),
					vl_total_glosa		= coalesce(tb_total_glosa_w(i), 0),
					vl_total_fornecedor	= coalesce(tb_total_fornecedor_w(i), 0),
					dt_atualizacao		= clock_timestamp(),
					nm_usuario		= nm_usuario_p
				where	nr_sequencia		= tb_sequencia_w(i);

			commit;
	else
		forall i in tb_sequencia_w.first .. tb_sequencia_w.last
				update 	pls_monitor_tiss_cta_val
				set	vl_cobranca_guia 	= coalesce(tb_total_apresentado_w(i), 0),
					vl_total_tabela_propria = coalesce(tb_total_tab_propria_w(i), 0),
					vl_total_pago		= coalesce(tb_total_pago_w(i), 0),
					vl_total_glosa		= coalesce(tb_total_glosa_w(i), 0),
					vl_total_fornecedor	= coalesce(tb_total_apresentado_w(i), 0),
					dt_atualizacao		= clock_timestamp(),
					nm_usuario		= nm_usuario_p
				where	nr_sequencia		= tb_sequencia_w(i);

			commit;
	end if;
end loop;
close C02;

-- busca todas as contas que no foram pagas e zera os campos de pagamento delas

open C03(nr_seq_lote_p);
loop
	tb_sequencia_w.delete;

	fetch C03 bulk collect into tb_sequencia_w limit current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer;

	exit when tb_sequencia_w.count = 0;

	if (ie_fornec_direto_w = 'N') then
	
		forall i in tb_sequencia_w.first .. tb_sequencia_w.last
			update 	pls_monitor_tiss_cta_val
			set	vl_total_procedimento 	= 0,
				vl_total_medicamentos 	= 0,
				vl_total_opm		= 0,
				vl_total_material	= 0,
				vl_total_taxa		= 0,
				vl_total_diaria		= 0,
				vl_total_fornecedor	= 0
			where	nr_sequencia		= tb_sequencia_w(i);

		commit;
	else --tratamento diferente para fornecimento direto
		forall i in tb_sequencia_w.first .. tb_sequencia_w.last
			update 	pls_monitor_tiss_cta_val
			set	vl_total_procedimento 	= 0,
				vl_total_medicamentos 	= 0,
				vl_total_opm		= 0,
				vl_total_material	= 0,
				vl_total_taxa		= 0,
				vl_total_diaria		= 0
			where	nr_sequencia		= tb_sequencia_w(i);

		commit;
	end if;
end loop;
close C03;

nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	null, null, 'F', null, nr_seq_processo_w);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.atualizar_valores_conta ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type ) FROM PUBLIC;
