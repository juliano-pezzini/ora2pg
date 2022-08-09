-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_icu_calc_occupancy ( cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


-- Cursors
---- Departments' names
c01_dpt CURSOR FOR
SELECT cd_setor_atendimento cd_department,
    ds_setor_atendimento ds_department
from setor_atendimento
where cd_classif_setor              = '4' -- ICU
    and ie_situacao                 = 'A'
    and coalesce(ie_semi_intensiva,'N')  = 'N'
    and cd_estabelecimento_base     = cd_estabelecimento_p;

---- All beds
c02_bds CURSOR(cd_setor_atendimento_p bigint) FOR
SELECT (uni.cd_unidade_basica || '-' || uni.cd_unidade_compl) ds_location,
	uni.ie_status_unidade cd_status,
	uni.cd_unidade_basica ds_room,
	uni.cd_unidade_compl ds_bed,
    uni.nr_seq_interno,
    pfcs_get_bed_status(uni.ie_status_unidade, 'T', cd_estabelecimento_p) ie_total_beds,
    pfcs_get_bed_status(uni.ie_status_unidade, 'C', cd_estabelecimento_p) ie_census
from unidade_atendimento uni
where uni.cd_setor_atendimento    = cd_setor_atendimento_p
    and	uni.ie_situacao           = 'A';

---- Occupied beds (Patient info)
c03_ocp CURSOR(nr_seq_interno_p bigint) FOR
SELECT enc.id_encounter nr_encounter_varchar,
    pat.patient_id id_patient,
    pfcs_get_human_name(pat.nr_sequencia, 'Patient') nm_patient,
    pfcs_get_human_name(pfcs_get_practitioner_seq(enc.nr_sequencia, '405279007'), 'Practitioner') physician_name,
    pat.gender,
    pat.birthdate,
    round(months_between(coalesce(pat.deceased_date, clock_timestamp()), pat.birthdate)) qt_patient_age,
    enc.period_start,
    pfcs_get_patient_diagnosis(enc.nr_sequencia) diagnosis,
    uni.cd_unidade_compl ds_bed,
    pfcs_get_code_status(pat.nr_sequencia, enc.nr_sequencia, 'S') code_status,
    pfcs_get_special_requests(enc.nr_sequencia, uni.nr_seq_location) special_requests,
	coalesce(pfcs_get_checklist(enc.nr_sequencia, pat.nr_sequencia, 'MPL'),'') ds_care_status,
	coalesce(pfcs_get_checklist(enc.nr_sequencia, pat.nr_sequencia, 'TOOLTIP'),'') ds_checklist
from pfcs_encounter enc,
    pfcs_patient pat,
    unidade_atendimento uni
where uni.nr_seq_location       = pfcs_get_pat_location(pat.nr_sequencia, enc.nr_sequencia)
    and uni.nr_seq_interno      = nr_seq_interno_p
    and enc.nr_seq_patient      = pat.nr_sequencia
    and (enc.period_start IS NOT NULL AND enc.period_start::text <> '')
    and coalesce(enc.period_end::text, '') = '';


nr_seq_indicator_w              pfcs_panel.nr_seq_indicator%type := 90;
pfcs_panel_detail_seq_w			pfcs_panel_detail.nr_sequencia%type;
pfcs_panel_seq_w			    pfcs_panel.nr_sequencia%type;

ds_dpt_w                        setor_atendimento.ds_setor_atendimento%type;
cd_dpt_w                        setor_atendimento.cd_setor_atendimento%type;

qt_unit_w				        numeric(20)  := 0; --> Total beds
qt_census_w                     numeric(20)  := 0; --> Total beds for census/capacity
qt_occupied_unit_w			    numeric(20)  := 0; --> Occupied beds
qt_blocked_unit_w			    numeric(20)  := 0; --> Blocked/Suspended Beds
BEGIN

for c01_w in c01_dpt loop
begin
    ds_dpt_w := c01_w.ds_department;
    cd_dpt_w := c01_w.cd_department;
    qt_unit_w := 0;
    qt_census_w := 0;
    qt_occupied_unit_w := 0;
    qt_blocked_unit_w := 0;

    for c02_w in c02_bds(c01_w.cd_department) loop
        if (c02_w.ie_census IS NOT NULL AND c02_w.ie_census::text <> '') then
            qt_unit_w := qt_unit_w + 1;
        end if;

        if (c02_w.ie_total_beds = 'Y') then
            qt_census_w := qt_census_w + 1;
        end if;

        if (c02_w.ie_census = 'B') then
            qt_blocked_unit_w := qt_blocked_unit_w + 1;
        end if;

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
            nr_seq_indicator_w,
            cd_estabelecimento_p);

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
            cd_status,
            ds_status)
        values (
            nextval('pfcs_detail_bed_seq'),
            nm_usuario_p,
            clock_timestamp(),
            nm_usuario_p,
            clock_timestamp(),
            pfcs_panel_detail_seq_w,
            c02_w.ds_location,
            c01_w.cd_department,
            c01_w.ds_department,
            c02_w.cd_status,
            c02_w.ie_census);

        for c03_w in c03_ocp(c02_w.nr_seq_interno) loop
            qt_occupied_unit_w := qt_occupied_unit_w + 1;

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
                dt_birthdate,
                ds_age_range,
                ds_symptoms,
                ds_dnr_status,
                ds_physician,
                ds_special_request,
                ds_care_status,
                ds_checklist)
            values (
                nextval('pfcs_detail_patient_seq'),
                nm_usuario_p,
                clock_timestamp(),
                nm_usuario_p,
                clock_timestamp(),
                pfcs_panel_detail_seq_w,
                c03_w.nr_encounter_varchar,
                c03_w.period_start,
                c03_w.id_patient,
                c03_w.nm_patient,
                c03_w.gender,
                c03_w.birthdate,
                c03_w.qt_patient_age,
                c03_w.diagnosis,
                c03_w.code_status,
                c03_w.physician_name,
                c03_w.special_requests,
                c03_w.ds_care_status,
                c03_w.ds_checklist);
        end loop;

        commit;
    end loop;

     := pfcs_pck.pfcs_generate_results(
        ds_reference_value_p => ds_dpt_w, cd_reference_value_p => cd_dpt_w, vl_indicator_p => qt_census_w, vl_indicator_help_p => qt_occupied_unit_w, nr_seq_indicator_p => nr_seq_indicator_w, nr_seq_operational_level_p => cd_estabelecimento_p, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);

     := pfcs_pck.pfcs_generate_results(
        ds_reference_value_p => ds_dpt_w, cd_reference_value_p => cd_dpt_w, vl_indicator_p => qt_census_w, vl_indicator_help_p => qt_occupied_unit_w, nr_seq_indicator_p => 91, nr_seq_operational_level_p => cd_estabelecimento_p, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);

    pfcs_pck.pfcs_generate_results(
        ds_reference_value_p => ds_dpt_w,
        cd_reference_value_p => cd_dpt_w,
        vl_indicator_p => (qt_unit_w - qt_occupied_unit_w - qt_blocked_unit_w),
        vl_indicator_help_p => (qt_unit_w - qt_blocked_unit_w),
        nr_seq_indicator_p => 92,
        nr_seq_operational_level_p => cd_estabelecimento_p,
        nm_usuario_p => nm_usuario_p,
        nr_seq_panel_p => pfcs_panel_seq_w);

     := pfcs_pck.pfcs_generate_results(
        ds_reference_value_p => ds_dpt_w, cd_reference_value_p => cd_dpt_w, vl_indicator_p => qt_blocked_unit_w, nr_seq_indicator_p => 93, nr_seq_operational_level_p => cd_estabelecimento_p, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);
end;
end loop;


CALL pfcs_pck.pfcs_update_detail(
        nr_seq_indicator_p => nr_seq_indicator_w,
        nr_seq_panel_p => pfcs_panel_seq_w,
        nr_seq_operational_level_p => cd_estabelecimento_p,
        nm_usuario_p => nm_usuario_p);

CALL pfcs_pck.pfcs_activate_records(
        nr_seq_indicator_p => nr_seq_indicator_w,
        nr_seq_operational_level_p => cd_estabelecimento_p,
        nm_usuario_p => nm_usuario_p);

CALL pfcs_pck.pfcs_activate_records(
        nr_seq_indicator_p => 91,
        nr_seq_operational_level_p => cd_estabelecimento_p,
        nm_usuario_p => nm_usuario_p);

CALL pfcs_pck.pfcs_activate_records(
        nr_seq_indicator_p => 92,
        nr_seq_operational_level_p => cd_estabelecimento_p,
        nm_usuario_p => nm_usuario_p);

CALL pfcs_pck.pfcs_activate_records(
        nr_seq_indicator_p => 93,
        nr_seq_operational_level_p => cd_estabelecimento_p,
        nm_usuario_p => nm_usuario_p);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_icu_calc_occupancy ( cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
