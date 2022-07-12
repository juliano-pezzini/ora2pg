-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_acumulado_compra ( nr_seq_regra_p bigint, dt_periodo_inicial_p timestamp, dt_periodo_final_p timestamp, vl_item_estoque_p bigint default 0, nr_documento_p bigint default 0) RETURNS bigint AS $body$
DECLARE




ie_considerar_sc_acum_w		regra_limite_compras.ie_considerar_sc_acum%type;
ie_considerar_cc_acum_w		regra_limite_compras.ie_considerar_cc_acum%type;
ie_considerar_oc_acum_w		regra_limite_compras.ie_considerar_oc_acum%type;
vl_ordem_compra_w		ordem_compra_item.vl_unitario_material%type;
vl_solic_compra_w		solic_compra_item.vl_unit_previsto%type;
vl_cot_compra_w			cot_compra_resumo.vl_unitario_material%type;
cd_grupo_material_w		grupo_material.cd_grupo_material%type;
cd_subgrupo_material_w		subgrupo_material.cd_subgrupo_material%type;
cd_classe_material_w		classe_material.cd_classe_material%type;
cd_material_w			material.cd_material%type;
vl_total_acum_w			regra_limite_compras_valor.vl_limite%type := 0;
cd_conta_contabil_w		conta_contabil.cd_conta_contabil%type;
cd_centro_custo_w		centro_custo.cd_centro_custo%type;
cd_local_estoque_w		regra_limite_compras.cd_local_estoque%type;
dt_baixa_w             ordem_compra.dt_baixa%type;
vl_total_item_nf_w      nota_fiscal_item.vl_unitario_item_nf%type;
cd_estabelecimento_w    regra_limite_compras.cd_estabelecimento%type;
ie_considerar_oct_acum_w regra_limite_compras.ie_considerar_oct_acum%type;

c01 CURSOR FOR

SELECT a.nr_ordem_compra, b.nr_item_oci, coalesce(sum(c.qt_prevista_entrega * vl_item_estoque_p),0) vl_total_item_oci
	from	ordem_compra a,
		ordem_compra_item b,
		ordem_compra_item_entrega c,
		estrutura_material_v e
	where	b.cd_material = e.cd_material
	and	a.nr_ordem_compra = b.nr_ordem_compra
	and	b.nr_ordem_compra = c.nr_ordem_compra
    and a.cd_estabelecimento = cd_estabelecimento_w
	and	b.nr_item_oci = c.nr_item_oci
	and a.ie_tipo_ordem = 'T'
	and (e.cd_grupo_material = cd_grupo_material_w or coalesce(cd_grupo_material_w,0) = 0)
	and (e.cd_subgrupo_material = cd_subgrupo_material_w or coalesce(cd_subgrupo_material_w,0) = 0)
	and (e.cd_classe_material = cd_classe_material_w or coalesce(cd_classe_material_w,0) = 0)
	and (e.cd_material = cd_material_w or coalesce(cd_material_w,0) = 0)
	and	trunc(b.dt_aprovacao,'dd') between dt_periodo_inicial_p and dt_periodo_final_p
	and	coalesce(c.dt_cancelamento::text, '') = ''
	and	coalesce(a.nr_seq_motivo_cancel::text, '') = ''
	and	coalesce(b.dt_reprovacao::text, '') = ''
	and	((coalesce(cd_conta_contabil_w::text, '') = '') or
		((cd_conta_contabil_w IS NOT NULL AND cd_conta_contabil_w::text <> '') and (b.cd_conta_contabil) = cd_conta_contabil_w))
	and	((coalesce(cd_centro_custo_w::text, '') = '') or
		((cd_centro_custo_w IS NOT NULL AND cd_centro_custo_w::text <> '') and (b.cd_centro_custo) = cd_centro_custo_w))
	and	((coalesce(cd_local_estoque_w::text, '') = '') or
		((cd_local_estoque_w IS NOT NULL AND cd_local_estoque_w::text <> '') and (b.cd_local_estoque) = cd_local_estoque_w))
	group by a.nr_ordem_compra, b.nr_item_oci;


BEGIN


select	ie_considerar_sc_acum,
	ie_considerar_cc_acum,
	ie_considerar_oc_acum,
    ie_considerar_oct_acum,
	cd_grupo_material,
	cd_subgrupo_material,
	cd_classe_material,
	cd_material,
	cd_conta_contabil,
	cd_centro_custo,
	cd_local_estoque,
    cd_estabelecimento
into STRICT	ie_considerar_sc_acum_w,
	ie_considerar_cc_acum_w,
	ie_considerar_oc_acum_w,
    ie_considerar_oct_acum_w,
	cd_grupo_material_w,
	cd_subgrupo_material_w,
	cd_classe_material_w,
	cd_material_w,
	cd_conta_contabil_w,
	cd_centro_custo_w,
	cd_local_estoque_w,   
    cd_estabelecimento_w
from	regra_limite_compras
where	nr_sequencia = nr_seq_regra_p;



if (ie_considerar_sc_acum_w = 'S') then



	select	coalesce(sum(b.qt_material * b.vl_unit_previsto),0)
	into STRICT	vl_solic_compra_w
	from	solic_compra a,
		solic_compra_item b,
		estrutura_material_v e
	where	b.cd_material = e.cd_material
	and	a.nr_solic_compra = b.nr_solic_compra
    and a.cd_estabelecimento = cd_estabelecimento_w
	and (e.cd_grupo_material = cd_grupo_material_w or coalesce(cd_grupo_material_w,0) = 0)
	and (e.cd_subgrupo_material = cd_subgrupo_material_w or coalesce(cd_subgrupo_material_w,0) = 0)
	and (e.cd_classe_material = cd_classe_material_w or coalesce(cd_classe_material_w,0) = 0)
	and (e.cd_material = cd_material_w or coalesce(cd_material_w,0) = 0)
	and	trunc(a.dt_autorizacao,'dd') between trunc(dt_periodo_inicial_p,'dd') and trunc(dt_periodo_final_p,'dd')
	and	coalesce(a.nr_seq_motivo_cancel::text, '') = ''
	and	coalesce(b.dt_reprovacao::text, '') = ''
	and	((coalesce(cd_conta_contabil_w::text, '') = '') or
		((cd_conta_contabil_w IS NOT NULL AND cd_conta_contabil_w::text <> '') and (b.cd_conta_contabil) = cd_conta_contabil_w))
	and	((coalesce(cd_centro_custo_w::text, '') = '') or
		((cd_centro_custo_w IS NOT NULL AND cd_centro_custo_w::text <> '') and (a.cd_centro_custo) = cd_centro_custo_w))
	and	((coalesce(cd_local_estoque_w::text, '') = '') or
		((cd_local_estoque_w IS NOT NULL AND cd_local_estoque_w::text <> '') and (a.cd_local_estoque) = cd_local_estoque_w));

	vl_total_acum_w	:= vl_total_acum_w + vl_solic_compra_w;

end if;

if (ie_considerar_cc_acum_w = 'S') then

	select	coalesce(sum(c.qt_material * c.vl_unitario_material),0)
	into STRICT	vl_cot_compra_w
	from	cot_compra a,
		cot_compra_item b,
		cot_compra_resumo c,
		estrutura_material_v e
	where	b.cd_material = e.cd_material
	and	a.nr_cot_compra = b.nr_cot_compra
	and	b.nr_cot_compra = c.nr_cot_compra
	and 	c.nr_cot_compra <> coalesce(nr_documento_p, 0)
    and a.cd_estabelecimento = cd_estabelecimento_w
	and	b.nr_item_cot_compra = c.nr_item_cot_compra
	and (e.cd_grupo_material = cd_grupo_material_w or coalesce(cd_grupo_material_w,0) = 0)
	and (e.cd_subgrupo_material = cd_subgrupo_material_w or coalesce(cd_subgrupo_material_w,0) = 0)
	and (e.cd_classe_material = cd_classe_material_w or coalesce(cd_classe_material_w,0) = 0)
	and (e.cd_material = cd_material_w or coalesce(cd_material_w,0) = 0)
	and	trunc(a.dt_cot_compra,'dd') between dt_periodo_inicial_p and dt_periodo_final_p
	and	coalesce(a.nr_seq_motivo_cancel::text, '') = ''
	and	coalesce(b.dt_reprovacao::text, '') = ''
	and	((coalesce(cd_conta_contabil_w::text, '') = '') or
		((cd_conta_contabil_w IS NOT NULL AND cd_conta_contabil_w::text <> '') and (obter_dados_solic_item_cot(b.nr_cot_compra, b.nr_item_cot_compra, 'CC')) = cd_conta_contabil_w))
	and	((coalesce(cd_centro_custo_w::text, '') = '') or
		((cd_centro_custo_w IS NOT NULL AND cd_centro_custo_w::text <> '') and (obter_dados_solic_item_cot(b.nr_cot_compra, b.nr_item_cot_compra, 'C')) = cd_centro_custo_w))
	and	((coalesce(cd_local_estoque_w::text, '') = '') or
		((cd_local_estoque_w IS NOT NULL AND cd_local_estoque_w::text <> '') and (obter_dados_solic_item_cot(b.nr_cot_compra, b.nr_item_cot_compra, 'L')) = cd_local_estoque_w));

	vl_total_acum_w	:= vl_total_acum_w + vl_cot_compra_w;
end if;

if (ie_considerar_oc_acum_w = 'S') then

	select	coalesce(sum(c.qt_prevista_entrega * b.vl_unitario_material),0)
	into STRICT	vl_ordem_compra_w
	from	ordem_compra a,
		ordem_compra_item b,
		ordem_compra_item_entrega c,
		estrutura_material_v e
	where	b.cd_material = e.cd_material
	and	a.nr_ordem_compra = b.nr_ordem_compra
    and a.cd_estabelecimento = cd_estabelecimento_w
	and	b.nr_ordem_compra = c.nr_ordem_compra
	and	b.nr_item_oci = c.nr_item_oci
    and a.ie_tipo_ordem <> 'T'
	and (e.cd_grupo_material = cd_grupo_material_w or coalesce(cd_grupo_material_w,0) = 0)
	and (e.cd_subgrupo_material = cd_subgrupo_material_w or coalesce(cd_subgrupo_material_w,0) = 0)
	and (e.cd_classe_material = cd_classe_material_w or coalesce(cd_classe_material_w,0) = 0)
	and (e.cd_material = cd_material_w or coalesce(cd_material_w,0) = 0)
	and	trunc(b.dt_aprovacao,'dd') between dt_periodo_inicial_p and dt_periodo_final_p
	and	coalesce(c.dt_cancelamento::text, '') = ''
	and	coalesce(a.nr_seq_motivo_cancel::text, '') = ''
	and	coalesce(b.dt_reprovacao::text, '') = ''
	and	((coalesce(cd_conta_contabil_w::text, '') = '') or
		((cd_conta_contabil_w IS NOT NULL AND cd_conta_contabil_w::text <> '') and (b.cd_conta_contabil) = cd_conta_contabil_w))
	and	((coalesce(cd_centro_custo_w::text, '') = '') or
		((cd_centro_custo_w IS NOT NULL AND cd_centro_custo_w::text <> '') and (b.cd_centro_custo) = cd_centro_custo_w))
	and	((coalesce(cd_local_estoque_w::text, '') = '') or
		((cd_local_estoque_w IS NOT NULL AND cd_local_estoque_w::text <> '') and (b.cd_local_estoque) = cd_local_estoque_w));

	vl_total_acum_w	:= vl_total_acum_w + vl_ordem_compra_w;

end if;

if (ie_considerar_oct_acum_w = 'S') then

    For r01 in c01 loop

        select dt_baixa
        into STRICT dt_baixa_w
        from ordem_compra a
        where a.nr_ordem_compra = r01.nr_ordem_compra;

        if (coalesce(dt_baixa_w::text, '') = '') then
            vl_total_acum_w := vl_total_acum_w + r01.vl_total_item_oci;
        else

            select coalesce(sum(b.vl_unitario_item_nf * b.qt_item_nf),0)
            into STRICT vl_total_item_nf_w
            from nota_fiscal a,
                 nota_fiscal_item b
            where a.nr_sequencia = b.nr_sequencia
            and (a.dt_atualizacao_estoque IS NOT NULL AND a.dt_atualizacao_estoque::text <> '')
            and a.ie_situacao = 1   
            and b.nr_ordem_compra = r01.nr_ordem_compra
            and b.nr_item_oci = r01.nr_item_oci;

            vl_total_acum_w := vl_total_acum_w + vl_total_item_nf_w;

        end if;

    end loop;

end if;

return	vl_total_acum_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_acumulado_compra ( nr_seq_regra_p bigint, dt_periodo_inicial_p timestamp, dt_periodo_final_p timestamp, vl_item_estoque_p bigint default 0, nr_documento_p bigint default 0) FROM PUBLIC;
