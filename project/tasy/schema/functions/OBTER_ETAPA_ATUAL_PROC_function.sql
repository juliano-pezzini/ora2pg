-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_etapa_atual_proc ( nr_prescricao_p bigint, nr_seq_procedimento_p bigint ) RETURNS bigint AS $body$
DECLARE

				
nr_etapa_sol_w		prescr_proc_hor.nr_etapa%type;


BEGIN

select	coalesce(max(nr_etapa),0)
into STRICT	nr_etapa_sol_w
from	prescr_proc_hor
where	Obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S'
and	(dt_inicio_horario IS NOT NULL AND dt_inicio_horario::text <> '')
and	nr_seq_procedimento 	= nr_seq_procedimento_p
and	nr_prescricao 		= nr_prescricao_p;

if (nr_etapa_sol_w = 0) then
	select	coalesce(min(nr_etapa),0)
	into STRICT	nr_etapa_sol_w
	from	prescr_proc_hor
	where	Obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S'
	and	coalesce(dt_suspensao::text, '') = ''
	and	nr_seq_procedimento 	= nr_seq_procedimento_p
	and	nr_prescricao 	= nr_prescricao_p;
end if;

return	nr_etapa_sol_w;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_etapa_atual_proc ( nr_prescricao_p bigint, nr_seq_procedimento_p bigint ) FROM PUBLIC;

