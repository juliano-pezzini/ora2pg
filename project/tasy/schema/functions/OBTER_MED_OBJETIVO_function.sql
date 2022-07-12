-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_med_objetivo (nr_seq_objetivo_p bigint) RETURNS varchar AS $body$
DECLARE


ds_objetivo_w		varchar(100);


BEGIN

if (nr_seq_objetivo_p IS NOT NULL AND nr_seq_objetivo_p::text <> '') then
	begin

	select	ds_objetivo
	into STRICT	ds_objetivo_w
	from	med_objetivo
	where	nr_sequencia	= nr_seq_objetivo_p;

	end;
end if;

return	ds_objetivo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_med_objetivo (nr_seq_objetivo_p bigint) FROM PUBLIC;

