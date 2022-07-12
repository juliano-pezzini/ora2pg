-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valores_diot (nr_sequencia_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE



vl_retorno_w		double precision;


BEGIN

if (ie_opcao_p = '1') then

	select  b.vl_liquido
	into STRICT    vl_retorno_w
	from 	nota_fiscal a,
		nota_fiscal_item b,
		nota_fiscal_item_trib c,
		tributo d
	where   a.nr_sequencia = b.nr_sequencia
	and     a.nr_sequencia = nr_sequencia_p
	and     c.cd_tributo = d.cd_tributo
	and     b.nr_item_nf = c.nr_item_nf
	and     c.nr_sequencia = a.nr_sequencia
	and     d.ie_tipo_tributo  =  'IVA'
	and     c.vl_tributo = 0;

elsif (ie_opcao_p = '2') then

select  sum(vl_liquido)
into STRICT    vl_retorno_w
from (SELECT b.vl_liquido vl_liquido
	from    nota_fiscal a,
	        nota_fiscal_item b,
	        nota_fiscal_item_trib c,
	        tributo d
	where   a.nr_sequencia = b.nr_sequencia
	and     a.nr_sequencia = nr_sequencia_p
	and     c.cd_tributo = d.cd_tributo
	and     b.nr_item_nf = c.nr_item_nf
	and     c.nr_sequencia = a.nr_sequencia
	and     d.ie_tipo_tributo  <>  'IVA'
	
union

                 SELECT  b.vl_liquido vl_liquido
	from 	nota_fiscal a,
		nota_fiscal_item b
	where   a.nr_sequencia = b.nr_sequencia
	and     a.nr_sequencia = nr_sequencia_p
	and     coalesce(obter_se_trib_item(a.nr_sequencia, b.nr_item_nf),'N') = 'N') alias4;


end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valores_diot (nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;

