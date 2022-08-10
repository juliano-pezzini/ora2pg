-- FUNCTION: pkg_name_utils.get_person(bigint, varchar2)

-- DROP FUNCTION IF EXISTS pkg_name_utils.get_person(bigint, varchar2);

CREATE OR REPLACE FUNCTION pkg_name_utils.get_person(
id bigint,
name_type varchar2 DEFAULT 'main'::varchar2)
    RETURNS pkg_name_utils.person_data
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE SECURITY DEFINER PARALLEL UNSAFE
AS $
                                     
                                        declare
                                     
                                     c01 REFCURSOR;
        name_types               character varying(2000)[];
        a_name_type character varying(2000);
         person_name_v   record;
        person                  pkg_name_utils.person_data;
        result                  varchar2(2000);
begin
        name_types := pkg_name_utils.split(name_type,',');

        --This approach may seem strange, but was the fastest possible in our tests.
        <<name_loop>>
        foreach     a_name_type in array name_types loop
                open c01 for
                select  ds_type,
                                ds_given_name,
                                ds_family_name,
                                ds_component_name_1,
                                ds_component_name_2,
                                ds_component_name_3,
                                substr(obter_titulo_academico_pf(OBTER_PESSOA_PERSON_NAME(nr_sequencia), 'S'),1,100) ds_academic_title
                from    person_name a
                where   nr_sequencia = id;

                loop
                fetch c01 into person_name_v;
                exit when NOT FOUND;
                begin
                if (person_name_v.ds_type = a_name_type) then
                     person := ROW(null)::pkg_name_utils.person_data;
                      person.person_data = array_append(person.person_data,person_name_v.ds_given_name);
                         person.person_data = array_append(person.person_data,person_name_v.ds_family_name);

                        person.person_data = array_append(person.person_data,person_name_v.ds_component_name_1);

                        person.person_data = array_append(person.person_data,person_name_v.ds_component_name_2);

                        person.person_data = array_append(person.person_data,person_name_v.ds_component_name_3);

                        person.person_data = array_append(person.person_data,person_name_v.ds_academic_title);

                      /*  person.extend(6);
                        person(1) := person_name_v.ds_given_name;
                        person(2) := person_name_v.ds_family_name;
                        person(3) := person_name_v.ds_component_name_1;
                        person(4) := person_name_v.ds_component_name_2;
                        person(5) := person_name_v.ds_component_name_3;
                        person(6) := person_name_v.ds_academic_title;
                        */
                        close c01;
                        exit name_loop;
                end if;
                end;
                end loop;
                close c01;
        end loop;

        return person::pkg_name_utils.person_data;

end;
$;

ALTER FUNCTION pkg_name_utils.get_person(bigint, varchar2)
    OWNER TO postgres;
