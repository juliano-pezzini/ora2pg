-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pkg_name_utils.get_person (id bigint, name_type text default TYPE_MAIN) RETURNS PERSON_DATA AS $body$
DECLARE

	c01 CURSOR FOR
		SELECT	ds_type,
				ds_given_name,
				ds_family_name,
				ds_component_name_1,
				ds_component_name_2,
				ds_component_name_3,
				substr(obter_titulo_academico_pf(OBTER_PESSOA_PERSON_NAME(nr_sequencia), 'S'),1,100) ds_academic_title
		from	person_name a
		where	nr_sequencia = id;

	name_types		split_table;
	person_name_v	c01%rowtype;
	person			person_data := person_data();
	result			varchar(2000);
BEGIN
	name_types := pkg_name_utils.split(name_type,',');

	--This approach may seem strange, but was the fastest possible in our tests.

	<<name_loop>>
	for	i in 1..name_types.last loop
		open c01;
		loop
		fetch c01 into person_name_v;
		EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		if (person_name_v.ds_type = name_types(i)) then
			person.extend(6);
			person(1) := person_name_v.ds_given_name;
			person(2) := person_name_v.ds_family_name;
			person(3) := person_name_v.ds_component_name_1;
			person(4) := person_name_v.ds_component_name_2;
			person(5) := person_name_v.ds_component_name_3;
			person(6) := person_name_v.ds_academic_title;
			close c01;
			exit name_loop;
		end if;
		end;
		end loop;
		close c01;
	end loop;

	return person;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pkg_name_utils.get_person (id bigint, name_type text default TYPE_MAIN) FROM PUBLIC;