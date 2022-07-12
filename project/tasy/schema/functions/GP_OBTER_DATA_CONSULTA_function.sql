-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gp_obter_data_consulta ( nr_seq_agecons_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_retorno_w		timestamp;


BEGIN

if (nr_seq_agecons_p IS NOT NULL AND nr_seq_agecons_p::text <> '') then
	select	max(trunc(dt_consulta))
	into STRICT	dt_retorno_w
	from	agenda_consulta
	where	nr_sequencia	= nr_seq_agecons_p;
end if;

return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gp_obter_data_consulta ( nr_seq_agecons_p bigint) FROM PUBLIC;
