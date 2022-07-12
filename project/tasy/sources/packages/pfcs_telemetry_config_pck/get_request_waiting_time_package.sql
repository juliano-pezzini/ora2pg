-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pfcs_telemetry_config_pck.get_request_waiting_time (nr_seq_encounter_p bigint) RETURNS bigint AS $body$
DECLARE

		nr_request_time_w			bigint := 0;
	
BEGIN
		select	round((clock_timestamp() - coalesce(sr.dt_authored_on,clock_timestamp())) * 24 * 60)
		  into STRICT	nr_request_time_w
		  from	pfcs_service_request sr
		 where	sr.nr_seq_encounter = nr_seq_encounter_p
		   and	sr.si_status = 'ACTIVE'
		   and	sr.cd_service = 'E0404';

		return nr_request_time_w;

		exception
		when no_data_found then
		  return 0;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pfcs_telemetry_config_pck.get_request_waiting_time (nr_seq_encounter_p bigint) FROM PUBLIC;