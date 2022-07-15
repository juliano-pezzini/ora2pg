-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_solic_x_discharge ( nr_seq_indicator_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

-- Tasy cursors
c01_tasy CURSOR(dt_reference_p timestamp) FOR
SELECT  a.cd_pessoa_fisica id_patient,
    coalesce(get_formatted_person_name(a.cd_pessoa_fisica, 'list'), obter_nome_pf(a.cd_pessoa_fisica)) nm_patient,
    pfcs_obter_lista_dados_classif(a.cd_pessoa_fisica) ds_classification,
    obter_sexo_pf(a.cd_pessoa_fisica, 'D') ds_gender,
    pf.dt_nascimento dt_birthdate,
    obter_dados_pf(a.cd_pessoa_fisica, 'I') qt_idade_paciente,
    coalesce(a.dt_prevista, a.dt_solicitacao) dt_time_request,
    substr(obter_desc_status_gv(a.ie_status,'D'),1,100) ds_status,
    a.ie_status ie_status,
    obter_valor_dominio(1410, a.ie_tipo_vaga) ds_type,
    a.ie_tipo_vaga ie_type
from    gestao_vaga a, pessoa_fisica pf
where   coalesce(a.nr_atendimento::text, '') = ''
and     a.ie_status in ('A', 'H', 'L', 'I')
and	trunc(coalesce(a.dt_prevista, a.dt_solicitacao)) = dt_reference_p
and	a.cd_estabelecimento = cd_estabelecimento_p
and	a.cd_pessoa_fisica = pf.cd_pessoa_fisica;


c02_tasy CURSOR(dt_reference_p timestamp) FOR
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
    coalesce(get_formatted_person_name(a.cd_medico_resp, 'list'), obter_nome_pf(a.cd_medico_resp)) ds_physician
from 	setor_atendimento	d,
    unidade_atendimento	c,
    atend_paciente_unidade	b,
    atendimento_paciente	a,
    pessoa_fisica pf
where 	a.nr_atendimento	= b.nr_atendimento
and	a.cd_pessoa_fisica	= pf.cd_pessoa_fisica
and	c.cd_setor_atendimento	= b.cd_setor_atendimento
and	c.cd_unidade_basica	= b.cd_unidade_basica
and	c.cd_unidade_compl	= b.cd_unidade_compl
and	b.nr_seq_interno	= obter_atepacu_paciente(a.nr_atendimento,'A')
and	c.cd_setor_atendimento	= d.cd_setor_atendimento
and	c.ie_situacao		= 'A'
and	d.ie_situacao		= 'A'
and	d.cd_classif_setor	in ('1','3','4','9','11','12')
and	d.ie_ocup_hospitalar	<> 'N'
and	coalesce(a.dt_cancelamento::text, '') = ''
and	coalesce(a.dt_alta::text, '') = ''
and	trunc(a.dt_previsto_alta) = dt_reference_p
and	a.cd_estabelecimento = cd_estabelecimento_p;

-- Integration cursors    
c01_fhir CURSOR(dt_reference_p timestamp) FOR
SELECT pat.patient_id id_patient,
    pfcs_get_human_name(pat.nr_sequencia, 'Patient') nm_patient,
    enc.ds_classification ds_classification,
    pat.gender ds_gender,
    pat.birthdate dt_birthdate,
    trunc(months_between(coalesce(pat.deceased_date, clock_timestamp()), pat.birthdate)/12) qt_idade_paciente,
    coalesce(ser.dt_authored_on, ser.dt_atualizacao) dt_time_request,
    substr(obter_valor_dominio(82, uni.ie_status_unidade),1,255) ds_status,
    uni.ie_status_unidade ie_status,
    substr(obter_valor_dominio(1,sec.cd_classif_setor),1,100) ds_type,
    sec.cd_classif_setor ie_type
from pfcs_service_request ser,
    pfcs_encounter enc,
    pfcs_patient pat,
    unidade_atendimento uni,
    setor_atendimento sec
where ser.cd_service in ('E0401', 'E0402')
    and ser.si_status = 'ACTIVE'
    and ser.si_intent = 'PLAN'
    and enc.nr_seq_patient = pat.nr_sequencia
    and ser.nr_seq_encounter = enc.nr_sequencia
    and ser.nr_seq_location = uni.nr_seq_location
    and uni.cd_setor_atendimento = sec.cd_setor_atendimento
    and sec.ie_situacao = 'A'
    and	uni.ie_situacao = 'A'
    and	sec.cd_classif_setor in ('1','3','4','9','11','12')
    and coalesce(trunc(ser.dt_authored_on), trunc(ser.dt_atualizacao)) =  dt_reference_p
    and sec.cd_estabelecimento = cd_estabelecimento_p
    and (enc.period_start IS NOT NULL AND enc.period_start::text <> '')
    and coalesce(enc.period_end::text, '') = '';

c02_fhir CURSOR(dt_reference_p timestamp) FOR
SELECT sec.cd_setor_atendimento cd_department,
        sec.ds_setor_atendimento ds_department,
		uni.cd_unidade_basica || ' ' || uni.cd_unidade_compl ds_location,
		substr(obter_valor_dominio(82, uni.ie_status_unidade),1,255) ds_status,
		uni.ie_status_unidade ie_status,
		hst.dt_period_start dt_entry_unit,
		pat.patient_id id_patient,
		pfcs_get_human_name(pat.nr_sequencia, 'Patient') nm_patient,
		enc.ds_classification ds_classification,
		pat.gender ds_gender,
		pat.birthdate dt_birthdate,
        trunc(months_between(coalesce(pat.deceased_date, clock_timestamp()), pat.birthdate)/12) qt_idade_paciente,
		enc.id_encounter nr_encounter,
		enc.period_start dt_entrance,
		pfcs_get_human_name(pfcs_get_practitioner_seq(enc.nr_sequencia, '405279007'), 'Practitioner') ds_physician
from pfcs_service_request ser,
    pfcs_encounter enc,
    pfcs_patient pat,
    unidade_atendimento uni,
    setor_atendimento sec,
    pfcs_patient_loc_hist hst
where ser.cd_service = 'E0405'
    and ser.si_status = 'ACTIVE'
    and ser.si_intent = 'PLAN'
    and enc.nr_seq_patient = pat.nr_sequencia
    and ser.nr_seq_encounter = enc.nr_sequencia
    and ser.nr_seq_location = uni.nr_seq_location
    and uni.cd_setor_atendimento = sec.cd_setor_atendimento
    and sec.ie_situacao = 'A'
    and	uni.ie_situacao = 'A'
    and sec.cd_classif_setor in ('1','3','4','9','11','12')
    and coalesce(trunc(ser.dt_authored_on), trunc(ser.dt_atualizacao)) = dt_reference_p
    and sec.cd_estabelecimento = cd_estabelecimento_p
    and (enc.period_start IS NOT NULL AND enc.period_start::text <> '')
    and coalesce(enc.period_end::text, '') = ''
    and (hst.dt_period_start IS NOT NULL AND hst.dt_period_start::text <> '')
    and coalesce(hst.dt_period_end::text, '') = ''
    and hst.si_intent = 'ORDER'
    and hst.nr_seq_encounter = enc.nr_sequencia
    and hst.nr_seq_location = uni.nr_seq_location
    and ser.nr_seq_location = uni.nr_seq_location
    and hst.ie_situacao = 'A';


-- Variables
qt_total_w				        bigint := 0;
dt_reference_w				    timestamp;
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


for nr_counter in -1..5 loop
	select trunc(clock_timestamp() + (nr_counter))
	into STRICT dt_reference_w
	;

	-- Request
	-- Tasy tables or both
	if (pfcs_flag_settings_w = 0 or pfcs_flag_settings_w = 2) then
		for c01_w in c01_tasy(dt_reference_w) loop
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
					id_patient,
					nm_patient,
					ds_gender,
					ds_classification,
					dt_birthdate,
					ds_age_range)
				values (
					nextval('pfcs_detail_patient_seq'),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					pfcs_panel_detail_seq_w,
					c01_w.id_patient,
					c01_w.nm_patient,
					c01_w.ds_gender,
					c01_w.ds_classification,
					c01_w.dt_birthdate,
					c01_w.qt_idade_paciente);

				insert into pfcs_detail_bed_request(
					nr_sequencia,
					nm_usuario,
					dt_atualizacao,
					nm_usuario_nrec,
					dt_atualizacao_nrec,
					nr_seq_detail,
					dt_time_request,
					ds_status,
					ie_status,
					ds_type,
					ie_type)
				values (
					nextval('pfcs_detail_bed_request_seq'),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					pfcs_panel_detail_seq_w,
					c01_w.dt_time_request,
					c01_w.ds_status,
					c01_w.ie_status,
					c01_w.ds_type,
					c01_w.ie_type);

			end;
		end loop;
	end if;

	-- Integration tables or both
	if (pfcs_flag_settings_w = 1 or pfcs_flag_settings_w = 2) then
		for c03_w in c01_fhir(dt_reference_w) loop
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
					id_patient,
					nm_patient,
					ds_gender,
					ds_classification,
					dt_birthdate,
					ds_age_range)
				values (
					nextval('pfcs_detail_patient_seq'),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					pfcs_panel_detail_seq_w,
					c03_w.id_patient,
					c03_w.nm_patient,
					c03_w.ds_gender,
					c03_w.ds_classification,
					c03_w.dt_birthdate,
					c03_w.qt_idade_paciente);

				insert into pfcs_detail_bed_request(
					nr_sequencia,
					nm_usuario,
					dt_atualizacao,
					nm_usuario_nrec,
					dt_atualizacao_nrec,
					nr_seq_detail,
					dt_time_request,
					ds_status,
					ie_status,
					ds_type,
					ie_type)
				values (
					nextval('pfcs_detail_bed_request_seq'),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					pfcs_panel_detail_seq_w,
					c03_w.dt_time_request,
					c03_w.ds_status,
					c03_w.ie_status,
					c03_w.ds_type,
					c03_w.ie_type);

			end;
		end loop;
	end if;

	 := pfcs_pck.pfcs_generate_results(
		vl_indicator_p => qt_total_w, vl_indicator_aux_p => nr_counter, ds_reference_value_p => 'R', nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => nr_seq_operational_level_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => nr_seq_panel_w);

	CALL pfcs_pck.pfcs_update_detail(
		nr_seq_indicator_p => nr_seq_indicator_p,
		nr_seq_panel_p => nr_seq_panel_w,
		nr_seq_operational_level_p => nr_seq_operational_level_w,
		nm_usuario_p => nm_usuario_p);

	qt_total_w := 0;

	-- Planed
	-- Tasy tables or both
	if (pfcs_flag_settings_w = 0 or pfcs_flag_settings_w = 2) then
		for c02_w in c02_tasy(dt_reference_w) loop

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
					ds_physician)
				values (
					nextval('pfcs_detail_patient_seq'),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					pfcs_panel_detail_seq_w,
					c02_w.nr_encounter,
					c02_w.dt_entrance,
					c02_w.id_patient,
					c02_w.nm_patient,
					c02_w.ds_gender,
					c02_w.ds_classification,
					c02_w.dt_birthdate,
					c02_w.qt_idade_paciente,
					c02_w.ds_physician);

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
					c02_w.ds_location,
					c02_w.cd_department,
					c02_w.ds_department,
					c02_w.ds_status,
					c02_w.ie_status,
					c02_w.dt_entry_unit);

			end;
		end loop;
	end if;

	-- Integration tables or both
	if (pfcs_flag_settings_w = 1 or pfcs_flag_settings_w = 2) then
		for c04_w in c02_fhir(dt_reference_w) loop

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
					ds_physician)
				values (
					nextval('pfcs_detail_patient_seq'),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					pfcs_panel_detail_seq_w,
					c04_w.nr_encounter,
					c04_w.dt_entrance,
					c04_w.id_patient,
					c04_w.nm_patient,
					c04_w.ds_gender,
					c04_w.ds_classification,
					c04_w.dt_birthdate,
					c04_w.qt_idade_paciente,
					c04_w.ds_physician);

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
					c04_w.ds_location,
					c04_w.cd_department,
					c04_w.ds_department,
					c04_w.ds_status,
					c04_w.ie_status,
					c04_w.dt_entry_unit);

			end;
		end loop;
	end if;

	 := pfcs_pck.pfcs_generate_results(
		vl_indicator_p => qt_total_w, vl_indicator_aux_p => nr_counter, ds_reference_value_p => 'D', nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => nr_seq_operational_level_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => nr_seq_panel_w);

	CALL pfcs_pck.pfcs_update_detail(
		nr_seq_indicator_p => nr_seq_indicator_p,
		nr_seq_panel_p => nr_seq_panel_w,
		nr_seq_operational_level_p => nr_seq_operational_level_w,
		nm_usuario_p => nm_usuario_p);

	qt_total_w := 0;
end loop;


CALL pfcs_pck.pfcs_activate_records(
    nr_seq_indicator_p => nr_seq_indicator_p,
    nr_seq_operational_level_p => nr_seq_operational_level_w,
    nm_usuario_p => nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_solic_x_discharge ( nr_seq_indicator_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

