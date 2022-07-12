-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_etapa_susp (nr_prescricao_p bigint, nr_seq_solucao_p bigint, nr_etapa_sol_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(1) := 'N';
nr_etapa_sol_w	smallint;


BEGIN

--Verifica se a etapa atual foi suspensa
nr_etapa_sol_w	:= nr_etapa_sol_p;

if (nr_etapa_sol_w = 0) then
	nr_etapa_sol_w	:= 1;
end if;

select	coalesce(max('N'), 'S')
into STRICT	ie_retorno_w
from	prescr_mat_hor
where	nr_prescricao = nr_prescricao_p
and		nr_seq_solucao = nr_seq_solucao_p
and		nr_etapa_sol = nr_etapa_sol_w
and		coalesce(dt_suspensao::text, '') = '';

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_etapa_susp (nr_prescricao_p bigint, nr_seq_solucao_p bigint, nr_etapa_sol_p bigint) FROM PUBLIC;

