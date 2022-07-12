-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW audit_mat_pac_ajuste_setor_v (cd_item, cd_unidade_medida, vl_unitario, nr_interno_conta, qt_item, qt_real, nr_atendimento, cd_setor_atendimento, cd_material, ds_item, dt_conta, dt_conta_item, nr_doc_convenio, ie_tipo_material, nr_seq_auditoria, cd_convenio, cd_categoria, qt_original, cd_material_tiss) AS select		a.cd_material cd_item,
		a.cd_unidade_medida, 
		a.vl_unitario, 
		a.nr_interno_conta, 
		sum(a.qt_material) qt_item, 
		sum(a.qt_material) qt_real, 
		a.nr_atendimento, 
		a.cd_setor_atendimento,	 
		a.cd_material, 
		c.ds_material ds_item, 
		min(dt_conta) dt_conta, 
		min(dt_conta) dt_conta_item, 
		null nr_doc_convenio, 
		c.ie_tipo_material, 
		e.nr_sequencia nr_seq_auditoria, 
		a.cd_convenio, 
		a.cd_categoria, 
		sum(CASE WHEN d.ie_tipo_auditoria='E' THEN 0  ELSE d.qt_original END ) qt_original, 
		a.cd_material_tiss 
FROM 		conta_paciente b, 
		auditoria_conta_paciente e, 
		auditoria_matpaci d, 
		material_atend_paciente a, 
		material c 
where 		a.cd_motivo_exc_conta is null 
and 		a.nr_interno_conta = b.nr_interno_conta 
and		b.nr_interno_conta = e.nr_interno_conta 
and		d.nr_seq_auditoria = e.nr_sequencia 
and 		a.nr_sequencia = d.nr_seq_matpaci 
and 		b.ie_status_acerto = 1 
and		a.cd_material = c.cd_material 
group by 	a.cd_material, 
		a.cd_unidade_medida, 
		a.vl_unitario, 
		a.nr_interno_conta, 
		a.nr_atendimento, 
		a.cd_setor_atendimento,	 
		a.cd_material, 
		c.ds_material, 
		c.ie_tipo_material, 
		e.nr_sequencia, 
		a.cd_convenio, 
		a.cd_categoria, 
		a.cd_material_tiss 
having 		sum(a.qt_material) <> 0;

