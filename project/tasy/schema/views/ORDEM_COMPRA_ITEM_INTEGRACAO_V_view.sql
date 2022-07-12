-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ordem_compra_item_integracao_v (nr_ordem_compra, nr_item_oci, cd_material, cd_unidade_medida_compra, vl_unitario_material, qt_material, pr_descontos, vl_desconto, vl_total_item, vl_item_liquido, cd_pessoa_solicitante, cd_cpf_pessoa_solicitante, qt_material_entregue, cd_centro_custo, cd_conta_contabil, cd_local_estoque, ds_material_direto, ds_observacao, nr_solic_compra, nr_item_solic_compra, nr_cot_compra, nr_item_cot_compra, ds_marca, nr_seq_marca, ds_marca_fornec, nr_seq_proj_rec, pr_desc_financ, nr_seq_conta_financ, vl_ultima_compra, vl_dif_ultima_compra, pr_dif_ultima_compra, nr_seq_criterio_rateio, nr_serie_material, nr_seq_conta_bco, nr_contrato, dt_inicio_garantia, dt_fim_garantia, qt_dias_garantia, ds_lote, dt_validade, ie_servico_realizado, dt_atualizacao, nm_usuario, nr_seq_ordem_serv, nr_seq_reg_lic_item, nr_seq_prescr_item, nr_empenho, dt_empenho, nr_atendimento, ie_motivo_reprovacao, ds_justificativa_reprov, ds_justif_diver, dt_lib_conferencia) AS select	nr_ordem_compra,
	nr_item_oci,
	cd_material,
	cd_unidade_medida_compra,
	vl_unitario_material,
	qt_material,
	pr_descontos,
	vl_desconto,
	vl_total_item,
	vl_item_liquido,
	cd_pessoa_solicitante,
	obter_cpf_pessoa_fisica(cd_pessoa_solicitante) cd_cpf_pessoa_solicitante,
	qt_material_entregue,
	cd_centro_custo,
	cd_conta_contabil,
	cd_local_estoque,
	ds_material_direto,
	replace(elimina_caractere_especial(ds_observacao),':',' ') ds_observacao,
	nr_solic_compra,
	nr_item_solic_compra,
	nr_cot_compra,
	nr_item_cot_compra,
	ds_marca,
	nr_seq_marca,
	ds_marca_fornec,
	nr_seq_proj_rec,
	pr_desc_financ,
	nr_seq_conta_financ,
	vl_ultima_compra,
	vl_dif_ultima_compra,
	pr_dif_ultima_compra,
	nr_seq_criterio_rateio,
	nr_serie_material,
	nr_seq_conta_bco,
	nr_contrato,
	dt_inicio_garantia,
	dt_fim_garantia,
	qt_dias_garantia,
	ds_lote,
	dt_validade,
	ie_servico_realizado,
	dt_atualizacao,
	nm_usuario,
	nr_seq_ordem_serv,
	nr_seq_reg_lic_item,
	nr_seq_prescr_item,
	nr_empenho,
	dt_empenho,
	nr_atendimento,
	ie_motivo_reprovacao,
	ds_justificativa_reprov,
	ds_justif_diver,
	dt_lib_conferencia
FROM	ordem_compra_item;
