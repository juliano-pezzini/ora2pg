-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_dt_entrega_item (nr_seq_agenda_int_p bigint) RETURNS timestamp AS $body$
DECLARE


ds_retorno_w		timestamp;


BEGIN

if (nr_seq_agenda_int_p IS NOT NULL AND nr_seq_agenda_int_p::text <> '') then

	select	max(dt_entrega_prevista)
	into STRICT	ds_retorno_w
	from	agenda_integrada_item
	where	nr_seq_agenda_int = nr_seq_agenda_int_p;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_dt_entrega_item (nr_seq_agenda_int_p bigint) FROM PUBLIC;
