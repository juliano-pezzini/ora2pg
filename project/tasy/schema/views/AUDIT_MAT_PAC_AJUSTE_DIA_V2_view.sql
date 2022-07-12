-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW audit_mat_pac_ajuste_dia_v2 (dt_conta, dt_conta2, cd_item, cd_unidade_medida, vl_unitario, nr_interno_conta, qt_item, qt_real, nr_atendimento, cd_setor_atendimento, cd_material, ds_item, dt_conta_item, nr_doc_convenio, ie_tipo_material, nr_seq_auditoria, cd_convenio, cd_categoria, ie_emite_conta, qt_original, ds_chave) AS select	to_char(a.dt_Conta,'dd/mm/yyyy') dt_conta,
	to_date(to_char(a.dt_Conta,'dd/mm/yyyy'),'dd/mm/yyyy') dt_conta2,
	a.cd_material cd_item, 
	a.cd_unidade_medida, 
	a.vl_unitario, 
	a.nr_interno_conta, 
	sum(a.qt_material) qt_item, 
	sum(a.qt_material) qt_real, 
	a.nr_atendimento,
	a.cd_setor_atendimento,	
	a.cd_material,
	c.ds_material ds_item,
	min(dt_conta) dt_conta_item,
	a.nr_doc_convenio,
	c.ie_tipo_material,
	d.nr_seq_auditoria,
	a.cd_convenio,
	a.cd_categoria,
	a.ie_emite_conta,
	sum(CASE WHEN d.ie_tipo_auditoria='E' THEN 0  ELSE d.qt_original END )  qt_original,
	substr('A' || to_char(a.dt_Conta,'ddmmyyyy') || to_char(a.cd_material) || to_char(a.cd_unidade_medida) || to_char(a.vl_unitario) || 
		to_char(a.nr_interno_conta) || 	to_char(a.nr_atendimento) || to_char(a.cd_setor_atendimento) || to_char(c.ie_tipo_material) || 
		to_char(d.nr_seq_auditoria) || to_char(a.cd_convenio) || to_char(a.cd_categoria) || a.ie_emite_conta,1,255) ds_chave
FROM  		conta_paciente b, 
	auditoria_matpaci d,
	material_atend_paciente a,
	material c
where 	a.cd_motivo_exc_conta is null
and 	a.nr_interno_conta = b.nr_interno_conta
and 	a.nr_sequencia = d.nr_seq_matpaci
and 	b.ie_status_acerto = 1
and	a.cd_material = c.cd_material
group by	To_char(a.dt_conta,'dd/mm/yyyy'), 
	to_date(to_char(a.dt_Conta,'dd/mm/yyyy'),'dd/mm/yyyy'),
	a.cd_material, 
	a.cd_unidade_medida, 
	a.vl_unitario, 
	a.nr_interno_conta,
	a.nr_atendimento,
	a.cd_setor_atendimento,	
	a.cd_material,
	c.ds_material,
	c.ie_tipo_material,
	nr_seq_auditoria,
	a.cd_convenio,
	a.cd_categoria,
	a.ie_emite_conta,
	a.nr_doc_convenio,
	substr('A' || to_char(a.dt_Conta,'ddmmyyyy') || to_char(a.cd_material) || to_char(a.cd_unidade_medida) || to_char(a.vl_unitario) || 
		to_char(a.nr_interno_conta) || 	to_char(a.nr_atendimento) || to_char(a.cd_setor_atendimento) || to_char(c.ie_tipo_material) || 
		to_char(d.nr_seq_auditoria) || to_char(a.cd_convenio) || to_char(a.cd_categoria) || a.ie_emite_conta,1,255)
having 	sum(a.qt_material) <> 0;

