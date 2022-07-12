-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW prescr_material_pendente_v3 (nr_prescricao, dt_prescricao, nr_atendimento, dt_primeiro_horario, nm_medico, nm_paciente, nr_itens, nr_itens_urgentes, ie_item_urgente, dt_liberacao, dt_liberacao_medico, dt_liberacao_farmacia, ie_lib_farm, dt_emissao_farmacia, nm_usuario, nm_usuario_original, cd_setor_atendimento, ds_setor_atendimento, cd_local_estoque, cd_local_material, dt_emissao_setor_atend, cd_estabelecimento, nr_prontuario, nr_cirurgia) AS select	a.nr_prescricao,
	a.dt_prescricao,
	a.nr_atendimento,
	a.dt_primeiro_horario,
	m.nm_pessoa_fisica nm_medico,
	p.nm_pessoa_fisica nm_paciente,
	count(*) nr_itens,
	sum(CASE WHEN b.ie_urgencia='S' THEN 1  ELSE 0 END ) nr_itens_urgentes,
	max(CASE WHEN b.ie_urgencia='S' THEN 1  ELSE 0 END ) ie_item_urgente,
	a.dt_liberacao,
	a.dt_liberacao_medico,
	a.dt_liberacao_farmacia,
	a.ie_lib_farm,
	a.dt_emissao_farmacia,
	a.nm_usuario,
	a.nm_usuario_original,
	a.cd_setor_atendimento,
	s.ds_setor_atendimento,
	s.cd_local_estoque,
	b.cd_local_estoque cd_local_material,
	b.dt_emissao_setor_atend dt_emissao_setor_atend,
	a.cd_estabelecimento,
	p.nr_prontuario,
	a.nr_cirurgia
FROM	setor_atendimento s,
	pessoa_fisica m,
	Pessoa_fisica p,
	prescr_medica a,
	prescr_material b
where	a.nr_prescricao		= b.nr_prescricao
and	b.cd_motivo_baixa	= 0
and	b.ie_medicacao_paciente	= 'N'
and	a.cd_setor_atendimento	= s.cd_setor_atendimento
and	a.cd_setor_atendimento	is not null
and	b.ie_suspenso		= 'N'
and	a.dt_suspensao		is null
and	a.cd_medico		= m.cd_pessoa_fisica
and	a.cd_pessoa_fisica	= p.cd_pessoa_fisica
and	b.cd_local_estoque	= 1
and	a.nr_cirurgia		is null
and     a.dt_liberacao between LOCALTIMESTAMP - interval '5 days' and LOCALTIMESTAMP
and not exists (	select 1 from prescr_emissao_local x where x.nr_prescricao = a.nr_prescricao)
group by
	a.nr_prescricao,
	a.dt_prescricao,
	a.nr_atendimento,
	a.dt_primeiro_horario,
	p.nm_pessoa_fisica,
	m.nm_pessoa_fisica,
	a.dt_liberacao,
	a.dt_liberacao_medico,
	a.dt_liberacao_farmacia,
	a.ie_lib_farm,
	a.dt_emissao_farmacia,
	a.nm_usuario,
	a.nm_usuario_original,
	a.cd_setor_atendimento,
	s.cd_local_estoque,
	s.ds_setor_atendimento,
	b.cd_local_estoque,
	b.dt_emissao_setor_atend,
	a.cd_estabelecimento,
	a.nr_cirurgia,
	p.nr_prontuario,
	a.IE_ORIGEM_INF

union all

select	a.nr_prescricao,
	a.dt_prescricao,
	a.nr_atendimento,
	a.dt_primeiro_horario,
	m.nm_pessoa_fisica nm_medico,
	p.nm_pessoa_fisica nm_paciente,
	count(*) nr_itens,
	sum(CASE WHEN b.ie_urgencia='S' THEN 1  ELSE 0 END ) nr_itens_urgentes,
	max(CASE WHEN b.ie_urgencia='S' THEN 1  ELSE 0 END ) ie_item_urgente,
	a.dt_liberacao,
	a.dt_liberacao_medico,
	a.dt_liberacao_farmacia,
	a.ie_lib_farm,
	a.dt_emissao_farmacia,
	a.nm_usuario,
	a.nm_usuario_original,
	a.cd_setor_atendimento,
	'' ds_setor_atendimento,
	null cd_local_estoque,
	b.cd_local_estoque cd_local_material,
	b.dt_emissao_setor_atend dt_emissao_setor_atend,
	a.cd_estabelecimento,
	p.nr_prontuario,
	a.nr_cirurgia
from	pessoa_fisica m,
	Pessoa_fisica p,
	prescr_medica a,
	prescr_material b
where	a.nr_prescricao		= b.nr_prescricao
and	b.cd_motivo_baixa	= 0
and	b.ie_medicacao_paciente	= 'N'
and	a.cd_setor_atendimento	is null
and	b.ie_suspenso		= 'N'
and	a.dt_suspensao		is null
and	a.cd_medico		= m.cd_pessoa_fisica
and	a.cd_pessoa_fisica	= p.cd_pessoa_fisica
and	b.cd_local_estoque	= 1
and	a.nr_cirurgia		is null
and     a.dt_liberacao between LOCALTIMESTAMP - interval '5 days' and LOCALTIMESTAMP
and not exists (	select 1 from prescr_emissao_local x where x.nr_prescricao = a.nr_prescricao)
group by
	a.nr_prescricao,
	a.dt_prescricao,
	a.nr_atendimento,
	a.dt_primeiro_horario,
	p.nm_pessoa_fisica,
	m.nm_pessoa_fisica,
	a.dt_liberacao,
	a.dt_liberacao_medico,
	a.dt_liberacao_farmacia,
	a.ie_lib_farm,
	a.dt_emissao_farmacia,
	a.nm_usuario,
	a.nm_usuario_original,
	a.cd_setor_atendimento,
	b.cd_local_estoque,
	a.nr_cirurgia,
	b.dt_emissao_setor_atend,
	a.cd_estabelecimento,
	p.nr_prontuario,
	a.IE_ORIGEM_INF;

