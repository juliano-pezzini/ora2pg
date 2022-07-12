-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_prim_prescr_mat_hor_gpt ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, cd_estabelecimento_p bigint ) RETURNS timestamp AS $body$
DECLARE


dt_primeiro_horario_w	timestamp;
dt_inicio_prescricao_w	timestamp;
ie_tipo_usuario_w	varchar(1);

				

BEGIN

ie_tipo_usuario_w := substr(obter_valor_param_usuario(252, 1, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, 0), 1, 1);

dt_inicio_prescricao_w	:= (clock_timestamp() - interval '7 days');

select	min(c.dt_horario)
into STRICT	dt_primeiro_horario_w
from	prescr_medica a,
		prescr_material b,
		prescr_mat_hor c
where	a.nr_prescricao = b.nr_prescricao
and		b.nr_prescricao = c.nr_prescricao
and		b.nr_sequencia	= c.nr_seq_material
and		(a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '')
and		coalesce(c.dt_suspensao::text, '') = ''
and		coalesce(a.dt_suspensao::text, '') = ''
and		b.ie_agrupador in (1,4)
and		a.cd_funcao_origem not in (924,950)
and		coalesce(a.nr_seq_atend::text, '') = ''
and 	a.dt_prescricao 	> dt_inicio_prescricao_w
and		a.nr_atendimento 	= nr_atendimento_p
and		a.cd_pessoa_fisica 	= cd_pessoa_fisica_p
and		((ie_tipo_usuario_w = 'E' and coalesce(a.dt_liberacao::text, '') = '')
		or (ie_tipo_usuario_w = 'F' and coalesce(a.dt_liberacao_farmacia::text, '') = ''));

if (coalesce(dt_primeiro_horario_w::text, '') = '') then
	
	select	min(c.dt_horario)
	into STRICT	dt_primeiro_horario_w
	from	prescr_medica a,
			prescr_material b,
			prescr_mat_hor c
	where	a.nr_prescricao = b.nr_prescricao
	and		b.nr_prescricao = c.nr_prescricao
	and		b.nr_sequencia	= c.nr_seq_material
	and		(a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '')
	and		coalesce(c.dt_suspensao::text, '') = ''
	and		coalesce(a.dt_suspensao::text, '') = ''
	and		b.ie_agrupador in (1,4)
	and		a.cd_funcao_origem not in (924,950)
	and		coalesce(a.nr_seq_atend::text, '') = ''
	and 	a.dt_prescricao 	> dt_inicio_prescricao_w
	and		coalesce(a.nr_atendimento::text, '') = ''
	and		a.cd_pessoa_fisica 	= cd_pessoa_fisica_p
	and		((ie_tipo_usuario_w = 'E' and coalesce(a.dt_liberacao::text, '') = '')
			or (ie_tipo_usuario_w = 'F' and coalesce(a.dt_liberacao_farmacia::text, '') = ''));

end if;

return	dt_primeiro_horario_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_prim_prescr_mat_hor_gpt ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, cd_estabelecimento_p bigint ) FROM PUBLIC;

