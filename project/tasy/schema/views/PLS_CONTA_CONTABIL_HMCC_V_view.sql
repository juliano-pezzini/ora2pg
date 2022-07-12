-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_conta_contabil_hmcc_v (ie_union, cd_conta, vl_titulo, dt_mesano_referencia, dt_vencimento, nr_titulo, nm_pessoa_titulo, ie_cancelamento, dt_emissao) AS select	1 ie_union,
	d.cd_conta_rec cd_conta,
	sum(abs(d.vl_item)) vl_titulo,
	c.dt_mesano_referencia dt_mesano_referencia,
	e.dt_vencimento dt_vencimento,
	e.nr_titulo,
	substr(Obter_nome_pf_pj(e.cd_pessoa_fisica,e.cd_cgc),1,200) nm_pessoa_titulo,
	b.ie_cancelamento ie_cancelamento,
	e.dt_emissao dt_emissao
FROM	pls_lote_mensalidade	a,
	pls_mensalidade		b,
	pls_mensalidade_segurado c,
	pls_mensalidade_seg_item d,
	titulo_receber		e
where	a.nr_sequencia	= b.nr_seq_lote
and	b.nr_sequencia	= c.nr_seq_mensalidade
and	c.nr_sequencia	= d.nr_seq_mensalidade_seg
and	e.nr_seq_mensalidade	= b.nr_sequencia
and	d.ie_tipo_item	not in ('1','3','12')
group	by	e.nr_titulo,
		e.dt_vencimento,
		c.dt_mesano_referencia,
		d.cd_conta_rec,
		e.cd_pessoa_fisica,
		e.cd_cgc,
		b.ie_cancelamento,
		e.dt_emissao

union all

select	2 ie_union,
	f.cd_conta_cred cd_conta,
	sum(abs(f.vl_coparticipacao)) vl_item,
	c.dt_mesano_referencia dt_mesano_referencia,
	g.dt_vencimento,
	g.nr_titulo,
	substr(Obter_nome_pf_pj(g.cd_pessoa_fisica,g.cd_cgc),1,200) nm_pessoa_titulo,
	b.ie_cancelamento,
	g.dt_emissao dt_emissao
from	pls_lote_mensalidade a,
	pls_mensalidade b,
	pls_mensalidade_segurado c,
	pls_mensalidade_seg_item d,
	pls_conta		 e,
	pls_conta_coparticipacao f,
	titulo_receber		g
where	a.nr_sequencia	= b.nr_seq_lote
and	b.nr_sequencia	= c.nr_seq_mensalidade
and	d.nr_seq_conta	= e.nr_sequencia
and	e.nr_sequencia	= f.nr_seq_conta
and	c.nr_sequencia	= d.nr_seq_mensalidade_seg
and	g.nr_seq_mensalidade	= b.nr_sequencia
and	d.ie_tipo_item	= '3'
group	by	f.cd_conta_cred ,
		c.dt_mesano_referencia,
		g.dt_vencimento,
		g.nr_titulo,
		g.cd_pessoa_fisica,
		g.cd_cgc,
		b.ie_cancelamento,
		g.dt_emissao

union all

select	3 ie_union,
	d.cd_conta_rec_antecip cd_conta,
	sum(abs(d.vl_antecipacao)) vl_item,
	c.dt_mesano_referencia dt_mesano_referencia,
	e.dt_vencimento,
	e.nr_titulo,
	substr(Obter_nome_pf_pj(e.cd_pessoa_fisica,e.cd_cgc),1,200) nm_pessoa_titulo,
	b.ie_cancelamento,
	e.dt_emissao dt_emissao
from	pls_lote_mensalidade	a,
	pls_mensalidade		b,
	pls_mensalidade_segurado c,
	pls_mensalidade_seg_item d,
	titulo_receber		e
where	a.nr_sequencia	= b.nr_seq_lote
and	b.nr_sequencia	= c.nr_seq_mensalidade
and	c.nr_sequencia	= d.nr_seq_mensalidade_seg
and	e.nr_seq_mensalidade	= b.nr_sequencia
and	d.ie_tipo_item	in ('1','12')
group	by	d.cd_conta_rec_antecip,
		c.dt_mesano_referencia,
		e.dt_vencimento,
		e.nr_titulo,
		e.cd_pessoa_fisica,
		e.cd_cgc,
		b.ie_cancelamento,
		e.dt_emissao

union all

select	4 ie_union,
	d.cd_conta_rec cd_conta,
	sum(abs(d.vl_pro_rata_dia)) vl_item,
	c.dt_mesano_referencia dt_mesano_referencia,
	e.dt_vencimento,
	e.nr_titulo,
	substr(Obter_nome_pf_pj(e.cd_pessoa_fisica,e.cd_cgc),1,200) nm_pessoa_titulo,
	b.ie_cancelamento,
	e.dt_emissao dt_emissao
from	pls_lote_mensalidade	a,
	pls_mensalidade		b,
	pls_mensalidade_segurado c,
	pls_mensalidade_seg_item d,
	titulo_receber		e
where	a.nr_sequencia	= b.nr_seq_lote
and	b.nr_sequencia	= c.nr_seq_mensalidade
and	c.nr_sequencia	= d.nr_seq_mensalidade_seg
and	e.nr_seq_mensalidade	= b.nr_sequencia
and	d.ie_tipo_item	in ('1','12')
group	by	d.cd_conta_rec,
		c.dt_mesano_referencia,
		e.dt_vencimento,
		e.nr_titulo,
		e.cd_pessoa_fisica,
		e.cd_cgc,
		b.ie_cancelamento,
		e.dt_emissao

union all

select	5 ie_union,
	d.cd_conta_deb cd_conta,
	sum(abs(d.vl_item)),
	c.dt_mesano_referencia dt_mesano_referencia,
	e.dt_vencimento,
	e.nr_titulo,
	substr(Obter_nome_pf_pj(e.cd_pessoa_fisica,e.cd_cgc),1,200) nm_pessoa_titulo,
	b.ie_cancelamento,
	e.dt_emissao dt_emissao
from	pls_lote_mensalidade	a,
	pls_mensalidade		b,
	pls_mensalidade_segurado c,
	pls_mensalidade_seg_item d,
	titulo_receber		e
where	a.nr_sequencia	= b.nr_seq_lote
and	b.nr_sequencia	= c.nr_seq_mensalidade
and	c.nr_sequencia	= d.nr_seq_mensalidade_seg
and	e.nr_seq_mensalidade	= b.nr_sequencia
and	d.ie_tipo_item	<> '3'
group	by	d.cd_conta_deb,
		c.dt_mesano_referencia,
		e.dt_vencimento,
		e.nr_titulo,
		e.cd_pessoa_fisica,
		e.cd_cgc,
		b.ie_cancelamento,
		e.dt_emissao

union all

select	6 ie_union,
	f.cd_conta_deb cd_conta,
	sum(abs(f.vl_coparticipacao)),
	c.dt_mesano_referencia dt_mesano_referencia,
	g.dt_vencimento,
	g.nr_titulo,
	substr(Obter_nome_pf_pj(g.cd_pessoa_fisica,g.cd_cgc),1,200) nm_pessoa_titulo,
	b.ie_cancelamento,
	g.dt_emissao dt_emissao
from	pls_lote_mensalidade	a,
	pls_mensalidade		b,
	pls_mensalidade_segurado c,
	pls_mensalidade_seg_item d,
	pls_conta		e,
	pls_conta_coparticipacao f,
	titulo_receber		g
where	a.nr_sequencia	= b.nr_seq_lote
and	b.nr_sequencia	= c.nr_seq_mensalidade
and	d.nr_seq_conta	= e.nr_sequencia
and	e.nr_sequencia	= f.nr_seq_conta
and	c.nr_sequencia	= d.nr_seq_mensalidade_seg
and	g.nr_seq_mensalidade	= b.nr_sequencia
and	d.ie_tipo_item	= '3'
group	by	f.cd_conta_deb,
		c.dt_mesano_referencia,
		g.dt_vencimento,
		g.nr_titulo,
		g.cd_pessoa_fisica,
		g.cd_cgc,
		b.ie_cancelamento,
		g.dt_emissao;

