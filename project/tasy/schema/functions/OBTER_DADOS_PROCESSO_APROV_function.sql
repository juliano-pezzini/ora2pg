-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_processo_aprov ( nr_seq_aprovacao_p bigint, ie_opcao_p bigint) RETURNS bigint AS $body$
DECLARE


ie_tipo_w				smallint;
vl_total_w			double precision;
vl_tot_qt_ult_compra_w		double precision;


BEGIN

/*
ie_tipo_w
0 - Ordens
1 - Solicitacao
2 - Requisicao
*/
select	distinct coalesce(max(ie_tipo),0)
into STRICT	ie_tipo_w
from (
	SELECT	0 ie_tipo
	from	ordem_compra_item
	where	nr_seq_aprovacao = nr_seq_aprovacao_p
	
union all

	SELECT	1 ie_tipo
	from	solic_compra_item
	where	nr_seq_aprovacao = nr_seq_aprovacao_p
	
union all

	select	2 ie_tipo
	from	item_requisicao_material
	where	nr_seq_aprovacao = nr_seq_aprovacao_p) alias2;

if (ie_tipo_w = 0) then
	select	coalesce(sum(b.qt_material * b.vl_unitario_material),0) vl_total,
		coalesce(sum((obter_dados_ult_compra_data(a.cd_estabelecimento,b.cd_material,null,clock_timestamp(),0,'VU'))::numeric  * b.qt_material),0) vl_tot_qt_ult_compra
	into STRICT	vl_total_w,
		vl_tot_qt_ult_compra_w
	from	ordem_compra a,
		ordem_compra_item b
	where	a.nr_ordem_compra = b.nr_ordem_compra
	and	coalesce(b.dt_aprovacao::text, '') = ''
	and	coalesce(b.dt_reprovacao::text, '') = ''
	and	nr_seq_aprovacao = nr_seq_aprovacao_p;
elsif (ie_tipo_w = 1) then
	select	coalesce(sum(b.qt_material * coalesce(b.vl_unit_previsto,0)),0)vl_total,
		coalesce(sum((obter_dados_ult_compra_data(a.cd_estabelecimento,b.cd_material,null,clock_timestamp(),0,'VU'))::numeric  * b.qt_material),0) vl_tot_qt_ult_compra
	into STRICT	vl_total_w,
		vl_tot_qt_ult_compra_w
	from	solic_compra a,
		solic_compra_item b
	where	a.nr_solic_compra = b.nr_solic_compra
	and	coalesce(b.dt_reprovacao::text, '') = ''
	and	coalesce(b.dt_autorizacao::text, '') = ''
	and	nr_seq_aprovacao = nr_seq_aprovacao_p;
elsif (ie_tipo_w = 2) then
	select	coalesce(sum(b.qt_material_requisitada * coalesce(b.vl_unit_previsto,0)),0)vl_total,
		coalesce(sum((obter_dados_ult_compra_data(a.cd_estabelecimento,b.cd_material,null,clock_timestamp(),0,'VU'))::numeric  * b.qt_material_requisitada),0) vl_tot_qt_ult_compra
	into STRICT	vl_total_w,
		vl_tot_qt_ult_compra_w
	from	requisicao_material a,
		item_requisicao_material b
	where	a.nr_requisicao = b.nr_requisicao
	and	coalesce(b.dt_reprovacao::text, '') = ''
	and	coalesce(b.dt_aprovacao::text, '') = ''
	and	nr_seq_aprovacao = nr_seq_aprovacao_p;
end if;

if (ie_opcao_p = 0) then
	return vl_total_w;
elsif (ie_opcao_p = 1) then
	return vl_tot_qt_ult_compra_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_processo_aprov ( nr_seq_aprovacao_p bigint, ie_opcao_p bigint) FROM PUBLIC;

