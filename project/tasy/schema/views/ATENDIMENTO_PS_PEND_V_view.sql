-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW atendimento_ps_pend_v (nr_atendimento, dt_entrada, cd_pessoa_fisica, nm_pessoa_fisica, nm_guerra, cd_medico_resp, cd_estabelecimento, ds_sintoma_paciente, cd_setor_atendimento, cd_unidade, ds_setor_atendimento, dt_nascimento, ds_idade, nr_telefone, hr_medicacao, hr_lib_medico, hr_inicio_consulta, hr_fim_consulta, hr_enfermagem, ds_unidade, ds_anotacao, qt_prescricao) AS select
	a.nr_atendimento, 
	a.dt_entrada, 
	a.cd_pessoa_fisica, 
	p.nm_pessoa_fisica, 
	substr(obter_nome_medico(cd_medico_resp,'G'),1,60) nm_guerra, 
	a.cd_medico_resp, 
	a.cd_estabelecimento, 
	a.ds_sintoma_paciente, 
	b.cd_setor_atendimento, 
	b.cd_unidade_basica || ' ' ||b.cd_unidade_compl cd_unidade, 
	s.ds_setor_atendimento, 
	p.dt_nascimento, 
	substr(obter_idade(p.dt_nascimento, LOCALTIMESTAMP, 'S'),1,15) ds_idade, 
	p.nr_telefone_celular nr_telefone, 
	to_char(a.dt_medicacao,'hh24:mi') hr_medicacao, 
	to_char(a.dt_lib_medico,'hh24:mi') hr_lib_medico, 
	to_char(a.dt_atend_medico,'hh24:mi') hr_inicio_consulta, 
	to_char(a.dt_fim_consulta,'hh24:mi') hr_fim_consulta, 
	to_char(a.dt_inicio_atendimento,'hh24:mi') hr_enfermagem, 
	substr(obter_unidade_atendimento(a.nr_atendimento,'A','U'),1,20) ds_unidade, 
	substr(obter_anotacao_pendente(a.nr_atendimento),1,255) ds_anotacao, 
	Obter_qt_prescr_Atend(a.nr_atendimento) qt_prescricao	 
FROM	pessoa_fisica p, 
	setor_atendimento s, 
	atend_paciente_unidade b, 
	atendimento_paciente a 
where	a.nr_atendimento = b.nr_atendimento 
and	b.nr_seq_interno = obter_atepacu_paciente(a.nr_atendimento, 'A') 
and	b.cd_setor_atendimento	= s.cd_setor_atendimento 
and	a.cd_pessoa_fisica		= p.cd_pessoa_fisica 
and	a.dt_alta_interno > LOCALTIMESTAMP 
and	a.dt_entrada	> LOCALTIMESTAMP - interval '7 days' 
and	a.dt_alta is null 
and	s.cd_classif_setor	= 1;
