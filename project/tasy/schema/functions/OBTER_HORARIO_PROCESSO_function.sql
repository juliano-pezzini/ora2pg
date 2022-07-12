-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_horario_processo (nr_seq_processo_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_horario_w	timestamp;


BEGIN
if (nr_seq_processo_p IS NOT NULL AND nr_seq_processo_p::text <> '') then

	select	max(dt_horario_processo)
	into STRICT	dt_horario_w
	from	adep_processo
	where	nr_sequencia = nr_seq_processo_p;

end if;

return dt_horario_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_horario_processo (nr_seq_processo_p bigint) FROM PUBLIC;
