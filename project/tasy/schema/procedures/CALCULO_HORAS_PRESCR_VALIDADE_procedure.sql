-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calculo_horas_prescr_validade ( ie_agora_p text, nm_usuario_p text, qt_horas_validade_p INOUT bigint, dt_inicio_prescr_p INOUT timestamp, nr_atendimento_p bigint, dt_prescricao_p timestamp, nr_sequencia_p bigint, dt_validade_prescr_p INOUT timestamp, cd_setor_atendimento_p bigint, dt_primeiro_horario_p timestamp, ie_message_recalculate_p text default null) AS $body$
DECLARE

				
ie_estender_w			varchar(10);
dt_inicio_setor_w	setor_atendimento.HR_INICIO_PRESCRICAO_SAE%type;
ie_quest_alt_hor_sae_w	parametro_medico.ie_quest_alt_hor_sae%type;


BEGIN

select	max(HR_INICIO_PRESCRICAO_SAE)
into STRICT	dt_inicio_setor_w
from	setor_atendimento
where	cd_setor_atendimento	= cd_setor_atendimento_p;	

select coalesce(max(ie_quest_alt_hor_sae), 'N')
into STRICT ie_quest_alt_hor_sae_w
from parametro_medico
where cd_estabelecimento = obter_estabelecimento_ativo;

if (dt_primeiro_horario_p IS NOT NULL AND dt_primeiro_horario_p::text <> '') then
	if (to_char(dt_primeiro_horario_p,'hh24:mi') < to_char(dt_prescricao_p,'hh24:mi')) then
		dt_inicio_prescr_p := ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_prescricao_p+1, dt_primeiro_horario_p);
	else
		dt_inicio_prescr_p := ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_prescricao_p, dt_primeiro_horario_p);
	end if;
else
	dt_inicio_prescr_p := dt_prescricao_p;
end if;	

if	((ie_agora_p	= 'S') and (ie_quest_alt_hor_sae_w = 'S') and ie_message_recalculate_p = 'N') then
	dt_validade_prescr_p := trunc(dt_inicio_prescr_p,'hh24') + coalesce(qt_horas_validade_p,24) / 24 - 1/86400;
else
	if (ie_agora_p	= 'S') then
		ie_estender_w	:= obter_valor_param_usuario(281,775, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo);
		if (ie_estender_w	<> 'N') then
			if (nr_sequencia_p > 0) then
				qt_horas_validade_p	:= obter_horas_validade_sae(dt_inicio_prescr_p,nr_atendimento_p,ie_estender_w,'A',dt_prescricao_p,nr_sequencia_p);
			end if;
			dt_validade_prescr_p := trunc(dt_inicio_prescr_p,'hh24') + coalesce(qt_horas_validade_p,24) / 24 - 1/86400;
		else
			if (coalesce(dt_inicio_setor_w::text, '') = '')then
				dt_validade_prescr_p	:= dt_inicio_prescr_p + 1 - 1/86400;
			elsif (dt_inicio_setor_w IS NOT NULL AND dt_inicio_setor_w::text <> '') then
					dt_validade_prescr_p	:= ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_inicio_prescr_p, dt_inicio_setor_w) - 1/86400;
				if (dt_validade_prescr_p	< dt_inicio_prescr_p) then
					dt_validade_prescr_p  := dt_validade_prescr_p + 1;
				end if;
			end if;
			if (nr_sequencia_p > 0) then
				qt_horas_validade_p	:= TRUNC((dt_validade_prescr_p - dt_inicio_prescr_p) * 24) + 1;				
			end if;
		end if;
	else
		dt_validade_prescr_p := trunc(dt_inicio_prescr_p,'hh24') + coalesce(qt_horas_validade_p,24) / 24 - 1/86400;
	end if;
end if;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calculo_horas_prescr_validade ( ie_agora_p text, nm_usuario_p text, qt_horas_validade_p INOUT bigint, dt_inicio_prescr_p INOUT timestamp, nr_atendimento_p bigint, dt_prescricao_p timestamp, nr_sequencia_p bigint, dt_validade_prescr_p INOUT timestamp, cd_setor_atendimento_p bigint, dt_primeiro_horario_p timestamp, ie_message_recalculate_p text default null) FROM PUBLIC;

