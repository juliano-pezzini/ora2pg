-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pacientes_transf_v (nr_atendimento, setor_saida, setor_entrada, ds_convenio, ds_paciente, ds_medico, dt_saida_unidade, dt_entrada_unidade, ie_informacao, cd_convenio, cd_pessoa_fisica, cd_medic_resp) AS SELECT	c.nr_atendimento,
	SUBSTR(obter_nome_setor(a.cd_setor_atendimento),1,100) setor_saida,
	SUBSTR(obter_nome_setor(b.cd_setor_atendimento),1,100) setor_entrada,
	SUBSTR(obter_nome_convenio(obter_convenio_atendimento(a.nr_atendimento)),1,200) ds_convenio,
	obter_nome_pf(c.cd_pessoa_fisica) ds_paciente,
	obter_nome_pf(c.cd_medico_resp) ds_medico,
	a.dt_saida_unidade,
	b.dt_entrada_unidade,
	'UI' ie_informacao,
	obter_convenio_atendimento(a.nr_atendimento) cd_convenio,
	c.cd_pessoa_fisica cd_pessoa_fisica,
	c.cd_medico_resp cd_medic_resp
FROM	atend_paciente_unidade a,
	atend_paciente_unidade b,
	atendimento_paciente c
WHERE	a.nr_atendimento = b.nr_atendimento
AND	a.dt_saida_unidade = b.dt_entrada_unidade
AND	c.nr_atendimento = a.nr_atendimento
AND	obter_classif_setor(a.cd_setor_atendimento) = 3
AND	obter_classif_setor(b.cd_setor_atendimento) = 4

union all

SELECT	c.nr_atendimento,
	SUBSTR(obter_nome_setor(a.cd_setor_atendimento),1,100) setor_saida,
	SUBSTR(obter_nome_setor(b.cd_setor_atendimento),1,100) setor_entrada,
	SUBSTR(obter_nome_convenio(obter_convenio_atendimento(a.nr_atendimento)),1,200) ds_convenio,
	SUBSTR(obter_nome_pf(c.cd_pessoa_fisica),1,100) ds_paciente,
	SUBSTR(obter_nome_pf(c.cd_medico_resp),1,100) ds_medico,
	a.dt_saida_unidade,
	b.dt_entrada_unidade,
	'PA' ie_informacao,
	obter_convenio_atendimento(a.nr_atendimento) cd_convenio,
	c.cd_pessoa_fisica cd_pessoa_fisica,
	c.cd_medico_resp cd_medic_resp
FROM	atend_paciente_unidade a,
	atend_paciente_unidade b,
	atendimento_paciente c
WHERE	a.nr_atendimento = b.nr_atendimento
AND	a.dt_saida_unidade = b.dt_entrada_unidade
AND	c.nr_atendimento = a.nr_atendimento
AND	obter_classif_setor(a.cd_setor_atendimento) = 1
AND	obter_classif_setor(b.cd_setor_atendimento) in (3,4);
