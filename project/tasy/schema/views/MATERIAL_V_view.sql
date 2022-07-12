-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW material_v (cd_material, ds_material, ds_reduzida, cd_classe_material, ie_material_estoque, ie_receita, ie_cobra_paciente, ie_baixa_inteira, ie_situacao, qt_dias_validade, dt_cadastramento, dt_atualizacao, nm_usuario, nr_minimo_cotacao, qt_estoque_maximo, qt_estoque_minimo, qt_ponto_pedido, ie_prescricao, cd_kit_material, qt_conversao_mg, ie_tipo_material, cd_material_generico, ie_padronizado, ie_preco_compra, ie_material_direto, ie_consignado, ie_utilizacao_sus, ie_controle_medico, ie_baixa_estoq_pac, qt_dia_estoque_minimo, qt_consumo_mensal, ie_curva_abc, ie_classif_xyz, cd_fabricante, qt_min_aplicacao, cd_unidade_medida_compra, cd_unidade_medida_estoque, cd_unidade_medida_consumo, qt_conv_estoque_consumo, qt_conv_compra_estoque, cd_unidade_medida_solic, qt_minimo_multiplo_solic, qt_peso_kg, ie_volumoso, ie_disponivel_mercado, nr_seq_familia, ds_familia, ds_fabricante, nr_seq_fabric, ds_general_name) AS select	a.cd_material,
	a.ds_material,
	a.ds_reduzida,
	a.cd_classe_material,
	a.ie_material_estoque,
	a.ie_receita,
	a.ie_cobra_paciente,
	a.ie_baixa_inteira,
	a.ie_situacao,
	a.qt_dias_validade,
	a.dt_cadastramento,
	a.dt_atualizacao,
	a.nm_usuario,
	a.nr_minimo_cotacao,
	a.qt_estoque_maximo,
	a.qt_estoque_minimo,
	a.qt_ponto_pedido,
	a.ie_prescricao,
	a.cd_kit_material,
	a.qt_conversao_mg,
	a.ie_tipo_material,
	a.cd_material_generico,
	a.ie_padronizado,
	a.ie_preco_compra,
	a.ie_material_direto,
	a.ie_consignado,
	a.ie_utilizacao_sus,
	a.ie_controle_medico,
	a.ie_baixa_estoq_pac,
	a.qt_dia_estoque_minimo,
	a.qt_consumo_mensal,
	a.ie_curva_abc,
	a.ie_classif_xyz,
	a.cd_fabricante,
	a.qt_min_aplicacao,
	a.cd_unidade_medida_compra,
	a.cd_unidade_medida_estoque,
	a.cd_unidade_medida_consumo,
	a.qt_conv_estoque_consumo,
	a.qt_conv_compra_estoque,
	a.cd_unidade_medida_solic,
	a.qt_minimo_multiplo_solic,
	qt_peso_kg,
	ie_volumoso,
	ie_disponivel_mercado,
	nr_seq_familia,
	substr(obter_desc_familia_mat(nr_seq_familia),1,255) ds_familia,
	substr(OBTER_DESC_FABRIC_MAT(nr_seq_fabric) ,1,255) ds_fabricante,
	a.nr_seq_fabric,
	get_desc_material_gen_jp(a.cd_material, 'S') ds_general_name
FROM	material a;

