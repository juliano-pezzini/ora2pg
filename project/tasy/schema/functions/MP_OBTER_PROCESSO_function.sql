-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mp_obter_processo (nr_seq_proc_objeto_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_processo_w	bigint;


BEGIN

if (nr_seq_proc_objeto_p IS NOT NULL AND nr_seq_proc_objeto_p::text <> '') then
	select	max(nr_seq_processo)
	into STRICT	nr_seq_processo_w
	from	mp_processo_objeto
	where	nr_sequencia	= nr_seq_proc_objeto_p;
end if;

return	nr_seq_processo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mp_obter_processo (nr_seq_proc_objeto_p bigint) FROM PUBLIC;

