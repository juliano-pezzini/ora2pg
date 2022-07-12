-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW movimento_contabil_v (nr_seq_ctb_movto, nr_lote_contabil, nr_sequencia, cd_conta_contabil, ie_debito_credito, cd_historico, dt_movimento, vl_movimento, dt_atualizacao, nm_usuario, cd_centro_custo, ds_compl_historico, nr_seq_trans_fin, cd_cgc, cd_pessoa_fisica, nr_seq_agrupamento, nr_doc_orig, ds_historico, ds_conta_contabil, ds_centro_custo, cd_conta_debito, cd_conta_credito, ci_integra, ie_deb_cred_num, ds_compl_fixo, ds_historico_fixo, cd_estabelecimento, dt_referencia, cd_tipo_lote_contabil, vl_debito_credito, ds_contra_partida, cd_centro_custo_debito, cd_centro_custo_credito, nr_documento, cd_classificacao, cd_estab_movto, cd_centro_sis_contabil, cd_historico_sis_contabil, cd_conta_sis_contabil, cd_conta_sis_debito, cd_conta_sis_credito, ds_historico_original, ie_transitorio, vl_debito, vl_credito, ie_origem_documento, nr_lancamento, nr_seq_classif_movto, ie_intercompany, nr_codigo_controle) AS select	a.nr_seq_ctb_movto,
	a.nr_lote_contabil,  
	a.nr_sequencia,  
	a.cd_conta_contabil,  
	a.ie_debito_credito,  
	a.cd_historico,  
	a.dt_movimento,  
	a.vl_movimento,  
	a.dt_atualizacao,  
	a.nm_usuario,  
	a.cd_centro_custo,  
	a.ds_compl_historico,  
	a.nr_seq_trans_fin,  
	a.cd_cgc,  
	a.cd_pessoa_fisica,  
	a.nr_seq_agrupamento,  
	a.nr_documento nr_doc_orig,  
	(h.ds_historico || ' ' || a.ds_compl_historico) ds_historico,  
	b.ds_conta_contabil,  
	c.ds_centro_custo,  
	CASE WHEN a.ie_debito_credito='D' THEN  a.cd_conta_contabil  ELSE 0 END  cd_conta_debito,  
	CASE WHEN a.ie_debito_credito='C' THEN  a.cd_conta_contabil  ELSE 0 END  cd_conta_credito,  
	CASE WHEN coalesce(a.cd_centro_custo, '0')=0 THEN  'N'  ELSE 'S' END  ci_integra,  
	CASE WHEN a.ie_debito_credito='D' THEN  1  ELSE 2 END  ie_deb_cred_num,  
	substr(ds_compl_historico || lpad(' ', 350 - length(ds_compl_historico)),1,350) ds_compl_fixo,  
	substr((h.ds_historico || ' ' || a.ds_compl_historico) ||  
	lpad(' ', 350 - length(h.ds_historico || ' ' || ds_compl_historico)),1,350) ds_historico_fixo,  
	x.cd_estabelecimento,  
	x.dt_referencia,  
	x.cd_tipo_lote_contabil,  
	CASE WHEN a.ie_debito_credito='C' THEN a.vl_movimento * -1  ELSE a.vl_movimento END  vl_debito_credito,  
	'                    ' ds_contra_partida,  
	CASE WHEN a.ie_debito_credito='D' THEN  a.cd_centro_custo  ELSE 0 END  cd_centro_custo_debito,  
	CASE WHEN a.ie_debito_credito='C' THEN  a.cd_centro_custo  ELSE 0 END  cd_centro_custo_credito,  
	CASE WHEN a.nr_documento IS NULL THEN somente_numero(substr(a.ds_compl_historico,1,15))  ELSE somente_numero(a.nr_documento) END  nr_documento,  
	a.cd_classificacao,  
	a.cd_estabelecimento cd_estab_movto,  
	c.cd_sistema_contabil cd_centro_sis_contabil,  
	h.cd_sistema_contabil cd_historico_sis_contabil,  
	b.cd_sistema_contabil cd_conta_sis_contabil,  
	CASE WHEN a.ie_debito_credito='D' THEN  b.cd_sistema_contabil  ELSE 0 END  cd_conta_sis_debito,  
	CASE WHEN a.ie_debito_credito='C' THEN  b.cd_sistema_contabil  ELSE 0 END  cd_conta_sis_credito,  
	h.ds_historico ds_historico_original,  
	coalesce(a.ie_transitorio,'N') ie_transitorio,  
	CASE WHEN a.ie_debito_credito='D' THEN  a.vl_movimento  ELSE 0 END  vl_debito,  
	CASE WHEN a.ie_debito_credito='C' THEN  a.vl_movimento  ELSE 0 END  vl_credito,  
	a.ie_origem_documento,  
	a.nr_lancamento,
	a.nr_seq_classif_movto,
	a.ie_intercompany,
	a.nr_codigo_controle
FROM lote_contabil x, historico_padrao h, conta_contabil b, movimento_contabil a
LEFT OUTER JOIN centro_custo c ON (a.cd_centro_custo = c.cd_centro_custo)
WHERE a.cd_conta_contabil 	= b.cd_conta_contabil and a.cd_historico		= h.cd_historico and a.nr_lote_contabil	= x.nr_lote_contabil;

