-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ordem_compra_item_entr_v (nr_ordem_compra, cd_estabelecimento, cd_cgc_fornecedor, cd_condicao_pagamento, cd_comprador, dt_ordem_compra, dt_atualizacao, nm_usuario, cd_moeda, ie_situacao, dt_inclusao, cd_local_entrega, dt_baixa, dt_liberacao, nr_item_oci, cd_material, cd_unidade_medida_compra, vl_unitario_material, qt_material, dt_atualizacao_item, ie_situacao_item, qt_material_entregue, cd_local_estoque, vl_item_liquido, dt_aprovacao, cd_centro_custo, cd_conta_contabil, nr_solic_compra, nr_item_solic_compra, qt_original, dt_validade, dt_prevista_entrega, dt_real_entrega, qt_prevista_entrega, qt_real_entrega, dt_atualizacao_entrega, dt_cancelamento, nr_sequencia, dt_entrega_original, dt_entrega_limite, nr_documento_externo) AS select	a.nr_ordem_compra,
	a.cd_estabelecimento, 
	a.cd_cgc_fornecedor, 
	a.cd_condicao_pagamento, 
	a.cd_comprador, 
	a.dt_ordem_compra, 
	a.dt_atualizacao, 
	a.nm_usuario, 
	a.cd_moeda, 
	a.ie_situacao, 
	a.dt_inclusao, 
	a.cd_local_entrega, 
	a.dt_baixa, 
	a.dt_liberacao, 
	/* item */
 
	b.nr_item_oci, 
	b.cd_material, 
	b.cd_unidade_medida_compra, 
	b.vl_unitario_material, 
	b.qt_material, 
	b.dt_atualizacao dt_atualizacao_item, 
	b.ie_situacao ie_situacao_item, 
	b.qt_material_entregue, 
	b.cd_local_estoque, 
	b.vl_item_liquido, 
	b.dt_aprovacao, 
	b.cd_centro_custo, 
	b.cd_conta_contabil, 
	b.nr_solic_compra, 
	b.nr_item_solic_compra, 
	b.qt_original, 
	b.dt_validade, 
	/* entrega */
 
	c.dt_prevista_entrega, 
	c.dt_real_entrega, 
	c.qt_prevista_entrega, 
	c.qt_real_entrega, 
	c.dt_atualizacao dt_atualizacao_entrega, 
	c.dt_cancelamento, 
	c.nr_sequencia, 
	c.dt_entrega_original, 
	c.dt_entrega_limite, 
	a.nr_documento_externo 
FROM	ordem_compra_item_entrega	c, 
	ordem_compra_item		b, 
	ordem_compra			a 
where	a.nr_ordem_compra	= b.nr_ordem_compra 
and	b.nr_ordem_compra	= c.nr_ordem_compra 
and	b.nr_item_oci		= c.nr_item_oci;
