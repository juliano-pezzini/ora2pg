-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW lote_audit_hist_item_v (nr_sequencia, cd_item, cd_item_convenio, nr_interno_conta, cd_autorizacao, qt_item, vl_glosa_informada, vl_glosa, vl_amenor, cd_motivo_glosa, cd_resposta, cd_setor_responsavel, ie_acao_glosa, ds_observacao, dt_execusao, vl_saldo, vl_unitario, dt_conta, dt_atendimento, nr_seq_material, nr_seq_procedimento, ie_emite_conta, vl_item, cd_medico, nr_seq_lote_audit, nr_analise, cd_material, cd_procedimento, ie_origem_proced, ie_material, ie_medicamento, ie_extra, ie_procedimento, ie_honorario, ie_taxa, ie_diaria, nr_seq_guia, ie_tipo_glosa, vl_original) AS select	c.nr_sequencia,
	d.cd_material cd_item, 
	d.cd_material_convenio cd_item_convenio, 
	b.nr_interno_conta, 
	b.cd_autorizacao, 
	c.qt_item, 
	c.vl_glosa_informada, 
	c.vl_glosa, 
	c.vl_amenor, 
	c.cd_motivo_glosa, 
	c.cd_resposta, 
	c.cd_setor_responsavel, 
	c.ie_acao_glosa, 
	c.ds_observacao, 
	d.dt_prescricao dt_execusao, 
	c.vl_saldo, 
	d.vl_unitario, 
	d.dt_conta, 
	d.dt_atendimento, 
	d.nr_sequencia nr_seq_material, 
	null nr_seq_procedimento, 
	d.ie_emite_conta, 
	d.vl_material vl_item, 
	d.cd_medico_prescritor cd_medico, 
	a.nr_seq_lote_audit, 
	a.nr_analise, 
	d.cd_material, 
	null cd_procedimento, 
	null ie_origem_proced, 
	obter_classif_material_proced(d.cd_material, null, null) ie_material, 
	obter_classif_material_proced(d.cd_material, null, null) ie_medicamento, 
	obter_classif_material_proced(d.cd_material, null, null) ie_extra, 
	null ie_procedimento, 
	null ie_honorario, 
	null ie_taxa, 
	null ie_diaria, 
	c.nr_seq_guia, 
	c.ie_tipo_glosa, 
	(obter_dados_lote_audit_item(c.nr_sequencia,'VO'))::numeric  vl_original 
FROM	material_atend_paciente d, 
	lote_audit_hist_item c, 
	lote_audit_hist_guia b, 
	lote_audit_hist a 
where	a.nr_sequencia		= b.nr_seq_lote_hist 
and	b.nr_sequencia		= c.nr_seq_guia 
and	c.nr_seq_matpaci	= d.nr_sequencia 

union
 
select	c.nr_sequencia, 
	d.cd_procedimento cd_item, 
	d.cd_procedimento_convenio cd_item_convenio, 
	b.nr_interno_conta, 
	b.cd_autorizacao, 
	c.qt_item, 
	c.vl_glosa_informada, 
	c.vl_glosa, 
	c.vl_amenor, 
	c.cd_motivo_glosa, 
	c.cd_resposta, 
	c.cd_setor_responsavel, 
	c.ie_acao_glosa, 
	c.ds_observacao, 
	d.dt_procedimento dt_execusao, 
	c.vl_saldo, 
	0 vl_unitario, 
	d.dt_conta, 
	null dt_atendimento, 
	null nr_seq_material, 
	d.nr_sequencia nr_seq_procedimento, 
	d.ie_emite_conta, 
	d.vl_procedimento vl_item, 
	d.cd_medico_executor cd_medico, 
	a.nr_seq_lote_audit, 
	a.nr_analise, 
	null cd_material, 
	d.cd_procedimento, 
	d.ie_origem_proced, 
	null ie_material, 
	null ie_medicamento, 
	null ie_extra, 
	obter_classif_material_proced(null, d.cd_procedimento, d.ie_origem_proced) ie_procedimento, 
	obter_se_pasta_honorario(d.ie_responsavel_credito) ie_honorario, 
	obter_classif_material_proced(null, d.cd_procedimento, d.ie_origem_proced) ie_taxa, 
	obter_classif_material_proced(null, d.cd_procedimento, d.ie_origem_proced) ie_diaria, 
	c.nr_seq_guia, 
	c.ie_tipo_glosa, 
	(obter_dados_lote_audit_item(c.nr_sequencia,'VO'))::numeric  vl_original 
from	procedimento_paciente d, 
	lote_audit_hist_item c, 
	lote_audit_hist_guia b, 
	lote_audit_hist a 
where	a.nr_sequencia		= b.nr_seq_lote_hist 
and	b.nr_sequencia		= c.nr_seq_guia 
and	c.nr_seq_propaci	= d.nr_sequencia;
