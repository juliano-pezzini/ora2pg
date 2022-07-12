-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_hora_regra_proc (cd_setor_atendimento_p bigint, cd_classif_setor_p bigint, nr_prescricao_p bigint, cd_tipo_procedimento_p bigint) RETURNS varchar AS $body$
DECLARE


dt_retorno_w		varchar(20) := '';
dt_horario_w		timestamp;
dt_inicio_prescr_w	timestamp;

BEGIN

select	max(dt_horario)
into STRICT	dt_horario_w
from	regra_horario_proc
where	coalesce(cd_setor_atendimento,cd_setor_atendimento_p) = coalesce(cd_setor_atendimento_p,0)
and	coalesce(cd_tipo_procedimento,coalesce(cd_tipo_procedimento_p,0))	= coalesce(cd_tipo_procedimento_p,0)
and	coalesce(cd_classif_setor,cd_classif_setor_p) = coalesce(cd_classif_setor_p,0);

if (dt_horario_w IS NOT NULL AND dt_horario_w::text <> '') then

	select 	dt_inicio_prescr
	into STRICT	dt_inicio_prescr_w
	from 	prescr_medica
	where 	nr_prescricao = nr_prescricao_p;

	if (to_char(dt_inicio_prescr_w, 'hh24:mi:ss') > to_char(dt_horario_w, 'hh24:mi:ss')) then
		dt_retorno_w := to_char(dt_inicio_prescr_w + 1, 'dd/mm/yyyy')||' '|| to_char(dt_horario_w, 'hh24:mi');
	else
		dt_retorno_w := to_char(dt_inicio_prescr_w, 'dd/mm/yyyy')||' '|| to_char(dt_horario_w, 'hh24:mi');
	end if;
end if;

return dt_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_hora_regra_proc (cd_setor_atendimento_p bigint, cd_classif_setor_p bigint, nr_prescricao_p bigint, cd_tipo_procedimento_p bigint) FROM PUBLIC;

