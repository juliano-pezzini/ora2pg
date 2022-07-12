-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pessoa_person_name (nr_seq_person_name_p bigint) RETURNS varchar AS $body$
DECLARE


cd_pessoa_fisica_w  pessoa_fisica.cd_pessoa_fisica%type;
				

BEGIN

if (nr_seq_person_name_p IS NOT NULL AND nr_seq_person_name_p::text <> '') then
	select 	coalesce(max(b.cd_pessoa_fisica), '0')
	into STRICT 	cd_pessoa_fisica_w
	from 	pessoa_fisica b
	where 	b.nr_seq_person_name = nr_seq_person_name_p;
end if;

return	cd_pessoa_fisica_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pessoa_person_name (nr_seq_person_name_p bigint) FROM PUBLIC;
