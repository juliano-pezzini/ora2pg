-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_recurso_item_v (ie_inserir, ie_inserir_check, ds_item_despesa, ie_ordem_titulo, nr_sequencia, nr_seq_analise, nr_id_transacao, nr_seq_conta, nr_seq_conta_proc, nr_seq_conta_mat, nr_seq_conta_rec, nr_seq_proc_rec, nr_seq_mat_rec, cd_item, cd_material, cd_procedimento, nr_ordem, ie_situacao, dt_item, ds_via_acesso, ie_via_acesso, ds_tipo_guia, ie_tipo_guia, nr_seq_protocolo, ds_tipo_despesa, ie_ordem, cd_guia, vl_glosa, vl_recursado, vl_acatado, vl_negado, ie_origem_proced, ds_item, ie_tipo_item, nr_seq_item, qt_apresentado, qt_liberado, nr_seq_protocolo_rec) AS select	0 ie_inserir,
	'' ie_inserir_check,
	substr(pls_obter_desc_item_desp_int(nr_ordem, 'P'),1,255) ds_item_despesa,
	0 ie_ordem_titulo,
	null nr_sequencia,
	nr_seq_analise,
	nr_id_transacao,
	null nr_seq_conta,
	null nr_seq_conta_proc,
	null nr_seq_conta_mat,
	null nr_seq_conta_rec,
	null nr_seq_proc_rec,
	null nr_seq_mat_rec,
	null cd_item,
	null cd_material,
	null cd_procedimento,
	nr_ordem,
	null ie_situacao,
	null dt_item,
	null ds_via_acesso,
	null ie_via_acesso,
	null ds_tipo_guia,
	null ie_tipo_guia,
	null nr_seq_protocolo,
	null ds_tipo_despesa,
	nr_ordem ie_ordem,
	null cd_guia,
	null vl_glosa,
	null vl_recursado,
	null vl_acatado,
	null vl_negado,
	null ie_origem_proced,
	null ds_item,
	null ie_tipo_item,
	null nr_seq_item,
	null qt_apresentado,
	null qt_liberado,
	null nr_seq_protocolo_rec
FROM	pls_analise_conta_rec
group by nr_ordem, nr_seq_analise, nr_id_transacao

union all

select	0 ie_inserir,
	'' ie_inserir_check,
	substr('        '||ds_item,1,255) ds_item_despesa,
	1 ie_ordem_titulo,
	nr_sequencia,
	nr_seq_analise,
	nr_id_transacao,
	nr_seq_conta,
	nr_seq_conta_proc,
	nr_seq_conta_mat,
	nr_seq_conta_rec,
	nr_seq_proc_rec,
	nr_seq_mat_rec,
	coalesce(cd_material_ops,to_char(cd_procedimento)) cd_item,
	cd_material_ops cd_material,
	cd_procedimento,
	nr_ordem,
	ie_situacao,
	dt_item,
	substr(obter_valor_dominio(1268,ie_via_acesso),1,255) ds_via_acesso,
	ie_via_acesso,
	substr(obter_valor_dominio(1746,ie_tipo_guia),1,255) ds_tipo_guia,
	ie_tipo_guia,
	nr_seq_protocolo,
	ie_tipo_item || ie_tipo_despesa ds_tipo_despesa,
	nr_ordem ie_ordem,
	cd_guia,
	vl_glosa,
	vl_recursado,
	vl_acatado,
	(vl_recursado - vl_acatado) vl_negado,
	ie_origem_proced,
	ds_item,
	ie_tipo_item,
	coalesce(nr_seq_conta_mat,nr_seq_conta_proc) nr_seq_item,
	CASE WHEN nr_seq_conta_proc IS NULL THEN  substr(pls_obter_dados_conta_mat(nr_seq_conta_mat, 'QT'),0,15)  ELSE substr(pls_obter_dados_conta_proc(nr_seq_conta_proc, 'QTI'),0,15) END  qt_apresentado,
	CASE WHEN nr_seq_conta_proc IS NULL THEN  substr(pls_obter_dados_conta_mat(nr_seq_conta_mat, 'QL'),0,15)  ELSE substr(pls_obter_dados_conta_proc(nr_seq_conta_proc, 'QL'),0,15) END  qt_liberado,
	nr_seq_protocolo_rec
from	pls_analise_conta_rec;

