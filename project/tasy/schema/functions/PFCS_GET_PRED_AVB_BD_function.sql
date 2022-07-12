-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pfcs_get_pred_avb_bd ( sim_census_p text, total_beds_p bigint ) RETURNS varchar AS $body$
DECLARE


census_w        bigint;
census_std_w    smallint;
ds_pred_bds     varchar(20);


BEGIN
    census_w := (REGEXP_SUBSTR(sim_census_p, '[^;]+', 1, 1))::numeric;
    census_std_w := (REGEXP_SUBSTR(sim_census_p, '[^;]+', 1, 2))::numeric;

    ds_pred_bds := (total_beds_p - census_w) || ';' || census_std_w;
    RETURN ds_pred_bds;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pfcs_get_pred_avb_bd ( sim_census_p text, total_beds_p bigint ) FROM PUBLIC;
