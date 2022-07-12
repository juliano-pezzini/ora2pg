-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pfcs_get_pred_capacity ( nr_sim_census_p text, nr_total_beds_p bigint ) RETURNS varchar AS $body$
DECLARE


nr_census_w         bigint;
nr_census_std_w     smallint;
nr_pred_capacity    varchar(20);


BEGIN
    nr_census_w     := (REGEXP_SUBSTR(nr_sim_census_p, '[^;]+', 1, 1))::numeric;
    nr_census_std_w := (REGEXP_SUBSTR(nr_sim_census_p, '[^;]+', 1, 2))::numeric;

    nr_pred_capacity    := pfcs_get_percentage_value(nr_census_w, nr_total_beds_p) || ';' || pfcs_get_percentage_value(nr_census_std_w, nr_total_beds_p);

    RETURN nr_pred_capacity;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pfcs_get_pred_capacity ( nr_sim_census_p text, nr_total_beds_p bigint ) FROM PUBLIC;

