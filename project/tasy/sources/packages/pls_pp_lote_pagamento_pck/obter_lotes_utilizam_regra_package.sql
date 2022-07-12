-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_pp_lote_pagamento_pck.obter_lotes_utilizam_regra ( ie_tipo_regra_p text, nr_seq_regra_p bigint) RETURNS varchar AS $body$
DECLARE

/*
ie_tipo_regra_p
	LP = Lancamento programado
	TP = Titulo a pagar
	TR = Titulo a receber
	AP = Adiantamento pago
	VB = Valor base tributos
*/


ds_retorno_w	varchar(4000);

c01 CURSOR(	nr_seq_regra_pc		pls_pp_item_lote.nr_seq_lanc_prog%type) FOR
	SELECT	distinct b.nr_seq_lote
	from	pls_pp_item_lote b,
		pls_pp_prest_evento_valor c,
		pls_pp_prest_event_prest d,
		pls_pp_prestador e
	where	b.nr_seq_lanc_prog = nr_seq_regra_pc
	and	c.nr_seq_lote = b.nr_seq_lote
	and	c.nr_seq_prestador = b.nr_seq_prestador
	and	d.nr_seq_pp_prest_even_val = c.nr_sequencia
	and	e.nr_sequencia = d.nr_seq_pp_prest
	and	e.ie_cancelado = 'N'
	order by b.nr_seq_lote;
	
c02 CURSOR(	nr_seq_regra_pc		pls_pp_item_lote.nr_seq_regra_tit_pag%type) FOR
	SELECT	distinct b.nr_seq_lote
	from 	pls_pp_item_lote b,
		pls_pp_prest_evento_valor c,
		pls_pp_prest_event_prest d,
		pls_pp_prestador e
	where 	b.nr_seq_regra_tit_pag = nr_seq_regra_pc
	and	c.nr_seq_lote = b.nr_seq_lote
	and	c.nr_seq_prestador = b.nr_seq_prestador
	and	d.nr_seq_pp_prest_even_val = c.nr_sequencia
	and	e.nr_sequencia = d.nr_seq_pp_prest
	and	e.ie_cancelado = 'N'
	order by b.nr_seq_lote;
	
c03 CURSOR( 	nr_seq_regra_pc		pls_pp_item_lote.nr_seq_regra_tit_rec%type) FOR
	SELECT	distinct b.nr_seq_lote
	from	pls_pp_item_lote b,
		pls_pp_prest_evento_valor c,
		pls_pp_prest_event_prest d,
		pls_pp_prestador e
	where 	b.nr_seq_regra_tit_rec = nr_seq_regra_pc
	and	c.nr_seq_lote = b.nr_seq_lote
	and	c.nr_seq_prestador = b.nr_seq_prestador
	and	d.nr_seq_pp_prest_even_val = c.nr_sequencia
	and	e.nr_sequencia = d.nr_seq_pp_prest
	and	e.ie_cancelado = 'N'
	order by b.nr_seq_lote;
	
c04 CURSOR(	nr_seq_regra_pc		pls_pp_item_lote.nr_seq_regra_adiant%type) FOR
	SELECT	distinct b.nr_seq_lote
	from	pls_pp_item_lote b,
		pls_pp_prest_evento_valor c,
		pls_pp_prest_event_prest d,
		pls_pp_prestador e
	where	b.nr_seq_regra_adiant = nr_seq_regra_pc
	and	c.nr_seq_lote = b.nr_seq_lote
	and	c.nr_seq_prestador = b.nr_seq_prestador
	and	d.nr_seq_pp_prest_even_val = c.nr_sequencia
	and	e.nr_sequencia = d.nr_seq_pp_prest
	and	e.ie_cancelado = 'N'
	order by b.nr_seq_lote;
	
-- Atencao, foi colocado um hint de index n C05 devido a performance. Em alguns ambientes o otimizador

-- Seleciona a UK  do lote e sequencial (!!!) pora selecionar os dados, e causa um index full scan muito caro para a performance

-- Se mudar os alias da query, atentar para sincronizar o novo alias, lembrando que hint de index nao causa erro de sintax, ele so nao

-- e seguido, portanto so sera notado o seu efeito na execucao

c05 CURSOR(	nr_seq_regra_pc		pls_pp_regra_vl_base_trib.nr_sequencia%type) FOR
	SELECT	/*+ NO_INDEX(c PPILOTE_UK) */ distinct c.nr_seq_lote
	from	pls_pp_regra_vl_base_trib a,
		pls_pp_base_atual_trib b,
		pls_pp_item_lote c
	where	a.nr_sequencia = nr_seq_regra_pc
	and	b.cd_tributo = a.cd_tributo
	and	b.nr_seq_evento = a.nr_seq_evento
	and	b.nr_seq_regra_trib = a.nr_sequencia
	and	c.nr_sequencia = b.nr_seq_item_lote
	order by c.nr_seq_lote;

BEGIN

ds_retorno_w := null;

-- LP = Lancamento programado

if (ie_tipo_regra_p = 'LP') then
	for r_c01_w in c01(nr_seq_regra_p) loop
		ds_retorno_w := pls_util_pck.concatena_string(ds_retorno_w, r_c01_w.nr_seq_lote);
	end loop;
	
-- TP = Titulo a pagar

elsif (ie_tipo_regra_p = 'TP') then
	for r_c02_w in c02(nr_seq_regra_p) loop
		ds_retorno_w := pls_util_pck.concatena_string(ds_retorno_w, r_c02_w.nr_seq_lote);
	end loop;
	
-- TR = Titulo a receber

elsif (ie_tipo_regra_p = 'TR') then
	for r_c03_w in c03(nr_seq_regra_p) loop
		ds_retorno_w := pls_util_pck.concatena_string(ds_retorno_w, r_c03_w.nr_seq_lote);
	end loop;
	
-- AP = Adiantamento pago

elsif (ie_tipo_regra_p = 'AP') then
	for r_c04_w in c04(nr_seq_regra_p) loop
		ds_retorno_w := pls_util_pck.concatena_string(ds_retorno_w, r_c04_w.nr_seq_lote);
	end loop;

-- VB = Valor base tributo

elsif (ie_tipo_regra_p = 'VB') then
	for r_c05_w in c05(nr_seq_regra_p) loop
		ds_retorno_w := pls_util_pck.concatena_string(ds_retorno_w, r_c05_w.nr_seq_lote);
	end loop;
end if;

return ds_retorno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_pp_lote_pagamento_pck.obter_lotes_utilizam_regra ( ie_tipo_regra_p text, nr_seq_regra_p bigint) FROM PUBLIC;