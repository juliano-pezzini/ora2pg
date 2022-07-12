-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_vl_rateio_item ( nr_sequencia_p bigint, nr_item_nf_p bigint) RETURNS bigint AS $body$
DECLARE


vl_despesa_acessoria_w			double precision := 0;
vl_total_item_nf_w			double precision;
vl_soma_itens_w				double precision;
vl_rateio_item				double precision;


BEGIN

select	sum(vl_total_item_nf)
into STRICT	vl_soma_itens_w
from	nota_fiscal_item
where	nr_sequencia = nr_sequencia_p;

select	b.vl_total_item_nf,
	coalesce(a.vl_despesa_acessoria,0)
into STRICT	vl_total_item_nf_w,
	vl_despesa_acessoria_w
from	nota_fiscal_item b,
	nota_fiscal a
where 	a.nr_sequencia	= b.nr_sequencia
and   	b.nr_item_nf	= nr_item_nf_p
and	a.nr_sequencia	= nr_sequencia_p;


select 	((dividir(vl_despesa_acessoria_w,100)) * (dividir((vl_total_item_nf_w * 100),vl_soma_itens_w))) + vl_total_item_nf_w
into STRICT 	vl_rateio_item
;

return vl_rateio_item;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_vl_rateio_item ( nr_sequencia_p bigint, nr_item_nf_p bigint) FROM PUBLIC;

