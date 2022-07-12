-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW sus_ato_medico_unif_v (vl_medico, vl_ponto_sp, nm_medico, nr_interno_conta, nr_atendimento, nr_seq_protocolo, nr_aih, cd_medico, dt_procedimento, dt_entrada, dt_alta, cd_procedimento, ds_procedimento, qt_ato_medico, cd_setor_atendimento, ds_setor_atendimento, vl_custo_operacional, vl_materiais, qt_procedimento, nr_seq_forma_org, nr_seq_subgrupo, nr_seq_grupo, ie_funcao_medico, ie_responsavel_credito) AS select	sum(a.vl_medico) vl_medico,
	sum(c.vl_ponto_sp) vl_ponto_sp, 
	substr(obter_nome_medico(a.cd_medico_executor,'NC'),1,150) nm_medico, 
	a.nr_interno_conta, 
	a.nr_atendimento, 
	b.nr_seq_protocolo, 
	Sus_Obter_AihUnif_Conta(a.nr_interno_conta) nr_aih, 
	a.cd_medico_executor cd_medico, 
	a.dt_procedimento, 
	d.dt_entrada, 
	d.dt_alta, 
	a.cd_procedimento, 
	substr(obter_descricao_procedimento(a.cd_procedimento,a.ie_origem_proced),1,240) ds_procedimento, 
	sum(c.qt_ato_medico) qt_ato_medico, 
	a.cd_setor_atendimento, 
	substr(obter_nome_setor(a.cd_setor_atendimento),1,150) ds_setor_atendimento, 
	sum(a.vl_custo_operacional) vl_custo_operacional, 
	sum(a.vl_materiais) vl_materiais, 
	sum(a.qt_procedimento) qt_procedimento, 
	e.nr_seq_forma_org, 
	e.nr_seq_subgrupo, 
	e.nr_seq_grupo, 
	a.ie_funcao_medico, 
	a.ie_responsavel_credito 
FROM	atendimento_paciente d, 
	procedimento_paciente a, 
	sus_valor_proc_paciente c, 
	Sus_Estrutura_Procedimento_v e, 
	conta_paciente b 
where	a.nr_interno_conta		= b.nr_interno_conta 
and	d.nr_atendimento		= b.nr_atendimento 
and	c.nr_sequencia			= a.nr_sequencia 
and	e.cd_procedimento		= a.cd_procedimento 
and	e.ie_origem_proced		= a.ie_origem_proced 
and	a.cd_motivo_exc_conta is null 
and	a.ie_origem_proced		= 7 
group by a.nr_interno_conta, 
	a.nr_atendimento, 
	a.cd_medico_executor, 
	b.nr_seq_protocolo, 
	a.dt_procedimento, 
	d.dt_entrada, 
	d.dt_alta, 
	a.cd_procedimento, 
	a.ie_origem_proced, 
	a.cd_setor_atendimento, 
	e.nr_seq_forma_org, 
	e.nr_seq_subgrupo, 
	e.nr_seq_grupo, 
	a.ie_funcao_medico, 
	a.ie_responsavel_credito 

union
 
select	sum(c.vl_participante) vl_medico, 
	sum(c.vl_ponto_sus) vl_ponto_sp, 
	substr(obter_nome_medico(c.cd_pessoa_fisica,'NC'),1,150) nm_medico, 
	a.nr_interno_conta, 
	a.nr_atendimento, 
	b.nr_seq_protocolo, 
	sus_Obter_AihUnif_Conta(a.nr_interno_conta) nr_aih, 
	c.cd_pessoa_fisica cd_medico, 
	a.dt_procedimento, 
	d.dt_entrada, 
	d.dt_alta, 
	a.cd_procedimento, 
	substr(obter_descricao_procedimento(a.cd_procedimento,a.ie_origem_proced),1,240) ds_procedimento, 
	sum(c.vl_ponto_sus) qt_ato_medico, 
	a.cd_setor_atendimento, 
	substr(obter_nome_setor(a.cd_setor_atendimento),1,150) ds_setor_atendimento, 
	0 vl_custo_operacional, 
	0 vl_materiais, 
	sum(a.qt_procedimento) qt_procedimento, 
	e.nr_seq_forma_org, 
	e.nr_seq_subgrupo, 
	e.nr_seq_grupo, 
	c.ie_funcao ie_funcao_medico, 
	c.ie_responsavel_credito	 
from	atendimento_paciente d, 
	procedimento_paciente a, 
	procedimento_participante c, 
	Sus_Estrutura_Procedimento_v e, 
	conta_paciente b 
where	a.nr_interno_conta		= b.nr_interno_conta 
and	d.nr_atendimento		= b.nr_atendimento 
and	a.nr_sequencia			= c.nr_sequencia 
and	e.cd_procedimento		= a.cd_procedimento 
and	e.ie_origem_proced		= a.ie_origem_proced 
and	a.cd_motivo_exc_conta is null 
and	a.ie_origem_proced		= 7 
group by c.cd_pessoa_fisica, 
	a.nr_interno_conta, 
	a.nr_atendimento, 
	b.nr_seq_protocolo, 
	a.dt_procedimento, 
	a.dt_procedimento, 
	d.dt_entrada, 
	d.dt_alta, 
	a.cd_procedimento, 
	a.ie_origem_proced, 
	a.cd_setor_atendimento, 
	e.nr_seq_forma_org, 
	e.nr_seq_subgrupo, 
	e.nr_seq_grupo, 
	c.ie_funcao, 
	c.ie_responsavel_credito;
