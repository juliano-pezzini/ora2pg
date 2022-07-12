-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_etapa_atual ( nr_prescricao_p bigint, nr_seq_solucao_p bigint) RETURNS bigint AS $body$
DECLARE


nr_etapa_sol_w		bigint;


BEGIN

select	coalesce(max(nr_etapa_sol),0)
into STRICT	nr_etapa_sol_w
from	prescr_mat_hor
where	Obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S'
and		(dt_inicio_horario IS NOT NULL AND dt_inicio_horario::text <> '')
and		ie_agrupador = 4
and		nr_seq_solucao = nr_seq_solucao_p
and		nr_prescricao = nr_prescricao_p;

if (nr_etapa_sol_w = 0) then
	select	coalesce(min(nr_etapa_sol),0)
	into STRICT	nr_etapa_sol_w
	from	prescr_mat_hor
	where	Obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S'
	and		coalesce(dt_suspensao::text, '') = ''
	and		ie_agrupador = 4
	and		nr_seq_solucao = nr_seq_solucao_p
	and		nr_prescricao = nr_prescricao_p;
end if;

return	nr_etapa_sol_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_etapa_atual ( nr_prescricao_p bigint, nr_seq_solucao_p bigint) FROM PUBLIC;
