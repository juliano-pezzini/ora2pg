-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_pend_transf_etq_estab (cd_estabelecimento_p bigint, cd_material_p bigint, cd_local_estoque_p bigint default 0) RETURNS bigint AS $body$
DECLARE


qt_pendente_w		double precision := 0;

/*
Deve sempre retornar a quantidade em unidade de medida de estoque
*/
BEGIN
if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
	begin

	select	coalesce(sum(obter_quantidade_convertida(b.cd_material,coalesce(c.qt_prevista_entrega,0) - coalesce(c.qt_real_entrega,0), b.cd_unidade_medida_compra,'UME')),0)
	into STRICT	qt_pendente_w
	from	ordem_compra a,
		ordem_compra_item b,
		ordem_compra_item_entrega c
	where	a.nr_ordem_compra = b.nr_ordem_compra
	and	a.nr_ordem_compra = c.nr_ordem_compra
	and	b.nr_item_oci = c.nr_item_oci
	and	a.cd_estab_transf = cd_estabelecimento_p
	and	coalesce(c.dt_cancelamento::text, '') = ''
	and	b.cd_material = coalesce(cd_material_p, b.cd_material)
	and	coalesce(b.dt_reprovacao::text, '') = ''
	and	coalesce(a.dt_baixa::text, '') = ''
	and	coalesce(a.nr_seq_motivo_cancel::text, '') = ''
	and	a.ie_tipo_ordem = 'T'
	and (coalesce(c.qt_prevista_entrega,0) - coalesce(c.qt_real_entrega,0)) > 0
	and	((a.cd_local_transf = cd_local_estoque_p) or (cd_local_estoque_p = 0));

	end;

end if;

return	qt_pendente_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_pend_transf_etq_estab (cd_estabelecimento_p bigint, cd_material_p bigint, cd_local_estoque_p bigint default 0) FROM PUBLIC;
