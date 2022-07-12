-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cv_honorarios_medico_v (nr_atendimento, nr_interno_conta, ds_convenio, cd_medico, nm_medico, dt_procedimento, ds_procedimento, nm_paciente, ie_responsavel_credito, vl_procedimento, vl_medico, vl_custo_operacional, vl_material, cd_setor_atendimento) AS Select	pp.nr_atendimento nr_atendimento,
	pp.nr_interno_conta nr_interno_conta, 
	substr(obter_nome_convenio(pp.cd_convenio),1,255) ds_convenio, 
	pp.cd_medico_executor cd_medico, 
	substr(obter_nome_pf(pp.cd_medico_executor),1,255) nm_medico, 
	pp.dt_procedimento dt_procedimento, 
	substr(obter_descricao_procedimento(pp.cd_procedimento,pp.ie_origem_proced),1,255) ds_procedimento, 
	substr(obter_pessoa_atendimento(pp.nr_atendimento,'N'),1,255) nm_paciente, 
	pp.ie_responsavel_credito ie_responsavel_credito, 
	sum(pp.vl_procedimento) vl_procedimento, 
	sum(pp.vl_medico) vl_medico, 
	sum(pp.vl_custo_operacional) vl_custo_operacional, 
	sum(pp.vl_materiais) vl_material, 
	pp.cd_setor_atendimento 
FROM	procedimento_paciente pp 
where	pp.cd_medico_executor is not null 
and	pp.cd_motivo_exc_conta is null 
group by	pp.nr_atendimento, 
		pp.nr_interno_conta, 
		pp.cd_convenio, 
		pp.cd_medico_executor, 
		pp.dt_procedimento, 
		pp.cd_procedimento, 
		pp.ie_origem_proced, 
		pp.ie_responsavel_credito, 
		pp.cd_setor_atendimento 

union
 
Select	pp.nr_atendimento nr_atendimento, 
	pp.nr_interno_conta nr_interno_conta, 
	substr(obter_nome_convenio(pp.cd_convenio),1,255) ds_convenio, 
	p.cd_pessoa_fisica cd_medico, 
	substr(obter_nome_pf(p.cd_pessoa_fisica),1,255) nm_medico, 
	pp.dt_procedimento dt_procedimento, 
	substr(obter_descricao_procedimento(pp.cd_procedimento,pp.ie_origem_proced),1,255) ds_procedimento, 
	substr(obter_pessoa_atendimento(pp.nr_atendimento,'N'),1,255) nm_paciente, 
	pp.ie_responsavel_credito ie_responsavel_credito, 
	0 vl_procedimento, 
	sum(p.vl_participante) vl_medico, 
	0 vl_custo_operacional, 
	0 vl_material, 
	pp.cd_setor_atendimento 
from	procedimento_paciente pp, 
	procedimento_participante p 
where	pp.nr_sequencia = p.nr_sequencia 
and	pp.cd_motivo_exc_conta is null 
group by	pp.nr_atendimento, 
		pp.nr_interno_conta, 
		pp.cd_convenio, 
		p.cd_pessoa_fisica, 
		pp.dt_procedimento, 
		pp.cd_procedimento, 
		pp.ie_origem_proced, 
		pp.ie_responsavel_credito, 
		pp.cd_setor_atendimento 
order by	nm_medico;
