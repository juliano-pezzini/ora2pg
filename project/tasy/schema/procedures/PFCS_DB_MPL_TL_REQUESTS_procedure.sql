-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_db_mpl_tl_requests ( nr_seq_indicator_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_total_req_count_pfcs_w	bigint := 0;
pfcs_panel_detail_seq_w		pfcs_panel_detail.nr_sequencia%type;
nr_seq_panel_w				pfcs_panel.nr_sequencia%type;


--Declare cursor begins
/*Cursor to calculate total telemetry request from pfcs integration table */

cur_get_tot_tele_req_pfcs CURSOR FOR
	SELECT	enc.id_encounter nr_encounter,
			pat.patient_id id_patient,
			pfcs_get_human_name(enc.nr_seq_patient, 'Patient') nm_patient,
			pfcs_get_tele_time(sr.nr_sequencia, 'R') nr_time_waiting,
			enc.ds_reason diagnosis,
			pat.birthdate dob_patiente,
			trunc(months_between(coalesce(pat.deceased_date, clock_timestamp()), pat.birthdate)/12) qt_idade_paciente,
			pat.gender gender,
			enc.ds_classification ds_classification,
			enc.period_start dt_entrance,
			pfcs_get_human_name(pfcs_get_practitioner_seq(enc.nr_sequencia, '405279007'), 'Practitioner') ds_attending_physician,
			pfcs_get_code_status_tl(pat.nr_sequencia,'S') ds_dnr_status,
			sa.ds_setor_atendimento ds_department,
            CASE WHEN coalesce(sa.ds_setor_atendimento::text, '') = '' THEN  uni.cd_unidade_basica || '-' || uni.cd_unidade_compl  ELSE sa.ds_setor_atendimento || '-' || uni.cd_unidade_basica || '-' || uni.cd_unidade_compl END  ds_bed,
			pfcs_get_frequent_flyer(enc.nr_sequencia) ie_frequent_flyer,
			pat.nr_sequencia ds_recurring_patient,
			pfcs_get_edi_score(enc.nr_sequencia) as nr_edi_score,
			pfcs_obs_contributor_pck.get_freqflyer_visits(enc.nr_sequencia) ds_recur_pat_adm_data,
			pfcs_obs_contributor_pck.get_freqflyer_comorbidities(enc.nr_sequencia) ds_recur_pat_comorbd,
			pfcs_obs_contributor_pck.get_freqflyer_visit_reason(enc.nr_sequencia) ds_recur_pat_reasons,
			pfcs_obs_contributor_pck.get_edi_vital_warnings(enc.nr_sequencia) ds_edi_vitals_warn,
			pfcs_obs_contributor_pck.get_edi_contributors(enc.nr_sequencia) ds_edi_contrb
	from	pfcs_service_request sr,
			pfcs_encounter enc,
			pfcs_patient pat,
			pfcs_encounter_location el,
            unidade_atendimento uni,
            setor_atendimento sa
	where	sr.si_status = 'ACTIVE'
	and		sr.cd_service = 'E0404'
	and		sr.nr_seq_encounter = enc.nr_sequencia
	and		enc.si_status in ('PLANNED', 'ARRIVED')
	and		enc.nr_seq_patient = pat.nr_sequencia
	and		pat.ie_active = '1'
	and		pat.nr_sequencia not in (SELECT	dev.nr_seq_patient
			from	pfcs_device dev
			where	dev.si_status = 'ACTIVE'
			and	dev.ds_device_type = 'Monitor'
			and	(dev.nr_seq_patient IS NOT NULL AND dev.nr_seq_patient::text <> ''))
	and 	el.nr_seq_encounter = enc.nr_sequencia
	and 	uni.nr_seq_location = el.nr_seq_location
	and 	uni.ie_situacao = 'A'
	and 	uni.cd_setor_atendimento = sa.cd_setor_atendimento
	and 	sa.ie_situacao = 'A'
	and 	sa.cd_classif_setor in ('1','3','4','9','11','12')
	and 	sa.cd_estabelecimento_base = cd_estabelecimento_p;
--Declare cursor Ends
BEGIN
	for r_c01 in cur_get_tot_tele_req_pfcs loop
	
		nr_total_req_count_pfcs_w := nr_total_req_count_pfcs_w + 1;
		select nextval('pfcs_panel_detail_seq') into STRICT pfcs_panel_detail_seq_w;

		 CALL pfcs_pck_v2.pfcs_insert_details(
			nr_seq_indicator_p => nr_seq_indicator_p,
			nr_seq_operational_level_p	=> cd_estabelecimento_p,
			nm_usuario_p => nm_usuario_p,
			nr_panel_detail_seq_p => pfcs_panel_detail_seq_w,
			nr_encounter_p => r_c01.nr_encounter,
			id_patient_p => r_c01.id_patient,
			nm_patient_p => r_c01.nm_patient,
			dt_birthdate_p => r_c01.dob_patiente,
			ds_primary_diagnosis_p => r_c01.diagnosis,
			ds_gender_p => r_c01.gender,
			ds_dnr_status_p => r_c01.ds_dnr_status,
			qt_time_telemetry_p => r_c01.nr_time_waiting,
			ds_classification_p => r_c01.ds_classification,
			dt_entrance_p => r_c01.dt_entrance,
			ds_service_line_p => r_c01.ds_attending_physician,
			cd_department_p => r_c01.ds_department,
			ds_department_p => r_c01.ds_department,
			ds_bed_location_p => r_c01.ds_bed,
			ds_age_range_p => r_c01.qt_idade_paciente,
			ie_frequent_flyer_p => r_c01.ie_frequent_flyer,
			ds_recurring_patient_p => r_c01.ds_recurring_patient,
			nr_edi_score_p =>  r_c01.nr_edi_score,
			ds_rec_pat_adm_data_p =>  r_c01.ds_recur_pat_adm_data,
			ds_rec_pat_comorbd_p =>  r_c01.ds_recur_pat_comorbd,
			ds_rec_pat_reasons_p =>  r_c01.ds_recur_pat_reasons,
			ds_edi_vitals_warn_p =>  r_c01.ds_edi_vitals_warn,
			ds_edi_contrb_p =>  r_c01.ds_edi_contrb);
	end loop;

	 := pfcs_pck_v2.pfcs_generate_results(
		vl_indicator_p => nr_total_req_count_pfcs_w, ds_reference_value_p => null, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => cd_estabelecimento_p, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => nr_seq_panel_w);

	CALL pfcs_pck_v2.pfcs_update_detail(
		nr_seq_indicator_p => nr_seq_indicator_p,
		nr_seq_panel_p => nr_seq_panel_w,
		nr_seq_operational_level_p => cd_estabelecimento_p,
		nm_usuario_p => nm_usuario_p);

  commit;

  CALL pfcs_pck_v2.pfcs_activate_records(
		nr_seq_indicator_p => nr_seq_indicator_p,
		nr_seq_operational_level_p => cd_estabelecimento_p,
		nm_usuario_p => nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_db_mpl_tl_requests ( nr_seq_indicator_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

