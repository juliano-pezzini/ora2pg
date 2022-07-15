-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_read_targets ( ie_classification_p text, nm_usuario_p text) AS $body$
DECLARE


	cd_establishment_w	pfcs_operational_level.cd_establishment%type;
	nr_seq_language_w	usuario.nr_seq_idioma%type;

    c01 CURSOR FOR
	SELECT	a.nr_sequencia,
		c.nr_seq_indicator,
		a.ie_condition,
		a.qt_initial_target,
		a.qt_final_target
	from	pfcs_indicator_target a, pfcs_indicator b, pfcs_indicator_rule c
	where	c.nr_seq_indicator = b.nr_sequencia
    and a.nr_seq_rule = c.nr_sequencia
	and	b.ie_classification <> 'CO'
	and	b.ie_classification = coalesce(ie_classification_p,b.ie_classification)
	
union

	SELECT	a.nr_sequencia,
		a.nr_seq_indicator,
		a.ie_condition,
		a.qt_initial_target,
		a.qt_final_target
	from	pfcs_indicator_target_def a, pfcs_indicator b
	where	a.nr_seq_indicator = b.nr_sequencia
	and	b.ie_classification <> 'CO'
	and	b.ie_classification = coalesce(ie_classification_p,b.ie_classification)
	and	not exists (select 1 from pfcs_indicator_rule c where c.nr_seq_indicator = a.nr_seq_indicator);

	c02 CURSOR FOR
	SELECT a.cd_establishment
    from pfcs_operational_level a,
    estabelecimento b
    where b.cd_estabelecimento = isnumber(a.cd_establishment);
BEGIN

	select	coalesce(max(obter_nr_seq_idioma(a.nm_usuario)), obter_pais_sistema(null,null,null)) nr_seq_language
	into STRICT	nr_seq_language_w
	from	usuario a
	where	a.nm_usuario = nm_usuario_p;

	CALL wheb_usuario_pck.set_nr_seq_idioma(nr_seq_language_w);
	CALL philips_param_pck.set_nr_seq_idioma(nr_seq_language_w);
	for c01_w in c01 loop
	begin
		for c02_w in c02 loop
		begin
			cd_establishment_w := c02_w.cd_establishment;

      CALL wheb_usuario_pck.set_cd_estabelecimento(cd_establishment_w);

			/* PFCS - Emergency Department */

			if (c01_w.nr_seq_indicator = 1) then
				CALL pfcs_calculate_waiting_number(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 4) then

				CALL pfcs_acceptable_times(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 7) then

				CALL pfcs_calculate_patient_classif(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 8) then

				CALL pfcs_detailed_accep_times(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 9) then

				CALL pfcs_calculate_box_total(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 10) then

				CALL pfcs_calculate_box_time_total(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 11) then

				CALL pfcs_calculate_box_quantity(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 12) then

				CALL pfcs_calculate_box_time(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 13) then

				CALL pfcs_average_arrival_time(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 14) then

				CALL pfcs_calculate_average_time(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 15) then

				CALL pfcs_hospitalization_rate(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 16) then

				CALL pfcs_patient_medication_rate(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 17) then

				CALL pfcs_time_exceeded_specialty(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			/* PFCS - Bed Management */

			elsif (c01_w.nr_seq_indicator = 18) then

				CALL pfcs_patient_solic_total(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 54) then

				CALL pfcs_patient_solic_urgent(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 19) then

				CALL pfcs_patient_classif_type(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 20) then

				CALL pfcs_accomm_avg_time(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 21) then

				CALL pfcs_calculate_occupancy(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 22) then

				CALL pfcs_calculate_occup_type(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 23) then

				CALL pfcs_inactive_beds(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 25) then

				CALL pfcs_hospitalization_avg_time(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 26) then

				CALL pfcs_patient_expec_discharge(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 27) then

				CALL pfcs_calculate_wo_planned_dis(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 28) then

				CALL pfcs_attend_discharge_total(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 29) then

				CALL pfcs_delayed_sanitization(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 30) then

				CALL pfcs_average_bed_release_time(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 31) then

				CALL pfcs_calculate_readmission(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 32) then

				CALL pfcs_solic_x_discharge(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 55) then

				CALL pfcs_avg_bed_cleaning_time(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			/* PFCS - Surgical Center */

			elsif (c01_w.nr_seq_indicator = 62) then

				CALL pfcs_not_scheduled_surgeries(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 66) then

				CALL pfcs_surgeries_after_deadline(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 63) then

				CALL pfcs_sched_surg_without_opme(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 64) then

				CALL pfcs_hours_available(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 65) then

				CALL pfcs_cost_of_scheduled_opme(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 67) then

				CALL pfcs_sched_surg_of_the_day(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 68) then

				CALL pfcs_available_hours_today(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 69) then

				CALL pfcs_delayed_surgeries(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 70) then

				CALL pfcs_average_setup_time(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 71) then

				CALL pfcs_surgeries_done(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 72) then

				CALL pfcs_calc_post_anesthetic(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 73) then

				CALL pfcs_average_length_of_stay(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);

			elsif (c01_w.nr_seq_indicator = 74) then

				CALL pfcs_discharge_post_anesthetic(
					nr_seq_indicator_p => c01_w.nr_seq_indicator,
					cd_estabelecimento_p => cd_establishment_w,
					nm_usuario_p => nm_usuario_p);
			end if;

		end;
		end loop;

	end;
	end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_read_targets ( ie_classification_p text, nm_usuario_p text) FROM PUBLIC;

