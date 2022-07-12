-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pfcs_obs_contributor_pck.get_observation_value ( nr_seq_encounter_p bigint, cd_observation_type_p text) RETURNS bigint AS $body$
DECLARE

		nr_referencia_w	bigint;
	
BEGIN
        select	to_number(vl_referencia, '999999.99')
            into STRICT	nr_referencia_w
            from	pfcs_observation obs
            where	nr_seq_encounter =  nr_seq_encounter_p
            and	cd_observation_type = cd_observation_type_p
            order by obs.dt_atualizacao desc LIMIT 1;

		return nr_referencia_w;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pfcs_obs_contributor_pck.get_observation_value ( nr_seq_encounter_p bigint, cd_observation_type_p text) FROM PUBLIC;
