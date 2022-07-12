-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW movimento_estoque_v (nr_movimento_estoque, cd_estabelecimento, cd_local_estoque, dt_movimento_estoque, cd_operacao_estoque, cd_acao, cd_material, dt_mesano_referencia, qt_movimento, dt_atualizacao, nm_usuario, ie_origem_documento, nr_documento, nr_sequencia_item_docto, cd_cgc_emitente, cd_serie_nf, nr_sequencia_documento, vl_movimento, cd_unidade_medida_estoque, cd_procedimento, cd_setor_atendimento, cd_conta, dt_contabil, cd_lote_fabricacao, dt_validade, qt_estoque, dt_processo, cd_local_estoque_destino, cd_centro_custo, cd_unidade_med_mov, nr_movimento_estoque_corresp, cd_conta_contabil, cd_material_estoque, ie_origem_proced, cd_fornecedor, nr_lote_contabil, qt_inventario, ds_observacao, nr_seq_tab_orig, nr_seq_lote_fornec, cd_funcao, cd_perfil, nr_atendimento, nr_prescricao, nr_receita, ie_movto_consignado, nr_ordem_compra, nr_item_oci, ds_consistencia, nr_lote_ap, nr_lote_producao, ds_operacao, ie_atualiza_estoque, ie_consignado, ie_consumo, qt_movto_estoque, qt_consumo, ie_tipo_acao) AS select	a.nr_movimento_estoque,
	a.cd_estabelecimento,
	a.cd_local_estoque,
	a.dt_movimento_estoque,
	a.cd_operacao_estoque,
	a.cd_acao,
	a.cd_material,
	a.dt_mesano_referencia,
	a.qt_movimento,
	a.dt_atualizacao,
	a.nm_usuario,
	a.ie_origem_documento,
	a.nr_documento,
	a.nr_sequencia_item_docto,
	a.cd_cgc_emitente,
	a.cd_serie_nf,
	a.nr_sequencia_documento,
	a.vl_movimento,
	a.cd_unidade_medida_estoque,
	a.cd_procedimento,
	a.cd_setor_atendimento,
	a.cd_conta,
	a.dt_contabil,
	a.cd_lote_fabricacao,
	a.dt_validade,
	a.qt_estoque,
	a.dt_processo,
	a.cd_local_estoque_destino,
	a.cd_centro_custo,
	a.cd_unidade_med_mov,
	a.nr_movimento_estoque_corresp,
	a.cd_conta_contabil,
	a.cd_material_estoque,
	a.ie_origem_proced,
	a.cd_fornecedor,
	a.nr_lote_contabil,
	a.qt_inventario,
	a.ds_observacao,
	a.nr_seq_tab_orig,
	a.nr_seq_lote_fornec,
	a.cd_funcao,
	a.cd_perfil,
	a.nr_atendimento,
	a.nr_prescricao,
	a.nr_receita,
	a.ie_movto_consignado,
	a.nr_ordem_compra,
	a.nr_item_oci,
	a.ds_consistencia,
	a.nr_lote_ap,
	a.nr_lote_producao,
	b.ds_operacao,
	b.ie_atualiza_estoque,
	b.ie_consignado,
	b.ie_consumo,
	CASE WHEN 	a.cd_acao='1' THEN  a.qt_estoque  ELSE a.qt_estoque * -1 END  qt_movto_estoque,
	CASE WHEN 	b.ie_consumo='A' THEN  CASE WHEN a.cd_acao='1' THEN  a.qt_estoque  ELSE a.qt_estoque * -1 END  WHEN 	b.ie_consumo='D' THEN  CASE WHEN a.cd_acao='1' THEN  a.qt_estoque * -1  ELSE a.qt_estoque END   ELSE 0 END  qt_consumo,
	b.ie_entrada_saida ie_tipo_acao
FROM	operacao_estoque b,
	movimento_estoque a
where	a.cd_operacao_estoque = b.cd_operacao_estoque;
