-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nfe_obter_valor_trib_item ( nr_sequencia_p bigint, nr_item_nf_p bigint, ie_tipo_tributo_p text, ie_tipo_valor_p text) RETURNS bigint AS $body$
DECLARE


/*
ie_tipo_valor_p
TRIB - valor do tributo
BC - base de calculo do tributo
TX - taxa do tributo
RICMS - Reduçâo da base de calculo de ICMS
*/
ie_tipo_tributo_w	varchar(15);
vl_retorno_w		double precision;
vl_tributo_w		double precision;
vl_taxa_w		double precision;
vl_base_calc_w		double precision;
vl_reducao_base_w	double precision;


BEGIN

ie_tipo_tributo_w := coalesce(ie_tipo_tributo_p,'X');

select	coalesce(sum(n.vl_tributo),0),
	coalesce(sum(n.vl_base_calculo),0),
	coalesce(sum(n.tx_tributo),0),
	coalesce(sum(n.vl_reducao_base),0)
into STRICT    vl_tributo_w,
	vl_base_calc_w,
	vl_taxa_w,
	vl_reducao_base_w
from   	tributo t,
        nota_fiscal_item_trib n
where	t.cd_tributo		= n.cd_tributo
and	((ie_tipo_tributo_w 	= 'X')
or (t.ie_tipo_tributo 	= ie_tipo_tributo_w))
and     n.nr_sequencia          = nr_sequencia_p
and     n.nr_item_nf            = nr_item_nf_p;

if (ie_tipo_valor_p = 'TRIB') then
	vl_retorno_w	:= vl_tributo_w;
elsif (ie_tipo_valor_p = 'BC') then
	vl_retorno_w	:= vl_base_calc_w;
elsif (ie_tipo_valor_p = 'TX') then
	vl_retorno_w	:= vl_taxa_w;
elsif (ie_tipo_valor_p = 'RICMS') then
	vl_retorno_w	:= vl_reducao_base_w;
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nfe_obter_valor_trib_item ( nr_sequencia_p bigint, nr_item_nf_p bigint, ie_tipo_tributo_p text, ie_tipo_valor_p text) FROM PUBLIC;
