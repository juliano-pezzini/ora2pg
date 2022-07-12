-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW preco_padrao_mat_v (cd_estabelecimento, cd_tabela_custo, cd_material, nm_usuario, dt_atualizacao, qt_parametro, pr_dvv, pr_despesa_fixa, pr_custo_indireto_fixo, pr_margem_lucro, vl_custo_variavel, vl_custo_direto_fixo, vl_preco_calculado, vl_preco_tabela, vl_preco_tabela_anterior, nr_seq_tabela, ie_calcula_conta, vl_dvv, vl_custo_total, pr_aumento, ds_material) AS SELECT /* +ORDERED */
	A.CD_ESTABELECIMENTO,A.CD_TABELA_CUSTO,A.CD_MATERIAL,A.NM_USUARIO,A.DT_ATUALIZACAO,A.QT_PARAMETRO,A.PR_DVV,A.PR_DESPESA_FIXA,A.PR_CUSTO_INDIRETO_FIXO,A.PR_MARGEM_LUCRO,A.VL_CUSTO_VARIAVEL,A.VL_CUSTO_DIRETO_FIXO,A.VL_PRECO_CALCULADO,A.VL_PRECO_TABELA,A.VL_PRECO_TABELA_ANTERIOR,A.NR_SEQ_TABELA,A.IE_CALCULA_CONTA,
     (A.VL_PRECO_CALCULADO * PR_DVV / 100) VL_DVV,
     ((vl_custo_variavel + vl_custo_direto_fixo) *
      (1 + pr_custo_indireto_fixo /100 + pr_despesa_fixa/100)) VL_CUSTO_TOTAL,
       CASE WHEN vl_preco_tabela_anterior=0 THEN  0  ELSE ((A.vl_preco_calculado / vl_preco_tabela_anterior * 100) - 100) END  pr_aumento,
	B.DS_MATERIAL
FROM	PRECO_PADRAO_MAT A,
	MATERIAL B
WHERE A.CD_MATERIAL		= B.CD_MATERIAL;

