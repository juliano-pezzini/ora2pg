-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_prox_etapa_dialise_adep ( nr_prescricao_p bigint, nr_seq_solucao_p bigint) RETURNS bigint AS $body$
DECLARE


nr_prox_etapa_w		bigint := 1;


BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '') then

	select	coalesce(max(nr_etapa_sol), 0)
	into STRICT	nr_prox_etapa_w
	from	prescr_mat_hor
	where	(coalesce(dt_inicio_horario, dt_fim_horario) IS NOT NULL AND (coalesce(dt_inicio_horario, dt_fim_horario))::text <> '')
	and 	nr_seq_solucao = nr_seq_solucao_p
	and		nr_prescricao = nr_prescricao_p;

	select	coalesce(min(nr_etapa_sol), nr_prox_etapa_w + 1)
	into STRICT	nr_prox_etapa_w
	from	prescr_mat_hor
	where	coalesce(coalesce(dt_suspensao, dt_inicio_horario)::text, '') = ''
	and		nr_etapa_sol > nr_prox_etapa_w
	and 	nr_seq_solucao = nr_seq_solucao_p
	and		nr_prescricao = nr_prescricao_p;

end if;

return	nr_prox_etapa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_prox_etapa_dialise_adep ( nr_prescricao_p bigint, nr_seq_solucao_p bigint) FROM PUBLIC;
