-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_proc_urgente (cd_setor_atendimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, nr_seq_exame_p bigint, ie_tipo_atendimento_p bigint, ie_rotina_p text default 'S', cd_perfil_p bigint default null, cd_medico_p bigint default null, cd_setor_entrega_p bigint default null) RETURNS varchar AS $body$
DECLARE


ie_urgente_w			varchar(10);
ie_urgente_perfil_w		varchar(10);
ie_urgente_medico_w		varchar(10);
cd_grupo_proc_w			bigint;
cd_especialidade_w		bigint;
cd_area_procedimento_w		bigint;
nr_seq_grupo_exame_lab_w	bigint;
nr_sequencia_regra_w		bigint;
qt_regra_perfil_w		bigint;
qt_regra_w			bigint;
qt_regra_medico_w		bigint;
cd_setor_entrega_w		setor_atendimento.cd_setor_atendimento%type;

c01 CURSOR FOR
SELECT	'S',
	nr_sequencia
from	proc_urgente_prescr a
where	ie_situacao	= 'A'
and	coalesce(a.cd_setor_atendimento,coalesce(cd_setor_atendimento_p,0)) 	= coalesce(cd_setor_atendimento_p,0)
and	coalesce(a.cd_setor_entrega,coalesce(cd_setor_entrega_w,0)) 	= coalesce(cd_setor_entrega_w,0)
and	coalesce(cd_procedimento, coalesce(cd_procedimento_p,0))			= coalesce(cd_procedimento_p,0)
and	((coalesce(ie_origem_proced::text, '') = '') or (ie_origem_proced = ie_origem_proced_p))
and	coalesce(cd_area_procedimento, coalesce(cd_area_procedimento_w,0))	= coalesce(cd_area_procedimento_w,0)
and	coalesce(cd_especialidade, coalesce(cd_especialidade_w,0))		= coalesce(cd_especialidade_w,0)
and	coalesce(cd_grupo_proc, coalesce(cd_grupo_proc_w,0))			= coalesce(cd_grupo_proc_w,0)
and	coalesce(nr_seq_proc_interno, coalesce(nr_seq_proc_interno_p,0))		= coalesce(nr_seq_proc_interno_p,0)
and	coalesce(nr_seq_exame, coalesce(nr_seq_exame_p,0))			= coalesce(nr_seq_exame_p,0)
and	coalesce(nr_seq_grupo_exame, coalesce(nr_seq_grupo_exame_lab_w,0))	= coalesce(nr_seq_grupo_exame_lab_w,0)
and	coalesce(ie_tipo_atendimento, ie_tipo_atendimento_p)			= ie_tipo_atendimento_p
and	((coalesce(a.ie_rotina,'N')						= ie_rotina_p) or (coalesce(ie_rotina_p,'N') = 'S'))
order	by coalesce(cd_procedimento, 0),
	coalesce(cd_grupo_proc, 0),
	coalesce(cd_especialidade, 0),
	coalesce(cd_area_procedimento, 0),
	coalesce(nr_seq_proc_interno,0),
	coalesce(nr_seq_exame,0),
	coalesce(cd_setor_atendimento, 0);


BEGIN
begin

select	max(cd_grupo_proc),
	max(cd_especialidade),
	max(cd_area_procedimento)
into STRICT	cd_grupo_proc_w,
	cd_especialidade_w,
	cd_area_procedimento_w
from	estrutura_procedimento_v
where	cd_procedimento		= cd_procedimento_p
and	ie_origem_proced	= ie_origem_proced_p;

select	max(nr_seq_grupo)
into STRICT	nr_seq_grupo_exame_lab_w
from	exame_laboratorio
where	nr_seq_exame	= nr_seq_exame_p;

ie_urgente_w	:= 'N';
ie_urgente_perfil_w  := 'S';
ie_urgente_medico_w  := 'S';

cd_setor_entrega_w := coalesce(cd_setor_entrega_p, obter_setor_entrega_proc(cd_procedimento_p, nr_seq_proc_interno_p));

open c01;
loop
fetch c01 into
	ie_urgente_w,
	nr_sequencia_regra_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	ie_urgente_w	:= ie_urgente_w;

	if (ie_urgente_w = 'S') and (coalesce(nr_sequencia_regra_w,0) > 0) then

		select  count(*)
		into STRICT	qt_regra_medico_w
		from 	PROC_URGENTE_MEDICO
		where   nr_seq_proc_urg = nr_sequencia_regra_w
		and     coalesce(cd_medico, coalesce(cd_medico_p,0)) = coalesce(cd_medico_p,0);

		if (coalesce(qt_regra_medico_w,0) > 0) then
			select  coalesce(max('S'),'N')
			into STRICT	ie_urgente_medico_w
			from    PROC_URGENTE_MEDICO
			where   nr_seq_proc_urg = nr_sequencia_regra_w
			and	coalesce(ie_urgente,'N') = 'S'
			and	coalesce(cd_medico, coalesce(cd_medico_p,0)) = coalesce(cd_medico_p,0);
		end if;

		select  count(*)
		into STRICT	qt_regra_w
		from 	proc_urgente_perfil
		where   nr_seq_proc_urg = nr_sequencia_regra_w
		and     coalesce(cd_perfil, coalesce(cd_perfil_p,0)) = coalesce(cd_perfil_p,0);

		if (coalesce(qt_regra_w,0) > 0) then
			select  coalesce(max('S'),'N')
			into STRICT	ie_urgente_perfil_w
			from    proc_urgente_perfil
			where   nr_seq_proc_urg = nr_sequencia_regra_w
			and	coalesce(ie_urgente,'N') = 'S'
			and	coalesce(cd_perfil, coalesce(cd_perfil_p,0)) = coalesce(cd_perfil_p,0);
		end if;

		if ((ie_urgente_perfil_w =  'N') or (ie_urgente_medico_w =  'N')) then
			ie_urgente_w := 'N';
		end if;
	end if;
end loop;
close c01;

exception
when others then
	null;
end;

return ie_urgente_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_proc_urgente (cd_setor_atendimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, nr_seq_exame_p bigint, ie_tipo_atendimento_p bigint, ie_rotina_p text default 'S', cd_perfil_p bigint default null, cd_medico_p bigint default null, cd_setor_entrega_p bigint default null) FROM PUBLIC;

