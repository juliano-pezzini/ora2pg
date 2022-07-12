-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_invent_material_v (cd_estabelecimento, dt_mesano_referencia, cd_local_estoque, cd_grupo_material, cd_subgrupo_material, cd_classe_material, cd_material, ie_curva_abc, qt_ocor_invent, qt_ocor_invent_ok, qt_inventario, vl_inventario, vl_estoque_medio, dt_atualizacao, nm_usuario, pr_acur, ds_local_estoque, ds_grupo_material, ds_subgrupo_material, ds_classe_material, ds_material, ie_receita) AS select	a.cd_estabelecimento,
	a.dt_mesano_referencia,
	a.cd_local_estoque,
	b.cd_grupo_material,
	b.cd_subgrupo_material,
	b.cd_classe_material,
	a.cd_material,
	substr(obter_curva_abc_estab(a.cd_estabelecimento, a.cd_material, null, a.dt_mesano_referencia),1,1) ie_curva_abc,
	coalesce(a.qt_ocor_invent,0) qt_ocor_invent,
	coalesce(a.qt_ocor_invent_ok,0) qt_ocor_invent_ok,
	coalesce(a.qt_inventario,0) qt_inventario,
	(coalesce(a.qt_inventario,0) * coalesce(vl_custo_medio,0)) vl_inventario,
	round((coalesce(a.qt_estoque_medio,0) * round((coalesce(vl_custo_medio,0))::numeric,4)),2) vl_estoque_medio,
	a.dt_atualizacao,
	a.nm_usuario,
	dividir(coalesce(a.qt_ocor_invent_ok,0)*100, coalesce(a.qt_ocor_invent,0)) pr_acur,
	substr(c.ds_local_estoque,1,40) ds_local_estoque,
	substr(b.ds_grupo_material,1,60) ds_grupo_material,
	substr(b.ds_subgrupo_material,1,60) ds_subgrupo_material,
	substr(b.ds_classe_material,1,60) ds_classe_material,
	substr(b.ds_material,1,60) ds_material,
	substr(obter_dados_material(a.cd_material,'REC'),1,1) ie_receita
FROM	saldo_estoque a,
	estrutura_material_v b,
	local_estoque c
where	a.cd_material = b.cd_material
and	a.cd_local_estoque = c.cd_local_estoque;
