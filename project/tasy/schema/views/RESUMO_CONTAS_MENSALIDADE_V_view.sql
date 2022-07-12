-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW resumo_contas_mensalidade_v (cd_conta, ie_tipo_conta, vl_item, ds_conta_contabil, dt_mesano_referencia, vl_credito, vl_debito) AS select	d.cd_conta_rec cd_conta,
	'C' ie_tipo_conta,
	d.vl_item,
	(select	substr(ds_conta_contabil,1,200)
	FROM	conta_contabil
	where	cd_conta_contabil = d.cd_conta_rec) ds_conta_contabil,
	c.dt_mesano_referencia dt_mesano_referencia,
	CASE WHEN d.vl_item=abs(d.vl_item) THEN abs(d.vl_item)  ELSE 0 END  vl_credito,
	CASE WHEN d.vl_item=abs(d.vl_item) THEN 0  ELSE abs(d.vl_item) END  vl_debito
from	pls_lote_mensalidade a,
	pls_mensalidade b,
	pls_mensalidade_segurado c,
	pls_mensalidade_seg_item d
where	a.nr_sequencia	= b.nr_seq_lote
and	b.nr_sequencia	= c.nr_seq_mensalidade
and	c.nr_sequencia	= d.nr_seq_mensalidade_seg
and	d.ie_tipo_item	not in ('1','3','12')

UNION ALL

select	f.cd_conta_cred cd_conta,
	'C' ie_tipo_conta,
	f.vl_coparticipacao vl_item,
	(select	substr(ds_conta_contabil,1,200)
	from	conta_contabil
	where	cd_conta_contabil = f.cd_conta_cred) ds_conta_contabil,
	c.dt_mesano_referencia dt_mesano_referencia,
	CASE WHEN d.vl_item=abs(d.vl_item) THEN abs(d.vl_item)  ELSE 0 END  vl_credito,
	CASE WHEN d.vl_item=abs(d.vl_item) THEN 0  ELSE abs(d.vl_item) END  vl_debito
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

UNION ALL

select	d.cd_conta_rec_antecip cd_conta,
	'C' ie_tipo_conta,
	coalesce(d.vl_antecipacao,0) vl_item,
	(select	substr(ds_conta_contabil,1,200)
	from	conta_contabil
	where	cd_conta_contabil = d.cd_conta_rec_antecip) ds_conta_contabil,
	c.dt_mesano_referencia dt_mesano_referencia,
	CASE WHEN d.vl_antecipacao=abs(d.vl_antecipacao) THEN abs(d.vl_antecipacao)  ELSE 0 END  vl_credito,
	CASE WHEN d.vl_antecipacao=abs(d.vl_antecipacao) THEN 0  ELSE abs(d.vl_antecipacao) END  vl_debito
from	pls_lote_mensalidade a,
	pls_mensalidade b,
	pls_mensalidade_segurado c,
	pls_mensalidade_seg_item d
where	a.nr_sequencia	= b.nr_seq_lote
and	b.nr_sequencia	= c.nr_seq_mensalidade
and	c.nr_sequencia	= d.nr_seq_mensalidade_seg
and	a.dt_contabilizacao is null

UNION ALL

select	d.cd_conta_rec_antecip cd_conta,
	'C' ie_tipo_conta,
	coalesce(d.vl_item,0) vl_item,
	(select	substr(ds_conta_contabil,1,200)
	from	conta_contabil
	where	cd_conta_contabil = d.cd_conta_rec_antecip) ds_conta_contabil,
	a.dt_contabilizacao dt_mesano_referencia,
	CASE WHEN d.vl_item=abs(d.vl_item) THEN abs(d.vl_item)  ELSE 0 END  vl_credito,
	CASE WHEN d.vl_item=abs(d.vl_item) THEN 0  ELSE abs(d.vl_item) END  vl_debito
from	pls_lote_mensalidade a,
	pls_mensalidade b,
	pls_mensalidade_segurado c,
	pls_mensalidade_seg_item d
where	a.nr_sequencia	= b.nr_seq_lote
and	b.nr_sequencia	= c.nr_seq_mensalidade
and	c.nr_sequencia	= d.nr_seq_mensalidade_seg

UNION ALL

select	d.cd_conta_rec cd_conta,
	'C' ie_tipo_conta,
	coalesce(d.vl_pro_rata_dia,0) vl_item,
	(select	substr(ds_conta_contabil,1,200)
	from	conta_contabil
	where	cd_conta_contabil = d.cd_conta_rec) ds_conta_contabil,
	c.dt_mesano_referencia dt_mesano_referencia,
	CASE WHEN d.vl_pro_rata_dia=abs(d.vl_pro_rata_dia) THEN abs(d.vl_pro_rata_dia)  ELSE 0 END  vl_credito,
	CASE WHEN d.vl_pro_rata_dia=abs(d.vl_pro_rata_dia) THEN 0  ELSE abs(d.vl_pro_rata_dia) END  vl_debito
from	pls_lote_mensalidade a,
	pls_mensalidade b,
	pls_mensalidade_segurado c,
	pls_mensalidade_seg_item d
where	a.nr_sequencia	= b.nr_seq_lote
and	b.nr_sequencia	= c.nr_seq_mensalidade
and	c.nr_sequencia	= d.nr_seq_mensalidade_seg
and	d.ie_tipo_item	in ('1','12')

UNION ALL

select	d.cd_conta_deb cd_conta,
	'D' ie_tipo_conta,
	d.vl_item,
	(select	substr(ds_conta_contabil,1,200)
	from	conta_contabil
	where	cd_conta_contabil = d.cd_conta_deb) ds_conta_contabil,
	coalesce(a.dt_contabilizacao,c.dt_mesano_referencia) dt_mesano_referencia,
	CASE WHEN d.vl_item=abs(d.vl_item) THEN 0  ELSE abs(d.vl_item) END  vl_credito,
	CASE WHEN d.vl_item=abs(d.vl_item) THEN abs(d.vl_item)  ELSE 0 END  vl_debito
from	pls_lote_mensalidade a,
	pls_mensalidade b,
	pls_mensalidade_segurado c,
	pls_mensalidade_seg_item d
where	a.nr_sequencia	= b.nr_seq_lote
and	b.nr_sequencia	= c.nr_seq_mensalidade
and	c.nr_sequencia	= d.nr_seq_mensalidade_seg
and	d.ie_tipo_item	<> '3'

UNION ALL

select	f.cd_conta_deb cd_conta,
	'D' ie_tipo_conta,
	f.vl_coparticipacao,
	(select	substr(ds_conta_contabil,1,200)
	from	conta_contabil
	where	cd_conta_contabil = f.cd_conta_deb) ds_conta_contabil,
	c.dt_mesano_referencia dt_mesano_referencia,
	CASE WHEN d.vl_item=abs(d.vl_item) THEN 0  ELSE abs(f.vl_coparticipacao) END  vl_credito,
	CASE WHEN d.vl_item=abs(d.vl_item) THEN abs(f.vl_coparticipacao)  ELSE 0 END  vl_debito
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

union all
 /* Lepinski - início contas imposto */
select  substr(pls_obter_conta_imposto('C',b.nr_sequencia,a.cd_estabelecimento),1,255) cd_conta,
	'C' ie_tipo_conta,
	coalesce(e.vl_tributo,0) vl_item,
	(select	substr(ds_conta_contabil,1,200)
	from	conta_contabil
	where	cd_conta_contabil = pls_obter_conta_imposto('C',b.nr_sequencia,a.cd_estabelecimento)) ds_conta_contabil,
	b.dt_referencia dt_mesano_referencia,
	coalesce(e.vl_tributo,0) vl_credito,
	0 vl_debito
FROM pls_lote_mensalidade a, pls_mensalidade b
LEFT OUTER JOIN titulo_receber c ON (b.nr_sequencia = c.nr_seq_mensalidade)
LEFT OUTER JOIN nota_fiscal d ON (b.nr_sequencia = d.nr_seq_mensalidade)
LEFT OUTER JOIN nota_fiscal_trib e ON (d.nr_sequencia = e.nr_sequencia)
WHERE a.nr_sequencia			= b.nr_seq_lote    and e.vl_tributo <> 0

union all

select  substr(pls_obter_conta_imposto('D',b.nr_sequencia,a.cd_estabelecimento),1,255) cd_conta,
	'D' ie_tipo_conta,
	coalesce(e.vl_tributo,0) vl_item,
	(select	substr(ds_conta_contabil,1,200)
	from	conta_contabil
	where	cd_conta_contabil = pls_obter_conta_imposto('D',b.nr_sequencia,a.cd_estabelecimento)) ds_conta_contabil,
	b.dt_referencia dt_mesano_referencia,
	0 vl_credito,
	coalesce(e.vl_tributo,0) vl_debito
FROM pls_lote_mensalidade a, pls_mensalidade b
LEFT OUTER JOIN titulo_receber c ON (b.nr_sequencia = c.nr_seq_mensalidade)
LEFT OUTER JOIN nota_fiscal d ON (b.nr_sequencia = d.nr_seq_mensalidade)
LEFT OUTER JOIN nota_fiscal_trib e ON (d.nr_sequencia = e.nr_sequencia)
WHERE a.nr_sequencia			= b.nr_seq_lote    and e.vl_tributo <> 0 /* Lepinski - fim contas imposto */
 
union all

select	d.cd_conta_rec_antecip cd_conta,
	'D' ie_tipo_conta,
	coalesce(d.vl_antecipacao,0) vl_item,
	(select	substr(ds_conta_contabil,1,200)
	from	conta_contabil
	where	cd_conta_contabil = d.cd_conta_rec_antecip) ds_conta_contabil,
	d.dt_antecipacao dt_mesano_referencia,
	0 vl_credito,
	d.vl_antecipacao vl_debito
from	pls_lote_mensalidade a,
	pls_mensalidade b,
	pls_mensalidade_segurado c,
	pls_mensalidade_seg_item d
where	a.nr_sequencia	= b.nr_seq_lote
and	b.nr_sequencia	= c.nr_seq_mensalidade
and	c.nr_sequencia	= d.nr_seq_mensalidade_seg

union all

select	d.cd_conta_deb_antecip cd_conta,
	'D' ie_tipo_conta,
	coalesce(d.vl_pro_rata_dia,0) vl_item,
	(select	substr(ds_conta_contabil,1,200)
	from	conta_contabil
	where	cd_conta_contabil = d.cd_conta_deb_antecip) ds_conta_contabil,
	c.dt_mesano_referencia dt_mesano_referencia,
	0 vl_credito,
	d.vl_pro_rata_dia vl_debito
from	pls_lote_mensalidade a,
	pls_mensalidade b,
	pls_mensalidade_segurado c,
	pls_mensalidade_seg_item d
where	a.nr_sequencia	= b.nr_seq_lote
and	b.nr_sequencia	= c.nr_seq_mensalidade
and	c.nr_sequencia	= d.nr_seq_mensalidade_seg
and     a.dt_contabilizacao is not null /* Debita a conta de antecipação para poder creditar a receita*/
union all

select	d.cd_conta_rec cd_conta,
	'C' ie_tipo_conta,
	coalesce(d.vl_antecipacao,0) vl_item,
	(select	substr(ds_conta_contabil,1,200)
	from	conta_contabil
	where	cd_conta_contabil = d.cd_conta_rec) ds_conta_contabil,
	d.dt_antecipacao dt_mesano_referencia,
	d.vl_antecipacao vl_credito,
	0 vl_debito
from	pls_lote_mensalidade a,
	pls_mensalidade b,
	pls_mensalidade_segurado c,
	pls_mensalidade_seg_item d
where	a.nr_sequencia	= b.nr_seq_lote
and	b.nr_sequencia	= c.nr_seq_mensalidade
and	c.nr_sequencia	= d.nr_seq_mensalidade_seg;
