-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_vl_comprometido_ordem ( nr_seq_proj_rec_p bigint, nr_ordem_compra_p bigint) RETURNS bigint AS $body$
DECLARE


vl_comprometido_w	projeto_recurso_saldo.vl_comprometido%type;

vl_total_item_ordem_w	ordem_compra_item.vl_unitario_material%type;
vl_total_ordem_w	ordem_compra_item.vl_unitario_material%type;
qt_item_pend_oc_w	ordem_compra_item_entrega.qt_prevista_entrega%type;
qt_total_item_pend_oc_w	ordem_compra_item_entrega.qt_prevista_entrega%type;
vl_unitario_material_w	ordem_compra_item.vl_unitario_material%type;
nr_item_oci_w		ordem_compra_item.nr_item_oci%type;
vl_total_nota_w		nota_fiscal_item.vl_liquido%type;
vl_total_item_nota_w	nota_fiscal_item.vl_liquido%type;
vl_total_oc_proj_w	ordem_compra_item.vl_unitario_material%type;
vl_tributo_item_w	ordem_compra_item_trib.vl_tributo%type;

c01 CURSOR FOR
	SELECT	b.vl_unitario_material,
		b.nr_item_oci
	from 	ordem_compra a,
		ordem_compra_item b
	where	a.nr_ordem_compra = b.nr_ordem_compra
	and	b.nr_seq_proj_rec = nr_seq_proj_rec_p
	and     a.nr_ordem_compra = nr_ordem_compra_p
	and     (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and     coalesce(a.nr_seq_motivo_cancel::text, '') = ''
	order by 1;


BEGIN

vl_comprometido_w	:= 0;
vl_total_ordem_w	:= 0;
qt_item_pend_oc_w 	:= 0;
qt_total_item_pend_oc_w := 0;
vl_total_item_nota_w	:= 0;
vl_total_nota_w		:= 0;
vl_tributo_item_w	:= 0;

open c01;
loop
fetch c01 into
	vl_unitario_material_w,
	nr_item_oci_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	coalesce(sum(qt_prevista_entrega),0) * coalesce(sum(vl_unitario_material_w),0)
	into STRICT	vl_total_item_ordem_w
	from	ordem_compra_item_entrega
	where	nr_ordem_compra = nr_ordem_compra_p
	and	nr_item_oci = nr_item_oci_w
	and	coalesce(dt_cancelamento::text, '') = '';

	select ((select coalesce(sum(a.vl_tributo),0)
	from   ordem_compra_item_trib a
	where  a.nr_ordem_compra = nr_ordem_compra_p
	and    a.nr_item_oci       = nr_item_oci_w
	and    exists (select 1
		       from   tributo b
		       where  b.cd_tributo = a.cd_tributo
		       and    ie_soma_diminui = 'S')) - (select coalesce(sum(a.vl_tributo),0)
	from   ordem_compra_item_trib a
	where  a.nr_ordem_compra = nr_ordem_compra_p
	and    a.nr_item_oci       = nr_item_oci_w
	and    exists (select 1
		       from   tributo b
		       where  b.cd_tributo = a.cd_tributo
		       and    ie_soma_diminui = 'D')))
	into STRICT vl_tributo_item_w
	;

	vl_total_ordem_w := vl_total_ordem_w + (vl_total_item_ordem_w + vl_tributo_item_w);

	select	coalesce(sum(qt_prevista_entrega),0) - coalesce(sum(qt_real_entrega),0)
	into STRICT 	qt_item_pend_oc_w
	from	ordem_compra_item_entrega
	where	nr_ordem_compra = nr_ordem_compra_p
	and 	nr_item_oci = nr_item_oci_w
	and	coalesce(dt_cancelamento::text, '') = '';

	qt_total_item_pend_oc_w := qt_total_item_pend_oc_w + qt_item_pend_oc_w;

	select  coalesce(sum(b.vl_liquido),0)
	into STRICT	vl_total_item_nota_w
	from    nota_fiscal a,
		nota_fiscal_item b
	where   a.nr_sequencia = b.nr_sequencia
	and     b.nr_ordem_compra = nr_ordem_compra_p
	and     b.nr_item_oci = nr_item_oci_w
	and	b.nr_seq_proj_rec = nr_seq_proj_rec_p
	and     a.ie_situacao = 1
	and     (a.dt_atualizacao_estoque IS NOT NULL AND a.dt_atualizacao_estoque::text <> '');

	vl_total_nota_w := vl_total_nota_w + vl_total_item_nota_w;

	end;
end loop;
close c01;

if (qt_total_item_pend_oc_w > 0) then
	vl_comprometido_w := coalesce(vl_total_ordem_w,0) - coalesce(vl_total_nota_w,0);
end if;

return	vl_comprometido_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_vl_comprometido_ordem ( nr_seq_proj_rec_p bigint, nr_ordem_compra_p bigint) FROM PUBLIC;
