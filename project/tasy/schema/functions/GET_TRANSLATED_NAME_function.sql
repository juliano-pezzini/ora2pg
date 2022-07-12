-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_translated_name (nr_seq_person_name_p bigint) RETURNS varchar AS $body$
DECLARE


ds_translated_fullname_w varchar(50):= '';
ds_given_name_t person_name.ds_given_name%type;
ds_family_name_t person_name.ds_family_name%type;


BEGIN

if (nr_seq_person_name_p IS NOT NULL AND nr_seq_person_name_p::text <> '') then
    SELECT  ds_given_name,
          ds_family_name
	INTO STRICT ds_given_name_t,
		ds_family_name_t
    FROM	 person_name
    WHERE nr_sequencia = nr_seq_person_name_p
    and ds_type = 'translated';
end if;
	
ds_translated_fullname_w := substr((ds_given_name_t || ' ' || ds_family_name_t), 1, 50);

return ds_translated_fullname_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_translated_name (nr_seq_person_name_p bigint) FROM PUBLIC;

