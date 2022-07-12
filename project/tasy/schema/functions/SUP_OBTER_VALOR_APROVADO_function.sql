-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sup_obter_valor_aprovado ( nr_seq_aprovacao_p bigint, nr_seq_processo_p bigint, cd_pessoa_fisica_p text) RETURNS bigint AS $body$
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
	where	nr_seq_aprovacao = nr_seq_aprovacao_p
	
union all

	select	3 ie_tipo
	from	cot_compra_item
	where	nr_seq_aprovacao = nr_seq_aprovacao_p
	
union all

	select	4 ie_tipo
	from	nota_fiscal_item
	where	nr_seq_aprovacao = nr_seq_aprovacao_p) alias2;

if (ie_tipo_w = 0) then
	select	coalesce(sum(b.qt_material * b.vl_unitario_material),0) vl_total
	into STRICT	vl_total_w
	from	ordem_compra a,
		ordem_compra_item b
	where	a.nr_ordem_compra = b.nr_ordem_compra
	and	(b.dt_aprovacao IS NOT NULL AND b.dt_aprovacao::text <> '')
	and	nr_seq_aprovacao = nr_seq_aprovacao_p
	and	substr(obter_se_pessoa_deleg_item(b.cd_material,nr_seq_aprovacao_p,nr_seq_processo_p,cd_pessoa_fisica_p,'AC',clock_timestamp()),1,1) = 'S';

elsif (ie_tipo_w = 1) then
	select	coalesce(sum(b.qt_material * coalesce(b.vl_unit_previsto,0)),0)vl_total
	into STRICT	vl_total_w
	from	solic_compra a,
		solic_compra_item b
	where	a.nr_solic_compra = b.nr_solic_compra
	and	coalesce(b.dt_reprovacao::text, '') = ''
	and	nr_seq_aprovacao = nr_seq_aprovacao_p
	and	substr(obter_se_pessoa_deleg_item(b.cd_material,nr_seq_aprovacao_p,nr_seq_processo_p,cd_pessoa_fisica_p,'AC',clock_timestamp()),1,1) = 'S';

elsif (ie_tipo_w = 2) then
	select	coalesce(sum(b.qt_material_requisitada * coalesce(b.vl_unit_previsto,0)),0) vl_total
	into STRICT	vl_total_w
	from	requisicao_material a,
		item_requisicao_material b
	where	a.nr_requisicao = b.nr_requisicao
	and	coalesce(b.dt_reprovacao::text, '') = ''
	and	nr_seq_aprovacao = nr_seq_aprovacao_p
	and	substr(obter_se_pessoa_deleg_item(b.cd_material,nr_seq_aprovacao_p,nr_seq_processo_p,cd_pessoa_fisica_p,'AC',clock_timestamp()),1,1) = 'S';

elsif (ie_tipo_w = 3) then
	select	coalesce(sum(a.qt_material * coalesce(a.vl_unitario_material,0)),0) vl_total
	into STRICT	vl_total_w
	from	cot_compra_resumo a,
		cot_compra_item b,
		cot_compra c
	where	a.nr_cot_compra = b.nr_cot_compra
	and	a.nr_item_cot_compra = b.nr_item_cot_compra
	and	c.nr_cot_compra = b.nr_cot_compra
	and	coalesce(b.dt_reprovacao::text, '') = ''
	and	nr_seq_aprovacao = nr_seq_aprovacao_p
	and	substr(obter_se_pessoa_deleg_item(b.cd_material,nr_seq_aprovacao_p,nr_seq_processo_p,cd_pessoa_fisica_p,'AC',clock_timestamp()),1,1) = 'S';

elsif (ie_tipo_w = 4) then
	select	coalesce(sum(b.qt_item_nf * coalesce(b.vl_unitario_item_nf,0)),0) vl_total
	into STRICT	vl_total_w
	from	nota_fiscal a,
		nota_fiscal_item b
	where	a.nr_sequencia = b.nr_sequencia
	and	coalesce(b.dt_reprovacao::text, '') = ''
	and	b.nr_seq_aprovacao = nr_seq_aprovacao_p
	and	substr(obter_se_pessoa_deleg_item(b.cd_material,nr_seq_aprovacao_p,nr_seq_processo_p,cd_pessoa_fisica_p,'AC',clock_timestamp()),1,1) = 'S';
end if;

return	vl_total_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sup_obter_valor_aprovado ( nr_seq_aprovacao_p bigint, nr_seq_processo_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;
