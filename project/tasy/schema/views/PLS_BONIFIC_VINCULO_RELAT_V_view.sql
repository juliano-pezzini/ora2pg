-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_bonific_vinculo_relat_v (vl_item, vl_coparticipacao, ds_produto, ie_tipo_contratacao, ie_regulamentacao, nr_seq_lote, dt_emissao, dt_liquidacao, dt_vencimento, ie_tipo_item, cd_portador, nr_seq_bonificacao, nr_seq_plano_mens, nr_seq_conta_banco, nr_seq_forma_cobranca, qt_beneficiarios) AS select	CASE WHEN c.ie_tipo_item='3' THEN 0  ELSE coalesce(c.vl_item,0) END  vl_item,
	CASE WHEN c.ie_tipo_item='3' THEN coalesce(c.vl_item,0)  ELSE 0 END  vl_coparticipacao,
	substr(g.ds_plano,1,255) ds_produto,
	g.ie_tipo_contratacao,
	g.ie_regulamentacao,
	a.nr_seq_lote,
	j.dt_emissao,
	j.dt_liquidacao,
	j.dt_vencimento,
	c.ie_tipo_item,
	f.cd_portador,
	k.nr_seq_bonificacao,
	b.nr_seq_plano nr_seq_plano_mens,
	f.nr_seq_conta_banco,
	a.nr_seq_forma_cobranca,
	a.qt_beneficiarios
FROM	pls_bonificacao_vinculo		k,
	titulo_receber			j,
	pls_contrato_plano		i,
	pls_contrato			h,
	pls_plano			g,
	pls_contrato_pagador_fin	f,
	pls_contrato_pagador		e,
	pls_segurado			d,
	pls_mensalidade_seg_item	c,
	pls_mensalidade_segurado	b,
	pls_mensalidade			a
where	c.nr_seq_mensalidade_seg	= b.nr_sequencia
and	b.nr_seq_mensalidade		= a.nr_sequencia
and	b.nr_seq_segurado		= d.nr_sequencia
and	d.nr_seq_pagador		= e.nr_sequencia
and	f.nr_seq_pagador		= e.nr_sequencia
and	i.nr_seq_plano			= g.nr_sequencia
and	j.nr_seq_mensalidade		= a.nr_sequencia
and	i.nr_seq_contrato		= h.nr_sequencia
and	e.nr_seq_contrato		= h.nr_sequencia
and	k.nr_seq_segurado		= d.nr_sequencia
and	c.nr_seq_bonificacao_vinculo 	= k.nr_sequencia

union all

select	CASE WHEN c.ie_tipo_item='3' THEN 0  ELSE coalesce(c.vl_item,0) END  vl_item,
	CASE WHEN c.ie_tipo_item='3' THEN coalesce(c.vl_item,0)  ELSE 0 END  vl_coparticipacao,
	substr(g.ds_plano,1,255) ds_produto,
	g.ie_tipo_contratacao,
	g.ie_regulamentacao,
	a.nr_seq_lote,
	j.dt_emissao,
	j.dt_liquidacao,
	j.dt_vencimento,
	c.ie_tipo_item,
	f.cd_portador,
	k.nr_seq_bonificacao,
	b.nr_seq_plano nr_seq_plano_mens,
	f.nr_seq_conta_banco,
	a.nr_seq_forma_cobranca,
	a.qt_beneficiarios
from	pls_bonificacao_vinculo		k,
	titulo_receber			j,
	pls_contrato_plano		i,
	pls_contrato			h,
	pls_plano			g,
	pls_contrato_pagador_fin	f,
	pls_contrato_pagador		e,
	pls_segurado			d,
	pls_mensalidade_seg_item	c,
	pls_mensalidade_segurado	b,
	pls_mensalidade			a
where	c.nr_seq_mensalidade_seg	= b.nr_sequencia
and	b.nr_seq_mensalidade		= a.nr_sequencia
and	b.nr_seq_segurado		= d.nr_sequencia
and	d.nr_seq_pagador		= e.nr_sequencia
and	f.nr_seq_pagador		= e.nr_sequencia
and	i.nr_seq_plano			= g.nr_sequencia
and	j.nr_seq_mensalidade		= a.nr_sequencia
and	i.nr_seq_contrato		= h.nr_sequencia
and	e.nr_seq_contrato		= h.nr_sequencia
and	k.nr_seq_plano			= e.nr_sequencia
and	c.nr_seq_bonificacao_vinculo 	= k.nr_sequencia

union all

select	CASE WHEN c.ie_tipo_item='3' THEN 0  ELSE coalesce(c.vl_item,0) END  vl_item,
	CASE WHEN c.ie_tipo_item='3' THEN coalesce(c.vl_item,0)  ELSE 0 END  vl_coparticipacao,
	substr(g.ds_plano,1,255) ds_produto,
	g.ie_tipo_contratacao,
	g.ie_regulamentacao,
	a.nr_seq_lote,
	j.dt_emissao,
	j.dt_liquidacao,
	j.dt_vencimento,
	c.ie_tipo_item,
	f.cd_portador,
	k.nr_seq_bonificacao,
	b.nr_seq_plano nr_seq_plano_mens,
	f.nr_seq_conta_banco,
	a.nr_seq_forma_cobranca,
	a.qt_beneficiarios
from	pls_bonificacao_vinculo		k,
	titulo_receber			j,
	pls_contrato_plano		i,
	pls_contrato			h,
	pls_plano			g,
	pls_contrato_pagador_fin	f,
	pls_contrato_pagador		e,
	pls_segurado			d,
	pls_mensalidade_seg_item	c,
	pls_mensalidade_segurado	b,
	pls_mensalidade			a
where	c.nr_seq_mensalidade_seg	= b.nr_sequencia
and	b.nr_seq_mensalidade		= a.nr_sequencia
and	b.nr_seq_segurado		= d.nr_sequencia
and	d.nr_seq_pagador		= e.nr_sequencia
and	f.nr_seq_pagador		= e.nr_sequencia
and	i.nr_seq_plano			= g.nr_sequencia
and	j.nr_seq_mensalidade		= a.nr_sequencia
and	i.nr_seq_contrato		= h.nr_sequencia
and	e.nr_seq_contrato		= h.nr_sequencia
and	k.nr_seq_contrato		= h.nr_sequencia
and	c.nr_seq_bonificacao_vinculo 	= k.nr_sequencia;
