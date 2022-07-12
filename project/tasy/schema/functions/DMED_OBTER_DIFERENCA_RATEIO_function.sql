-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION dmed_obter_diferenca_rateio ( vl_mensalidade_p bigint, nr_titulo_p bigint, dt_referencia_p timestamp, nr_seq_mensalidade_p bigint) RETURNS bigint AS $body$
DECLARE

				 
vl_diferenca_rateio_w		double precision;
vl_total_rec_w			double precision;
vl_total_itens_rec_w		double precision;
vl_recebido_w			double precision;
dt_ref_inicial_w		timestamp;
dt_ref_final_w			timestamp;


BEGIN 
dt_ref_inicial_w	:= trunc(dt_referencia_p, 'mm');
dt_ref_final_w		:= fim_dia(fim_mes(dt_referencia_p));
 
select	sum(l.vl_recebido) 
into STRICT	vl_total_rec_w	 
FROM titulo_receber r
LEFT OUTER JOIN titulo_receber_liq l ON (r.nr_titulo = l.nr_titulo)
WHERE r.nr_titulo	= nr_titulo_p  and l.dt_recebimento between dt_ref_inicial_w and dt_ref_final_w and exists (SELECT	1 
		from	dmed_regra_tipo_tit	w 
		where	w.ie_tipo_receber		= l.cd_tipo_recebimento 
		and	coalesce(w.ie_prestadora_ops,'P')	= 'O') and exists (select	1 
		from	dmed_regra_origem_tit	w 
		where	w.ie_origem_titulo	= r.ie_origem_titulo);
		 
vl_recebido_w	:= (vl_total_rec_w / vl_mensalidade_p);
 
select	sum(round((vl_recebido_w * d.vl_item)::numeric, 2)) 
into STRICT	vl_total_itens_rec_w	 
from	pls_mensalidade_seg_item	d, 
	pls_mensalidade_segurado	e 
where	e.nr_sequencia		= d.nr_seq_mensalidade_seg 
and	e.nr_seq_mensalidade	= nr_seq_mensalidade_p 
and	((exists (SELECT d.nr_seq_tipo_lanc 
			from	dmed_regra_tipo_lanc	z, 
				dmed_regra_tipo_item	t 
			where	t.nr_sequencia		= z.nr_seq_dmed_item 
			and 	d.ie_tipo_item		= t.ie_tipo_item 
			and	z.nr_tipo_lanc_adic	= d.nr_seq_tipo_lanc)) 
or	((select	count(1) 
	from	dmed_regra_tipo_lanc	z, 
		dmed_regra_tipo_item	t 
	where 	t.nr_sequencia		= z.nr_seq_dmed_item 
	and 	d.ie_tipo_item		= t.ie_tipo_item 
	and	z.nr_tipo_lanc_adic	= d.nr_seq_tipo_lanc  LIMIT 1) = 0));
 
 
vl_diferenca_rateio_w	:= vl_total_rec_w - vl_total_itens_rec_w;
 
return	vl_diferenca_rateio_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION dmed_obter_diferenca_rateio ( vl_mensalidade_p bigint, nr_titulo_p bigint, dt_referencia_p timestamp, nr_seq_mensalidade_p bigint) FROM PUBLIC;

