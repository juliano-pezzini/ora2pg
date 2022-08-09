-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_calculate_wo_planned_dis ( nr_seq_indicator_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


--Tasy Cursor
c01 CURSOR FOR
SELECT	d.cd_setor_atendimento cd_department,
	d.ds_setor_atendimento ds_department,
	c.cd_unidade_basica || ' ' || c.cd_unidade_compl ds_location,
	substr(obter_valor_dominio(82, c.ie_status_unidade),1,255) ds_status,
	c.ie_status_unidade ie_status,
	b.dt_entrada_unidade dt_entry_unit,
	a.cd_pessoa_fisica id_patient,
	coalesce(get_formatted_person_name(a.cd_pessoa_fisica, 'list'), obter_nome_pf(a.cd_pessoa_fisica)) nm_patient,
	pfcs_obter_lista_dados_classif(a.cd_pessoa_fisica) ds_classification,
	obter_sexo_pf(a.cd_pessoa_fisica, 'D') ds_gender,
	pf.dt_nascimento dt_birthdate,
    obter_dados_pf(a.cd_pessoa_fisica, 'I') qt_idade_paciente,
	a.nr_atendimento nr_encounter,
	a.dt_entrada dt_entrance,
	coalesce(get_formatted_person_name(a.cd_medico_resp, 'list'), obter_nome_pf(a.cd_medico_resp)) ds_physician,
	a.dt_previsto_alta dt_expected_discharge
from 	setor_atendimento	d,
	unidade_atendimento	c,
	atend_paciente_unidade b,
	atendimento_paciente	a,
	pessoa_fisica pf
where 	a.nr_atendimento	= b.nr_atendimento
and	a.cd_pessoa_fisica	= pf.cd_pessoa_fisica
and	c.cd_setor_atendimento	= b.cd_setor_atendimento
and	c.cd_unidade_basica	= b.cd_unidade_basica
and	c.cd_unidade_compl	= b.cd_unidade_compl
and	b.nr_seq_interno	= obter_atepacu_paciente(a.nr_atendimento,'A')
and	c.ie_situacao		= 'A'
and	c.cd_setor_atendimento	= d.cd_setor_atendimento
and	c.ie_situacao		= 'A'
and	d.ie_situacao		= 'A'
and	d.cd_classif_setor	in ('1','3','4','9','11','12')
and	d.ie_ocup_hospitalar	<> 'N'
and	coalesce(a.dt_cancelamento::text, '') = ''
and	coalesce(a.dt_alta::text, '') = ''
and (coalesce(a.dt_previsto_alta::text, '') = '' or trunc(a.dt_previsto_alta) < trunc(clock_timestamp()))
and	a.cd_estabelecimento = cd_estabelecimento_p;

--Integration Cursor
c01_fhir CURSOR FOR
SELECT	sec.cd_setor_atendimento cd_department,
	sec.ds_setor_atendimento ds_department,
	uni.cd_unidade_basica || ' ' || uni.cd_unidade_compl ds_location,
	substr(obter_valor_dominio(82, uni.ie_status_unidade),1,255) ds_status,
	uni.ie_status_unidade ie_status,
	uni.dt_entrada_unidade dt_entry_unit,
	pat.patient_id id_patient,
	pfcs_get_human_name(pat.nr_sequencia, 'Patient') nm_patient,
	enc.si_classif ds_classification,
	PFCS_GET_PATIENT_GENDER(pat.gender) ds_gender,
	pat.birthdate dt_birthdate,
    trunc(months_between(coalesce(pat.deceased_date, clock_timestamp()), pat.birthdate)/12) qt_idade_paciente,
	enc.id_encounter nr_encounter,
	enc.period_start dt_entrance,
	pfcs_get_human_name_orntn(pfcs_get_practitioner_seq(enc.nr_sequencia), 'Practitioner' ,'.',2) ds_physician,
    (select max(aux.dt_authored_on) from pfcs_Service_request aux where
        aux.nr_seq_patient = pat.nr_sequencia
        and aux.nr_seq_encounter = enc.nr_sequencia
        and aux.si_status = 'ACTIVE'
        and aux.si_intent = 'PLAN'
        and aux.cd_service = 'E0405' )dt_expected_discharge
from 	setor_atendimento	sec,
        unidade_atendimento	uni,
        pfcs_encounter enc,
        pfcs_patient pat
where	uni.nr_seq_location = pfcs_get_pat_location(pat.nr_sequencia, enc.nr_sequencia)
and uni.cd_setor_atendimento	= sec.cd_setor_atendimento
and enc.nr_seq_patient = pat.nr_sequencia
and	uni.ie_situacao		= 'A'
and	sec.ie_situacao		= 'A'
and	sec.cd_classif_setor	in ('1','3','4','9','11','12')
and	sec.ie_ocup_hospitalar	<> 'N'
and (enc.period_start IS NOT NULL AND enc.period_start::text <> '')
and coalesce(enc.period_end::text, '') = ''
and	sec.cd_estabelecimento = cd_estabelecimento_p
and not exists (
    SELECT 1 from pfcs_service_request ser
    where ser.nr_seq_patient = pat.nr_sequencia
    and ser.nr_seq_encounter = enc.nr_sequencia
    and ser.si_status = 'ACTIVE'
    and ser.si_intent = 'PLAN'
    and ser.cd_service = 'E0405'
    and trunc(ser.dt_authored_on) = trunc(clock_timestamp())
);

-- Variables
qt_total_w				        bigint := 0;
pfcs_panel_detail_seq_w			pfcs_panel_detail.nr_sequencia%type;
nr_seq_operational_level_w		pfcs_operational_level.nr_sequencia%type;
nr_seq_panel_w				    pfcs_panel.nr_sequencia%type;
pfcs_flag_settings_w            pfcs_general_rule.ie_table_origin%type;
BEGIN

	nr_seq_operational_level_w := pfcs_get_structure_level(
		cd_establishment_p => cd_estabelecimento_p,
		ie_level_p => 'O',
		ie_info_p => 'C');

select ie_table_origin
    into STRICT pfcs_flag_settings_w
from pfcs_general_rule;

-- Tasy tables or both
if (pfcs_flag_settings_w = 0 or pfcs_flag_settings_w = 2) then
   for c01_w in c01 loop
		begin
			qt_total_w := qt_total_w + 1;

			select	nextval('pfcs_panel_detail_seq')
			into STRICT	pfcs_panel_detail_seq_w
			;

			insert into pfcs_panel_detail(
				nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				ie_situation,
				nr_seq_indicator,
				nr_seq_operational_level)
			values (
				pfcs_panel_detail_seq_w,
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				'T',
				nr_seq_indicator_p,
				nr_seq_operational_level_w);

			insert into pfcs_detail_patient(
				nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				nr_seq_detail,
				nr_encounter_varchar,
				dt_entrance,
				id_patient,
				nm_patient,
				ds_gender,
				ds_classification,
				dt_birthdate,
                ds_age_range,
				ds_physician,
				dt_expected_discharge)
			values (
				nextval('pfcs_detail_patient_seq'),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				pfcs_panel_detail_seq_w,
				c01_w.nr_encounter,
				c01_w.dt_entrance,
				c01_w.id_patient,
				c01_w.nm_patient,
				c01_w.ds_gender,
				c01_w.ds_classification,
				c01_w.dt_birthdate,
                c01_w.qt_idade_paciente,
				c01_w.ds_physician,
				c01_w.dt_expected_discharge);

			insert into pfcs_detail_bed(
				nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				nr_seq_detail,
				ds_location,
				cd_department,
				ds_department,
				ds_status,
				ie_status,
				dt_entry_unit)
			values (
				nextval('pfcs_detail_bed_seq'),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				pfcs_panel_detail_seq_w,
				c01_w.ds_location,
				c01_w.cd_department,
				c01_w.ds_department,
				c01_w.ds_status,
				c01_w.ie_status,
				c01_w.dt_entry_unit);
		end;
	end loop;
end if;

 -- Integration tables or both
if (pfcs_flag_settings_w = 1 or pfcs_flag_settings_w = 2) then
   for c01_f in c01_fhir loop
		begin
			qt_total_w := qt_total_w + 1;

			select	nextval('pfcs_panel_detail_seq')
			into STRICT	pfcs_panel_detail_seq_w
			;

			insert into pfcs_panel_detail(
				nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				ie_situation,
				nr_seq_indicator,
				nr_seq_operational_level)
			values (
				pfcs_panel_detail_seq_w,
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				'T',
				nr_seq_indicator_p,
				nr_seq_operational_level_w);

			insert into pfcs_detail_patient(
				nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				nr_seq_detail,
				nr_encounter_varchar,
				dt_entrance,
				id_patient,
				nm_patient,
				ds_gender,
				ds_classification,
				dt_birthdate,
                ds_age_range,
				ds_physician,
				dt_expected_discharge)
			values (
				nextval('pfcs_detail_patient_seq'),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				pfcs_panel_detail_seq_w,
				c01_f.nr_encounter,
				c01_f.dt_entrance,
				c01_f.id_patient,
				c01_f.nm_patient,
				c01_f.ds_gender,
				c01_f.ds_classification,
				c01_f.dt_birthdate,
                c01_f.qt_idade_paciente,
				c01_f.ds_physician,
				c01_f.dt_expected_discharge);

			insert into pfcs_detail_bed(
				nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				nr_seq_detail,
				ds_location,
				cd_department,
				ds_department,
				ds_status,
				ie_status,
				dt_entry_unit)
			values (
				nextval('pfcs_detail_bed_seq'),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				pfcs_panel_detail_seq_w,
				c01_f.ds_location,
				c01_f.cd_department,
				c01_f.ds_department,
				c01_f.ds_status,
				c01_f.ie_status,
				c01_f.dt_entry_unit);
		end;
	end loop;
end if;


 := pfcs_pck.pfcs_generate_results(
	vl_indicator_p => qt_total_w, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => nr_seq_operational_level_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => nr_seq_panel_w);

CALL pfcs_pck.pfcs_update_detail(
	nr_seq_indicator_p => nr_seq_indicator_p,
	nr_seq_panel_p => nr_seq_panel_w,
	nr_seq_operational_level_p => nr_seq_operational_level_w,
	nm_usuario_p => nm_usuario_p);

CALL pfcs_pck.pfcs_activate_records(
	nr_seq_indicator_p => nr_seq_indicator_p,
	nr_seq_operational_level_p => nr_seq_operational_level_w,
	nm_usuario_p => nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_calculate_wo_planned_dis ( nr_seq_indicator_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
