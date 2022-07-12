-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_etapa_preparar_sol ( nr_prescricao_p bigint, nr_seq_solucao_p bigint) RETURNS bigint AS $body$
DECLARE

				
nr_etapa_valida_w	prescr_mat_hor.nr_etapa_sol%type := 0;


BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '') then

	select	coalesce(min(b.nr_etapa_sol),0)
	into STRICT	nr_etapa_valida_w
	FROM prescr_mat_hor b
LEFT OUTER JOIN adep_processo a ON (b.nr_seq_processo = a.nr_sequencia)
WHERE b.nr_prescricao = nr_prescricao_p and b.nr_seq_solucao = nr_seq_solucao_p  and coalesce(b.dt_suspensao::text, '') = '' and coalesce(a.dt_paciente::text, '') = '' and coalesce(b.dt_fim_horario::text, '') = '';

end if;

return nr_etapa_valida_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_etapa_preparar_sol ( nr_prescricao_p bigint, nr_seq_solucao_p bigint) FROM PUBLIC;
