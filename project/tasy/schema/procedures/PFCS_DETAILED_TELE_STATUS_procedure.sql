-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_detailed_tele_status ( nr_seq_indicator_p bigint, cd_estabelecimento_p text, nm_usuario_p text) AS $body$
DECLARE


  ie_telemetria varchar(5) := 'S';
  ie_started_status varchar(5) := 'S';
  qt_time_review_rule bigint := 72 * 60;

  ie_active								smallint := 1;
  ds_tele_req_status					varchar(15) := 'R';
  ds_active_status						varchar(15) := 'ACTIVE';
  ds_inactive_status					varchar(15) := 'INACTIVE';
  ds_planned_status						varchar(15) := 'PLANNED';
  ds_arrived_status						varchar(15) := 'ARRIVED';
  ds_service_requested					varchar(10) := 'E0404';
  ds_service_requ_disch					varchar(10) := 'E0403';
  ds_service_status						varchar(15) := 'COMPLETED';
  ds_monitor_dev_type 					varchar(10) := 'Monitor';
  pfcs_flag_settings          			smallint := 0;

cur_get_tot_review_pfcs CURSOR FOR
SELECT ds_unit,
		sum(qt_orders_written) qt_orders_written,
		sum(qt_patients_to_review) qt_patients_to_review
    from (
        SELECT loc.ds_department ds_unit,
        count(enc.nr_sequencia)  qt_orders_written,
        0 qt_patients_to_review
        from pfcs_service_request sr,
          pfcs_encounter enc,
          pfcs_patient pat,
          pfcs_encounter_identifier eid,
          pfcs_encounter_location el,
          pfcs_location loc,
          pfcs_device pd
        where
          sr.si_status =  ds_active_status
          and sr.cd_service = ds_service_requ_disch
          and sr.nr_seq_encounter = enc.nr_sequencia
          and enc.si_status in (ds_planned_status, ds_arrived_status)
          and eid.nr_seq_encounter = enc.nr_sequencia
          and el.nr_seq_encounter = enc.nr_sequencia
          and el.nr_seq_location = loc.nr_sequencia
          and enc.nr_seq_patient = pat.nr_sequencia
          and pat.ie_active = ie_active
          and pat.nr_seq_organization = (cd_estabelecimento_p)::numeric
          and pat.nr_sequencia = pd.nr_seq_patient
          and loc.si_status = ds_active_status
          and pd.si_status = ds_active_status
          and pd.ds_device_type = ds_monitor_dev_type
        group by loc.ds_department
      
union

        select loc.ds_department ds_unit,
          0 qt_orders_written,
          count(enc.nr_sequencia) qt_patients_to_review
        from pfcs_service_request sr,
          pfcs_encounter enc,
          pfcs_patient pat,
          pfcs_encounter_identifier eid,
          pfcs_encounter_location el,
          pfcs_location loc,
          pfcs_device pd
        where
          sr.si_status = ds_service_status
          and sr.cd_service = ds_service_requested
          and sr.nr_seq_encounter = enc.nr_sequencia
          and enc.si_status in (ds_planned_status, ds_arrived_status)
          and eid.nr_seq_encounter = enc.nr_sequencia
          and el.nr_seq_encounter = enc.nr_sequencia
          and el.nr_seq_location = loc.nr_sequencia
          and enc.nr_seq_patient = pat.nr_sequencia
          and pat.ie_active = ie_active
          and pat.nr_seq_organization = (cd_estabelecimento_p)::numeric 
          and pat.nr_sequencia = pd.nr_seq_patient
          and loc.si_status = ds_active_status
          and pd.si_status = ds_active_status
          and pd.ds_device_type = ds_monitor_dev_type
          group by loc.ds_department) alias8
      group by ds_unit;

	cur_get_tot_review_tasy CURSOR FOR
		SELECT ds_unit,
		sum(qt_orders_written) qt_orders_written,
		sum(qt_patients_to_review) qt_patients_to_review
    from (
        SELECT sa.ds_setor_atendimento ds_unit, 0 qt_orders_written,
        count(cr.nr_sequencia) qt_patients_to_review
        from atendimento_paciente ap,
			cpoe_recomendacao cr,
			atend_paciente_unidade apu,
			setor_atendimento sa,
			tipo_recomendacao tr
		where ap.nr_atendimento = cr.nr_atendimento
		and cr.nr_atendimento = apu.nr_atendimento
		and apu.nr_seq_interno = obter_atepacu_paciente(apu.nr_atendimento, 'A')
		and apu.cd_setor_atendimento = sa.cd_setor_atendimento
		and cr.cd_recomendacao = tr.cd_tipo_recomendacao
		and tr.ie_telemetria = ie_telemetria
		and coalesce(ap.dt_cancelamento::text, '') = ''
		and coalesce(ap.dt_alta::text, '') = ''
		and coalesce(cr.dt_suspensao::text, '') = ''
        and apu.dt_saida_unidade is  null
		and pfcs_get_recommendation_status(cr.nr_sequencia) = ie_started_status
		and pfcs_get_time_on_tele(ap.nr_atendimento,'TL', cd_estabelecimento_p) > qt_time_review_rule
		and coalesce(ap.dt_alta_medico::text, '') = ''
		and ap.cd_estabelecimento = (cd_estabelecimento_p)::numeric
		group by sa.ds_setor_atendimento
    
union

		select sa.ds_setor_atendimento ds_unit,
			count(cr.nr_sequencia) qt_orders_written,
			0 qt_patients_to_review
		from atendimento_paciente ap,
			 cpoe_recomendacao cr,
			 atend_paciente_unidade apu,
			 setor_atendimento sa,
			 tipo_recomendacao tr
		where cr.nr_atendimento = ap.nr_atendimento
		and apu.nr_atendimento  = cr.nr_atendimento
		and apu.nr_seq_interno = obter_atepacu_paciente(apu.nr_atendimento, 'A')
		and apu.cd_setor_atendimento = sa.cd_setor_atendimento
		and cr.cd_recomendacao = tr.cd_tipo_recomendacao
		and tr.ie_telemetria = ie_telemetria
		and coalesce(ap.dt_cancelamento::text, '') = ''
		and apu.dt_saida_unidade is  null
		and pfcs_get_recommendation_status(cr.nr_sequencia) = ie_started_status
		and (ap.dt_alta_medico IS NOT NULL AND ap.dt_alta_medico::text <> '')
    and coalesce(ap.dt_alta::text, '') = ''
    and coalesce(cr.dt_suspensao::text, '') = ''
		and ap.cd_estabelecimento = (cd_estabelecimento_p)::numeric 
		group by sa.ds_setor_atendimento) alias19
    group by ds_unit;

nr_seq_operational_level_w pfcs_operational_level.nr_sequencia%type;
nr_seq_panel_w pfcs_panel.nr_sequencia%type;
BEGIN

  nr_seq_operational_level_w := pfcs_get_structure_level( cd_establishment_p => cd_estabelecimento_p, ie_level_p => 'O', ie_info_p => 'C');

  select ie_table_origin into STRICT pfcs_flag_settings from pfcs_general_rule;

if (pfcs_flag_settings = 0 or pfcs_flag_settings = 2) then
  for c01_w in cur_get_tot_review_tasy loop
    begin

       := pfcs_pck.pfcs_generate_results(
        vl_indicator_p => c01_w.qt_orders_written, vl_indicator_aux_p => c01_w.qt_patients_to_review, ds_reference_value_p => c01_w.ds_unit, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => nr_seq_operational_level_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => nr_seq_panel_w);


    end;
  end loop;
 end if;

 if (pfcs_flag_settings = 1 or pfcs_flag_settings = 2) then
  for c01_w in cur_get_tot_review_pfcs loop

       := pfcs_pck.pfcs_generate_results(
        vl_indicator_p => c01_w.qt_orders_written, vl_indicator_aux_p => c01_w.qt_patients_to_review, ds_reference_value_p => c01_w.ds_unit, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => nr_seq_operational_level_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => nr_seq_panel_w);

  end loop;
 end if;

commit;

  CALL pfcs_pck.pfcs_activate_records(
    nr_seq_indicator_p => nr_seq_indicator_p,
    nr_seq_operational_level_p => nr_seq_operational_level_w,
    nm_usuario_p => nm_usuario_p );

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_detailed_tele_status ( nr_seq_indicator_p bigint, cd_estabelecimento_p text, nm_usuario_p text) FROM PUBLIC;

