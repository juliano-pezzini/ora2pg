-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Atualiza valores na w_pls_conta_pos_mat ap_s executar a atualiza_valro_proc_int



CREATE OR REPLACE PROCEDURE pls_pos_estabelecido_pck.atualiza_val_regra_mat_int ( tb_dados_mat_p INOUT table_dados_regra_preco_mat) AS $body$
BEGIN
	if (tb_dados_mat_p.nr_seq_regra.count > 0) then
	
		forall i in tb_dados_mat_p.nr_seq_regra.first..tb_dados_mat_p.nr_seq_regra.last
			update	w_pls_conta_pos_mat
			set	nr_seq_regra_preco	= tb_dados_mat_p.nr_seq_regra(i),
				vl_material_tabela	= tb_dados_mat_p.vl_material_tabela(i),
				cd_moeda_calculo	= tb_dados_mat_p.cd_moeda_calculo(i),
				vl_ch_material		= tb_dados_mat_p.vl_ch_material(i),
				vl_materiais_calc	= tb_dados_mat_p.vl_materiais(i),
				tx_administracao	= tb_dados_mat_p.tx_intercambio(i),
				vl_taxa_material	= tb_dados_mat_p.vl_taxa_material(i)
			where	nr_sequencia		= tb_dados_mat_p.nr_sequencia(i);
	end if;
	tb_dados_mat_p.nr_seq_regra.delete;
	tb_dados_mat_p.vl_material_tabela.delete;
	tb_dados_mat_p.cd_moeda_calculo.delete;
	tb_dados_mat_p.vl_ch_material.delete;
	tb_dados_mat_p.vl_materiais.delete;
	tb_dados_mat_p.tx_intercambio.delete;
	tb_dados_mat_p.nr_sequencia.delete;
	tb_dados_mat_p.vl_taxa_material.delete;
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pos_estabelecido_pck.atualiza_val_regra_mat_int ( tb_dados_mat_p INOUT table_dados_regra_preco_mat) FROM PUBLIC;
