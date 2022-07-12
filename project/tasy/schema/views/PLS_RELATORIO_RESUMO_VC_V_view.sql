-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_relatorio_resumo_vc_v (cd_conta, ie_tipo_conta, vl_item, ds_conta_contabil, dt_mesano_referencia, ie_tipo_item, nr_seq_sca, nr_seq_bonificacao, nr_seq_plano, ie_tipo_reg) AS select	d.cd_conta_rec cd_conta,
	'C' ie_tipo_conta,
	sum(d.vl_item) vl_item,
	substr(obter_desc_conta_contabil(d.cd_conta_rec),1,255) ds_conta_contabil,
	trunc(c.dt_mesano_referencia,'month') dt_mesano_referencia,
	d.ie_tipo_item ie_tipo_item,
	e.nr_seq_plano nr_seq_sca,
	null nr_seq_bonificacao,
	null nr_seq_plano,
	'SCA' ie_tipo_reg
FROM	pls_lote_mensalidade a,
	pls_mensalidade b,
	pls_mensalidade_segurado c,
	pls_mensalidade_seg_item d,
	pls_sca_vinculo		e
where	a.nr_sequencia	= b.nr_seq_lote
and	b.nr_sequencia	= c.nr_seq_mensalidade
and	c.nr_sequencia	= d.nr_seq_mensalidade_seg
and	d.nr_seq_vinculo_sca	= e.nr_sequencia
and	d.ie_tipo_item	= '15'
group by e.nr_seq_plano,d.cd_conta_rec,	d.ie_tipo_item,c.dt_mesano_referencia

union

select	d.cd_conta_rec cd_conta,
	'C' ie_tipo_conta,
	sum(d.vl_item),
	substr(obter_desc_conta_contabil(d.cd_conta_rec),1,255) ds_conta_contabil,
	trunc(c.dt_mesano_referencia,'month'),
	d.ie_tipo_item,
	null nr_seq_sca,
	f.nr_seq_bonificacao,
	null nr_seq_plano,
	'BON' ie_tipo_reg
from	pls_lote_mensalidade a,
	pls_mensalidade b,
	pls_mensalidade_segurado c,
	pls_mensalidade_seg_item d,
	pls_bonificacao_vinculo	f
where	a.nr_sequencia	= b.nr_seq_lote
and	b.nr_sequencia	= c.nr_seq_mensalidade
and	c.nr_sequencia	= d.nr_seq_mensalidade_seg
and	d.ie_tipo_item	= '14'
and	d.nr_seq_bonificacao_vinculo	= f.nr_sequencia
group by d.cd_conta_rec,d.ie_tipo_item,f.nr_seq_bonificacao,c.dt_mesano_referencia

UNION ALL

select	d.cd_conta_rec_antecip cd_conta,
	'C' ie_tipo_conta,
	coalesce(sum(d.vl_antecipacao),0) vl_item,
	substr(obter_desc_conta_contabil(d.cd_conta_rec_antecip),1,255) ds_conta_contabil,
	trunc(c.dt_mesano_referencia,'month') dt_mesano_referencia,
	d.ie_tipo_item,
	null nr_seq_sca,
	null nr_seq_bonificacao,
	c.nr_seq_plano,
	'PRE' ie_tipo_reg
from	pls_lote_mensalidade a,
	pls_mensalidade b,
	pls_mensalidade_segurado c,
	pls_mensalidade_seg_item d
where	a.nr_sequencia	= b.nr_seq_lote
and	b.nr_sequencia	= c.nr_seq_mensalidade
and	c.nr_sequencia	= d.nr_seq_mensalidade_seg
and	d.ie_tipo_item	in ('1','12')
group by d.cd_conta_rec_antecip,d.ie_tipo_item,c.nr_seq_plano,c.dt_mesano_referencia

UNION ALL

select	f.cd_conta_cred cd_conta,
	'C' ie_tipo_conta,
	SUM(f.vl_coparticipacao) vl_item,
	substr(obter_desc_conta_contabil(f.cd_conta_cred),1,255) ds_conta_contabil,
	trunc(c.dt_mesano_referencia,'month') dt_mesano_referencia,
	d.ie_tipo_item,
	null nr_seq_sca,
	null nr_seq_bonificacao,
	null nr_seq_plano,
	'COP' ie_tipo_reg
from	pls_lote_mensalidade a,
	pls_mensalidade b,
	pls_mensalidade_segurado c,
	pls_mensalidade_seg_item d,
	pls_conta e,
	pls_conta_coparticipacao f
where	a.nr_sequencia	= b.nr_seq_lote
and	b.nr_sequencia	= c.nr_seq_mensalidade
and	d.nr_seq_conta	= e.nr_sequencia
and	e.nr_sequencia	= f.nr_seq_conta
and	c.nr_sequencia	= d.nr_seq_mensalidade_seg
and	d.ie_tipo_item	= '3'
group by f.cd_conta_cred,c.dt_mesano_referencia,d.ie_tipo_item

union

select	d.cd_conta_rec cd_conta,
	'C' ie_tipo_conta,
	sum(d.vl_item) vl_item,
	substr(obter_desc_conta_contabil(d.cd_conta_rec),1,255) ds_conta_contabil,
	trunc(c.dt_mesano_referencia,'month') dt_mesano_referencia,
	d.ie_tipo_item,
	null nr_seq_sca,
	null nr_seq_bonificacao,
	null nr_seq_plano,
	'TOT' ie_tipo_reg
from	pls_lote_mensalidade a,
	pls_mensalidade b,
	pls_mensalidade_segurado c,
	pls_mensalidade_seg_item d
where	a.nr_sequencia	= b.nr_seq_lote
and	b.nr_sequencia	= c.nr_seq_mensalidade
and	c.nr_sequencia	= d.nr_seq_mensalidade_seg
and	d.ie_tipo_item	not in ('1','3','12','14','15')
group by d.cd_conta_rec,c.dt_mesano_referencia,d.ie_tipo_item

UNION ALL

select	d.cd_conta_deb cd_conta,
	'D' ie_tipo_conta,
	sum(d.vl_item),
	substr(obter_desc_conta_contabil(d.cd_conta_deb),1,255) ds_conta_contabil,
	trunc(c.dt_mesano_referencia,'month') dt_mesano_referencia,
	d.ie_tipo_item,
	e.nr_seq_plano nr_seq_sca,
	null nr_seq_bonificacao,
	null nr_seq_plano,
	'SCA' ie_tipo_reg
from	pls_lote_mensalidade a,
	pls_mensalidade b,
	pls_mensalidade_segurado c,
	pls_mensalidade_seg_item d,
	pls_sca_vinculo		e
where	a.nr_sequencia	= b.nr_seq_lote
and	b.nr_sequencia	= c.nr_seq_mensalidade
and	c.nr_sequencia	= d.nr_seq_mensalidade_seg
and	d.ie_tipo_item	= '15'
and	d.nr_seq_vinculo_sca	= e.nr_sequencia
group by e.nr_seq_plano,d.cd_conta_deb,	d.ie_tipo_item,c.dt_mesano_referencia

UNION ALL

select	d.cd_conta_deb cd_conta,
	'D' ie_tipo_conta,
	sum(d.vl_item),
	substr(obter_desc_conta_contabil(d.cd_conta_deb),1,255) ds_conta_contabil,
	trunc(c.dt_mesano_referencia,'month') dt_mesano_referencia,
	d.ie_tipo_item,
	null nr_seq_sca,
	f.nr_seq_bonificacao nr_seq_bonificacao,
	null nr_seq_plano,
	'BON' ie_tipo_reg
from	pls_lote_mensalidade a,
	pls_mensalidade b,
	pls_mensalidade_segurado c,
	pls_mensalidade_seg_item d,
	pls_bonificacao_vinculo	f
where	a.nr_sequencia	= b.nr_seq_lote
and	b.nr_sequencia	= c.nr_seq_mensalidade
and	c.nr_sequencia	= d.nr_seq_mensalidade_seg
and	d.nr_seq_bonificacao_vinculo	= f.nr_sequencia
and	d.ie_tipo_item	= '14'
group by d.cd_conta_deb,d.ie_tipo_item,f.nr_seq_bonificacao,c.dt_mesano_referencia

UNION ALL

select	d.cd_conta_deb cd_conta,
	'D' ie_tipo_conta,
	sum(d.vl_item),
	substr(obter_desc_conta_contabil(d.cd_conta_deb),1,255) ds_conta_contabil,
	trunc(c.dt_mesano_referencia,'month') dt_mesano_referencia,
	d.ie_tipo_item,
	null nr_seq_sca,
	null nr_seq_bonificacao,
	c.nr_seq_plano,
	'PRE' ie_tipo_reg
from	pls_lote_mensalidade a,
	pls_mensalidade b,
	pls_mensalidade_segurado c,
	pls_mensalidade_seg_item d
where	a.nr_sequencia	= b.nr_seq_lote
and	b.nr_sequencia	= c.nr_seq_mensalidade
and	c.nr_sequencia	= d.nr_seq_mensalidade_seg
and	d.ie_tipo_item	in ('1','12')
group by d.cd_conta_deb,d.ie_tipo_item,c.nr_seq_plano,c.dt_mesano_referencia

UNION ALL

select	f.cd_conta_deb cd_conta,
	'D' ie_tipo_conta,
	sum(f.vl_coparticipacao),
	substr(obter_desc_conta_contabil(f.cd_conta_deb),1,255) ds_conta_contabil,
	trunc(c.dt_mesano_referencia,'month') dt_mesano_referencia,
	d.ie_tipo_item,
	null nr_seq_sca,
	null nr_seq_bonificacao,
	null nr_seq_plano,
	'COP' ie_tipo_reg
from	pls_lote_mensalidade a,
	pls_mensalidade b,
	pls_mensalidade_segurado c,
	pls_mensalidade_seg_item d,
	pls_conta e,
	pls_conta_coparticipacao f
where	a.nr_sequencia	= b.nr_seq_lote
and	b.nr_sequencia	= c.nr_seq_mensalidade
and	d.nr_seq_conta	= e.nr_sequencia
and	e.nr_sequencia	= f.nr_seq_conta
and	c.nr_sequencia	= d.nr_seq_mensalidade_seg
and	d.ie_tipo_item	= '3'
group by f.cd_conta_deb,c.dt_mesano_referencia,d.ie_tipo_item

UNION ALL

select	d.cd_conta_deb cd_conta,
	'D' ie_tipo_conta,
	sum(d.vl_item),
	substr(obter_desc_conta_contabil(d.cd_conta_deb),1,255) ds_conta_contabil,
	trunc(c.dt_mesano_referencia,'month') dt_mesano_referencia,
	d.ie_tipo_item,
	null nr_seq_sca,
	null nr_seq_bonificacao,
	null nr_seq_plano,
	'TOT' ie_tipo_reg
from	pls_lote_mensalidade a,
	pls_mensalidade b,
	pls_mensalidade_segurado c,
	pls_mensalidade_seg_item d
where	a.nr_sequencia	= b.nr_seq_lote
and	b.nr_sequencia	= c.nr_seq_mensalidade
and	c.nr_sequencia	= d.nr_seq_mensalidade_seg
and	d.ie_tipo_item	not in ('1','3','12','14','15')
group by d.cd_conta_deb,c.dt_mesano_referencia,d.ie_tipo_item;
