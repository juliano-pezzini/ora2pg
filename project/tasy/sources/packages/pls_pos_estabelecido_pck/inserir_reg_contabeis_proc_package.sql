-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pos_estabelecido_pck.inserir_reg_contabeis_proc ( tb_nr_seq_conta_ins_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_conta_proc_pos_ins_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_conta_resumo_ins_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_prestador_pgto_ins_p INOUT pls_util_cta_pck.t_number_table, tb_vl_administracao_ins_p INOUT pls_util_cta_pck.t_number_table, tb_vl_materiais_ins_p INOUT pls_util_cta_pck.t_number_table, tb_vl_tx_co_ins_p INOUT pls_util_cta_pck.t_number_table, tb_vl_co_ins_p INOUT pls_util_cta_pck.t_number_table, tb_vl_tx_servico_ins_p INOUT pls_util_cta_pck.t_number_table, tb_vl_servico_ins_p INOUT pls_util_cta_pck.t_number_table, tb_dt_mes_p INOUT pls_util_cta_pck.t_date_table, tb_seq_pos_proc INOUT pls_util_cta_pck.t_number_table, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

	if ( tb_nr_seq_conta_ins_p.count > 0) then
		
		forall i in tb_nr_seq_conta_ins_p.first..tb_nr_seq_conta_ins_p.last
			insert into pls_conta_pos_proc_contab(nr_seq_conta, nr_seq_conta_pos_proc, nr_seq_conta_resumo,   	
					nr_seq_prestador_pgto, vl_administracao, vl_lib_taxa_material,  	
					vl_materiais, nm_usuario, dt_atualizacao,
					nm_usuario_nrec, dt_atualizacao_nrec,nr_sequencia,
					vl_lib_taxa_servico, vl_lib_taxa_co, vl_custo_operacional,
					vl_medico, vl_pos_estabelecido, vl_provisao,
					dt_mes_competencia)
			values	(	tb_nr_seq_conta_ins_p(i), tb_nr_seq_conta_proc_pos_ins_p(i), tb_nr_seq_conta_resumo_ins_p(i),	
					tb_nr_seq_prestador_pgto_ins_p(i), (tb_vl_tx_servico_ins_p(i) + tb_vl_tx_co_ins_p(i) + tb_vl_administracao_ins_p(i)), 
					tb_vl_administracao_ins_p(i),   		
					tb_vl_materiais_ins_p(i), nm_usuario_p, clock_timestamp(),
					nm_usuario_p, clock_timestamp(), tb_seq_pos_proc(i),
					tb_vl_tx_servico_ins_p(i), tb_vl_tx_co_ins_p(i), tb_vl_co_ins_p(i),
					tb_vl_servico_ins_p(i), (tb_vl_servico_ins_p(i) + tb_vl_co_ins_p(i) + tb_vl_materiais_ins_p(i)),
					(tb_vl_servico_ins_p(i) + tb_vl_co_ins_p(i) + tb_vl_materiais_ins_p(i) + 
					 tb_vl_tx_servico_ins_p(i) + tb_vl_tx_co_ins_p(i) + tb_vl_administracao_ins_p(i)),
					tb_dt_mes_p(i));	
	end if;
	tb_nr_seq_conta_ins_p.delete;         	
	tb_nr_seq_conta_proc_pos_ins_p.delete;	
	tb_nr_seq_conta_resumo_ins_p.delete;  	
	tb_nr_seq_prestador_pgto_ins_p.delete;	
	tb_vl_administracao_ins_p.delete;   	
	tb_vl_materiais_ins_p.delete;
	tb_vl_tx_co_ins_p.delete;  	
	tb_vl_co_ins_p.delete;  		
	tb_vl_tx_servico_ins_p.delete; 	
	tb_vl_servico_ins_p.delete;  	
	tb_dt_mes_p.delete;	
	tb_seq_pos_proc.delete;
	

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pos_estabelecido_pck.inserir_reg_contabeis_proc ( tb_nr_seq_conta_ins_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_conta_proc_pos_ins_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_conta_resumo_ins_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_prestador_pgto_ins_p INOUT pls_util_cta_pck.t_number_table, tb_vl_administracao_ins_p INOUT pls_util_cta_pck.t_number_table, tb_vl_materiais_ins_p INOUT pls_util_cta_pck.t_number_table, tb_vl_tx_co_ins_p INOUT pls_util_cta_pck.t_number_table, tb_vl_co_ins_p INOUT pls_util_cta_pck.t_number_table, tb_vl_tx_servico_ins_p INOUT pls_util_cta_pck.t_number_table, tb_vl_servico_ins_p INOUT pls_util_cta_pck.t_number_table, tb_dt_mes_p INOUT pls_util_cta_pck.t_date_table, tb_seq_pos_proc INOUT pls_util_cta_pck.t_number_table, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;