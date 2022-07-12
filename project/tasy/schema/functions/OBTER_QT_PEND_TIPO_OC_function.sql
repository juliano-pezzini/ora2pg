-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_pend_tipo_oc ( cd_estabelecimento_p bigint, cd_material_p bigint, ie_tipo_ordem_p text) RETURNS bigint AS $body$
DECLARE

 
qt_ordem_compra_w		double precision := 0;
qt_dia_w				integer := 180;
cd_unid_med_compra_w		varchar(30);
cd_unid_med_movto_w		varchar(30);
qt_conversao_w			double precision := 0;
ie_data_base_compra_pend_w	varchar(80);


BEGIN 
select	coalesce(max(qt_dia_compra_pend), 180), 
	coalesce(max(ie_data_base_compra_pend), 'DT_ATUALIZACAO') 
into STRICT	qt_dia_w, 
	ie_data_base_compra_pend_W 
from	parametro_compras 
where	cd_estabelecimento = cd_estabelecimento_p;
 
select	substr(obter_dados_material_estab(cd_material,cd_estabelecimento_p,'UMC'),1,255) cd_unidade_medida_compra, 
	qt_conv_compra_estoque 
into STRICT	cd_unid_med_compra_w, 
	qt_conversao_w 
from	material 
where	cd_material = cd_material_p;
 
/* Obter Ordens de compra pendentes */
 
select	/*+ index(a Orcoite_materia_fk_i) */ 
	coalesce(sum(a.qt_material - 
	coalesce(a.qt_material_entregue,0) - 
	coalesce(obter_qt_entr_cancel_ordem(a.nr_ordem_compra, a.nr_item_oci),0)),0), 
	max(cd_unidade_medida_compra) 
into STRICT 	qt_ordem_compra_w, 
	cd_unid_med_movto_w 
from 	ordem_compra b, 
	ordem_compra_item a 
where 	a.nr_ordem_compra = b.nr_ordem_compra 
and	a.qt_material > coalesce(a.qt_material_entregue,0) 
and	b.ie_tipo_ordem = ie_tipo_ordem_p 
and	CASE WHEN ie_data_base_compra_pend_W='DT_ATUALIZACAO' THEN  a.dt_atualizacao WHEN ie_data_base_compra_pend_W='DT_ORDEM_COMPRA' THEN  b.dt_ordem_compra WHEN ie_data_base_compra_pend_W='DT_ENTREGA' THEN  b.dt_entrega END  > clock_timestamp() - qt_dia_w 
and	a.cd_material 	in (	SELECT cd_material 
				from material 
				where cd_material_estoque = cd_material_p) 
and	exists (select	1 
		from	ordem_compra b 
		where	a.nr_ordem_compra = b.nr_ordem_compra 
	 	and	coalesce(b.dt_baixa::text, '') = '' 
		and	b.cd_estabelecimento = cd_estabelecimento_p);
		 
if (cd_unid_med_movto_w = cd_unid_med_compra_w) then 
	qt_ordem_compra_w := qt_ordem_compra_w * qt_conversao_w;
end if;
 
return qt_ordem_compra_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_pend_tipo_oc ( cd_estabelecimento_p bigint, cd_material_p bigint, ie_tipo_ordem_p text) FROM PUBLIC;

