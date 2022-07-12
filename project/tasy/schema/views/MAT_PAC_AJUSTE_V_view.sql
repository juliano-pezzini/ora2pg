-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW mat_pac_ajuste_v (dt_conta, cd_item, cd_unidade_medida, vl_unitario, nr_interno_conta, qt_item, qt_real, dt_atendimento, cd_medico_executor, nm_medico, nr_atendimento, cd_setor_atendimento, cd_material, ds_item, ie_auditoria, dt_conta_item, nr_doc_convenio, ie_valor_informado) AS select		to_char(a.dt_conta,'dd/mm/yyyy') dt_conta,
		a.cd_material cd_item,
		a.cd_unidade_medida,
		a.vl_unitario,
/*		a.dt_acerto_conta,    os - 147986 - diego */

		a.nr_interno_conta,
		sum(a.qt_material) qt_item,
		sum(a.qt_material) qt_real,
		min(a.dt_atendimento) dt_atendimento,
		'0' cd_medico_executor,
		'Nenhum' nm_medico,
		a.nr_atendimento,
		a.cd_setor_atendimento,
		a.cd_material,
		c.ds_material ds_item,
		a.ie_auditoria,
		max(a.dt_conta) dt_conta_item,
		a.nr_doc_convenio,
		a.ie_valor_informado
FROM  	conta_paciente b,
		material_atend_paciente a,
		material c
where 	a.cd_motivo_exc_conta is null
and 		a.nr_interno_conta = b.nr_interno_conta
and 		b.ie_status_acerto = 1
and		a.cd_material = c.cd_material
group by 	to_char(a.dt_conta,'dd/mm/yyyy'),
		a.cd_material,
		a.cd_unidade_medida,
		a.vl_unitario,
--		a.dt_acerto_conta,
		a.nr_interno_conta,
		a.nr_atendimento,
		a.cd_setor_atendimento,
		a.cd_material,
		c.ds_material,
		a.ie_auditoria,
		a.nr_doc_convenio,
		a.ie_valor_informado
having 	sum(a.qt_material) <> 0;
