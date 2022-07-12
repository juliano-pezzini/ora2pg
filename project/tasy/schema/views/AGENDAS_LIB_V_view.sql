-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW agendas_lib_v (cd_agenda, cd_especialidade, cd_espec_x, ie_classificacao) AS select	a.cd_agenda,
	a.cd_especialidade,
	x.cd_especialidade cd_espec_x,
	ie_classificacao
FROM pessoa_fisica b, agenda a, medico c
LEFT OUTER JOIN medico_especialidade x ON (c.cd_pessoa_fisica = x.cd_pessoa_fisica)
WHERE a.cd_pessoa_fisica = b.cd_pessoa_fisica and a.cd_pessoa_fisica = c.cd_pessoa_fisica  and a.cd_pessoa_fisica = obter_pessoa_fisica_usuario(obter_usuario_ativo,'C') and a.cd_tipo_agenda = 3 and coalesce(a.ie_situacao,'A') = 'A' and ((a.cd_estabelecimento in (
		select	x.cd_estabelecimento
		from	usuario_estabelecimento_v x
		where	x.nm_usuario = obter_usuario_ativo
		and 	obter_parametro_funcao(821,1,obter_usuario_ativo) = 'N'))
		or	 (((a.cd_estabelecimento = obter_estabelecimento_ativo) or (obter_estabelecimento_ativo = 0))
		and 	coalesce(obter_parametro_funcao(821,1,obter_usuario_ativo),'S') = 'S'))

union

select	a.cd_agenda,
	a.cd_especialidade,
	x.cd_especialidade cd_espec_x,
	ie_classificacao
FROM med_permissao d, pessoa_fisica b, agenda a
LEFT OUTER JOIN medico c ON (a.cd_pessoa_fisica = c.cd_pessoa_fisica)
LEFT OUTER JOIN medico_especialidade x ON (c.cd_pessoa_fisica = x.cd_pessoa_fisica)
WHERE a.cd_pessoa_fisica = b.cd_pessoa_fisica  and a.cd_pessoa_fisica = d.cd_medico_prop and coalesce(d.cd_agenda,a.cd_agenda) = a.cd_agenda  and d.cd_pessoa_fisica = obter_pessoa_fisica_usuario(obter_usuario_ativo,'C') and d.ie_agenda <> 'N' and a.cd_tipo_agenda = 3 and coalesce(a.ie_situacao,'A') = 'A' and ((a.cd_estabelecimento in (
		select	x.cd_estabelecimento
		from	usuario_estabelecimento_v x
		where	x.nm_usuario = obter_usuario_ativo
		and 	obter_parametro_funcao(821,1,obter_usuario_ativo) = 'N'))
		or	 (((a.cd_estabelecimento = obter_estabelecimento_ativo) or (obter_estabelecimento_ativo = 0))
		and 	coalesce(obter_parametro_funcao(821,1,obter_usuario_ativo),'S') = 'S'))
 
union

select	a.cd_agenda,
	a.cd_especialidade,
	x.cd_especialidade cd_espec_x,
	ie_classificacao
FROM med_permissao d, pessoa_fisica b, agenda a, medico c
LEFT OUTER JOIN medico_especialidade x ON (c.cd_pessoa_fisica = x.cd_pessoa_fisica)
WHERE a.cd_pessoa_fisica = b.cd_pessoa_fisica and a.cd_pessoa_fisica = c.cd_pessoa_fisica and a.cd_pessoa_fisica = d.cd_medico_prop and coalesce(d.cd_agenda,a.cd_agenda) = a.cd_agenda  and d.cd_perfil = obter_perfil_ativo and d.ie_agenda <> 'N' and a.cd_tipo_agenda = 3 and coalesce(a.ie_situacao,'A') = 'A' and ((a.cd_estabelecimento in (
		select	x.cd_estabelecimento
		from	usuario_estabelecimento_v x
		where	x.nm_usuario = obter_usuario_ativo
		and 	obter_parametro_funcao(821,1,obter_usuario_ativo) = 'N'))
		or	 (((a.cd_estabelecimento = obter_estabelecimento_ativo) or (obter_estabelecimento_ativo = 0))
		and 	coalesce(obter_parametro_funcao(821,1,obter_usuario_ativo),'S') = 'S')) and d.cd_pessoa_fisica is null and not exists (
		select	1
		from	med_permissao y
		where	y.cd_agenda = a.cd_agenda
		and	y.cd_pessoa_fisica = obter_pessoa_fisica_usuario(obter_usuario_ativo,'C'))
 
union

select	a.cd_agenda,
	a.cd_especialidade,
	x.cd_especialidade cd_espec_x,
	ie_classificacao
FROM med_permissao d, pessoa_fisica b, agenda a, medico c
LEFT OUTER JOIN medico_especialidade x ON (c.cd_pessoa_fisica = x.cd_pessoa_fisica)
WHERE a.cd_pessoa_fisica = b.cd_pessoa_fisica and a.cd_pessoa_fisica = c.cd_pessoa_fisica and a.cd_pessoa_fisica = d.cd_medico_prop and coalesce(d.cd_agenda, a.cd_agenda) = a.cd_agenda  and d.cd_setor_atendimento = obter_setor_usuario(obter_usuario_ativo) and d.ie_agenda <> 'N' and a.cd_tipo_agenda = 3 and coalesce(a.ie_situacao,'A') = 'A' and ((a.cd_estabelecimento in (
		select	x.cd_estabelecimento
		from	usuario_estabelecimento_v x
		where	x.nm_usuario = obter_usuario_ativo
		and 	obter_parametro_funcao(821,1,obter_usuario_ativo) = 'N'))
		or	 (((a.cd_estabelecimento = obter_estabelecimento_ativo) or (obter_estabelecimento_ativo = 0))
		and 	coalesce(obter_parametro_funcao(821,1,obter_usuario_ativo),'S') = 'S')) and not exists (
		select	1
		from	agenda y,
			med_permissao x
		where	x.cd_medico_prop = d.cd_medico_prop
		and	x.cd_perfil = obter_perfil_ativo
		and	x.ie_agenda <> 'N'
		and	coalesce(x.cd_agenda, y.cd_agenda) = y.cd_agenda
		and	y.cd_agenda = a.cd_agenda)
 
union

select	a.cd_agenda,
	a.cd_especialidade,
	x.cd_especialidade cd_espec_x,
	ie_classificacao
FROM med_permissao d, agenda a
LEFT OUTER JOIN medico_especialidade x ON (a.cd_pessoa_fisica = x.cd_pessoa_fisica)
WHERE a.cd_agenda = d.cd_agenda and d.ie_agenda <> 'N'  and a.cd_tipo_agenda = 3 and coalesce(a.ie_situacao,'A') = 'A' and ((a.cd_estabelecimento in (
		select	x.cd_estabelecimento
		from	usuario_estabelecimento_v x
		where	x.nm_usuario = obter_usuario_ativo
		and 	obter_parametro_funcao(821,1,obter_usuario_ativo) = 'N'))
		or	 (((a.cd_estabelecimento = obter_estabelecimento_ativo) or (obter_estabelecimento_ativo = 0))
		and 	coalesce(obter_parametro_funcao(821,1,obter_usuario_ativo),'S') = 'S')) and d.cd_perfil = obter_perfil_ativo and not exists (
		select	1
		from	medico z
		where	z.cd_pessoa_fisica = a.cd_pessoa_fisica);

