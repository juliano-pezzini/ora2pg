-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION plt_obter_prescr_nao_liberada ( nr_atendimento_p bigint, ie_opcao_p text, cd_estabelecimento_p bigint, nm_usuario_p text, dt_setor_atendimento_p timestamp, cd_pessoa_fisica_p text, cd_perfil_p bigint, cd_setor_atendimento_p bigint default null) RETURNS bigint AS $body$
DECLARE

/*
ie_opcao_p
-L = Liberar
-I = Incluir item
-E = Estendida Pendente
*/
nr_prescricao_w			bigint;
cd_setor_w				bigint;
ie_libera_vencida_w		varchar(1);
hr_prim_hor_w			timestamp;
dt_inicio_w				timestamp;
dt_inicial_setor_w		timestamp;
dt_final_setor_w		timestamp;
cd_classif_setor_w		varchar(2);
cd_pessoa_fisica_w		varchar(10);
nr_atendimento_w		bigint;
qt_hor_passada_w		bigint;


BEGIN
ie_libera_vencida_w := obter_param_usuario(950, 33, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_libera_vencida_w);
qt_hor_passada_w := obter_param_usuario(950, 104, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, qt_hor_passada_w);

dt_inicial_setor_w	:= (dt_setor_atendimento_p - 1) + 1/86400;
dt_final_setor_w	:= dt_setor_atendimento_p;

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	cd_pessoa_fisica_w	:= coalesce(obter_pessoa_atendimento(nr_atendimento_p,'C'),cd_pessoa_fisica_p);
	nr_atendimento_w	:= nr_atendimento_p;
else
	cd_pessoa_fisica_w	:= cd_pessoa_fisica_p;
	select	max(a.nr_atendimento)
	into STRICT	nr_atendimento_w
	from	atendimento_paciente a
	where	a.cd_pessoa_fisica	= cd_pessoa_fisica_w
	and		coalesce(a.dt_alta::text, '') = ''
	and		exists (	SELECT	1
						from 	atend_paciente_unidade x
						where 	a.nr_atendimento = x.nr_atendimento);
end if;

cd_setor_w := cd_setor_atendimento_p;
if (coalesce(cd_setor_atendimento_p::text, '') = '') then
	cd_setor_w := obter_setor_atendimento(nr_atendimento_w);
end if;

select	max(Obter_Prim_Horario_Prescricao(nr_atendimento_w, cd_setor_atendimento, clock_timestamp(), nm_usuario_p, 'P')),
		max(cd_classif_setor)
into STRICT	hr_prim_hor_w,
		cd_classif_setor_w
from	setor_atendimento
where	cd_setor_atendimento = cd_setor_w;

if (ie_opcao_p = 'L') and (ie_libera_vencida_w = 'S') then

	select	coalesce(max(nr_prescricao),0)
	into STRICT	nr_prescricao_w
	from	prescr_medica B
	where	nm_usuario_original = nm_usuario_p
	and	coalesce(dt_liberacao::text, '') = ''
	and	coalesce(dt_liberacao_medico::text, '') = ''
	and not exists (SELECT 1
		from cirurgia c
		where c.nr_prescricao = b.nr_prescricao)
	and coalesce(nr_atendimento,999) = coalesce(nr_atendimento_p,999)
	and	cd_pessoa_fisica	= cd_pessoa_fisica_w;

elsif (ie_opcao_p	= 'E') then


	select	coalesce(max(nr_prescricao),0)
	into STRICT	nr_prescricao_w
	from	prescr_medica B
	where	nm_usuario_original = nm_usuario_p
	and	coalesce(dt_liberacao::text, '') = ''
	and	coalesce(dt_liberacao_medico::text, '') = ''
	and not exists (SELECT 1
		from cirurgia c
		where c.nr_prescricao = b.nr_prescricao)
	and	dt_inicio_prescr	>= dt_final_setor_w
	and coalesce(nr_atendimento,999) = coalesce(nr_atendimento_p,999)
	and	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	cd_funcao_origem	= 950
	and	coalesce(ie_hemodialise,'X')  not in ('E','S')
	and	coalesce(b.nr_seq_atend::text, '') = '';
	--and	nr_prescricao_anterior	is not null;
else

	select	coalesce(max(nr_prescricao),0)
	into STRICT	nr_prescricao_w
	from	prescr_medica B
	where	nm_usuario_original = nm_usuario_p
	and	coalesce(dt_liberacao::text, '') = ''
	and	coalesce(dt_liberacao_medico::text, '') = ''
	and not exists (SELECT 1
		from cirurgia c
		where c.nr_prescricao = b.nr_prescricao)
	and	((obter_se_prescr_hor_passado(nr_prescricao, qt_hor_passada_w) = 'N') or (cd_classif_setor_w = '1'))
	and	((dt_inicio_prescr between dt_inicial_setor_w and dt_final_setor_w) or (dt_validade_prescr between dt_inicial_setor_w and dt_final_setor_w) or
		 (dt_inicial_setor_w	> dt_validade_prescr AND ie_prescr_emergencia = 'S'))
	and coalesce(nr_atendimento,999) = coalesce(nr_atendimento_p,999)
	and	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	((coalesce(ie_hemodialise,'X')  not in ('E','S')) or (ie_opcao_p  = 'L'))
	and	((coalesce(b.nr_seq_atend::text, '') = '') or (ie_opcao_p = 'L'));



	if (nr_prescricao_w	= 0) then

		dt_inicial_setor_w	:= dt_inicial_setor_w + 1;
		dt_final_setor_w	:= dt_final_setor_w + 1;

		select	coalesce(max(nr_prescricao),0)
		into STRICT	nr_prescricao_w
		from	prescr_medica B
		where	nm_usuario_original = nm_usuario_p
		and	coalesce(dt_liberacao::text, '') = ''
		and	coalesce(dt_liberacao_medico::text, '') = ''
		and	coalesce(b.nr_prescricao_anterior::text, '') = ''
		and not exists (SELECT 1
			from cirurgia c
			where c.nr_prescricao = b.nr_prescricao)
		and	((obter_se_prescr_hor_passado(nr_prescricao, qt_hor_passada_w) = 'N') or (cd_classif_setor_w = '1'))
		and	((dt_inicio_prescr between dt_inicial_setor_w and dt_final_setor_w) or (dt_validade_prescr between dt_inicial_setor_w and dt_final_setor_w) or
			 (dt_inicial_setor_w	> dt_validade_prescr AND ie_prescr_emergencia = 'S'))
		and coalesce(nr_atendimento,999) = coalesce(nr_atendimento_p,999)
		and	cd_pessoa_fisica	   = cd_pessoa_fisica_w
		and	((coalesce(ie_hemodialise,'X')  not in ('E','S')) or (ie_opcao_p  = 'L'))
		and	((coalesce(b.nr_seq_atend::text, '') = '') or (ie_opcao_p = 'L'));

	end if;

end if;

return	nr_prescricao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION plt_obter_prescr_nao_liberada ( nr_atendimento_p bigint, ie_opcao_p text, cd_estabelecimento_p bigint, nm_usuario_p text, dt_setor_atendimento_p timestamp, cd_pessoa_fisica_p text, cd_perfil_p bigint, cd_setor_atendimento_p bigint default null) FROM PUBLIC;

