-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_person_ihi (cd_pessoa_fisica_p text, ie_data_type_p text) RETURNS varchar AS $body$
DECLARE


/*
ie_data_type_p
I - Individual (for Patient)
P - Provider (for Physician)
N - nr_sequencia based search
*/
ds_return_w	varchar(100);


BEGIN

if (ie_data_type_p = 'N') then

 	select	max(nr_ihi)
	into STRICT	ds_return_w
	from	person_ihi
	where	nr_sequencia = cd_pessoa_fisica_p;
	
else
 
 	select	max(nr_ihi)
	into STRICT	ds_return_w
	from	person_ihi
	where	ie_situacao = 'A'
	and	cd_pessoa_fisica = cd_pessoa_fisica_p
	and	ie_data_type = ie_data_type_p;

end if;

return	ds_return_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_person_ihi (cd_pessoa_fisica_p text, ie_data_type_p text) FROM PUBLIC;
