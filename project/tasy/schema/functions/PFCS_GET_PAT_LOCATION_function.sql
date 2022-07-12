-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pfcs_get_pat_location ( nr_seq_patient_p bigint, nr_seq_encounter_p bigint, dt_location_p timestamp default null) RETURNS bigint AS $body$
DECLARE


nr_seq_location_w       pfcs_patient_loc_hist.nr_seq_location%type := null;


BEGIN
    select max(nr_seq_location)
    into STRICT nr_seq_location_w
    from (
        SELECT nr_seq_location
        from pfcs_patient_loc_hist
        where nr_seq_patient = nr_seq_patient_p
            and nr_seq_encounter = nr_seq_encounter_p
            and ie_situacao = 'A'
            and si_intent = 'ORDER'
            and (dt_period_start IS NOT NULL AND dt_period_start::text <> '')
            and ( (coalesce(dt_location_p::text, '') = '') or (dt_location_p between dt_period_start and coalesce(dt_period_end, clock_timestamp())) )
        order by nr_sequencia desc
    ) alias8 LIMIT 1;

    RETURN nr_seq_location_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pfcs_get_pat_location ( nr_seq_patient_p bigint, nr_seq_encounter_p bigint, dt_location_p timestamp default null) FROM PUBLIC;
