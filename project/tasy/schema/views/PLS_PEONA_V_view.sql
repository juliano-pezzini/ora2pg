-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_peona_v (ie_tipo_valor, ie_tipo_protocolo, dt_referencia, vl_peona, ie_tipo_plano, ie_tipo_guia, nr_seq_segurado, nr_seq_conta, dt_entrada, dt_atendimento_referencia) AS select	'R' ie_tipo_valor,
	null ie_tipo_protocolo,
	c.dt_mesano_referencia dt_referencia,
	pls_obter_receita_peona(c.dt_mesano_referencia) vl_peona,
	CASE WHEN f.ie_segmentacao=4 THEN 'OD'  ELSE 'PS' END  ie_tipo_plano,
	null ie_tipo_guia,
	null nr_seq_segurado,
	null nr_seq_conta,
	null dt_entrada,
	null dt_atendimento_referencia
FROM	pls_mensalidade_seg_item 	d,
	pls_mensalidade_segurado	c,
	pls_segurado			e,
	pls_plano 			f,
	pls_mensalidade			b,
	pls_lote_mensalidade		a
where	c.nr_sequencia		= d.nr_seq_mensalidade_seg
and	c.nr_seq_segurado	= e.nr_sequencia
and	e.nr_seq_plano		= f.nr_sequencia
and	b.nr_sequencia		= c.nr_seq_mensalidade
and	a.nr_sequencia		= b.nr_seq_lote
and	d.ie_tipo_item in ('1','4','5','12')
and	f.ie_preco		= '1'
and	e.ie_tipo_segurado	= 'B'
and	((coalesce(d.nr_lote_contabil_ppcng,0) <> 0)
or (coalesce(d.nr_lote_contabil,0) <> 0))
--and	pls_obter_se_exclui_seg_peona(e.nr_sequencia,a.cd_estabelecimento) = 'N'
group by c.dt_mesano_referencia, d.dt_antecipacao, CASE WHEN f.ie_segmentacao=4 THEN 'OD'  ELSE 'PS' END

union

select	'D' ie_tipo_valor,
	b.ie_tipo_protocolo ie_tipo_protocolo,
	b.dt_mes_competencia dt_referencia,
	sum(coalesce(a.vl_total,0) + coalesce(a.vl_glosa,0)) vl_peona,
	CASE WHEN c.ie_segmentacao=4 THEN 'OD'  ELSE 'PS' END  ie_tipo_plano,
	b.ie_tipo_guia ie_tipo_guia,
	a.nr_seq_segurado nr_seq_segurado,
	a.nr_sequencia nr_seq_conta,
	a.dt_entrada dt_entrada,
	a.dt_atendimento_referencia dt_atendimento_referencia
from	pls_plano		c,
	pls_protocolo_conta	b,
	pls_conta		a
where	a.nr_seq_protocolo	= b.nr_sequencia
and	a.nr_seq_plano		= c.nr_sequencia
and	c.ie_preco		= '1'
and	a.ie_tipo_segurado	<> 'I'
and	b.ie_tipo_protocolo	in ('C','I')
and	pls_obter_se_exclui_seg_peona(a.nr_seq_segurado, b.dt_mes_competencia, a.cd_estabelecimento) = 'N'
group by 'D',b.ie_tipo_protocolo,b.dt_mes_competencia, CASE WHEN c.ie_segmentacao=4 THEN 'OD'  ELSE 'PS' END ,b.ie_tipo_guia,a.nr_seq_segurado,a.nr_sequencia,a.dt_entrada,a.dt_atendimento_referencia

union

select	'D' ie_tipo_valor,
	b.ie_tipo_protocolo ie_tipo_protocolo,
	b.dt_mes_competencia dt_referencia,
	sum(coalesce(a.vl_total,0) + coalesce(a.vl_coparticipacao,0)) vl_peona,
	CASE WHEN c.ie_segmentacao=4 THEN 'OD'  ELSE 'PS' END  ie_tipo_plano,
	b.ie_tipo_guia ie_tipo_guia,
	a.nr_seq_segurado nr_seq_segurado,
	a.nr_sequencia nr_seq_conta,
	a.dt_entrada dt_entrada,
	a.dt_atendimento_referencia dt_atendimento_referencia
from	pls_plano		c,
	pls_protocolo_conta	b,
	pls_conta		a
where	a.nr_seq_protocolo	= b.nr_sequencia
and	a.nr_seq_plano		= c.nr_sequencia
and	c.ie_preco		= '1'
and	a.ie_tipo_segurado	= 'B'
and	b.ie_tipo_protocolo	= 'R'
and	trunc(b.dt_mes_competencia,'month') > to_date('31/12/2009','dd/mm/yyyy')
and	pls_obter_se_exclui_seg_peona(a.nr_seq_segurado, b.dt_mes_competencia, a.cd_estabelecimento) = 'N'
group by 'D',b.ie_tipo_protocolo,b.dt_mes_competencia, CASE WHEN c.ie_segmentacao=4 THEN 'OD'  ELSE 'PS' END ,b.ie_tipo_guia,a.nr_seq_segurado,a.nr_sequencia,a.dt_entrada,a.dt_atendimento_referencia

union

select	'D' ie_tipo_valor,
	b.ie_tipo_protocolo ie_tipo_protocolo,
	b.dt_mes_competencia dt_referencia,
	sum(coalesce(a.vl_total,0)) vl_peona,
	CASE WHEN c.ie_segmentacao=4 THEN 'OD'  ELSE 'PS' END  ie_tipo_plano,
	b.ie_tipo_guia ie_tipo_guia,
	a.nr_seq_segurado nr_seq_segurado,
	a.nr_sequencia nr_seq_conta,
	a.dt_entrada dt_entrada,
	a.dt_atendimento_referencia dt_atendimento_referencia
from	pls_plano		c,
	pls_protocolo_conta	b,
	pls_conta		a
where	a.nr_seq_protocolo	= b.nr_sequencia
and	a.nr_seq_plano		= c.nr_sequencia
and	c.ie_preco		= '1'
and	a.ie_tipo_segurado	= 'B'
and	b.ie_tipo_protocolo	= 'R'
and	trunc(b.dt_mes_competencia,'month') < to_date('01/01/2010','dd/mm/yyyy')
and	pls_obter_se_exclui_seg_peona(a.nr_seq_segurado, b.dt_mes_competencia, a.cd_estabelecimento) = 'N'
group by 'D',b.ie_tipo_protocolo,b.dt_mes_competencia, CASE WHEN c.ie_segmentacao=4 THEN 'OD'  ELSE 'PS' END ,b.ie_tipo_guia,a.nr_seq_segurado,a.nr_sequencia,a.dt_entrada,a.dt_atendimento_referencia

union all

select	'G' ie_tipo_valor,
	b.ie_tipo_protocolo ie_tipo_protocolo,
	b.dt_mes_competencia dt_referencia,
	sum(coalesce(a.vl_glosa,0)) vl_peona,
	CASE WHEN c.ie_segmentacao=4 THEN 'OD'  ELSE 'PS' END  ie_tipo_plano,
	b.ie_tipo_guia ie_tipo_guia,
	a.nr_seq_segurado nr_seq_segurado,
	a.nr_sequencia nr_seq_conta,
	a.dt_entrada dt_entrada,
	a.dt_atendimento_referencia dt_atendimento_referencia
from	pls_plano		c,
	pls_protocolo_conta	b,
	pls_conta		a
where	a.nr_seq_protocolo	= b.nr_sequencia
and	a.nr_seq_plano		= c.nr_sequencia
and	c.ie_preco		= '1'
and	a.ie_tipo_segurado	= 'B'
and	b.ie_tipo_protocolo	= 'R'
and	trunc(b.dt_mes_competencia,'month') < to_date('01/01/2010','dd/mm/yyyy')
and	pls_obter_se_exclui_seg_peona(a.nr_seq_segurado, b.dt_mes_competencia, a.cd_estabelecimento) = 'N'
group by 'D',b.ie_tipo_protocolo,b.dt_mes_competencia, CASE WHEN c.ie_segmentacao=4 THEN 'OD'  ELSE 'PS' END ,b.ie_tipo_guia,a.nr_seq_segurado,a.nr_sequencia,a.dt_entrada,a.dt_atendimento_referencia

union all

select	'C' ie_tipo_valor,
	null ie_tipo_protocolo,
	c.dt_mesano_referencia dt_referencia,
	sum(coalesce(c.vl_coparticipacao,0)) vl_peona,
	CASE WHEN f.ie_segmentacao=4 THEN 'OD'  ELSE 'PS' END  ie_tipo_plano,
	null ie_tipo_guia,
	c.nr_seq_segurado nr_seq_segurado,
	null nr_seq_conta,
	null dt_entrada,
	null dt_atendimento_referencia
from	pls_mensalidade_seg_item 	d,
	pls_mensalidade_segurado	c,
	pls_segurado			e,
	pls_plano 			f,
	pls_mensalidade			b,
	pls_lote_mensalidade		a
where	c.nr_sequencia		= d.nr_seq_mensalidade_seg
and	c.nr_seq_segurado	= e.nr_sequencia
and	e.nr_seq_plano		= f.nr_sequencia
and	b.nr_sequencia		= c.nr_seq_mensalidade
and	a.nr_sequencia		= b.nr_seq_lote
and	d.ie_tipo_item in ('1','4','5','12')
and	f.ie_preco		= '1'
and	e.ie_tipo_segurado	= 'B'
and	a.dt_contabilizacao is not null /*Colocada a restrição is not null para que apenas as mensalidades já contabilizadas sejam consideradas no PEONA. Solicitação realizada na OS 825710 e identificada como padrão mais adequado*/
--and	pls_obter_se_exclui_seg_peona(e.nr_sequencia,a.cd_estabelecimento) = 'N'
group by 'C',c.dt_mesano_referencia, d.dt_antecipacao, CASE WHEN f.ie_segmentacao=4 THEN 'OD'  ELSE 'PS' END ,c.nr_seq_segurado

union all

select 	'R' ie_tipo_valor,
	null ie_tipo_protocolo,
	t.dt_emissao dt_referencia,
	sum(t.vl_titulo) * (-1) vl_peona,
	'PS' ie_tipo_plano,
	null ie_tipo_guia,
	null ie_tipo_protocolo,
	null nr_seq_conta,
	null dt_entrada,
	null dt_atendimento_referencia
from	titulo_pagar t
where	t.ie_origem_titulo = '23'
group by 'R',
	t.dt_emissao,
	'PS'
order by 2 desc;
