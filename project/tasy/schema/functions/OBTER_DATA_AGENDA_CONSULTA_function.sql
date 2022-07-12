-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_agenda_consulta ( nr_sequencia_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_agenda_w	timestamp;


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	select	max(dt_agenda)
	into STRICT	dt_agenda_w
	from	agenda_consulta
	where	nr_sequencia = nr_sequencia_p;
end if;

return	dt_agenda_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_agenda_consulta ( nr_sequencia_p bigint) FROM PUBLIC;

