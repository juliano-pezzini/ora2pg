-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW material_ressuprimento_v (cd_material, cd_material_generico, qt_estoque, qt_ordem_compra, dt_ordem_compra, qt_solic_compra, qt_cotacao_compra, dt_atualizacao, nm_usuario, dt_entrega_ordem, vl_excedente, qt_excedente, nr_ordem_compra, qt_cons_prev_mes, cd_estabelecimento, dt_entrega_ordem_item, qt_compra_alterada, qt_compra, cd_grupo_material, cd_subgrupo_material, ds_grupo_material, ds_subgrupo_material, ds_material_ressup, ds_material_comercial, ds_comercial_estoque, ds_material, cd_unidade_medida_estoque, qt_dia_interv_ressup, qt_dia_ressup_forn, qt_dia_estoque_minimo, qt_estoque_minimo, qt_estoque_maximo, qt_consumo_mensal, qt_ponto_pedido, ie_curva_abc, ie_curva_abc_grupo, cd_material_comercial, cd_comercial_estoque, ie_cons_prev_mes, ie_padronizado, ie_controlado, ie_temperatura, ie_situacao, qt_desvio_padrao, ds_observacao, ie_consignado, dt_proxima_entrega, qt_pend_req_consumo, qt_pend_transf) AS select	a.cd_material,
	a.cd_material_generico,
	a.qt_estoque,
	a.qt_ordem_compra,
	(select min(x.dt_ordem_compra)
	 FROM	ordem_compra x
	 where	x.nr_ordem_compra = a.nr_ordem_compra) dt_ordem_compra,
	a.qt_solic_compra,
	a.qt_cotacao_compra,
	a.dt_atualizacao,
	a.nm_usuario,
	a.dt_entrega_ordem,
	a.vl_excedente,
	a.qt_excedente,
	a.nr_ordem_compra,
	a.qt_cons_prev_mes,
	a.cd_estabelecimento,
	a.dt_entrega_ordem_item,
	a.qt_compra_alterada,
	a.qt_compra,
	c.cd_grupo_material,
	c.cd_subgrupo_material,
	substr(c.ds_grupo_material,1,40) ds_grupo_material,
	substr(c.ds_subgrupo_material,1,40) ds_subgrupo_material,
	CASE WHEN substr(obter_dados_material(Obter_Mat_Comercial(a.cd_material, 'C'),'SIT'),1,1)='I' THEN  substr(b.ds_material,1,255)  ELSE substr(Obter_Mat_Comercial(a.cd_material, 'D'),1,255) END  ds_material_ressup,
	substr(Obter_Mat_Comercial(a.cd_material, 'D'),1,60) ds_material_comercial,
	substr(Obter_Mat_Comercial_estoque(a.cd_material, 'D'),1,255) ds_comercial_estoque,
	substr(b.ds_material,1,255) ds_material,
	substr(obter_dados_material_estab(a.cd_material,a.cd_estabelecimento,'UME'),1,30) cd_unidade_medida_estoque,
	a.qt_dia_interv_ressup,
	a.qt_dia_ressup_forn,
	a.qt_dia_estoque_minimo,
	a.qt_estoque_minimo,
	a.qt_estoque_maximo,
	a.qt_consumo_mensal,
	a.qt_ponto_pedido,
	substr(obter_curva_abc_estab(a.cd_estabelecimento, a.cd_material, 'N', a.dt_atualizacao),1,1) ie_curva_abc,
	substr(obter_curva_abc_estab(a.cd_estabelecimento, a.cd_material, 'S', a.dt_atualizacao),1,1) ie_curva_abc_grupo,
	Somente_Numero(Obter_Mat_Comercial(a.cd_material, 'C')) cd_material_comercial,
	Somente_Numero(Obter_Mat_Comercial_estoque(a.cd_material, 'C')) cd_comercial_estoque,
	CASE WHEN Obter_Valor_maior(Obter_mat_estabelecimento(a.cd_estabelecimento, 0, a.cd_material, 'CM'),		a.QT_CONS_PREV_MES)=a.QT_CONS_PREV_MES THEN  'S'  ELSE 'N' END  ie_cons_prev_mes,
	a.ie_padronizado,
	a.ie_controlado,
	a.ie_temperatura,
	b.ie_situacao,
	obter_mat_estabelecimento(a.cd_estabelecimento, 0, a.cd_material, 'DP') qt_desvio_padrao,
	a.ds_observacao,
	b.ie_consignado,
	a.dt_proxima_entrega,
	a.qt_pend_req_consumo,
	a.qt_pend_transf
from	estrutura_material_v c,
	material b,
	material_ressuprimento a
where	a.cd_material	= b.cd_material
and	a.cd_material	= c.cd_material;
