-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW agenda_autorizada_usuario_v (ie_permissao, cd_tipo_agenda, cd_agenda, cd_perfil, cd_setor_atendimento, cd_especialidade, cd_pessoa_fisica) AS select	1 ie_permissao,
	a.cd_tipo_agenda cd_tipo_agenda,
	a.cd_agenda cd_agenda,
	0 cd_perfil,
	0 cd_setor_atendimento,
	x.cd_especialidade cd_especialidade,
	a.cd_pessoa_fisica cd_pessoa_fisica
FROM pessoa_fisica b, agenda a, medico c
LEFT OUTER JOIN medico_especialidade x ON (c.cd_pessoa_fisica = x.cd_pessoa_fisica)
WHERE a.cd_pessoa_fisica		= b.cd_pessoa_fisica and a.cd_pessoa_fisica  		= c.cd_pessoa_fisica  and coalesce(a.ie_situacao,'A')	= 'A' group by
	1,
	a.cd_tipo_agenda,
	a.cd_agenda,
	0,
	0,
	x.cd_especialidade,
	a.cd_pessoa_fisica

union

select	2 ie_permissao,
	a.cd_tipo_agenda cd_tipo_agenda,
	a.cd_agenda cd_agenda,
	0 cd_perfil,
	0 cd_setor_atendimento,
	x.cd_especialidade cd_especialidade,
	d.cd_pessoa_fisica cd_pessoa_fisica
FROM med_permissao d, pessoa_fisica b, agenda a
LEFT OUTER JOIN medico c ON (a.cd_pessoa_fisica = c.cd_pessoa_fisica)
LEFT OUTER JOIN medico_especialidade x ON (c.cd_pessoa_fisica = x.cd_pessoa_fisica)
WHERE a.cd_pessoa_fisica			= b.cd_pessoa_fisica  and a.cd_pessoa_fisica 			= d.cd_medico_prop and coalesce(d.cd_agenda, a.cd_agenda)	= a.cd_agenda  and d.ie_agenda       			<> 'N' and coalesce(a.ie_situacao,'A') 		= 'A' group by
	2,
	a.cd_tipo_agenda,
	a.cd_agenda,
	0,
	0,
	x.cd_especialidade,
	d.cd_pessoa_fisica

union

select	3 ie_permissao,
	a.cd_tipo_agenda cd_tipo_agenda,
	a.cd_agenda cd_agenda,
	d.cd_perfil cd_perfil,
	0 cd_setor_atendimento,
	x.cd_especialidade cd_especialidade,
	'0' cd_pessoa_fisica
FROM med_permissao d, pessoa_fisica b, agenda a, medico c
LEFT OUTER JOIN medico_especialidade x ON (c.cd_pessoa_fisica = x.cd_pessoa_fisica)
WHERE a.cd_pessoa_fisica 			= b.cd_pessoa_fisica and a.cd_pessoa_fisica 			= c.cd_pessoa_fisica and a.cd_pessoa_fisica 			= d.cd_medico_prop and coalesce(d.cd_agenda, a.cd_agenda)	= a.cd_agenda  and d.ie_agenda       			<> 'N' and coalesce(a.ie_situacao,'A') 		= 'A' group by
	3,
	a.cd_tipo_agenda,
	a.cd_agenda,
	d.cd_perfil,
	0,
	x.cd_especialidade,
	'0'

union

select	4 ie_permissao,
      	a.cd_tipo_agenda cd_tipo_agenda,
	a.cd_agenda cd_agenda,
	0 cd_perfil,
	d.cd_setor_atendimento cd_setor_atendimento,
	x.cd_especialidade cd_especialidade,
	'0' cd_pessoa_fisica
FROM med_permissao d, pessoa_fisica b, agenda a, medico c
LEFT OUTER JOIN medico_especialidade x ON (c.cd_pessoa_fisica = x.cd_pessoa_fisica)
WHERE a.cd_pessoa_fisica			= b.cd_pessoa_fisica and a.cd_pessoa_fisica 			= c.cd_pessoa_fisica and a.cd_pessoa_fisica 			= d.cd_medico_prop and coalesce(d.cd_agenda, a.cd_agenda) 	= a.cd_agenda  and d.ie_agenda       			<> 'N' and coalesce(a.ie_situacao,'A') 		= 'A' group by
	4,
	a.cd_tipo_agenda,
	a.cd_agenda,
	0,
	d.cd_setor_atendimento,
	x.cd_especialidade,
	'0'
order by
	ie_permissao,
	cd_tipo_agenda,
	cd_agenda,
	cd_perfil,
	cd_setor_atendimento,
	cd_especialidade,
	cd_pessoa_fisica;

