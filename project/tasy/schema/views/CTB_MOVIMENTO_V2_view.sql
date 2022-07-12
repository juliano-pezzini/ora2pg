-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ctb_movimento_v2 (nr_sequencia, nr_lote_contabil, nr_seq_mes_ref, dt_movimento, vl_movimento, cd_conta_debito, cd_conta_credito, ds_compl_historico, nr_seq_agrupamento, vl_debito, vl_credito, ie_debito_credito, cd_contrapartida, cd_estabelecimento, dt_atualizacao_saldo, nr_agrup_sequencial, nr_seq_movto_partida, ie_encerramento, ie_tipo, ds_historico, cd_historico, ie_centro_custo, cd_classificacao, cd_conta_contabil, nr_documento, ie_origem_documento, ie_status_concil, dt_lancto_ext, ie_status_origem, ds_consistencia) AS select	a.nr_sequencia,
	a.nr_lote_contabil,
	a.nr_seq_mes_ref,
	a.dt_movimento,
	a.vl_movimento,
	a.cd_conta_debito,
	a.cd_conta_credito,
	a.ds_compl_historico,
	a.nr_seq_agrupamento,
	vl_movimento vl_debito,
	0 vl_credito,
	'D' ie_debito_credito,
	a.cd_conta_credito cd_contrapartida,
	coalesce(a.cd_estabelecimento, d.cd_estabelecimento) cd_estabelecimento,
	d.dt_atualizacao_saldo,
	a.nr_agrup_sequencial,
	a.nr_seq_movto_partida,
	d.ie_encerramento,
	b.ie_tipo,
	c.ds_historico,
	a.cd_historico,
	b.ie_centro_custo,
	coalesce(a.cd_classif_debito, b.cd_classificacao) cd_classificacao,
	b.cd_conta_contabil,
	a.nr_documento,
	a.ie_origem_documento,
	a.ie_status_concil,
	a.dt_lancto_ext,
	a.ie_status_origem,
	a.ds_consistencia
FROM	lote_contabil d,
	ctb_movimento a,
	conta_contabil b,
	historico_padrao c
where	a.cd_conta_debito	= b.cd_conta_contabil
and	a.cd_historico		= c.cd_historico
and 	a.nr_lote_contabil	= d.nr_lote_contabil
and	a.cd_conta_debito 	is not null

union

select	a.nr_sequencia,
	a.nr_lote_contabil,
	a.nr_seq_mes_ref,
	a.dt_movimento,
	a.vl_movimento,
	a.cd_conta_debito,
	a.cd_conta_credito,
	a.ds_compl_historico,
	a.nr_seq_agrupamento,
	0 vl_debito,
	vl_movimento vl_credito,
	'C' ie_debito_credito,
	a.cd_conta_debito cd_contrapartida,
	coalesce(a.cd_estabelecimento, d.cd_estabelecimento) cd_estabelecimento,
	d.dt_atualizacao_saldo,
	a.nr_agrup_sequencial,
	a.nr_seq_movto_partida,
	d.ie_encerramento,
	b.ie_tipo,
	c.ds_historico,
	a.cd_historico,
	b.ie_centro_custo,
	coalesce(a.cd_classif_credito, b.cd_classificacao) cd_classificacao,
	b.cd_conta_contabil,
	a.nr_documento,
	a.ie_origem_documento,
	a.ie_status_concil,
	a.dt_lancto_ext,
	a.ie_status_origem,
	a.ds_consistencia
from	lote_contabil d,
	ctb_movimento a,
	conta_contabil b,
	historico_padrao c
where	a.cd_conta_credito	= b.cd_conta_contabil
and	a.cd_historico		= c.cd_historico
and 	a.nr_lote_contabil	= d.nr_lote_contabil
and	a.cd_conta_credito 	is not null;

