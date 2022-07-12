-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_prescr_atendida_pa (nr_atendimento_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w				varchar(255);
qt_mat_tot_w				integer;
qt_prescricao_w				bigint;
ie_prescr_pend_lib_w		char(1) := 'N';
ie_prescr_pend_lib_ww		char(1);
ie_consistir_status_pa_pa_w	varchar(1);
nr_prescricao_w				bigint;


BEGIN

ds_retorno_w				:= 'N';

select 	coalesce(max(IE_CONSISTIR_STATUS_PA_PA),'N')
into STRICT	ie_consistir_status_pa_pa_w
from	parametro_medico
where	cd_estabelecimento = cd_estabelecimento_p;

if (ie_consistir_status_pa_pa_w = 'S') then

	select	count(nr_prescricao)
	into STRICT	qt_prescricao_w
	from	prescr_medica
	where	nr_atendimento = nr_atendimento_p;

	if (qt_prescricao_w > 0) then
		select	count(a.nr_prescricao)
		into STRICT	qt_mat_tot_w
		from	prescr_medica a
		where	nr_atendimento	= nr_atendimento_p
		and		(dt_liberacao_medico IS NOT NULL AND dt_liberacao_medico::text <> '')
		and		coalesce(DT_SUSPENSAO::text, '') = ''
		and     to_char(dt_liberacao_medico,'dd/mm/yyyy hh24:mi:ss')
									= (	SELECT 	max(to_char(dt_liberacao_medico,'dd/mm/yyyy hh24:mi:ss'))
										from 	prescr_medica
										where	nr_atendimento	= nr_atendimento_p
										and		(dt_liberacao_medico IS NOT NULL AND dt_liberacao_medico::text <> '')
										and		coalesce(DT_SUSPENSAO::text, '') = '')
		and	exists (Select 1
					from prescr_mat_hor x
					where 	x.nr_prescricao = a.nr_prescricao
					and 	OBTER_SE_HORARIO_LIBERADO(x.dt_lib_horario, x.dt_horario) = 'S'
					and	coalesce(x.dt_suspensao::text, '') = ''
					and	(x.dt_fim_horario IS NOT NULL AND x.dt_fim_horario::text <> '')
					
union all

					SELECT	1
					FROM	prescr_proc_hor x,
							prescr_procedimento b
					WHERE	x.nr_prescricao = b.nr_prescricao
					AND	coalesce(x.nr_seq_proc_origem,x.nr_seq_procedimento) = b.nr_sequencia
					AND	(x.dt_fim_horario IS NOT NULL AND x.dt_fim_horario::text <> '')
					AND	coalesce(x.dt_suspensao::text, '') = ''
					AND	(b.nr_seq_exame IS NOT NULL AND b.nr_seq_exame::text <> '')
					AND	Obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S'
					AND	b.nr_prescricao = a.nr_prescricao
					
union all

					Select 1
					from 	prescr_rec_hor x
					where 	x.nr_prescricao = a.nr_prescricao
					and	coalesce(x.dt_suspensao::text, '') = ''
					and	(x.dt_fim_horario IS NOT NULL AND x.dt_fim_horario::text <> '')
					and 	OBTER_SE_HORARIO_LIBERADO(x.dt_lib_horario, x.dt_horario) = 'S');

		select 	max(nr_prescricao)
		into STRICT	nr_prescricao_w
		from 	prescr_medica
		where 	nr_atendimento	= nr_atendimento_p
		and		(dt_liberacao_medico IS NOT NULL AND dt_liberacao_medico::text <> '')
		and		coalesce(dt_liberacao::text, '') = ''
		and     to_char(dt_liberacao_medico,'dd/mm/yyyy hh24:mi:ss')
									= (	SELECT max(to_char(dt_liberacao_medico,'dd/mm/yyyy hh24:mi:ss'))
										from 	prescr_medica
										where 	nr_atendimento	= nr_atendimento_p
										and		(dt_liberacao_medico IS NOT NULL AND dt_liberacao_medico::text <> '')
										and		coalesce(dt_liberacao::text, '') = '');

		select	coalesce(max('S'), 'N')
		into STRICT	ie_prescr_pend_lib_ww
		from	prescr_medica
		where	nr_prescricao = nr_prescricao_w;

		Select  coalesce(max('S'), 'N')
		into STRICT	ie_prescr_pend_lib_w
		from 	prescr_medica a
		where 	nr_prescricao = nr_prescricao_w
		and not exists (SELECT 1
				from prescr_mat_hor x
				where x.nr_prescricao = a.nr_prescricao
				and OBTER_SE_HORARIO_LIBERADO(x.dt_lib_horario, x.dt_horario) = 'S'
				
union all

				SELECT 1
				from prescr_proc_hor x
				where x.nr_prescricao = a.nr_prescricao
				and OBTER_SE_HORARIO_LIBERADO(x.dt_lib_horario, x.dt_horario) = 'S'
				
union all

				Select 1
				from prescr_rec_hor x
				where x.nr_prescricao = a.nr_prescricao
				and OBTER_SE_HORARIO_LIBERADO(x.dt_lib_horario, x.dt_horario) = 'S');

	end if;

	if (qt_prescricao_w > 0) and
		((qt_mat_tot_w > 0) or
		(ie_prescr_pend_lib_ww = 'S' AND ie_prescr_pend_lib_w = 'S'))  then
             ds_retorno_w := 'S';
	end if;

end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_prescr_atendida_pa (nr_atendimento_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
