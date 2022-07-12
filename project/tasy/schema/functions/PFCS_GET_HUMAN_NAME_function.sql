-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pfcs_get_human_name ( nr_seq_person_p bigint, ds_role_p text default PFCS_PCK_CONSTANTS.DS_PATIENT) RETURNS varchar AS $body$
DECLARE


    ds_name_w         pfcs_human_name.full_name%type;
    ds_family_name_w  pfcs_human_name.family%type;
    ds_given_name_w   pfcs_human_name.given%type;


BEGIN
    if (ds_role_p = PFCS_PCK_CONSTANTS.DS_PATIENT) then
        select  family, given
        into STRICT    ds_family_name_w, ds_given_name_w
        from    pfcs_human_name
        where    nr_seq_patient = nr_seq_person_p;
    elsif (ds_role_p = PFCS_PCK_CONSTANTS.DS_PRACTITIONER) then
        select  family, given
        into STRICT    ds_family_name_w, ds_given_name_w
        from    pfcs_human_name
        where   nr_seq_practitioner = nr_seq_person_p;
    end if;

	if (ds_family_name_w IS NOT NULL AND ds_family_name_w::text <> '') then
        ds_name_w := ds_family_name_w;
        if (ds_given_name_w IS NOT NULL AND ds_given_name_w::text <> '') then
            ds_name_w := ds_name_w || ', ' || substr(ds_given_name_w, 0, 1) || '.';
        end if;
    else
        ds_name_w := ds_given_name_w;
    end if;

    return ds_name_w;
    exception
    when no_data_found then
        return null;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pfcs_get_human_name ( nr_seq_person_p bigint, ds_role_p text default PFCS_PCK_CONSTANTS.DS_PATIENT) FROM PUBLIC;
