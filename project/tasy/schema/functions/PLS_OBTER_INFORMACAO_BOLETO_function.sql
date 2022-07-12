-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_informacao_boleto ( nr_titulo_p bigint, ie_linha_p bigint) RETURNS varchar AS $body$
DECLARE


nr_linha_w		bigint := 1;
nr_sequencia_w		bigint := null;
ds_retorno_w		varchar(255);
ds_item_w		varchar(255);

c01 CURSOR FOR
SELECT	d.nr_sequencia,
	rpad(substr(g.cd_usuario_plano,1,13),13,' ') ||
	rpad(upper(substr(h.nm_pessoa_fisica,1,25)),33,' ') ||
	rpad(e.nr_protocolo_ans,10,' ') ||
	rpad(upper(CASE WHEN d.ie_tipo_item='1' THEN substr(e.ds_plano,1,20) WHEN d.ie_tipo_item='15' THEN substr(pls_obter_dados_vinc_bonific('',d.nr_seq_vinculo_sca,'N'),1,20)  ELSE substr(obter_valor_dominio(1930,d.ie_tipo_item),1,20) END ),21,' ') ||
	rpad(c.dt_contratacao,12,' ') ||
	rpad(campo_mascara_virgula(d.vl_item),15,' ')
from	pls_mensalidade		a,
	pls_mensalidade_segurado	b,
	pls_segurado			c,
	pls_mensalidade_seg_item	d,
	pls_plano			e,
	titulo_receber			f,
	pls_segurado_carteira		g,
	pessoa_fisica			h,
	pls_contrato_pagador		i
where	b.nr_seq_mensalidade	= a.nr_sequencia
and	c.nr_sequencia		= b.nr_seq_segurado
and	b.nr_sequencia		= d.nr_seq_mensalidade_seg
and	f.nr_seq_mensalidade	= a.nr_sequencia
and	g.nr_seq_segurado	= c.nr_sequencia
and	a.nr_seq_pagador	= i.nr_sequencia
and	coalesce(i.cd_cgc::text, '') = ''
and	f.nr_titulo		= nr_titulo_p
and	c.cd_pessoa_fisica	= h.cd_pessoa_fisica
and	c.nr_seq_plano		= e.nr_sequencia
--and	d.ie_tipo_item		in ('1','15','4')
order by	d.nr_sequencia;


BEGIN

if (ie_linha_p > 0) then

	open	c01;
	loop
	fetch	c01 into
		nr_sequencia_w,
		ds_item_w;
	exit	when(c01%notfound or (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> ''));

		if (nr_linha_w	= ie_linha_p) then
			ds_retorno_w	:= ds_item_w;
		end if;

		nr_linha_w	:= nr_linha_w + 1;

	end	loop;
	close	c01;

elsif (ie_linha_p = 0) then
	ds_retorno_w := '';

	select	'Total: ' || campo_mascara_virgula(sum(vl_total)) ||
		' Desc: ' || campo_mascara_virgula(sum(vl_descontos)) ||
		' Acresc: ' || campo_mascara_virgula(sum(vl_acrescimo)) ||
		' CO-PART: ' || campo_mascara_virgula(sum(vl_coparticipacao)) ||
		' Bol: ' || campo_mascara_virgula(sum(vl_boleto)) ||
		' PARC: ' || dt_referencia
	into STRICT	ds_retorno_w
	from	(SELECT	sum(d.vl_item) vl_total,
			0 vl_descontos,
			0 vl_coparticipacao,
			0 vl_acrescimo,
			0 vl_boleto,
			'PARC ' || to_char(a.dt_referencia, 'MM/YYYY') dt_referencia
		from	pls_mensalidade			a,
			pls_mensalidade_segurado	b,
			pls_segurado			c,
			pls_mensalidade_seg_item	d,
			pls_plano			e,
			titulo_receber			f
		where	b.nr_seq_mensalidade	= a.nr_sequencia
		and	c.nr_sequencia		= b.nr_seq_segurado
		and	b.nr_sequencia		= d.nr_seq_mensalidade_seg
		and	f.nr_titulo = nr_titulo_p
		and	c.nr_seq_plano = e.nr_sequencia
		and	f.nr_seq_mensalidade = a.nr_sequencia
		--and	d.ie_tipo_item	in ('1','15')
		and	e.ie_tipo_contratacao	= 'I'
		group by a.dt_referencia
		
union

		SELECT	0 vl_total,
			sum(vl_item) vl_descontos,
			0 vl_coparticipacao,
			0 vl_acrescimo,
			0 vl_boleto,
			'PARC ' || to_char(a.dt_referencia, 'MM/YYYY') dt_referencia
		from	pls_mensalidade			a,
			pls_mensalidade_segurado	b,
			pls_segurado			c,
			pls_mensalidade_seg_item	d,
			pls_plano			e,
			titulo_receber			f
		where	b.nr_seq_mensalidade	= a.nr_sequencia
		and	c.nr_sequencia		= b.nr_seq_segurado
		and	b.nr_sequencia		= d.nr_seq_mensalidade_seg
		and	f.nr_titulo = nr_titulo_p
		and	c.nr_seq_plano = e.nr_sequencia
		and	f.nr_seq_mensalidade = a.nr_sequencia
		--and	d.ie_tipo_item	= '14'
		and	e.ie_tipo_contratacao	= 'I'
		group by a.dt_referencia
		
union

		select	0 vl_total,
			0 vl_descontos,
			0 vl_coparticipacao,
			sum(vl_item) vl_acrescimo,
			0 vl_boleto,
			'PARC ' || to_char(a.dt_referencia, 'MM/YYYY') dt_referencia
		from	pls_mensalidade			a,
			pls_mensalidade_segurado	b,
			pls_segurado			c,
			pls_mensalidade_seg_item	d,
			pls_plano			e,
			titulo_receber			f
		where	b.nr_seq_mensalidade	= a.nr_sequencia
		and	c.nr_sequencia		= b.nr_seq_segurado
		and	b.nr_sequencia		= d.nr_seq_mensalidade_seg
		and	f.nr_titulo = nr_titulo_p
		and	c.nr_seq_plano = e.nr_sequencia
		and	f.nr_seq_mensalidade = a.nr_sequencia
		and	d.ie_tipo_item not in ('1','3','12','14','15','17','22')
		and	e.ie_tipo_contratacao	= 'I'
		group by a.dt_referencia
		
union all

		select	0 vl_total,
			0 vl_descontos,
			0 vl_coparticipacao,
			sum(vl_item) vl_acrescimo,
			0 vl_boleto,
			'PARC ' || to_char(a.dt_referencia, 'MM/YYYY') dt_referencia
		from	pls_mensalidade			a,
			pls_mensalidade_seg_item	c,
			titulo_receber			e
		where	c.nr_seq_mensalidade	= a.nr_sequencia
		and	e.nr_titulo = nr_titulo_p
		and	e.nr_seq_mensalidade = a.nr_sequencia
		--and	c.ie_tipo_item	= '17'
		group by a.dt_referencia
		
union

		select	0 vl_total,
			0 vl_descontos,
			0 vl_coparticipacao,
			0 vl_acrescimo,
			f.vl_titulo vl_boleto,
			'PARC ' || to_char(a.dt_referencia, 'MM/YYYY') dt_referencia
		from	pls_mensalidade			a,
			pls_mensalidade_segurado	b,
			pls_segurado			c,
			pls_mensalidade_seg_item	d,
			pls_plano			e,
			titulo_receber			f
		where	b.nr_seq_mensalidade	= a.nr_sequencia
		and	c.nr_sequencia		= b.nr_seq_segurado
			and	((b.nr_sequencia		= d.nr_seq_mensalidade_seg)
		or (a.nr_sequencia		= d.nr_sequencia))
		and	f.nr_titulo = nr_titulo_p
		and	c.nr_seq_plano = e.nr_sequencia
		and	f.nr_seq_mensalidade = a.nr_sequencia
		and	e.ie_tipo_contratacao	= 'I'
		group by a.dt_referencia,f.vl_titulo) alias23
	group by	dt_referencia;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_informacao_boleto ( nr_titulo_p bigint, ie_linha_p bigint) FROM PUBLIC;

