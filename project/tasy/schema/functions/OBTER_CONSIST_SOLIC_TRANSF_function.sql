-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_consist_solic_transf ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


qt_saldo_estab_transf_w		double precision;
qt_material_w				ordem_compra_item.qt_material%type;
cd_material_w				ordem_compra_item.cd_material%type;
ie_material_estoque_w		material_estab.ie_material_estoque%type;
ie_consistencia_w			varchar(1) := 'N';


BEGIN
begin
select	a.cd_material,
	obter_quantidade_convertida(a.cd_material, SUM(b.qt_prevista_entrega) - obter_qt_oci_trans_nota(a.nr_ordem_compra, a.nr_item_oci,'S'), cd_unidade_medida_compra, 'UME')
into STRICT	cd_material_w,
	qt_material_w
from	ordem_compra_item a,
	ordem_compra_item_entrega b
where	a.nr_ordem_compra = b.nr_ordem_compra
and	a.nr_item_oci = b.nr_item_oci
and	coalesce(b.dt_cancelamento::text, '') = ''
and	a.nr_ordem_compra = nr_ordem_compra_p
and	a.nr_item_oci = nr_item_oci_p
group by a.cd_material, a.nr_ordem_compra, a.nr_item_oci, cd_unidade_medida_compra;
exception
when others then
	cd_material_w	:=	0;
	ie_consistencia_w	:=	'S';
end;

if (cd_material_w > 0) then
	select	obter_saldo_disp_estoque(cd_estabelecimento_p,cd_material_w,obter_local_atend_trasf(nr_ordem_compra_p),null)
	into STRICT	qt_saldo_estab_transf_w
	from	ordem_compra_item
	where	nr_ordem_compra = nr_ordem_compra_p
	and	nr_item_oci = nr_item_oci_p;

	select	coalesce(max(ie_material_estoque),'N')
	into STRICT	ie_material_estoque_w
	from	material_estab
	where	cd_material = cd_material_w
	and	cd_estabelecimento = cd_estabelecimento_p;

	if (qt_saldo_estab_transf_w <= 0) or (ie_material_estoque_w = 'N') or (qt_saldo_estab_transf_w < qt_material_w)then
		ie_consistencia_w := 'S';
	else
		ie_consistencia_w := 'N';
	end if;
end if;

return	ie_consistencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_consist_solic_transf ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

