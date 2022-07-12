-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pont_esc_cognitive_md ( qt_age_p bigint, qt_dob_p bigint, qt_address_p bigint, qt_year_p bigint, qt_location_p bigint, qt_recognize_object_p bigint, qt_time_p bigint, qt_second_par_p bigint, qt_prime_minister_p bigint, qt_count_down_p bigint ) RETURNS bigint AS $body$
BEGIN
    RETURN( coalesce(qt_age_p, 0) + coalesce(qt_dob_p, 0) + coalesce(qt_address_p, 0) + coalesce(qt_year_p, 0) + coalesce(qt_location_p, 0) + coalesce(qt_recognize_object_p,0)
            + coalesce(qt_time_p, 0) + coalesce(qt_second_par_p, 0) + coalesce(qt_prime_minister_p, 0) + coalesce(qt_count_down_p, 0) );
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pont_esc_cognitive_md ( qt_age_p bigint, qt_dob_p bigint, qt_address_p bigint, qt_year_p bigint, qt_location_p bigint, qt_recognize_object_p bigint, qt_time_p bigint, qt_second_par_p bigint, qt_prime_minister_p bigint, qt_count_down_p bigint ) FROM PUBLIC;

