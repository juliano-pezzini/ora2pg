-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_sol_iniciada ( nr_prescricao_p bigint, nr_seq_solucao_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(1) := 'N';


BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '') then
	begin
	select	coalesce(max('S'),'N')
	into STRICT	ie_retorno_w
	from	prescr_mat_hor
	where	nr_prescricao	= nr_prescricao_p
	and	nr_seq_solucao	= nr_seq_solucao_p
	and	(dt_inicio_horario IS NOT NULL AND dt_inicio_horario::text <> '')
	and	coalesce(dt_fim_horario::text, '') = ''
	and	coalesce(dt_interrupcao::text, '') = '';

	end;
end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_sol_iniciada ( nr_prescricao_p bigint, nr_seq_solucao_p bigint) FROM PUBLIC;

