-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW relatorio_diagnostico_v (cd_doenca_cid, ds_doenca_cid, cd_medico, dt_diagnostico, cd_motivo_alta, cd_pessoa_fisica, dt_nascimento, ie_sexo, nr_atendimento, ie_tipo_atendimento, ie_carater_inter_sus, cd_estabelecimento, cd_setor_atendimento, ds_diagnostico, dt_entrada, dt_alta, nm_paciente, nr_prontuario, nr_crm) AS select	t.cd_doenca_cid,
	t.ds_doenca_cid,
	g.cd_medico,
	d.dt_diagnostico,
	a.cd_motivo_alta,
	p.cd_pessoa_fisica,
	p.dt_nascimento,
	p.ie_sexo,
	d.nr_atendimento,
	a.ie_tipo_atendimento,
	a.ie_carater_inter_sus,
	a.cd_estabelecimento,
	0 cd_setor_atendimento,
	d.ds_diagnostico,
	a.dt_entrada,
	a.dt_alta,
	p.nm_pessoa_fisica nm_paciente,
	p.nr_prontuario,
	m.nr_crm
FROM	medico m,
	pessoa_fisica p,
	cid_doenca t,
	diagnostico_medico g,
	atendimento_paciente a,
	diagnostico_doenca d
where	d.nr_atendimento = g.nr_atendimento
and	d.dt_diagnostico = g.dt_diagnostico
and	d.nr_atendimento = a.nr_atendimento
and	d.cd_doenca = t.cd_doenca_cid
and	g.cd_medico = m.cd_pessoa_fisica
and	a.cd_pessoa_fisica = p.cd_pessoa_fisica
and	not exists (	select	w.cd_setor_atendimento
			from	atend_paciente_unidade w
			where	1 = 1
			and	w.nr_atendimento = a.nr_atendimento)

union

select	t.cd_doenca_cid,
	t.ds_doenca_cid,
	g.cd_medico,
	d.dt_diagnostico,
	a.cd_motivo_alta,
	p.cd_pessoa_fisica,
	p.dt_nascimento,
	p.ie_sexo,
	d.nr_atendimento,
	a.ie_tipo_atendimento,
	a.ie_carater_inter_sus,
	a.cd_estabelecimento,
	w.cd_setor_atendimento,
	d.ds_diagnostico,
	a.dt_entrada,
	a.dt_alta,
	p.nm_pessoa_fisica nm_paciente,
	p.nr_prontuario,
	m.nr_crm
from	medico m,
	pessoa_fisica p,
	cid_doenca t,
	diagnostico_medico g,
	atendimento_paciente a,
	diagnostico_doenca d,
	atend_paciente_unidade w
where	d.nr_atendimento = g.nr_atendimento
and	d.dt_diagnostico = g.dt_diagnostico
and	d.nr_atendimento = a.nr_atendimento
and	w.nr_atendimento = a.nr_atendimento
and	d.cd_doenca = t.cd_doenca_cid
and	g.cd_medico = m.cd_pessoa_fisica
and	a.cd_pessoa_fisica = p.cd_pessoa_fisica;

