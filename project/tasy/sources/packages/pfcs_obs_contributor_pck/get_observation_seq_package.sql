-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pfcs_obs_contributor_pck.get_observation_seq ( nr_seq_encounter_p bigint, cd_observation_type_p text) RETURNS bigint AS $body$
DECLARE

		nr_sequencia_w		pfcs_observation.nr_sequencia%type;
	
BEGIN
		if (cd_observation_type_p = current_setting('pfcs_obs_contributor_pck.cd_freqflyer_type_w')::varchar(100)) then
			select	coalesce(max(nr_sequencia),'')
			  into STRICT	nr_sequencia_w
			  from (SELECT	nr_sequencia
					   from	pfcs_observation obs
					  where	nr_seq_encounter =  nr_seq_encounter_p
						and	obs.nr_freq_flyer = 1
						and	cd_observation_type = cd_observation_type_p
					order by obs.dt_atualizacao desc) alias5 LIMIT 1;
		else
			select	coalesce(max(nr_sequencia),'')
			  into STRICT	nr_sequencia_w
			  from (SELECT	nr_sequencia
					   from	pfcs_observation obs
					  where	nr_seq_encounter =  nr_seq_encounter_p
						and	cd_observation_type = cd_observation_type_p
					order by obs.dt_atualizacao desc) alias2 LIMIT 1;
		end if;

		return nr_sequencia_w;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pfcs_obs_contributor_pck.get_observation_seq ( nr_seq_encounter_p bigint, cd_observation_type_p text) FROM PUBLIC;