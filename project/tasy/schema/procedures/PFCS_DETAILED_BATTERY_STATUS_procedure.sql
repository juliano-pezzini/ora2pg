-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_detailed_battery_status ( nr_seq_indicator_p bigint, cd_estabelecimento_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_operational_level_w    pfcs_operational_level.nr_sequencia%type;
pfcs_panel_detail_seq_w			pfcs_panel_detail.nr_sequencia%type;
nr_seq_panel_w					pfcs_panel_detail.nr_seq_panel%type;


device_type varchar(10) := 'TL';
ie_telemetria varchar(5) :='S';
ie_rec_status varchar(5) :='S';
ie_not_rec_status varchar(5) :='F';

	ds_planned_status				varchar(15) := 'PLANNED';
	ds_arrived_status				varchar(15) := 'ARRIVED';
  ds_complete_status				varchar(15) := 'COMPLETED';
  ds_active_status			varchar(15) := 'ACTIVE';
  ds_low_battery_code		varchar(15) := 'D0401';
  ds_empty_battery_code		varchar(15) := 'D0402';
  ds_service_requested      varchar(10) := 'E0403';
  ds_service_completed					varchar(10) := 'E0404';
  ds_monitor_dev_type 			varchar(10) := 'Monitor';
	ds_service_status				varchar(15) := 'COMPLETED';

c01 CURSOR FOR
  SELECT ds_unit,
		 sum(qt_low_battery_status) low_battery_status,
		 sum(qt_empty_battery_status) empty_battery_status
	from(
		SELECT loc.ds_department ds_unit,
			count(ppf.nr_sequencia) qt_low_battery_status,
			0 qt_empty_battery_status
			from pfcs_service_request sr,
				pfcs_patient_flag ppf,
				pfcs_encounter enc,
				pfcs_patient pat,
				pfcs_encounter_location el,
				pfcs_location loc,
				pfcs_device pd
			where ((sr.si_status = ds_complete_status
      and sr.cd_service = ds_service_completed) or (sr.si_status = ds_active_status
      and sr.cd_service = ds_service_requested))
      and ppf.nr_seq_patient = pat.nr_sequencia
			and ppf.si_status = ds_active_status
      and sr.nr_seq_encounter = enc.nr_sequencia
			and el.nr_seq_encounter = enc.nr_sequencia
			and el.nr_seq_location = loc.nr_sequencia
			and loc.si_status = ds_active_status
			and ppf.cd_flag = ds_low_battery_code
			and pat.nr_sequencia = pd.nr_seq_patient
			and pd.si_status = ds_active_status
			and pd.ds_device_type = ds_monitor_dev_type
      and enc.nr_seq_patient = pat.nr_sequencia
      and coalesce(ppf.period_end::text, '') = ''
      and pd.nr_seq_organization = (cd_estabelecimento_p)::numeric
			group by loc.ds_department
		
union

			select loc.ds_department ds_unit,
			0 qt_low_battery_status,
			count(ppf.nr_sequencia) qt_empty_battery_status
			from pfcs_service_request sr,
				pfcs_patient_flag ppf,
				pfcs_encounter enc,
				pfcs_patient pat,
				pfcs_encounter_location el,
				pfcs_location loc,
				pfcs_device pd
			where ((sr.si_status = ds_complete_status
      and sr.cd_service = ds_service_completed) or (sr.si_status = ds_active_status
      and sr.cd_service = ds_service_requested))
      and ppf.nr_seq_patient = pat.nr_sequencia
			and ppf.si_status = ds_active_status
      and sr.nr_seq_encounter = enc.nr_sequencia
			and el.nr_seq_encounter = enc.nr_sequencia
			and el.nr_seq_location = loc.nr_sequencia
			and loc.si_status = ds_active_status
			and ppf.cd_flag = ds_empty_battery_code
			and pat.nr_sequencia = pd.nr_seq_patient
			and pd.si_status = ds_active_status
			and pd.ds_device_type = ds_monitor_dev_type
      and enc.nr_seq_patient = pat.nr_sequencia
      and coalesce(ppf.period_end::text, '') = ''
      and pd.nr_seq_organization =  (cd_estabelecimento_p)::numeric 
			group by loc.ds_department)
		group by ds_unit;

BEGIN

 nr_seq_operational_level_w := pfcs_get_structure_level(
									cd_establishment_p => cd_estabelecimento_p,
									ie_level_p => 'O',
									ie_info_p => 'C');

for r_c01 in c01 loop

	select 	nextval('pfcs_panel_detail_seq') into STRICT 	pfcs_panel_detail_seq_w;

      := pfcs_pck.pfcs_generate_results(
        vl_indicator_p => r_c01.low_battery_status, vl_indicator_aux_p => r_c01.empty_battery_status, ds_reference_value_p => r_c01.ds_unit, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => nr_seq_operational_level_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => nr_seq_panel_w);

end loop;

commit;

CALL pfcs_pck.pfcs_activate_records(
		nr_seq_indicator_p => nr_seq_indicator_p,
		nr_seq_operational_level_p => nr_seq_operational_level_w,
		nm_usuario_p => nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_detailed_battery_status ( nr_seq_indicator_p bigint, cd_estabelecimento_p text, nm_usuario_p text) FROM PUBLIC;

