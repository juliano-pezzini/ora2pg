-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Obter valor total de liquido de um item de uma Ordem de Compra <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--	
	/*
	Objetivo: Retornar o valor total de tributos da nota fiscal vinculados ao projeto.
	Parametros: 
	nr_ordem_compra_p = Numero de sequencia da ordem de compra
	nr_item_oci_p = Numero do item da ordem de compra(1,2,3,4,5,6,7...)
	ie_soma_trib_p = Flag para saber se o valor de retorno sera somado os tributos ou nao. Exemplo = valor item 10R$ , tributo +2R$ ;  Se flag = S  entao retorno = 12R$ senao retorno = 10R$.
	*/
CREATE OR REPLACE FUNCTION gerenciamento_contrato_pck.obter_vl_liq_oci ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, ie_soma_trib_p text) RETURNS bigint AS $body$
DECLARE

			
	vl_item_w			ordem_compra_item.vl_item_liquido%type;
	vl_item_ww			ordem_compra_item.vl_item_liquido%type;
	vl_desconto_w			ordem_compra_item.pr_descontos%type;
	vl_desconto_ww			ordem_compra_item.pr_descontos%type;
	pr_tributo_w			double precision;
	pr_descontos_w			ordem_compra_item.pr_descontos%type;
	vl_unitario_material_w		ordem_compra_item.vl_unitario_material%type;
	qt_material_w			ordem_compra_item.qt_material%type;
	
	vl_retorno_w			double precision;
	vl_retorno_div_w		double precision;
	
	
BEGIN
	
	vl_item_ww := 0;
	vl_desconto_w := 0;
	
	select	sum(e.qt_prevista_entrega) * max(i.vl_unitario_material),
		max(coalesce(i.pr_descontos,0)),
		max(coalesce(i.vl_desconto,0)),
		max(i.vl_unitario_material),
		sum(e.qt_prevista_entrega)
	into STRICT	vl_item_w,
		pr_descontos_w,
		vl_desconto_w,
		vl_unitario_material_w,
		qt_material_w
	from	ordem_compra_item i,
			ordem_compra_item_entrega e
	where	i.nr_ordem_compra = e.nr_ordem_compra
	and	i.nr_item_oci = e.nr_item_oci
	and	coalesce(e.dt_cancelamento::text, '') = ''
	and	i.nr_ordem_compra = nr_ordem_compra_p
	and	i.nr_item_oci	= nr_item_oci_p;

	pr_tributo_w := 0;

	if (ie_soma_trib_p = 'S') then
		select	coalesce(sum(CASE WHEN b.ie_soma_diminui='S' THEN  pr_tributo WHEN b.ie_soma_diminui='D' THEN pr_tributo * -1  ELSE 0 END ),0)
		into STRICT	pr_tributo_w
		from	tributo b,
			ordem_compra_item_trib a
		where	a.cd_tributo		= b.cd_tributo
		and 	a.nr_ordem_compra	= nr_ordem_compra_p
		and 	a.nr_item_oci		= nr_item_oci_p;
	end if;
	
	if (vl_desconto_w > 0) then
		vl_desconto_ww 		:= vl_desconto_w;
	elsif (pr_descontos_w > 0) then
		vl_desconto_ww		:= coalesce((((vl_unitario_material_w * qt_material_w) * pr_descontos_w) / 100),0);
	end if;

	vl_retorno_div_w	:= round((dividir(coalesce(vl_item_w,0), 100) * pr_tributo_w)::numeric, 2);
	vl_retorno_w	 	:= vl_item_w + round((vl_retorno_div_w)::numeric,4) - coalesce(vl_desconto_ww,0);
	
	return vl_retorno_w;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION gerenciamento_contrato_pck.obter_vl_liq_oci ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, ie_soma_trib_p text) FROM PUBLIC;
