-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ctb_balancete_projeto_v (ie_normal_encerramento, cd_empresa, cd_estabelecimento, cd_conta_contabil, nr_seq_mes_ref, cd_classificacao, ds_conta_contabil, ds_conta_apres, cd_grupo, ie_tipo, vl_debito, vl_credito, vl_saldo, vl_movimento, vl_saldo_ant, vl_eliminacao, ie_nivel, ie_classif_superior, ie_centro_custo, ie_tipo_conta, cd_estab, cd_classif_sup, ie_situacao, dt_referencia, ds_grupo_conta, cd_classif_sem_ponto, nr_seq_proj_rec) AS select
	'N' ie_normal_encerramento,
	b.cd_empresa,
	a.cd_estabelecimento,
	a.cd_conta_contabil,
	a.nr_seq_mes_ref,
	coalesce(a.cd_classificacao, b.cd_classificacao) cd_classificacao,
	b.ds_conta_contabil,
	substr(ctb_obter_conta_apres(b.cd_conta_contabil),1,255) ds_conta_apres,
	b.cd_grupo,
	b.ie_tipo,
	a.vl_debito,
	a.vl_credito,
	a.vl_saldo,
	a.vl_movimento,
	a.vl_saldo - a.vl_movimento vl_saldo_ant,
	coalesce(a.vl_eliminacao,0) vl_eliminacao,
	coalesce(a.nr_nivel_conta, ctb_obter_nivel_classif_conta(coalesce(a.cd_classificacao, b.cd_classificacao))) ie_nivel,
	obter_classif_ctb(coalesce(a.cd_classificacao, b.cd_classificacao), 'SUPERIOR') ie_classif_superior,
	b.ie_centro_custo,
	c.ie_tipo ie_tipo_conta,
	a.cd_estabelecimento cd_estab,
	a.cd_classif_sup,
	b.ie_situacao,
	d.dt_referencia,
	c.ds_grupo ds_grupo_conta,
	replace(coalesce(a.cd_classificacao, b.cd_classificacao), '.', null) cd_classif_sem_ponto,
    a.nr_seq_proj_rec
FROM ctb_mes_ref d, ctb_saldo_projeto a, conta_contabil b
LEFT OUTER JOIN ctb_grupo_conta c ON (b.cd_grupo = c.cd_grupo)
WHERE a.cd_conta_contabil	= b.cd_conta_contabil and d.nr_sequencia		= a.nr_seq_mes_ref and d.cd_empresa		= b.cd_empresa
union all

select
	'E' ie_normal_encerramento,
	b.cd_empresa,
	a.cd_estabelecimento,
	a.cd_conta_contabil,
	a.nr_seq_mes_ref,
	coalesce(a.cd_classificacao, b.cd_classificacao) cd_classificacao,
	b.ds_conta_contabil,
	substr(ctb_obter_conta_apres(b.cd_conta_contabil),1,255) ds_conta_apres,
	b.cd_grupo,
	b.ie_tipo,
	a.vl_debito - coalesce(a.vl_enc_debito,0) vl_debito,
	a.vl_credito - coalesce(a.vl_enc_credito,0) vl_credito,
	a.vl_saldo - a.vl_encerramento,
	a.vl_movimento - a.vl_encerramento,
	a.vl_saldo - a.vl_movimento vl_saldo_ant,
	coalesce(a.vl_eliminacao,0) vl_eliminacao,
	coalesce(a.nr_nivel_conta, ctb_obter_nivel_classif_conta(coalesce(a.cd_classificacao, b.cd_classificacao))) ie_nivel,
	obter_classif_ctb(coalesce(a.cd_classificacao, b.cd_classificacao), 'SUPERIOR') ie_classif_superior,
	b.ie_centro_custo,
	c.ie_tipo ie_tipo_conta,
	a.cd_estabelecimento cd_estab,
	a.cd_classif_sup,
	b.ie_situacao,
	d.dt_referencia,
	c.ds_grupo ds_grupo_conta,
	replace(coalesce(a.cd_classificacao, b.cd_classificacao), '.', null) cd_classif_sem_ponto,
    a.nr_seq_proj_rec
FROM ctb_mes_ref d, ctb_saldo_projeto a, conta_contabil b
LEFT OUTER JOIN ctb_grupo_conta c ON (b.cd_grupo = c.cd_grupo)
WHERE a.cd_conta_contabil	= b.cd_conta_contabil and d.nr_sequencia		= a.nr_seq_mes_ref and d.cd_empresa		= b.cd_empresa;

