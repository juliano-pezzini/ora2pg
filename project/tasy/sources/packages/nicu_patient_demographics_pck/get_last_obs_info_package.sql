-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION nicu_patient_demographics_pck.get_last_obs_info ( nr_seq_patient_p bigint, ds_id_rule_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w    varchar(2000) := '';


BEGIN
    select	max(value_result)
    into STRICT	ds_retorno_w
    from (	SELECT	value_result
                from	nicu_observation
                where	nr_seq_patient = nr_seq_patient_p
                and     id_rule = ds_id_rule_p
                order by nr_seq_patient desc, dt_observation desc) alias1 LIMIT 1;

    return ds_retorno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION nicu_patient_demographics_pck.get_last_obs_info ( nr_seq_patient_p bigint, ds_id_rule_p text) FROM PUBLIC;