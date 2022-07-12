-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_grau_parentesco_pf (nr_seq_grau_parentesco_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_parentesco_w	bigint := 0;
ds_parentesco_w	varchar(40) := '';


BEGIN
	if (coalesce(nr_seq_grau_parentesco_p,0) > 0) then
		select	ds_parentesco
		into STRICT	ds_parentesco_w
		from	grau_parentesco
		where	nr_sequencia = nr_seq_grau_parentesco_p;
	end if;

return ds_parentesco_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_grau_parentesco_pf (nr_seq_grau_parentesco_p bigint) FROM PUBLIC;

