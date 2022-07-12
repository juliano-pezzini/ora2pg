-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ultima_dt_alta_hist (nr_atendimento_p bigint) RETURNS timestamp AS $body$
DECLARE

			
dt_retorno_w		timestamp;			
nr_sequencia_w		bigint;


BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

	select 	max(nr_sequencia)
	into STRICT	nr_sequencia_w
	from 	ATEND_ALTA_HIST
	where 	nr_atendimento = nr_atendimento_p
	and	ie_alta_estorno = 'A';
	
	select 	max(dt_alta)
	into STRICT	dt_retorno_w
	from	ATEND_ALTA_HIST
	where 	nr_atendimento = nr_atendimento_p
	and	nr_sequencia = nr_sequencia_w;
	
end if;

return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ultima_dt_alta_hist (nr_atendimento_p bigint) FROM PUBLIC;
