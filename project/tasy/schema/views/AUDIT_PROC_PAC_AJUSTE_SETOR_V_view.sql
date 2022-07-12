-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW audit_proc_pac_ajuste_setor_v (cd_item, vl_unitario, nr_interno_conta, qt_item, qt_real, nr_atendimento, cd_setor_atendimento, cd_procedimento, ie_origem_proced, ds_item, nr_doc_convenio, nr_seq_auditoria, cd_convenio, cd_categoria, dt_conta, dt_conta_item, qt_original, cd_cgc_prestador, cd_medico_executor, nm_medico_executor, nr_seq_proc_interno, nr_seq_exame) AS select		a.cd_procedimento cd_item,
		dividir(sum(a.vl_procedimento),sum(a.qt_procedimento)) vl_unitario, 
		a.nr_interno_conta, 
		sum(a.qt_procedimento) qt_item, 
		sum(a.qt_procedimento) qt_real, 
		a.nr_atendimento, 
		a.cd_setor_atendimento,	 
		a.cd_procedimento, 
		a.ie_origem_proced, 
		c.ds_procedimento ds_item, 
		a.nr_doc_convenio, 
		d.nr_seq_auditoria, 
		a.cd_convenio, 
		a.cd_categoria, 
		min(dt_conta) dt_conta, 
		min(dt_conta) dt_conta_item, 
		sum(CASE WHEN d.ie_tipo_auditoria='E' THEN 0  ELSE d.qt_original END ) qt_original, 
		a.cd_cgc_prestador, 
		a.cd_medico_executor, 
		substr(obter_nome_pf(a.cd_medico_executor),1,60) nm_medico_executor, 
		a.nr_seq_proc_interno, 
		a.nr_seq_exame 
FROM 		conta_paciente b, 
		auditoria_propaci d, 
		procedimento_paciente a, 
		procedimento c 
where 		a.cd_motivo_exc_conta is null 
and 		a.nr_interno_conta = b.nr_interno_conta 
and 		a.nr_sequencia = d.nr_seq_propaci 
and 		b.ie_status_acerto = 1 
and		a.cd_procedimento = c.cd_procedimento 
and		a.ie_origem_proced = c.ie_origem_proced 
group by 	a.cd_procedimento, 
		a.ie_origem_proced, 
		a.nr_interno_conta, 
		a.nr_atendimento, 
		a.cd_setor_atendimento,	 
		c.ds_procedimento, 
		a.nr_doc_convenio, 
		nr_seq_auditoria, 
		a.cd_convenio, 
		a.cd_categoria, 
		a.cd_cgc_prestador, 
		a.cd_medico_executor, 
		a.nr_seq_proc_interno, 
		a.nr_seq_exame 
having 		sum(a.qt_procedimento) <> 0;
