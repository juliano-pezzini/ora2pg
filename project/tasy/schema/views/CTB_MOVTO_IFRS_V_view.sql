-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ctb_movto_ifrs_v (nr_sequencia, nr_lote_contabil, nr_seq_mes_ref, dt_movimento, vl_movimento, nr_seq_conta_debito, nr_seq_conta_credito, ds_compl_historico, nr_seq_agrupamento, vl_debito, vl_credito, ie_debito_credito, cd_contrapartida, cd_estabelecimento, dt_atualizacao_saldo, ie_encerramento, ie_tipo, ds_historico, cd_historico, ie_centro_custo, cd_classificacao, cd_conta_contabil, ds_inconsistencia, dt_inicio_vigencia, dt_fim_vigencia) AS select	a.nr_sequencia,
	a.nr_lote_contabil,
	a.nr_seq_mes_ref,
	a.dt_movimento,
	a.vl_movimento,
	a.nr_seq_conta_debito,
	a.nr_seq_conta_credito,
	a.ds_compl_historico,
	a.nr_seq_agrupamento,
	a.vl_movimento vl_debito,
	0 vl_credito,
	'D' ie_debito_credito,
	b.cd_conta_contabil cd_contrapartida,
	coalesce(a.cd_estabelecimento, d.cd_estabelecimento) cd_estabelecimento,
	d.dt_atualizacao_saldo,
	d.ie_encerramento,
	b.ie_tipo,
	c.ds_historico,
	a.cd_historico,
	b.ie_centro_custo,
	coalesce(a.cd_classif_debito, b.cd_classificacao) cd_classificacao,
	b.cd_conta_contabil,
	a.ds_inconsistencia,
	e.dt_inicio_vigencia,
	e.dt_fim_vigencia
FROM	lote_contabil d,
	ctb_movto_ifrs a,
	conta_contabil b,
	conta_contabil_ifrs e,
	historico_padrao c
where	a.nr_seq_conta_debito	= e.nr_seq_conta_ifrs
and	b.cd_conta_contabil	= e.cd_conta_contabil
and	a.cd_historico		= c.cd_historico
and 	a.nr_lote_contabil	= d.nr_lote_contabil
and	a.nr_seq_conta_debito 	is not null

union

select	a.nr_sequencia,
	a.nr_lote_contabil,
	a.nr_seq_mes_ref,
	a.dt_movimento,
	a.vl_movimento,
	a.nr_seq_conta_debito,
	a.nr_seq_conta_credito,
	a.ds_compl_historico,
	a.nr_seq_agrupamento,
	0 vl_debito,
	a.vl_movimento vl_credito,
	'C' ie_debito_credito,
	b.cd_conta_contabil cd_contrapartida,
	coalesce(a.cd_estabelecimento, d.cd_estabelecimento) cd_estabelecimento,
	d.dt_atualizacao_saldo,
	d.ie_encerramento,
	b.ie_tipo,
	c.ds_historico,
	a.cd_historico,
	b.ie_centro_custo,
	coalesce(a.cd_classif_credito, b.cd_classificacao) cd_classificacao,
	b.cd_conta_contabil,
	a.ds_inconsistencia,
	e.dt_inicio_vigencia,
	e.dt_fim_vigencia
from	lote_contabil d,
	ctb_movto_ifrs a,
	conta_contabil b,
	conta_contabil_ifrs e,
	historico_padrao c
where	a.nr_seq_conta_credito	= e.nr_seq_conta_ifrs
and	b.cd_conta_contabil	= e.cd_conta_contabil
and	a.cd_historico		= c.cd_historico
and 	a.nr_lote_contabil	= d.nr_lote_contabil
and	a.nr_seq_conta_credito 	is not null;
