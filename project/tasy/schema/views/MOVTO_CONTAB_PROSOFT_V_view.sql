-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW movto_contab_prosoft_v (nr_lote_contabil, dt_escritura, cd_conta_debito, cd_conta_credito, cd_centro_custo_debito, cd_centro_custo_credito, vl_lancamento, ds_historico, nr_sequencia, nr_documento, ds_branco, ds_zeros) AS select	nr_lote_contabil,
	dt_escritura,
	cd_conta_debito,
	cd_conta_credito,
	CASE WHEN cd_centro_custo_debito=0 THEN null  ELSE cd_centro_custo_debito END  cd_centro_custo_debito,
	CASE WHEN cd_centro_custo_credito=0 THEN null  ELSE cd_centro_custo_credito END  cd_centro_custo_credito,
	vl_lancamento,
	ds_historico,
	nr_sequencia,
	nr_documento,
	ds_branco,
	ds_zeros
FROM (
/* lançamentos sem centro de custo informado */

select	a.nr_lote_contabil,
	a.dt_movimento dt_escritura,
	coalesce(a.cd_conta_debito,'21516') cd_conta_debito,
	coalesce(a.cd_conta_credito,'21516') cd_conta_credito,
	0 cd_centro_custo_debito,
	0 cd_centro_custo_credito,
	a.vl_movimento vl_lancamento,
	b.ds_historico || ' ' || a.ds_compl_historico ds_historico,
	a.nr_sequencia,
	campo_numerico(a.ds_compl_historico) nr_documento,
	'                    ' ds_branco,
	'00000000000000000000' ds_zeros
from	historico_padrao b,
	ctb_movimento a
where	a.cd_historico		= b.cd_historico
and	not exists (
	select 1
	from	ctb_movto_centro_custo c
	where	a.nr_sequencia		= c.nr_seq_movimento)

union

/* lançamentos com centro de custo para conta debito */

select	a.nr_lote_contabil,
	a.dt_movimento dt_escritura,
	a.cd_conta_debito,
	'21516' cd_conta_credito,
	c.cd_centro_custo cd_centro_custo_debito,
	0 cd_centro_custo_credito,
	coalesce(c.vl_movimento, a.vl_movimento) vl_lancamento,
	b.ds_historico || ' ' || a.ds_compl_historico ds_historico,
	a.nr_sequencia,
	campo_numerico(a.ds_compl_historico) nr_documento,
	'                    ' ds_branco,
	'00000000000000000000' ds_zeros
FROM conta_contabil d, historico_padrao b, ctb_movimento a
LEFT OUTER JOIN ctb_movto_centro_custo c ON (a.nr_sequencia = c.nr_seq_movimento)
WHERE a.cd_historico		= b.cd_historico  and a.cd_conta_debito	= d.cd_conta_contabil and ie_centro_custo		= 'S' and exists (
	select 1
	from	ctb_movto_centro_custo c
	where	a.nr_sequencia		= c.nr_seq_movimento)

union

/* lançamentos com centro de custo para conta credito */

select	a.nr_lote_contabil,
	a.dt_movimento dt_escritura,
	'21516' cd_conta_debito,
	cd_conta_credito,
	0 cd_centro_custo_debito,
	c.cd_centro_custo  cd_centro_custo_credito,
	coalesce(c.vl_movimento, a.vl_movimento) vl_lancamento,
	b.ds_historico || ' ' || a.ds_compl_historico ds_historico,
	a.nr_sequencia,
	campo_numerico(a.ds_compl_historico) nr_documento,
	'                    ' ds_branco,
	'00000000000000000000' ds_zeros
FROM conta_contabil d, historico_padrao b, ctb_movimento a
LEFT OUTER JOIN ctb_movto_centro_custo c ON (a.nr_sequencia = c.nr_seq_movimento)
WHERE a.cd_historico		= b.cd_historico  and a.cd_conta_credito	= d.cd_conta_contabil and exists (
	select 1
	from	ctb_movto_centro_custo c
	where	a.nr_sequencia		= c.nr_seq_movimento) and ie_centro_custo		= 'S'
 
Union all

/* lançamentos sem centro de custo para conta debito */

select	a.nr_lote_contabil,
	a.dt_movimento dt_escritura,
	a.cd_conta_debito,
	'21516' cd_conta_credito,
	0 cd_centro_custo_debito,
	0 cd_centro_custo_credito,
	a.vl_movimento vl_lancamento,
	b.ds_historico || ' ' || a.ds_compl_historico ds_historico,
	a.nr_sequencia,
	campo_numerico(a.ds_compl_historico) nr_documento,
	'                    ' ds_branco,
	'00000000000000000000' ds_zeros
from	conta_contabil d,
	historico_padrao b,
	ctb_movimento a
where	a.cd_historico		= b.cd_historico
and	a.cd_conta_debito	= d.cd_conta_contabil
and	ie_centro_custo		= 'N'
and	exists (
	select 1
	from	ctb_movto_centro_custo c
	where	a.nr_sequencia		= c.nr_seq_movimento)

union

/* lançamentos sem centro de custo para conta credito */

select	a.nr_lote_contabil,
	a.dt_movimento dt_escritura,
	'21516' cd_conta_debito,
	cd_conta_credito,
	0 cd_centro_custo_debito,
	0 cd_centro_custo_credito,
	a.vl_movimento,
	b.ds_historico || ' ' || a.ds_compl_historico ds_historico,
	a.nr_sequencia,
	campo_numerico(a.ds_compl_historico) nr_documento,
	'                    ' ds_branco,
	'00000000000000000000' ds_zeros
from	conta_contabil d,
	historico_padrao b,
	ctb_movimento a
where	a.cd_historico		= b.cd_historico
and	a.cd_conta_credito	= d.cd_conta_contabil
and	exists (
	select 1
	from	ctb_movto_centro_custo c
	where	a.nr_sequencia		= c.nr_seq_movimento)
and	ie_centro_custo		= 'N') alias14;
