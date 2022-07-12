-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ecd_saldo_sem_encerramento_v (tp_registro, ds_identificador, cd_empresa, cd_estabelecimento, dt_resultado, cd_conta_contabil, cd_classificacao, cd_centro_custo, vl_saldo, ie_debito_credito, barra_final) AS select	distinct
	1 tp_registro,
	'|I350' ds_identificador,
	b.cd_empresa,
	a.cd_estabelecimento,
	b.dt_referencia dt_resultado,
	'' 	cd_conta_contabil,
	''	cd_classificacao,
	null	cd_centro_custo,
	null	vl_saldo,
	'' 	ie_debito_credito,
	'|' barra_final
FROM	ctb_mes_ref b,
	ctb_saldo a
where	a.nr_seq_mes_ref	= b.nr_sequencia

union all

select	2 tp_registro,
	'|I355' ds_identificador,
	b.cd_empresa,
	a.cd_estabelecimento,
	b.dt_referencia			dt_resultado,
	a.cd_conta_contabil,
	c.cd_classificacao,
	a.cd_centro_custo,
	sum(a.vl_saldo) vl_saldo,
	substr(ctb_obter_situacao_saldo(a.cd_conta_contabil,  sum(a.vl_saldo)),1,1) ie_debito_credito,
	'|' barra_final
from	ctb_grupo_conta d,
	ctb_mes_ref b,
	conta_contabil c,
	ctb_saldo a
where	a.nr_seq_mes_ref 	= b.nr_sequencia
and	c.cd_conta_contabil	= a.cd_conta_contabil
and	d.cd_grupo		= c.cd_grupo
and	c.ie_tipo			= 'A'
and	d.ie_tipo in ('R','C','D')
group by b.dt_referencia,
	  b.cd_empresa,
	  a.cd_estabelecimento,
	a.cd_conta_contabil,
	a.cd_centro_custo,
	c.cd_classificacao
order by dt_resultado, tp_registro, cd_classificacao,cd_centro_custo;
