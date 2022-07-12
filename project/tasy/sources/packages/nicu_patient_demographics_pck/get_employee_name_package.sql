-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION nicu_patient_demographics_pck.get_employee_name ( nr_seq_encounter_p bigint, ie_type_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(2000) := '';


BEGIN

    select	max(nm_employee)
    into STRICT	ds_retorno_w
    from 	nicu_encounter_staff
    where	nr_seq_encounter = nr_seq_encounter_p
    and	        ie_type = ie_type_p;

    return ds_retorno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION nicu_patient_demographics_pck.get_employee_name ( nr_seq_encounter_p bigint, ie_type_p text) FROM PUBLIC;
