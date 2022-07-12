-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_if_kinship_genogram (nr_seq_grau_parentesco_p bigint) RETURNS varchar AS $body$
DECLARE


ds_return_w		varchar(1) := 'N';
ie_grau_parentesco_w	grau_parentesco.ie_grau_parentesco%type;
			

BEGIN

if (nr_seq_grau_parentesco_p > 0) then

	select	ie_grau_parentesco
	into STRICT	ie_grau_parentesco_w
	from	grau_parentesco
	where	nr_sequencia = nr_seq_grau_parentesco_p;

	if (ie_grau_parentesco_w in ('12','9','5','6','7','13','15','3','14')) then
		ds_return_w	:= 'Y';
	else
		ds_return_w	:= 'N';
	
	end if;
end if;


return	ds_return_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_if_kinship_genogram (nr_seq_grau_parentesco_p bigint) FROM PUBLIC;

