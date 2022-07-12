-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_rel_empresarial_seisa_v (nr_ordem, ds_item, qt, vl_total, vl_unitario, nr_contrato, dt_mesano_referencia) AS select	1 nr_ordem,
	CASE WHEN c.nr_seq_titular IS NULL THEN 'TITULARES'  ELSE 'DEPENDENTES' END  || ' PLANO ' ||upper(pls_obter_dados_produto(c.nr_seq_plano,'N')) ds_item,
	count(*) qt,
	sum(a.vl_item) vl_total,
	a.vl_item /*dividir(sum(a.vl_item) , count(*))*/
 vl_unitario,
	e.nr_contrato,
	b.dt_mesano_referencia
FROM	pls_mensalidade_seg_item	a,
	pls_mensalidade_segurado	b,
	pls_segurado			c,
	pls_mensalidade			d,
	pls_contrato			e
where	b.nr_seq_segurado	= c.nr_sequencia
and	a.nr_seq_mensalidade_seg = b.nr_sequencia
and	b.nr_seq_mensalidade	= d.nr_sequencia
and	c.nr_seq_contrato	= e.nr_sequencia
and	d.ie_cancelamento is null
and	a.ie_tipo_item		= '1'
group by CASE WHEN c.nr_seq_titular IS NULL THEN 'TITULARES'  ELSE 'DEPENDENTES' END ,
	c.nr_seq_plano,
	e.nr_contrato,
	b.dt_mesano_referencia,
	a.vl_item

union all

select	2 nr_ordem,
	'COBRANÇA RETROATIVA DE ASSOCIADO(S) ADMITIDO(S)' ds_item,
	count(*) qt,
	sum(a.vl_item) vl_total,
	dividir(sum(a.vl_item) , count(*)) vl_unitario,
	e.nr_contrato,
	b.dt_mesano_referencia
from	pls_mensalidade_seg_item	a,
	pls_mensalidade_segurado	b,
	pls_segurado			c,
	pls_mensalidade			d,
	pls_contrato			e
where	b.nr_seq_segurado	= c.nr_sequencia
and	a.nr_seq_mensalidade_seg = b.nr_sequencia
and	b.nr_seq_mensalidade	= d.nr_sequencia
and	c.nr_seq_contrato	= e.nr_sequencia
and	d.ie_cancelamento is null
and	a.ie_tipo_item		= '4'
group by CASE WHEN c.nr_seq_titular IS NULL THEN 'TITULARES'  ELSE 'DEPENDENTES' END ,
	c.nr_seq_plano,
	e.nr_contrato,
	b.dt_mesano_referencia

union all

select	3 nr_ordem,
	'DESCONTO DE ASSOCIADO(S) EXCLUIDO(S)' ds_plano,
	count(*) qt,
	(sum(a.vl_item) * -1) vl_total,
	(dividir(sum(a.vl_item) , count(*)) * -1) vl_unitario,
	e.nr_contrato,
	trunc(c.dt_rescisao,'month') dt_mesano_referencia
from	pls_mensalidade_seg_item	a,
	pls_mensalidade_segurado	b,
	pls_segurado			c,
	pls_mensalidade			d,
	pls_contrato			e
where	b.nr_seq_segurado	= c.nr_sequencia
and	a.nr_seq_mensalidade_seg = b.nr_sequencia
and	b.nr_seq_mensalidade	= d.nr_sequencia
and	c.nr_seq_contrato	= e.nr_sequencia
and	d.ie_cancelamento is null
and	b.dt_mesano_referencia	= add_months(trunc(c.dt_rescisao,'month'),-1)
and	a.ie_tipo_item		= '1'
group by CASE WHEN c.nr_seq_titular IS NULL THEN 'TITULARES'  ELSE 'DEPENDENTES' END ,
	c.nr_seq_plano,
	e.nr_contrato,
	trunc(c.dt_rescisao,'month')

union all

select	4 nr_ordem,
	'SEGUNDAS VIAS DE CARTEIRINHAS' ds_item,
	count(*) qt,
	sum(a.vl_item) vl_total,
	dividir(sum(a.vl_item) , count(*)) vl_unitario,
	e.nr_contrato,
	b.dt_mesano_referencia
from	pls_mensalidade_seg_item	a,
	pls_mensalidade_segurado	b,
	pls_segurado			c,
	pls_mensalidade			d,
	pls_contrato			e
where	b.nr_seq_segurado	= c.nr_sequencia
and	a.nr_seq_mensalidade_seg = b.nr_sequencia
and	b.nr_seq_mensalidade	= d.nr_sequencia
and	c.nr_seq_contrato	= e.nr_sequencia
and	d.ie_cancelamento is null
and	a.ie_tipo_item		= '11'
group by CASE WHEN c.nr_seq_titular IS NULL THEN 'TITULARES'  ELSE 'DEPENDENTES' END ,
	c.nr_seq_plano,
	e.nr_contrato,
	b.dt_mesano_referencia;
