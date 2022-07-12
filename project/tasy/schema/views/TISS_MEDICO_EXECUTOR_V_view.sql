-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tiss_medico_executor_v (ds_versao, nm_medico_executor, uf_crm, sg_conselho, cd_medico_executor, nr_crm, nr_cpf, cd_cbo_saude, cd_cnes, nr_seq_procedimento, nr_seq_partic, cd_especialidade, cd_medico_convenio) AS select	'2.01.01' ds_versao,
	substr(TISS_ELIMINAR_CARACTERE(a.nm_pessoa_fisica),1,100) nm_medico_executor, 
	b.uf_crm, 
	c.sg_conselho, 
	a.cd_pessoa_fisica cd_medico_executor, 
	b.nr_crm, 
	a.nr_cpf, 
	substr(TISS_OBTER_CBOS_MEDICO(e.cd_medico_executor, e.cd_especialidade, tiss_obter_versao(f.cd_convenio_parametro, f.cd_estabelecimento,f.dt_mesano_referencia), f.cd_convenio_parametro),1,20) cd_cbo_saude, 
	a.cd_cnes, 
	e.nr_sequencia nr_seq_procedimento, 
	(null)::numeric  nr_seq_partic, 
	e.cd_especialidade, 
	substr(obter_medico_convenio(f.cd_estabelecimento, b.cd_pessoa_fisica, f.cd_convenio_parametro, null, null, null, null,dt_procedimento, null, e.ie_funcao_medico, null),1,20) cd_medico_convenio 
FROM conta_paciente f, procedimento_paciente e, pessoa_fisica a
LEFT OUTER JOIN conselho_profissional c ON (a.nr_seq_conselho = c.nr_sequencia)
LEFT OUTER JOIN cbo_saude d ON (a.nr_seq_cbo_saude = d.nr_sequencia)
LEFT OUTER JOIN medico b ON (a.cd_pessoa_fisica = b.cd_pessoa_fisica)
WHERE e.cd_medico_executor	= a.cd_pessoa_fisica and f.nr_interno_conta	= e.nr_interno_conta    
union
 
select	'2.01.01' ds_versao, 
	substr(TISS_ELIMINAR_CARACTERE(a.nm_pessoa_fisica),1,100) nm_medico_executor, 
	b.uf_crm, 
	c.sg_conselho, 
	a.cd_pessoa_fisica cd_medico_executor, 
	b.nr_crm, 
	a.nr_cpf, 
	substr(TISS_OBTER_CBOS_MEDICO(f.cd_pessoa_fisica, f.cd_especialidade, tiss_obter_versao(g.cd_convenio_parametro, g.cd_estabelecimento,g.dt_mesano_referencia), g.cd_convenio_parametro),1,20) cd_cbo_saude, 
	a.cd_cnes, 
	f.nr_sequencia nr_seq_procedimento, 
	f.nr_seq_partic, 
	f.cd_especialidade, 
	substr(obter_medico_convenio(g.cd_estabelecimento, b.cd_pessoa_fisica, g.cd_convenio_parametro, null, null, null, null,dt_procedimento, null, f.ie_funcao, null),1,20) cd_medico_convenio 
FROM procedimento_paciente h, conta_paciente g, procedimento_participante f, pessoa_fisica a
LEFT OUTER JOIN medico b ON (a.cd_pessoa_fisica = b.cd_pessoa_fisica)
LEFT OUTER JOIN conselho_profissional c ON (a.nr_seq_conselho = c.nr_sequencia)
LEFT OUTER JOIN cbo_saude d ON (a.nr_seq_cbo_saude = d.nr_sequencia)
WHERE g.nr_interno_conta	= h.nr_interno_conta and h.nr_sequencia	= f.nr_sequencia and f.cd_pessoa_fisica	= a.cd_pessoa_fisica;

