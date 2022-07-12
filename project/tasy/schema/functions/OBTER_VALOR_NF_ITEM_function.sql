-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_nf_item (nr_sequencia_p bigint, nr_item_nf_p bigint, ie_tributo_p text, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


/*
VI - Valor total do item da nota_fiscal_item
TX - Taxa do tributo do item (aliquota)
BC - Valor da base de cálculo do tributo do item
VT - Valor do tributo do item
*/
vl_retorno_w		double precision;


BEGIN
if (ie_opcao_p = 'VI')	then
	select	vl_total_item_nf
	into STRICT	vl_retorno_w
	from 	nota_fiscal_item
	where	nr_sequencia	= nr_sequencia_p
	and	nr_item_nf	= nr_item_nf_p;

elsif (ie_opcao_p = 'TX')	then
	select	t.tx_tributo
	into STRICT	vl_retorno_w
	from	nota_fiscal a,
		nota_fiscal_item_trib t,
		tributo b
	where	a.nr_sequencia	= t.nr_sequencia
	and	t.cd_tributo 	= b.cd_tributo
	and	a.nr_sequencia	= nr_sequencia_p
	and	t.nr_item_nf	= nr_item_nf_p
	and	b.ie_tipo_tributo	= ie_tributo_p;

elsif (ie_opcao_p = 'BC')	then
	select	coalesce(a.vl_base_calculo,0)
	into STRICT	vl_retorno_w
	from	nota_fiscal_item_trib a,
		tributo b
	where	a.cd_tributo	= b.cd_tributo
	and	a.nr_sequencia	= nr_sequencia_p
	and	a.nr_item_nf	= nr_item_nf_p
	and	b.ie_tipo_tributo	= ie_tributo_p;

elsif (ie_opcao_p = 'VT')	then
	select	coalesce(a.vl_tributo,0)
	into STRICT	vl_retorno_w
	from	nota_fiscal_item_trib a,
		tributo b
	where	a.cd_tributo	= b.cd_tributo
	and	a.nr_sequencia	= nr_sequencia_p
	and	a.nr_item_nf	= nr_item_nf_p
	and	b.ie_tipo_tributo	= ie_tributo_p;

end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_nf_item (nr_sequencia_p bigint, nr_item_nf_p bigint, ie_tributo_p text, ie_opcao_p text) FROM PUBLIC;
