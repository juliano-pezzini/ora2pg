-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

--Limpa todas os campos tabela da estrutura tabela_dados_analise_conta



CREATE OR REPLACE PROCEDURE pls_cta_valorizacao_pck.limpa_tabela_dados_conta_mat ( tb_dados_conta_mat_p INOUT table_dados_conta_mat) AS $body$
BEGIN
	tb_dados_conta_mat_p.nr_sequencia.delete;
	tb_dados_conta_mat_p.vl_material.delete;
	tb_dados_conta_mat_p.vl_glosa.delete;
	tb_dados_conta_mat_p.vl_saldo.delete;
	tb_dados_conta_mat_p.vl_beneficiario.delete;
	tb_dados_conta_mat_p.nr_seq_regra.delete;
	tb_dados_conta_mat_p.ie_status.delete;
	tb_dados_conta_mat_p.nr_seq_regra_pos_estab.delete;
	tb_dados_conta_mat_p.dt_inicio_atend.delete;
	tb_dados_conta_mat_p.dt_fim_atend.delete;
	tb_dados_conta_mat_p.vl_mat_copartic.delete;
	tb_dados_conta_mat_p.nr_seq_regra_copartic.delete;
	tb_dados_conta_mat_p.ie_ato_cooperado.delete;
	tb_dados_conta_mat_p.nr_seq_regra_cooperado.delete;
	tb_dados_conta_mat_p.vl_material_ptu.delete;
	tb_dados_conta_mat_p.nr_seq_regra_int.delete;
	tb_dados_conta_mat_p.ie_vl_apresentado_sistema.delete;
	tb_dados_conta_mat_p.tx_intercambio.delete;
	tb_dados_conta_mat_p.vl_taxa_material.delete;
	tb_dados_conta_mat_p.vl_calculado_ant.delete;
	tb_dados_conta_mat_p.nr_seq_regra_tx_inter.delete;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_valorizacao_pck.limpa_tabela_dados_conta_mat ( tb_dados_conta_mat_p INOUT table_dados_conta_mat) FROM PUBLIC;
