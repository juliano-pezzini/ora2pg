-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW laudo_hemod_cirurgia_v (cd_procedimento, ds_procedimento, nr_atendimento, cd_pessoa_fisica, nr_prescricao, cd_convenio, ds_convenio, cd_categoria, ds_categoria, dt_inicio_real, dt_termino, cd_medico_cirurgiao, nm_medico, dt_nascimento, nr_cpf, nr_identidade, nm_pessoa_fisica, nr_sequencia, cd_medico_referido, ie_sexo, cd_estabelecimento) AS select 	b.cd_procedimento,
	substr(obter_desc_prescr_proc(b.cd_procedimento,b.ie_origem_proced, b.nr_seq_proc_interno),1,240) ds_procedimento, 
	c.nr_atendimento, 
	c.cd_pessoa_fisica, 
	a.nr_prescricao, 
	a.cd_convenio, 
	substr(obter_nome_convenio(a.cd_convenio),1,200) ds_convenio, 
	a.cd_categoria, 
	substr(obter_categoria_convenio(a.cd_convenio,a.cd_categoria),1,200) ds_categoria, 
	a.dt_inicio_real, 
	a.dt_termino, 
	a.cd_medico_cirurgiao, 
	substr(obter_nome_medico(cd_medico_cirurgiao,'N'),1,200) nm_medico, 
	d.dt_nascimento, 
	d.nr_cpf, 
	d.nr_identidade, 
	d.nm_pessoa_fisica, 
	b.nr_sequencia, 
	c.cd_medico_referido, 
	d.ie_sexo, 
	c.cd_estabelecimento 
FROM  cirurgia a, 
	atendimento_paciente c, 
	procedimento_paciente b, 
	pessoa_fisica d 
where  a.nr_cirurgia = b.nr_cirurgia 
and   c.nr_atendimento = b.nr_atendimento 
and   c.cd_pessoa_fisica = d.cd_pessoa_fisica;
