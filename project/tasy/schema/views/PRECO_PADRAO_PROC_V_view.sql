-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW preco_padrao_proc_v (cd_estabelecimento, cd_tabela_custo, ie_origem_proced, cd_procedimento, nm_usuario, dt_atualizacao, qt_parametro, pr_dvv, pr_despesa_fixa, pr_custo_indireto_fixo, pr_margem_lucro, vl_custo_variavel, vl_custo_direto_fixo, vl_preco_calculado, vl_preco_tabela, vl_preco_tabela_anterior, cd_centro_controle, vl_custo_dir_apoio, vl_custo_mao_obra, vl_custo_indireto, vl_despesa, ie_calcula_conta, vl_custo_hm, nr_sequencia, nr_seq_proc_interno, nr_seq_exame, cd_setor_atendimento, nr_seq_tabela, dt_atualizacao_nrec, nm_usuario_nrec, nr_ficha_tecnica, vl_dvv, vl_custo_total, pr_aumento, ds_procedimento) AS select /* +ordered */
	a.CD_ESTABELECIMENTO,a.CD_TABELA_CUSTO,a.IE_ORIGEM_PROCED,a.CD_PROCEDIMENTO,a.NM_USUARIO,a.DT_ATUALIZACAO,a.QT_PARAMETRO,a.PR_DVV,a.PR_DESPESA_FIXA,a.PR_CUSTO_INDIRETO_FIXO,a.PR_MARGEM_LUCRO,a.VL_CUSTO_VARIAVEL,a.VL_CUSTO_DIRETO_FIXO,a.VL_PRECO_CALCULADO,a.VL_PRECO_TABELA,a.VL_PRECO_TABELA_ANTERIOR,a.CD_CENTRO_CONTROLE,a.VL_CUSTO_DIR_APOIO,a.VL_CUSTO_MAO_OBRA,a.VL_CUSTO_INDIRETO,a.VL_DESPESA,a.IE_CALCULA_CONTA,a.VL_CUSTO_HM,a.NR_SEQUENCIA,a.NR_SEQ_PROC_INTERNO,a.NR_SEQ_EXAME,a.CD_SETOR_ATENDIMENTO,a.NR_SEQ_TABELA,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC,a.NR_FICHA_TECNICA,
	(a.vl_preco_calculado * pr_dvv / 100) vl_dvv,
	((vl_custo_variavel + vl_custo_direto_fixo) *
	(1 + pr_custo_indireto_fixo /100 + pr_despesa_fixa/100)) vl_custo_total,
	CASE WHEN vl_preco_tabela_anterior=0 THEN  0  ELSE ((a.vl_preco_calculado / vl_preco_tabela_anterior * 100) - 100) END  pr_aumento,
	b.ds_procedimento
FROM	preco_padrao_proc a,
	procedimento b
where	a.cd_procedimento = b.cd_procedimento
and	a.ie_origem_proced = b.ie_origem_proced;

