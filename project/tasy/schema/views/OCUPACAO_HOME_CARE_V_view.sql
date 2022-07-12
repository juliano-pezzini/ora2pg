-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ocupacao_home_care_v (nr_atendimento, dt_entrada_unidade, cd_unidade, cd_unidade_basica, cd_unidade_compl, nm_pessoa_fisica, cd_pessoa_fisica, cd_setor_atendimento, cd_convenio, nr_seq_apresent, classif, ds_tipo_atendimento, ie_tipo_atendimento, dt_nascimento, dt_entrada, dt_alta, nr_prontuario, nm_medico_resp) AS select	a.nr_atendimento,
	a.dt_entrada_unidade, 
	a.cd_unidade_basica || ' ' || a.cd_unidade_compl cd_unidade, 
	a.cd_unidade_basica, 
	a.cd_unidade_compl, 
	SUBSTR(obter_nome_pf(d.cd_pessoa_fisica),1,100) nm_pessoa_fisica, 
	d.cd_pessoa_fisica, 
	b.cd_setor_atendimento, 
	obter_convenio_atendimento(c.nr_atendimento) cd_convenio, 
	obter_seq_apresent_unidade(a.cd_setor_atendimento, a.cd_unidade_basica, a.cd_unidade_compl) nr_seq_apresent, 
	substr(obter_desc_classif_atend(c.nr_seq_classificacao),1,60) classif, 
	substr(obter_nome_tipo_atend(obter_tipo_atendimento(a.nr_atendimento)),1,255) ds_tipo_atendimento, 
	c.ie_tipo_atendimento, 
	d.dt_nascimento dt_nascimento, 
	c.dt_entrada dt_entrada, 
	c.dt_alta dt_alta, 
	d.nr_prontuario nr_prontuario, 
	obter_dados_medico(c.cd_medico_resp, 'NM') nm_medico_resp 
FROM	pessoa_fisica d, 
	atendimento_paciente c, 
	setor_atendimento b, 
	atend_paciente_unidade a 
where	a.cd_setor_atendimento = b.cd_setor_atendimento 
and	b.cd_classif_setor = 8 
and	a.dt_saida_unidade is null 
and	a.nr_atendimento	= c.nr_atendimento 
and	c.cd_pessoa_fisica	= d.cd_pessoa_fisica 
and	c.dt_alta is null 
and	a.cd_setor_atendimento = obter_unidade_atendimento(a.nr_atendimento,'A','CS');

