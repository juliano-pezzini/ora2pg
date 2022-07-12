-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW protocolo_honorario_v (ie_emite_conta, nr_interno_conta_proc, nr_interno_conta, ie_cancelamento, cd_procedimento, ie_origem_proced, cd_procedimento_convenio, ds_procedimento, dt_procedimento, dt_conta, dt_conta_dia, qt_procedimento, vl_medico, vl_procedimento, vl_custo_operacional, cd_setor_atendimento, ds_setor_atendimento, ds_classif_setor, nm_medico, qt_pto_medico, qt_pto_auxiliares, qt_pto_anestesista, qt_pto_custo_oper, qt_pto_procedimento, nr_crm, nr_crm_dig, pr_participacao, tx_procedimento, ie_funcao_medico, ds_funcao, nr_sequencia, nr_seq_proc_pacote, ie_responsavel_credito, ds_responsavel_credito, cd_unidade_basica, cd_unidade_compl, cd_tipo_acomodacao_pac, ds_tipo_acomodacao_pac, cd_medico, dt_item, qt_porte_anestesico, pr_via_acesso, cd_procedimento_princ, nr_cpf_medico, cd_cgc_medico, cd_cgc_cpf_medico, ie_cobra_pf_pj, ie_corpo_clinico, uf_crm, ie_vinculo_medico, cd_motivo_exc_conta, cd_especialidade, cd_cgc_prestador, cd_cgc_cpf_resp_cred, cd_funcao_espec_med, nr_prescricao, dt_prescricao, nr_seq_autorizacao, nr_doc_convenio, nr_seq_protocolo, nr_atendimento, cd_convenio, dt_mesano_referencia, cd_proc_ref, cd_proc_ref_conv, ie_emite_conta_honor, ie_emite_conta_hosp, vl_filme, cd_proc_convenio, ds_proc_convenio, ie_video, pr_procedimento, pr_faturado, ie_participante, ds_especialidade, cd_medico_convenio, cd_medico_crm_convenio, ie_via_acesso, cd_tipo_procedimento, cd_grupo_proc, nr_cirurgia, hr_conta, hr_execucao, tx_hora_extra, nr_seq_atepacu, ie_status_protocolo, dt_referencia_protocolo, ds_convenio, ie_tipo_convenio) AS select
	coalesce(a.ie_emite_conta_honor, a.ie_emite_conta) ie_emite_conta, 
	a.nr_interno_conta nr_interno_conta_proc, 
	y.nr_interno_conta, 
	y.ie_cancelamento, 
	a.cd_procedimento, 
	a.ie_origem_proced, 
	a.cd_procedimento_convenio, 
	substr(b.ds_procedimento,0,100) ds_procedimento, 
	trunc(a.dt_procedimento,'DD') dt_procedimento, 
	a.dt_conta, 
	trunc(a.dt_conta,'DD') dt_conta_dia, 
	a.qt_procedimento, 
	a.vl_medico, 
	a.vl_procedimento, 
	a.vl_custo_operacional, 
	c.cd_setor_atendimento, 
	c.ds_setor_atendimento, 
	substr(Obter_valor_dominio(1,c.cd_classif_setor),1,30) ds_classif_setor, 
	e.nm_pessoa_fisica nm_medico, 
	coalesce(f.vl_medico,0) qt_pto_medico, 
	coalesce(f.vl_auxiliares,0) qt_pto_auxiliares, 
	coalesce(f.vl_anestesista,0) qt_pto_anestesista, 
	coalesce(f.vl_custo_operacional,0) qt_pto_custo_oper, 
	coalesce(f.vl_procedimento,0) qt_pto_procedimento, 
	g.nr_crm, 
	g.nr_crm || calcula_digito('Modulo11',g.nr_crm) nr_crm_dig, 
	100 pr_participacao, 
	a.tx_procedimento, 
	a.ie_funcao_medico, 
	w.ds_funcao, 
	a.nr_sequencia, 
	a.nr_seq_proc_pacote, 
	a.ie_responsavel_credito, 
	x.ds_regra ds_responsavel_credito, 
	h.cd_unidade_basica, 
	h.cd_unidade_compl, 
	h.cd_tipo_acomodacao cd_tipo_acomodacao_pac, 
	n.ds_tipo_acomodacao ds_tipo_acomodacao_pac, 
	a.cd_medico_executor cd_medico, 
	a.dt_procedimento dt_item, 
	a.qt_porte_anestesico, 
	a.tx_procedimento pr_via_acesso, 
	a.cd_procedimento_princ, 
	e.nr_cpf nr_cpf_medico, 
	g.cd_cgc cd_cgc_medico, 
	CASE WHEN g.ie_cobra_pf_pj='J' THEN g.cd_cgc  ELSE e.nr_cpf END  cd_cgc_cpf_medico, 
	g.ie_cobra_pf_pj, 
	g.ie_corpo_clinico, 
	g.uf_crm, 
	g.ie_vinculo_medico, 
	a.cd_motivo_exc_conta, 
	a.cd_especialidade, 
	a.cd_cgc_prestador, 
	CASE WHEN a.ie_responsavel_credito='M' THEN CASE WHEN g.ie_cobra_pf_pj='J' THEN g.cd_cgc  ELSE e.nr_cpf END  WHEN a.ie_responsavel_credito='H' THEN a.cd_cgc_prestador WHEN a.ie_responsavel_credito='RM' THEN a.cd_cgc_prestador  ELSE coalesce(x.cd_cgc,a.cd_cgc_prestador) END  cd_cgc_cpf_resp_cred, 
	obter_funcao_medico_convenio(a.cd_convenio,a.ie_funcao_medico,a.cd_especialidade) 
								cd_funcao_espec_med, 
	a.nr_prescricao, 
	a.dt_prescricao, 
	a.nr_seq_autorizacao, 
	a.nr_doc_convenio, 
	y.nr_seq_protocolo, 
	y.nr_atendimento, 
	y.cd_convenio_parametro cd_convenio, 
	y.dt_mesano_referencia, 
	substr(Obter_Proc_Ref(a.nr_seq_proc_princ,'I'),1,8) cd_proc_ref, 
	substr(Obter_Proc_Ref(a.nr_seq_proc_princ,'C'),1,20) cd_proc_ref_conv, 
	a.ie_emite_conta_honor ie_emite_conta_honor, 
	a.ie_emite_conta ie_emite_conta_hosp, 
	a.vl_materiais vl_filme, 
	coalesce(y.cd_procedimento, coalesce(a.cd_procedimento_convenio,a.cd_procedimento)) cd_proc_convenio, 
	coalesce(y.ds_procedimento, substr(b.ds_procedimento,0,100)) ds_proc_convenio, 
	a.ie_video, 
	a.tx_procedimento pr_procedimento, 
	a.tx_procedimento pr_faturado, 
	'N' ie_participante, 
	substr(obter_desc_espec_medica(a.cd_especialidade),1,60) ds_especialidade, 
	a.cd_medico_convenio, 
	coalesce(a.cd_medico_convenio, g.nr_crm) cd_medico_crm_convenio, 
	a.ie_via_acesso, 
	b.cd_tipo_procedimento, 
	b.cd_grupo_proc, 
	a.nr_cirurgia, 
	to_char(dt_conta,'hh24:mi') hr_conta, 
	to_char(dt_procedimento,'hh24:mi') hr_execucao, 
	coalesce(a.tx_hora_extra,1) tx_hora_extra, 
	a.nr_seq_atepacu, 
	t.ie_status_protocolo, 
	t.dt_mesano_referencia dt_referencia_protocolo, 
	m.ds_convenio, 
	m.ie_tipo_convenio 
FROM convenio m, setor_atendimento c, procedimento b, atend_paciente_unidade h
LEFT OUTER JOIN tipo_acomodacao n ON (h.cd_tipo_acomodacao = n.cd_tipo_acomodacao)
, procedimento_paciente a
LEFT OUTER JOIN pessoa_fisica e ON (a.cd_medico_executor = e.cd_pessoa_fisica)
LEFT OUTER JOIN medico g ON (a.cd_medico_executor = g.cd_pessoa_fisica)
LEFT OUTER JOIN conta_paciente y ON (a.nr_sequencia = y.nr_seq_procedimento)
LEFT OUTER JOIN proc_paciente_valor f ON (a.nr_sequencia = f.nr_seq_procedimento AND 2 = f.ie_tipo_valor)
LEFT OUTER JOIN regra_honorario x ON (a.ie_responsavel_credito = x.cd_regra)
LEFT OUTER JOIN funcao_medico w ON (a.ie_funcao_medico = w.cd_funcao)
LEFT OUTER JOIN protocolo_convenio t ON (y.nr_seq_protocolo = t.nr_seq_protocolo)
WHERE a.cd_procedimento 		= b.cd_procedimento and a.ie_origem_proced 		= b.ie_origem_proced and a.cd_setor_atendimento 		= c.cd_setor_atendimento and a.nr_atendimento			= h.nr_atendimento and a.dt_entrada_unidade		= h.dt_entrada_unidade         and a.nr_interno_conta		= y.nr_interno_conta and a.cd_motivo_exc_conta		is null  and y.cd_convenio_parametro	= m.cd_convenio 
 
union
 
select 
	h.ie_emite_conta, 
	a.nr_interno_conta nr_interno_conta_proc, 
	y.nr_interno_conta, 
	y.ie_cancelamento, 
	a.cd_procedimento, 
	a.ie_origem_proced, 
	a.cd_procedimento_convenio, 
	substr(b.ds_procedimento,0,100), 
	trunc(a.dt_procedimento,'DD') dt_procedimento, 
	a.dt_conta, 
	trunc(a.dt_conta,'DD') dt_conta_dia, 
	a.qt_procedimento, 
	h.vl_participante, 
	h.vl_conta, 
	0, 
	c.cd_setor_atendimento, 
	c.ds_setor_atendimento, 
	substr(Obter_valor_dominio(1,c.cd_classif_setor),1,30) ds_classif_setor, 
	e.nm_pessoa_fisica nm_medico, 
	coalesce(h.vl_original,0), 
	coalesce(f.vl_auxiliares,0), 
	coalesce(f.vl_anestesista,0), 
	coalesce(f.vl_custo_operacional,0) qt_pto_custo_oper, 
	coalesce(f.vl_procedimento,0) qt_pto_procedimento, 
	g.nr_crm, 
	g.nr_crm || calcula_digito('Modulo11',g.nr_crm) nr_crm_dig, 
	100, 
	h.pr_procedimento, 
	h.ie_funcao, 
	i.ds_funcao, 
	a.nr_sequencia, 
	a.nr_seq_proc_pacote, 
	h.ie_responsavel_credito, 
	x.ds_regra ds_responsavel_credito, 
	m.cd_unidade_basica, 
	m.cd_unidade_compl, 
	m.cd_tipo_acomodacao cd_tipo_acomodacao_pac, 
	n.ds_tipo_acomodacao ds_tipo_acomodacao_pac, 
	h.cd_pessoa_fisica cd_medico, 
	a.dt_procedimento dt_item, 
	a.qt_porte_anestesico, 
	a.tx_procedimento pr_via_acesso, 
	a.cd_procedimento_princ, 
	e.nr_cpf nr_cpf_medico, 
	g.cd_cgc cd_cgc_medico, 
	CASE WHEN g.ie_cobra_pf_pj='J' THEN g.cd_cgc  ELSE e.nr_cpf END  cd_cgc_cpf_medico, 
	g.ie_cobra_pf_pj, 
	g.ie_corpo_clinico, 
	g.uf_crm, 
	g.ie_vinculo_medico, 
	a.cd_motivo_exc_conta, 
	h.cd_especialidade, 
	a.cd_cgc_prestador, 
	CASE WHEN h.ie_responsavel_credito='M' THEN CASE WHEN g.ie_cobra_pf_pj='J' THEN g.cd_cgc  ELSE e.nr_cpf END  WHEN h.ie_responsavel_credito='H' THEN a.cd_cgc_prestador WHEN h.ie_responsavel_credito='RM' THEN a.cd_cgc_prestador  ELSE coalesce(x.cd_cgc,a.cd_cgc_prestador) END  cd_cgc_cpf_resp_cred, 
	obter_funcao_medico_convenio(a.cd_convenio,h.ie_funcao,h.cd_especialidade) 
								cd_funcao_espec_med, 
	a.nr_prescricao, 
	a.dt_prescricao, 
	a.nr_seq_autorizacao, 
	a.nr_doc_convenio, 
	y.nr_seq_protocolo, 
	y.nr_atendimento, 
	y.cd_convenio_parametro cd_convenio, 
	y.dt_mesano_referencia, 
	substr(Obter_Proc_Ref(a.nr_seq_proc_princ,'I'),1,8) cd_proc_ref, 
	substr(Obter_Proc_Ref(a.nr_seq_proc_princ,'C'),1,20) cd_proc_ref_conv, 
	h.ie_emite_conta ie_emite_conta_honor, 
	'' ie_emite_conta_hosp, 
	0 vl_filme, 
	coalesce(y.cd_procedimento, coalesce(a.cd_procedimento_convenio,a.cd_procedimento)) cd_proc_convenio, 
	coalesce(y.ds_procedimento, substr(b.ds_procedimento,0,100)) ds_proc_convenio, 
	a.ie_video, 
	(h.pr_procedimento * 100) pr_procedimento, 
	coalesce(h.pr_faturar,a.tx_procedimento) pr_faturado, 
	'S' ie_participante, 
	substr(obter_desc_espec_medica(a.cd_especialidade),1,60) ds_especialidade, 
	h.cd_medico_convenio, 
	coalesce(h.cd_medico_convenio, g.nr_crm) cd_medico_crm_convenio, 
	a.ie_via_acesso, 
	b.cd_tipo_procedimento, 
	b.cd_grupo_proc, 
	a.nr_cirurgia, 
	to_char(dt_conta,'hh24:mi') hr_conta, 
	to_char(dt_procedimento,'hh24:mi') hr_execucao, 
	coalesce(a.tx_hora_extra,1) tx_hora_extra, 
	a.nr_seq_atepacu, 
	t.ie_status_protocolo, 
	t.dt_mesano_referencia dt_referencia_protocolo, 
	m.ds_convenio, 
	m.ie_tipo_convenio 
FROM setor_atendimento c, procedimento b, atend_paciente_unidade m
LEFT OUTER JOIN tipo_acomodacao n ON (m.cd_tipo_acomodacao = n.cd_tipo_acomodacao)
, procedimento_participante h
LEFT OUTER JOIN pessoa_fisica e ON (h.cd_pessoa_fisica = e.cd_pessoa_fisica)
LEFT OUTER JOIN medico g ON (h.cd_pessoa_fisica = g.cd_pessoa_fisica)
LEFT OUTER JOIN funcao_medico i ON (h.ie_funcao = i.cd_funcao)
LEFT OUTER JOIN regra_honorario x ON (h.ie_responsavel_credito = x.cd_regra)
, procedimento_paciente a
LEFT OUTER JOIN conta_paciente y ON (a.nr_sequencia = y.nr_seq_procedimento)
LEFT OUTER JOIN proc_paciente_valor f ON (a.nr_sequencia = f.nr_seq_procedimento AND 2 = f.ie_tipo_valor)
LEFT OUTER JOIN protocolo_convenio t ON (y.nr_seq_protocolo = t.nr_seq_protocolo)
WHERE a.cd_procedimento 		= b.cd_procedimento and a.ie_origem_proced 		= b.ie_origem_proced and a.cd_setor_atendimento 		= c.cd_setor_atendimento and a.nr_atendimento			= m.nr_atendimento and a.dt_entrada_unidade		= m.dt_entrada_unidade    and a.nr_sequencia 			= h.nr_sequencia      and a.nr_interno_conta		= y.nr_interno_conta and a.cd_motivo_exc_conta		is null  and y.cd_convenio_parametro	= m.cd_convenio;
