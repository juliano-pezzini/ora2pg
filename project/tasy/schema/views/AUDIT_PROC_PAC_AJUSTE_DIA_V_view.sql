-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW audit_proc_pac_ajuste_dia_v (dt_conta, dt_conta2, cd_item, vl_unitario, nr_interno_conta, qt_item, qt_real, vl_item, nr_atendimento, cd_setor_atendimento, cd_procedimento, ie_origem_proced, ds_item, dt_conta_item, nr_doc_convenio, nr_seq_auditoria, cd_convenio, cd_categoria, cd_cgc_prestador, nr_seq_proc_interno, cd_medico_executor, ie_funcao_medico, ie_emite_conta, nr_seq_exame, qt_original, ds_chave) AS select	to_char(a.dt_Conta,'dd/mm/yyyy') dt_conta,
	to_date(to_char(a.dt_Conta,'dd/mm/yyyy'),'dd/mm/yyyy')dt_conta2,
	a.cd_procedimento cd_item, 
	dividir(sum(a.vl_procedimento),sum(a.qt_procedimento)) vl_unitario, 
	a.nr_interno_conta, 
	sum(a.qt_procedimento) qt_item, 
	sum(a.qt_procedimento) qt_real, 
	sum(a.vl_procedimento) vl_item,
	a.nr_atendimento,
	a.cd_setor_atendimento,	
	a.cd_procedimento,
	a.ie_origem_proced,
	c.ds_procedimento ds_item,
	min(dt_conta) dt_conta_item,
	null nr_doc_convenio,
	d.nr_seq_auditoria,
	a.cd_convenio,
	a.cd_categoria,
	a.cd_cgc_prestador,
	a.nr_seq_proc_interno,
	a.cd_medico_executor,
	a.ie_funcao_medico,
	a.ie_emite_conta,
	a.nr_seq_exame,
	sum(CASE WHEN d.ie_tipo_auditoria='E' THEN 0  ELSE d.qt_original END )  qt_original,
	substr('A' || to_char(a.dt_Conta,'ddmmyyyy') || to_char(a.cd_procedimento) || to_char(a.nr_interno_conta) ||  
		to_char(a.nr_atendimento) || to_char(a.cd_setor_atendimento) || to_char(a.cd_procedimento) ||	
		to_char(a.ie_origem_proced) || to_char(d.nr_seq_auditoria) ||
		to_char(a.cd_convenio) ||to_char(a.cd_categoria) || to_char(a.cd_cgc_prestador) || to_char(a.nr_seq_proc_interno) ||
		a.cd_medico_executor || a.ie_funcao_medico || a.ie_emite_conta || a.nr_seq_exame,1,255) ds_chave
FROM	conta_paciente b,
	auditoria_propaci d,
	procedimento_paciente a,
	procedimento c
where 	a.cd_motivo_exc_conta is null
and 	a.nr_interno_conta = b.nr_interno_conta
and 	a.nr_sequencia = d.nr_seq_propaci
and 	b.ie_status_acerto = 1
and	a.cd_procedimento = c.cd_procedimento
and	a.ie_origem_proced = c.ie_origem_proced
group by	To_char(a.dt_conta,'dd/mm/yyyy'), 
		to_date(to_char(a.dt_Conta,'dd/mm/yyyy'),'dd/mm/yyyy'),
		a.cd_procedimento, 
		a.ie_origem_proced,
		a.nr_interno_conta,
		a.nr_atendimento,
		a.cd_setor_atendimento,	
		c.ds_procedimento,
		nr_seq_auditoria,
		a.cd_convenio,
		a.cd_categoria,
		a.cd_cgc_prestador,
		a.nr_seq_proc_interno,
		a.cd_medico_executor,
		a.ie_funcao_medico,
		a.ie_emite_conta,
		a.nr_seq_exame,
		substr('A' || to_char(a.dt_Conta,'ddmmyyyy') || to_char(a.cd_procedimento) || to_char(a.nr_interno_conta) ||  
			to_char(a.nr_atendimento) ||  to_char(a.cd_setor_atendimento) ||	to_char(a.cd_procedimento) ||	
			to_char(a.ie_origem_proced) || to_char(d.nr_seq_auditoria) ||
			to_char(a.cd_convenio) ||to_char(a.cd_categoria) || to_char(a.cd_cgc_prestador) || to_char(a.nr_seq_proc_interno) ||
			a.cd_medico_executor || a.ie_funcao_medico || a.ie_emite_conta || a.nr_seq_exame,1,255)
having 		sum(a.qt_procedimento) <> 0;

