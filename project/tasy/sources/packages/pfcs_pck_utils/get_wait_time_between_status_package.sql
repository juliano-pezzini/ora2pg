-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pfcs_pck_utils.get_wait_time_between_status (nr_seq_encounter_p bigint, ds_status_initial_p text,ds_status_final_p text) RETURNS bigint AS $body$
DECLARE

		nr_wait_time_in_minutes integer;
	
BEGIN
		nr_wait_time_in_minutes := (coalesce(pfcs_pck_utils.get_start_encounter_status(nr_seq_encounter_p,ds_status_final_p), clock_timestamp())
									- pfcs_pck_utils.get_start_encounter_status(nr_seq_encounter_p,ds_status_initial_p))*24*60;
		nr_wait_time_in_minutes := pfcs_pck_utils.get_zero_if_negative(nr_wait_time_in_minutes);

		return nr_wait_time_in_minutes;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pfcs_pck_utils.get_wait_time_between_status (nr_seq_encounter_p bigint, ds_status_initial_p text,ds_status_final_p text) FROM PUBLIC;
