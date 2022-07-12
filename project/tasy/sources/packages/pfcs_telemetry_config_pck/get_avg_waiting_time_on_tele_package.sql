-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pfcs_telemetry_config_pck.get_avg_waiting_time_on_tele (cd_establishment_p bigint, cd_department_p text) RETURNS bigint AS $body$
DECLARE

		nr_time_on_tele_w	bigint := 0;
		nr_total_patients_w	bigint := 0;
	
BEGIN
		select	sum(round(((clock_timestamp() - pdp.dt_monitor_entrance) * 1440 ))) nr_time_on_tele,
				count(1) nr_total_patients
		into STRICT	nr_time_on_tele_w,
				nr_total_patients_w
		from	pfcs_panel_detail ppd,
				pfcs_detail_patient pdp,
				pfcs_detail_bed pdb
		where	ppd.nr_seq_indicator = 46
		and	ppd.nr_sequencia = pdp.nr_seq_detail
		and	ppd.nr_sequencia = pdb.nr_seq_detail
		and	ppd.nr_seq_operational_level = cd_establishment_p
		and (coalesce(cd_department_p::text, '') = '' or pdb.cd_department = cd_department_p or ds_department = cd_department_p)
		and	ppd.ie_situation = pfcs_pck_constants.IE_ACTIVE;

		return round(dividir_sem_round(nr_time_on_tele_w, nr_total_patients_w));

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pfcs_telemetry_config_pck.get_avg_waiting_time_on_tele (cd_establishment_p bigint, cd_department_p text) FROM PUBLIC;
