-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW controle_proc_terceiro_v (nr_atendimento, nr_sequencia, cd_pessoa_fisica, nr_seq_propaci, nr_seq_partic, vl_producao, dt_producao, vl_recebido, dt_recebido, ds_convenio_conta, ds_convenio, nm_paciente, cd_convenio, cd_procedimento, ie_origem_proced, ds_funcao, ds_procedimento, cd_setor_atendimento, ds_acomodacao, ie_tipo_atendimento, ds_tipo_atendimento, nr_repasse_terceiro, ie_status_repasse, vl_repasse, cd_motivo_exc_conta, ds_motivo_exc_conta, nr_interno_conta, nr_seq_proc_interno, ds_proc_interno, ds_motivo_auditoria, ds_compl_motivo_excon) AS select b.nr_atendimento,
	a.nr_sequencia, 
	a.cd_pessoa_fisica, 
	a.nr_seq_propaci, 
	a.nr_seq_partic, 
	a.vl_producao, 
	a.dt_producao, 
	a.vl_recebido, 
	a.dt_recebido, 
	substr(obter_nome_convenio(obter_conv_conta(b.nr_interno_conta)),1,180) ds_convenio_conta, 
	substr(obter_nome_convenio(obter_convenio_atendimento(b.nr_atendimento)),1,180) ds_convenio, 
	substr(obter_pessoa_atendimento(b.nr_atendimento,'N'),1,200) nm_paciente, 
	substr(obter_convenio_atendimento(b.nr_atendimento),1,255) cd_convenio, 
	b.cd_procedimento, 
	b.ie_origem_proced, 
	substr(obter_funcao_medico(b.ie_funcao_medico),1,255) ds_funcao, 
	c.ds_procedimento, 
	b.cd_setor_atendimento, 
	substr(obter_tipo_acomodacao_atend(b.nr_atendimento,'D'),1,255) ds_acomodacao, 
	d.ie_tipo_atendimento, 
	substr(obter_valor_dominio(12,d.ie_tipo_atendimento),1,255) ds_tipo_atendimento, 
	(select	max(x.nr_repasse_terceiro) 
	FROM	procedimento_repasse x 
	where	x.nr_seq_procedimento	= b.nr_sequencia) nr_repasse_terceiro, 
	(select	max(y.ie_status) 
	from	repasse_terceiro y, 
		procedimento_repasse x 
	where	x.nr_repasse_terceiro	= y.nr_repasse_terceiro 
	and	x.nr_seq_procedimento	= b.nr_sequencia) ie_status_repasse, 
	coalesce((select	coalesce(sum(x.vl_repasse),0) 
	from	procedimento_repasse x 
	where	x.nr_seq_procedimento	= b.nr_sequencia 
	and	x.cd_medico		= a.cd_pessoa_fisica),0) vl_repasse, 
	b.cd_motivo_exc_conta, 
	substr(obter_motivo_exc_conta(b.cd_motivo_exc_conta),1,255) ds_motivo_exc_conta, 
	b.nr_interno_conta, 
	b.nr_seq_proc_interno, 
	substr(Obter_Desc_Proc_Interno(b.nr_seq_proc_interno),1,255) ds_proc_interno, 
	substr(Obter_motivo_auditoria(obter_motivo_audit_item(b.nr_sequencia,b.nr_atendimento,'P')),1,250) ds_motivo_auditoria, 
	substr(b.ds_compl_motivo_excon,1,250) ds_compl_motivo_excon 
from  atendimento_paciente d, 
	procedimento c, 
	procedimento_paciente b, 
	controle_proc_terceiro a 
where  a.nr_seq_propaci  	= b.nr_sequencia 
and	b.cd_procedimento	= c.cd_Procedimento 
and	b.ie_origem_proced	= c.ie_origem_proced 
and	b.nr_atendimento	= d.nr_atendimento 
and	a.nr_seq_partic		is null 

union
 
select c.nr_atendimento, 
	a.nr_sequencia, 
	a.cd_pessoa_fisica, 
	a.nr_seq_propaci, 
	a.nr_seq_partic, 
	a.vl_producao, 
	a.dt_producao, 
	a.vl_recebido, 
	a.dt_recebido, 
	substr(obter_nome_convenio(obter_conv_conta(c.nr_interno_conta)),1,180) ds_convenio_conta, 
	substr(obter_nome_convenio(obter_convenio_atendimento(c.nr_atendimento)),1,180) ds_convenio, 
	substr(obter_pessoa_atendimento(c.nr_atendimento,'N'),1,200) nm_paciente, 
	substr(obter_convenio_atendimento(c.nr_atendimento),1,255) cd_convenio, 
	c.cd_procedimento, 
	c.ie_origem_proced, 
	substr(obter_funcao_medico(b.ie_funcao),1,255) ds_funcao, 
	d.ds_procedimento, 
	c.cd_setor_atendimento, 
	substr(obter_tipo_acomodacao_atend(c.nr_atendimento,'D'),1,255) ds_acomodacao, 
	e.ie_tipo_atendimento, 
	substr(obter_valor_dominio(12,e.ie_tipo_atendimento),1,255) ds_tipo_atendimento, 
	(select	max(x.nr_repasse_terceiro) 
	from	procedimento_repasse x 
	where	x.nr_seq_procedimento	= c.nr_sequencia) nr_repasse_terceiro, 
	(select	max(y.ie_status) 
	from	repasse_terceiro y, 
		procedimento_repasse x 
	where	x.nr_repasse_terceiro	= y.nr_repasse_terceiro 
	and	x.nr_seq_procedimento	= c.nr_sequencia) ie_status_repasse, 
	coalesce((select	coalesce(sum(x.vl_repasse),0) 
	from	procedimento_repasse x 
	where	x.nr_seq_procedimento	= c.nr_sequencia 
	and	x.cd_medico		= a.cd_pessoa_fisica),0) vl_repasse, 
	c.cd_motivo_exc_conta, 
	substr(obter_motivo_exc_conta(c.cd_motivo_exc_conta),1,255) ds_motivo_exc_conta, 
	c.nr_interno_conta, 
	c.nr_seq_proc_interno, 
	substr(Obter_Desc_Proc_Interno(c.nr_seq_proc_interno),1,255) ds_proc_interno, 
	substr(Obter_motivo_auditoria(obter_motivo_audit_item(c.nr_sequencia,c.nr_atendimento,'P')),1,250) ds_motivo_auditoria, 
	substr(c.ds_compl_motivo_excon,1,250) ds_compl_motivo_excon 
from  atendimento_paciente e, 
	procedimento d, 
	procedimento_paciente c, 
	procedimento_participante b, 
	controle_proc_terceiro a 
where  a.nr_seq_propaci  	= b.nr_sequencia 
and	b.nr_sequencia		= c.nr_sequencia 
and	c.cd_procedimento	= d.cd_Procedimento 
and	c.ie_origem_proced	= d.ie_origem_proced 
and	c.nr_atendimento	= e.nr_atendimento 
and	a.nr_seq_partic		= b.nr_seq_partic;

