-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qtde_a_comprar_generico ( cd_material_p bigint, qt_estoque_p bigint, qt_max_estoque_p bigint, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE



/*
Retorna a quantidade a comprar no ressuprimento
Utilizada somente quando o ressuprimento é agrupado pelo genérico*/
qt_conversao_w		double precision;
qt_ordem_w		double precision;
qt_solic_w		double precision;
qt_Cotacao_w		double precision;
qt_compra_w		double precision;
qt_pend_req_consumo_w	double precision;
ie_cons_solic_ressup_w	varchar(1);
ie_cons_cot_ressup_w	varchar(1);


BEGIN

select	coalesce(sum(qt_ordem_compra),0),
	coalesce(sum(qt_solic_compra),0),
	coalesce(sum(qt_cotacao_compra),0),
	coalesce(sum(qt_pend_req_consumo),0)
into STRICT	qt_ordem_w,
	qt_solic_w,
	qt_cotacao_w,
	qt_pend_req_consumo_w
from	material_ressuprimento
where	cd_material_generico	= cd_material_p
and	cd_estabelecimento		= cd_estabelecimento_p;

select	coalesce(qt_conv_compra_estoque,1)
into STRICT	qt_conversao_w
from	material
where	cd_material = cd_material_p;

select 	coalesce(ie_cons_solic_ressup,'S'),
	coalesce(ie_cons_cot_ressup,'S')
into STRICT	ie_cons_solic_ressup_w,
	ie_cons_cot_ressup_w
from 	parametro_compras
where 	cd_estabelecimento = cd_estabelecimento_p;

if (ie_cons_solic_ressup_w in ('N','M')) then
	qt_solic_w := 0;
end if;

if (ie_cons_cot_ressup_w in ('N','M')) then
	qt_cotacao_w := 0;
end if;

qt_compra_w	:= qt_max_estoque_p - (qt_estoque_p + qt_pend_req_consumo_w) -
		(qt_ordem_w + qt_solic_w + qt_cotacao_w);
		
if (qt_compra_w	<= 0) then
	qt_compra_w	:= 0;
elsif (qt_compra_w	< qt_conversao_w) then
	qt_compra_w	:= 1;
else
	qt_compra_w	:= round((qt_compra_w / qt_conversao_w)::numeric,0);
end if;
return qt_compra_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qtde_a_comprar_generico ( cd_material_p bigint, qt_estoque_p bigint, qt_max_estoque_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
