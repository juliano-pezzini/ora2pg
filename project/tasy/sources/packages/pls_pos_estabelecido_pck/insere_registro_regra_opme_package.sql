-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pos_estabelecido_pck.insere_registro_regra_opme ( tb_cd_procedimento_p INOUT pls_util_cta_pck.t_number_table, tb_ie_origem_proced_p INOUT pls_util_cta_pck.t_number_table, tb_seq_cabecalho_ins_p INOUT pls_util_cta_pck.t_number_table, tb_seq_conta_ins_p INOUT pls_util_cta_pck.t_number_table, tb_seq_proc_ins_p INOUT pls_util_cta_pck.t_number_table, tb_dt_atend_ref_ins_p INOUT pls_util_cta_pck.t_date_table, tb_lib_taxa_material_ins_p INOUT pls_util_cta_pck.t_number_table, tb_vl_materiais_ins_p INOUT pls_util_cta_pck.t_number_table, tb_seq_pos_proc_p INOUT pls_util_cta_pck.t_number_table, tb_seq_regra_tx_opme_p INOUT pls_util_cta_pck.t_number_table, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

	if (tb_seq_proc_ins_p.count > 0) then
		
		forall i in tb_seq_proc_ins_p.first..tb_seq_proc_ins_p.last
			insert into pls_conta_pos_proc(cd_procedimento, dt_item, ie_origem_proced,
			 nr_seq_cabecalho, nr_seq_conta, nr_seq_conta_proc,
			 nr_seq_regra_horario,  qt_filme_tab,
			 qt_item, tx_administracao, tx_item,
			 vl_cotacao_moeda, vl_custo_operacional, vl_custo_operacional_calc,
			 vl_custo_operacional_tab, vl_liberado_co_fat, vl_liberado_hi_fat,
			 vl_liberado_material_fat, vl_lib_taxa_co, vl_lib_taxa_material,
			 vl_lib_taxa_servico, vl_materiais, vl_materiais_calc,
			 vl_material_tab, vl_medico, vl_medico_calc,
			 vl_provisao, vl_tabela_preco, vl_taxa_co,
			 vl_taxa_material, vl_taxa_servico, dt_atualizacao_nrec,
			 nm_usuario, nm_usuario_nrec, dt_atualizacao,
			 nr_seq_regra_preco, cd_procedimento_conv, nr_seq_regra_co_filme,
			 ie_origem_proced_conv, cd_procedimento_conv_xml, nr_seq_regra_conv_xml,     
			 ie_origem_conv_xml, nr_seq_regra_conv, dt_inicio_item, 
			 dt_fim_item, nr_sequencia, nr_seq_regra_tx_opme,
			 ie_status_faturamento)
			values
			(tb_cd_procedimento_p(i), tb_dt_atend_ref_ins_p(i), tb_ie_origem_proced_p(i),
			tb_seq_cabecalho_ins_p(i), tb_seq_conta_ins_p(i), tb_seq_proc_ins_p(i),
			null, null, 
			1,  0, 100, 
			0, 0,  0, 
			0, 0, 0,
			tb_vl_materiais_ins_p(i), 0, tb_lib_taxa_material_ins_p(i),
			0, tb_vl_materiais_ins_p(i), 0,
			0, 0, 0, 
			(tb_lib_taxa_material_ins_p(i) + tb_vl_materiais_ins_p(i)), 0, 0, 
			tb_lib_taxa_material_ins_p(i), 0, clock_timestamp(),
			nm_usuario_p, nm_usuario_p, clock_timestamp(),
			null, null,  null, 
			null, null, null,
			null, null, tb_dt_atend_ref_ins_p(i),
			tb_dt_atend_ref_ins_p(i), nextval('pls_conta_pos_proc_seq'), tb_seq_regra_tx_opme_p(i),
			'L');
	
	
	end if;
	tb_cd_procedimento_p.delete;
	tb_ie_origem_proced_p.delete;
	tb_seq_cabecalho_ins_p.delete;
	tb_seq_conta_ins_p.delete;
	tb_seq_proc_ins_p.delete;
	tb_dt_atend_ref_ins_p.delete;
	tb_lib_taxa_material_ins_p.delete;
        tb_vl_materiais_ins_p.delete;
	tb_seq_pos_proc_p.delete;
	tb_seq_regra_tx_opme_p.delete;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pos_estabelecido_pck.insere_registro_regra_opme ( tb_cd_procedimento_p INOUT pls_util_cta_pck.t_number_table, tb_ie_origem_proced_p INOUT pls_util_cta_pck.t_number_table, tb_seq_cabecalho_ins_p INOUT pls_util_cta_pck.t_number_table, tb_seq_conta_ins_p INOUT pls_util_cta_pck.t_number_table, tb_seq_proc_ins_p INOUT pls_util_cta_pck.t_number_table, tb_dt_atend_ref_ins_p INOUT pls_util_cta_pck.t_date_table, tb_lib_taxa_material_ins_p INOUT pls_util_cta_pck.t_number_table, tb_vl_materiais_ins_p INOUT pls_util_cta_pck.t_number_table, tb_seq_pos_proc_p INOUT pls_util_cta_pck.t_number_table, tb_seq_regra_tx_opme_p INOUT pls_util_cta_pck.t_number_table, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
