-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Atualiza valores na w_pls_conta_pos_proc ap_s executar a atualiza_valro_proc_int



CREATE OR REPLACE PROCEDURE pls_pos_estabelecido_pck.atualiza_val_regra_proc_int ( tb_dados_proc_p INOUT table_dados_regra_preco_proc) AS $body$
BEGIN
	if (tb_dados_proc_p.nr_seq_regra_preco.count > 0) then
	
		forall i in tb_dados_proc_p.nr_seq_regra_preco.first..tb_dados_proc_p.nr_seq_regra_preco.last
			update	w_pls_conta_pos_proc
			set	nr_seq_regra_preco		= tb_dados_proc_p.nr_seq_regra_preco(i),
				vl_taxa_co			= tb_dados_proc_p.vl_taxa_co(i),
				vl_taxa_material		= tb_dados_proc_p.vl_taxa_material(i),
				vl_taxa_servico			= tb_dados_proc_p.vl_taxa_servico(i),
				vl_materiais_calc		= tb_dados_proc_p.vl_materiais(i),
				vl_medico_calc			= tb_dados_proc_p.vl_medico(i),
				vl_custo_operacional_calc	= tb_dados_proc_p.vl_custo_operacional(i),
				qt_filme_tab			= tb_dados_proc_p.qt_filme_tab(i),
				vl_custo_operacional_tab	= tb_dados_proc_p.vl_custo_operacional_tab(i),
				nr_seq_regra_horario		= tb_dados_proc_p.nr_seq_criterio_horario(i),
				vl_proc_tabela			= tb_dados_proc_p.vl_proc_tabela(i),
				vl_ch_hnorarios			= tb_dados_proc_p.vl_ch_honorarios(i),
				cd_moeda_autogerado		= tb_dados_proc_p.cd_moeda_autogerado(i),
				vl_base_filme			= tb_dados_proc_p.vl_base_filme(i),
				cd_porte_anestesico		= tb_dados_proc_p.cd_porte_anestesico(i),
				tx_administracao		= tb_dados_proc_p.tx_intercambio(i),
				ie_nao_gera_tx_inter		= tb_dados_proc_p.ie_nao_gera_tx_inter(i)
			where	nr_seq_conta_proc		= tb_dados_proc_p.nr_seq_proc(i);
	end if;
	tb_dados_proc_p.nr_seq_regra_preco.delete;
	tb_dados_proc_p.vl_taxa_co.delete;
	tb_dados_proc_p.vl_taxa_material.delete;
	tb_dados_proc_p.vl_taxa_servico.delete;
	tb_dados_proc_p.vl_materiais.delete;
	tb_dados_proc_p.vl_medico.delete;
	tb_dados_proc_p.vl_custo_operacional.delete;
	tb_dados_proc_p.qt_filme_tab.delete;
	tb_dados_proc_p.vl_custo_operacional_tab.delete;
	tb_dados_proc_p.nr_seq_criterio_horario.delete;
	tb_dados_proc_p.vl_proc_tabela.delete;
	tb_dados_proc_p.vl_ch_honorarios.delete;
	tb_dados_proc_p.cd_moeda_autogerado.delete;
	tb_dados_proc_p.vl_base_filme.delete;
	tb_dados_proc_p.cd_porte_anestesico.delete;
	tb_dados_proc_p.tx_intercambio.delete;
	tb_dados_proc_p.ie_nao_gera_tx_inter.delete;
	tb_dados_proc_p.nr_seq_proc.delete;
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pos_estabelecido_pck.atualiza_val_regra_proc_int ( tb_dados_proc_p INOUT table_dados_regra_preco_proc) FROM PUBLIC;
