-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ctb_movimento_v (nr_sequencia, nr_lote_contabil, nr_seq_mes_ref, dt_movimento, vl_movimento, dt_atualizacao, nm_usuario, cd_historico, cd_conta_debito, cd_conta_credito, ds_compl_historico, nr_seq_agrupamento, ie_revisado, ds_conta_contabil, ds_historico, cd_conta_contabil, cd_classificacao, vl_debito, vl_credito, ie_debito_credito, ie_tipo, ie_centro_custo, cd_contrapartida, cd_estabelecimento, cd_estab_lote, cd_classif_plano_ans, cd_sistema_contabil, ds_consistencia, cd_classif_debito, cd_classif_credito, cd_tipo_lote_contabil, cd_grupo, ds_tipo_lote_contabil, dt_atualizacao_saldo, cd_centro_custo, nr_seq_conta_ans_deb, nr_seq_conta_ans_cred, cd_classif_contrapartida, nr_agrup_sequencial, nr_seq_movto_partida, ie_status_concil, nr_seq_reg_concil, ie_origem_documento, nr_documento, nr_seq_mutacao_pl, ds_observacao, nr_seq_classif_movto, ie_validacao) AS select	a.nr_sequencia,
	a.nr_lote_contabil,
	a.nr_seq_mes_ref,
	a.dt_movimento,
	a.vl_movimento,
	a.dt_atualizacao,
	a.nm_usuario,
	a.cd_historico,
	a.cd_conta_debito,
	a.cd_conta_credito,
	a.ds_compl_historico,
	a.nr_seq_agrupamento,
	a.ie_revisado,
	b.ds_conta_contabil,
	c.ds_historico,
	b.cd_conta_contabil,
	coalesce(a.cd_classif_debito, b.cd_classificacao) cd_classificacao,
	vl_movimento vl_debito,
	0 vl_credito,
	'D' ie_debito_credito,
	b.ie_tipo,
	b.ie_centro_custo,
	a.cd_conta_credito cd_contrapartida,
	coalesce(a.cd_estabelecimento, d.cd_estabelecimento) cd_estabelecimento,
	d.cd_estabelecimento cd_estab_lote,
	substr(obter_classif_plano_ans(b.cd_plano_ans,b.cd_empresa),1,255) cd_classif_plano_ans,
	b.cd_sistema_contabil,
	a.ds_consistencia,
	a.cd_classif_debito,
	a.cd_classif_credito,
	d.cd_tipo_lote_contabil,
	b.cd_grupo,
	substr(ctb_obter_desc_tipo_lote(d.cd_tipo_lote_contabil),1,100) ds_tipo_lote_contabil,
	d.dt_atualizacao_saldo,
	b.cd_centro_custo,
	a.nr_seq_conta_ans_deb,
	a.nr_seq_conta_ans_cred,
	a.cd_classif_credito cd_classif_contrapartida,
	a.nr_agrup_sequencial,
	a.nr_seq_movto_partida,
	a.ie_status_concil,
	a.nr_seq_reg_concil,
	a.ie_origem_documento,
	a.nr_documento,
	a.nr_seq_mutacao_pl,
	a.ds_observacao,
	a.nr_seq_classif_movto,
	a.ie_validacao
FROM lote_contabil d, conta_contabil b, ctb_movimento a
LEFT OUTER JOIN historico_padrao c ON (a.cd_historico = c.cd_historico)
WHERE a.cd_conta_debito	= b.cd_conta_contabil  and a.nr_lote_contabil	= d.nr_lote_contabil

union

select	a.nr_sequencia,
	a.nr_lote_contabil,
	a.nr_seq_mes_ref,
	a.dt_movimento,
	a.vl_movimento,
	a.dt_atualizacao,
	a.nm_usuario,
	a.cd_historico,
	a.cd_conta_debito,
	a.cd_conta_credito,
	a.ds_compl_historico,
	a.nr_seq_agrupamento,
	a.ie_revisado,
	b.ds_conta_contabil,
	c.ds_historico,
	b.cd_conta_contabil,
	coalesce(a.cd_classif_credito, b.cd_classificacao) cd_classificacao,
	0 vl_debito,
 	vl_movimento vl_credito,
 	'C',
	b.ie_tipo,
	b.ie_centro_custo,
	a.cd_conta_debito cd_contrapartida,
	coalesce(a.cd_estabelecimento, d.cd_estabelecimento) cd_estabelecimento,
	d.cd_estabelecimento,
	substr(obter_classif_plano_ans(b.cd_plano_ans,b.cd_empresa),1,255) cd_classif_plano_ans,
	b.cd_sistema_contabil,
	a.ds_consistencia,
	a.cd_classif_debito,
	a.cd_classif_credito,
	d.cd_tipo_lote_contabil,
	b.cd_grupo,
	substr(ctb_obter_desc_tipo_lote(d.cd_tipo_lote_contabil),1,100) ds_tipo_lote_contabil,
	d.dt_atualizacao_saldo,
	b.cd_Centro_custo,
	a.nr_seq_conta_ans_deb,
	a.nr_seq_conta_ans_cred,
	a.cd_classif_debito cd_classif_contrapartida,
	a.nr_agrup_sequencial,
	a.nr_seq_movto_partida,
	a.ie_status_concil,
	a.nr_seq_reg_concil,
	a.ie_origem_documento,
	a.nr_documento,
	a.nr_seq_mutacao_pl,
	a.ds_observacao,
	a.nr_seq_classif_movto,
	a.ie_validacao
FROM lote_contabil d, conta_contabil b, ctb_movimento a
LEFT OUTER JOIN historico_padrao c ON (a.cd_historico = c.cd_historico)
WHERE a.cd_conta_credito	= b.cd_conta_contabil and a.nr_lote_contabil	= d.nr_lote_contabil;
