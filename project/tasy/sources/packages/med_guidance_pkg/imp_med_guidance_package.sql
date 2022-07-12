-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE med_guidance_pkg.imp_med_guidance ( nr_seq_edition_p JPN_MEDICAL_GUIDANCE.NR_SEQ_EDITION%type, nm_usuario_p JPN_MEDICAL_GUIDANCE.NM_USUARIO%type, ds_file_p text ) AS $body$
DECLARE


    nr_sequencia_w                  bigint;
    si_change_classif_w             varchar(10);
    si_master_type_w                varchar(2);
    cd_medical_practice_code_w      varchar(15);
    qt_valid_digits_kanji_w         bigint;
    ds_abbreviated_kanji_name_w     varchar(255);
    qt_valid_digits_w               bigint;
    ds_abbreviated_kana_w           varchar(255);
    cd_data_standard_code_w         bigint;
    qt_effective_kanji_digits_w     bigint;
    si_unit_measurement_w           varchar(30);
    si_score_identification_w       integer;
    qt_current_score_w              double precision;
    si_applicable_classif_w         bigint;
    si_elderly_category_w           bigint;
    qt_column_tab_dest_ident_w      bigint;
    si_comprehensive_inspec_w       varchar(5);
    si_dpc_category_w               varchar(5);
    si_hospital_classification_w    varchar(5);
    si_surgical_img_addition_w      varchar(5);
    si_obs_law_target_classif_w     varchar(5);
    si_nursing_addition_w           varchar(5);
    si_anesthesia_ident_classif_w   varchar(5);
    si_basic_hosp_fee_addition_w    varchar(5);
    si_injury_name_rel_classif_w    varchar(5);
    si_medical_manage_fee_w         varchar(5);
    qt_real_days_w                  integer;
    qt_number_of_times_w            integer;
    qt_pharm_categ_w                integer;
    si_step_value_calc_id_w         integer;
    qt_lower_limit_w                bigint;
    qt_upper_limit_w                bigint;
    qt_step_value_w                 bigint;
    qt_step_score_w                 double precision;
    qt_upper_lower_lim_err_w        bigint;
    qt_max_num_times_w              bigint;
    qt_max_error_handling_w         bigint;
    cd_note_add_code_w              varchar(10);
    cd_add_serial_num_w             varchar(10);
    cd_general_age_w                varchar(3);
    cd_min_age_w                    varchar(3);
    cd_max_age_w                    varchar(3);
    qt_times_add_classif_w          integer;
    cd_conformity_classif_w         integer;
    cd_target_facility_w            varchar(5);
    cd_treat_inf_add_classif_w      varchar(5);
    si_low_birth_w                  varchar(5);
    si_ident_basic_hosp_w           varchar(5);
    si_donor_classif_w              varchar(5);
    si_insp_impl_jud_classif_w      varchar(5);
    si_gradual_red_target_w         varchar(5);
    si_add_class_spinal_measur_w    varchar(5);
    si_neck_dissection_add_w        varchar(5);
    si_aut_suture_device_add_w      varchar(5);
    si_outpatient_man_add_w         varchar(5);
    si_score_identif_2_w            varchar(5);
    si_old_score_w                  double precision;
    cd_kanji_name_change_classif_w  varchar(5);
    cd_kana_name_change_classif_w   varchar(5);
    si_specimen_test_comment_w      varchar(5);
    si_gen_add_presc_point_w        varchar(5);
    si_comprehensive_dec_classif_w  varchar(5);
    si_ultrasound_endo_add_w        varchar(5);
    si_point_col_tab_dest_ident_w   integer;
    si_aut_anast_dev_add_classif_w  integer;
    si_ident_classif_not_1_w        integer;
    si_ident_classif_not_2_w        integer;
    si_regional_addition_w          integer;
    qt_number_beds_w                integer;
    cd_facility_code_1_w            bigint;
    cd_facility_code_2_w            bigint;
    cd_facility_code_3_w            bigint;
    cd_facility_code_4_w            bigint;
    cd_facility_code_5_w            bigint;
    cd_facility_code_6_w            bigint;
    cd_facility_code_7_w            bigint;
    cd_facility_code_8_w            bigint;
    cd_facility_code_9_w            bigint;
    cd_facility_code_10_w           bigint;
    cd_add_ultra_coag_incision_w    varchar(5);
    cd_short_stay_surg_w            varchar(5);
    cd_dental_app_classif_w         varchar(5);
    cd_number_tab_alph_part_w       varchar(5);
    cd_notif_rel_num_alph_part_w    varchar(5);
    dt_update_w                     timestamp;
    dt_end_date_w                   timestamp;
    cd_publication_seq_w            bigint;
    cd_chapter_w                    integer;
    cd_department_w                 integer;
    cd_category_w                   integer;
    cd_branch_w                     integer;
    cd_item_number_w                integer;
    cd_chapter_2_w                  integer;
    cd_department_2_w               integer;
    cd_category_2_w                 integer;
    cd_branch_2_w                   integer;
    cd_item_number_2_w              integer;
    si_min_age_add_code1_w          varchar(5);
    si_max_age_add_code1_w          varchar(5);
    cd_add_code1_w                  varchar(15);
    si_min_age_add_code2_w          varchar(5);
    si_max_age_add_code2_w          varchar(5);
    cd_add_code2_w                  varchar(15);
    si_min_age_add_code3_w          varchar(5);
    si_max_age_add_code3_w          varchar(5);
    cd_add_code3_w                  varchar(15);
    si_min_age_add_code4_w          varchar(5);
    si_max_age_add_code4_w          varchar(5);
    cd_add_code4_w                  varchar(15);
    cd_transfer_related_w           varchar(15);
    ds_basic_kanji_name_w           varchar(255);
    si_endo_add_sinus_surgery_w     varchar(5);
    si_bone_soft_tissue_w           varchar(5);
    si_long_term_anesth_add_w       varchar(5);
    si_score_tab_classif_num_w      varchar(15);
    si_non_invasive_hemo_monit_w    varchar(5);
    si_cryo_allogeneic_add_w        varchar(5);
    si_malignant_tumor_spec_add_w   varchar(5);
    si_external_fixator_add_w       varchar(5);
    su_ultra_cut_add_w              varchar(5);
    si_atrial_append_W              varchar(5);
    dt_sysdate_s                    timestamp := clock_timestamp();


BEGIN
        current_setting('med_guidance_pkg.r_list_tbl')::split_tbl.delete;
        CALL MED_GUIDANCE_PKG.SPLIT_ROW(ds_file_p);

        si_change_classif_w             := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[1].ds_split;
        si_master_type_w                := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[2].ds_split;
        cd_medical_practice_code_w      := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[3].ds_split;
        qt_valid_digits_kanji_w         := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[4].ds_split)::numeric;
        ds_abbreviated_kanji_name_w     := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[5].ds_split;
        qt_valid_digits_w               := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[6].ds_split)::numeric;
        ds_abbreviated_kana_w           := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[7].ds_split;
        cd_data_standard_code_w         := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[8].ds_split)::numeric;
        qt_effective_kanji_digits_w     := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[9].ds_split)::numeric;
        si_unit_measurement_w           := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[10].ds_split;
        si_score_identification_w       := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[11].ds_split)::numeric;
        qt_current_score_w              := to_number(current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[12].ds_split, '9999999999.99');
        si_applicable_classif_w         := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[13].ds_split)::numeric;
        si_elderly_category_w           := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[14].ds_split)::numeric;
        qt_column_tab_dest_ident_w      := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[15].ds_split)::numeric;
        si_comprehensive_inspec_w       := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[16].ds_split;
        si_dpc_category_w               := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[18].ds_split;
        si_hospital_classification_w    := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[19].ds_split;
        si_surgical_img_addition_w      := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[20].ds_split;
        si_obs_law_target_classif_w     := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[21].ds_split;
        si_nursing_addition_w           := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[22].ds_split;
        si_anesthesia_ident_classif_w   := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[23].ds_split;
        si_basic_hosp_fee_addition_w    := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[24].ds_split;
        si_injury_name_rel_classif_w    := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[25].ds_split;
        si_medical_manage_fee_w         := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[26].ds_split;
        qt_real_days_w                  := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[27].ds_split)::numeric;
        qt_number_of_times_w            := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[28].ds_split)::numeric;
        qt_pharm_categ_w                := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[29].ds_split)::numeric;
        si_step_value_calc_id_w         := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[30].ds_split)::numeric;
        qt_lower_limit_w                := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[31].ds_split)::numeric;
        qt_upper_limit_w                := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[32].ds_split)::numeric;
        qt_step_value_w                 := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[33].ds_split)::numeric;
        qt_step_score_w                 := to_number(current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[34].ds_split, '9999999999.99');
        qt_upper_lower_lim_err_w        := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[35].ds_split)::numeric;
        qt_max_num_times_w              := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[36].ds_split)::numeric;
        qt_max_error_handling_w         := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[37].ds_split)::numeric;
        cd_note_add_code_w              := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[38].ds_split;
        cd_add_serial_num_w             := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[39].ds_split;
        cd_general_age_w                := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[40].ds_split;
        cd_min_age_w                    := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[41].ds_split;
        cd_max_age_w                    := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[42].ds_split;
        qt_times_add_classif_w          := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[43].ds_split)::numeric;
        cd_conformity_classif_w         := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[44].ds_split)::numeric;
        cd_target_facility_w            := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[45].ds_split;
        cd_treat_inf_add_classif_w      := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[46].ds_split;
        si_low_birth_w                  := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[47].ds_split;
        si_ident_basic_hosp_w           := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[48].ds_split;
        si_donor_classif_w              := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[49].ds_split;
        si_insp_impl_jud_classif_w      := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[50].ds_split;
        si_gradual_red_target_w         := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[52].ds_split;
        si_add_class_spinal_measur_w    := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[53].ds_split;
        si_neck_dissection_add_w        := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[54].ds_split;
        si_aut_suture_device_add_w      := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[55].ds_split;
        si_outpatient_man_add_w         := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[56].ds_split;
        si_score_identif_2_w            := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[57].ds_split;
        si_old_score_w                  := to_number(current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[58].ds_split, '9999999999.99');
        cd_kanji_name_change_classif_w  := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[59].ds_split;
        cd_kana_name_change_classif_w   := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[60].ds_split;
        si_specimen_test_comment_w      := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[61].ds_split;
        si_gen_add_presc_point_w        := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[62].ds_split;
        si_comprehensive_dec_classif_w  := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[63].ds_split;
        si_ultrasound_endo_add_w        := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[64].ds_split;
        si_point_col_tab_dest_ident_w   := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[66].ds_split)::numeric;
        si_aut_anast_dev_add_classif_w  := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[67].ds_split)::numeric;
        si_ident_classif_not_1_w        := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[68].ds_split)::numeric;
        si_ident_classif_not_2_w        := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[69].ds_split)::numeric;
        si_regional_addition_w          := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[70].ds_split)::numeric;
        qt_number_beds_w                := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[71].ds_split)::numeric;
        cd_facility_code_1_w            := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[72].ds_split)::numeric;
        cd_facility_code_2_w            := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[73].ds_split)::numeric;
        cd_facility_code_3_w            := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[74].ds_split)::numeric;
        cd_facility_code_4_w            := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[75].ds_split)::numeric;
        cd_facility_code_5_w            := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[76].ds_split)::numeric;
        cd_facility_code_6_w            := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[77].ds_split)::numeric;
        cd_facility_code_7_w            := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[78].ds_split)::numeric;
        cd_facility_code_8_w            := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[79].ds_split)::numeric;
        cd_facility_code_9_w            := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[80].ds_split)::numeric;
        cd_facility_code_10_w           := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[81].ds_split)::numeric;
        cd_add_ultra_coag_incision_w    := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[82].ds_split;
        cd_short_stay_surg_w            := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[83].ds_split;
        cd_dental_app_classif_w         := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[84].ds_split;
        cd_number_tab_alph_part_w       := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[85].ds_split;
        cd_notif_rel_num_alph_part_w    := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[86].ds_split;
        dt_update_w                     := to_date(current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[87].ds_split, 'yyyymmdd');
        cd_publication_seq_w            := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[89].ds_split)::numeric;
        cd_chapter_w                    := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[90].ds_split)::numeric;
        cd_department_w                 := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[91].ds_split)::numeric;
        cd_category_w                   := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[92].ds_split)::numeric;
        cd_branch_w                     := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[93].ds_split)::numeric;
        cd_item_number_w                := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[94].ds_split)::numeric;
        cd_chapter_2_w                  := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[95].ds_split)::numeric;
        cd_department_2_w               := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[96].ds_split)::numeric;
        cd_category_2_w                 := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[97].ds_split)::numeric;
        cd_branch_2_w                   := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[98].ds_split)::numeric;
        cd_item_number_2_w              := (current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[99].ds_split)::numeric;
        si_min_age_add_code1_w          := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[100].ds_split;
        si_max_age_add_code1_w          := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[101].ds_split;
        cd_add_code1_w                  := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[102].ds_split;
        si_min_age_add_code2_w          := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[103].ds_split;
        si_max_age_add_code2_w          := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[104].ds_split;
        cd_add_code2_w                  := current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[105].ds_split;
        si_min_age_add_code3_w          := r_list_tbl[106].ds_split;
        si_max_age_add_code3_w          := r_list_tbl[107].ds_split;
        cd_add_code3_w                  := r_list_tbl[108].ds_split;
        si_min_age_add_code4_w          := r_list_tbl[109].ds_split;
        si_max_age_add_code4_w          := r_list_tbl[110].ds_split;
        cd_add_code4_w                  := r_list_tbl[111].ds_split;
        cd_transfer_related_w           := r_list_tbl[112].ds_split;
        ds_basic_kanji_name_w           := r_list_tbl[113].ds_split;
        si_endo_add_sinus_surgery_w     := r_list_tbl[114].ds_split;
        si_bone_soft_tissue_w           := r_list_tbl[115].ds_split;
        si_long_term_anesth_add_w       := r_list_tbl[116].ds_split;
        si_score_tab_classif_num_w      := r_list_tbl[117].ds_split;
        si_non_invasive_hemo_monit_w    := r_list_tbl[118].ds_split;
        si_cryo_allogeneic_add_w        := r_list_tbl[119].ds_split;
        si_malignant_tumor_spec_add_w   := r_list_tbl[120].ds_split;
        si_external_fixator_add_w       := r_list_tbl[121].ds_split;
        su_ultra_cut_add_w              := r_list_tbl[122].ds_split;
        si_atrial_append_w              := r_list_tbl[123].ds_split;

        SELECT (
                case when   position('99999' in r_list_tbl[88].ds_split) > 0
                    then    to_date('01/01/3999', 'dd/mm/yyyy') 
                    else    to_date(r_list_tbl[88].ds_split, 'dd/mm/yyyy')
                end
            )
        INTO STRICT    dt_end_date_w
;

        SELECT  nextval('jpn_medical_guidance_seq')
        INTO STRICT    nr_sequencia_w
;

        INSERT INTO JPN_MEDICAL_GUIDANCE(
            nr_sequencia,
            dt_atualizacao,
            nm_usuario,
            dt_atualizacao_nrec,
            nm_usuario_nrec,
            nr_seq_edition,
            si_change_classif,
            si_master_type,
            cd_medical_practice_code,
            qt_valid_digits_kanji,
            ds_abbreviated_kanji_name,
            qt_valid_digits,
            ds_abbreviated_kana,
            cd_data_standard_code,
            qt_effective_kanji_digits,
            si_unit_measurement,
            si_score_identification,
            qt_current_score,
            si_applicable_classif,
            si_elderly_category,
            qt_column_tab_dest_ident,
            si_comprehensive_inspec,
            si_dpc_category,
            si_hospital_classification,
            si_surgical_img_addition,
            si_obs_law_target_classif,
            si_nursing_addition,
            si_anesthesia_ident_classif,
            si_basic_hosp_fee_addition,
            si_injury_name_rel_classif,
            si_medical_manage_fee,
            qt_real_days,
            qt_number_of_times,
            qt_pharm_categ,
            si_step_value_calc_id,
            qt_lower_limit,
            qt_upper_limit,
            qt_step_value,
            qt_step_score,
            qt_upper_lower_lim_err,
            qt_max_num_times,
            qt_max_error_handling,
            cd_note_add_code,
            cd_add_serial_num,
            cd_general_age,
            cd_min_age,
            cd_max_age,
            qt_times_add_classif,
            cd_conformity_classif,
            cd_target_facility,
            cd_treat_inf_add_classif,
            si_low_birth_weight_add_class,
            si_ident_basic_hosp,
            si_donor_classif,
            si_insp_impl_jud_classif,
            si_gradual_red_target,
            si_add_class_spinal_measur,
            si_neck_dissection_add,
            si_aut_suture_device_add,
            si_outpatient_man_add,
            si_score_identif_2,
            si_old_score,
            cd_kanji_name_change_classif,
            cd_kana_name_change_classif,
            si_specimen_test_comment,
            si_gen_add_presc_point,
            si_comprehensive_dec_classif,
            si_ultrasound_endo_add,
            si_point_col_tab_dest_ident,
            si_aut_anast_dev_add_classif,
            si_ident_classif_not_1,
            si_ident_classif_not_2,
            si_regional_addition,
            qt_number_beds,
            cd_facility_code_1,
            cd_facility_code_2,
            cd_facility_code_3,
            cd_facility_code_4,
            cd_facility_code_5,
            cd_facility_code_6,
            cd_facility_code_7,
            cd_facility_code_8,
            cd_facility_code_9,
            cd_facility_code_10,
            cd_add_ultra_coag_incision,
            cd_short_stay_surg,
            cd_dental_app_classif,
            cd_number_tab_alph_part,
            cd_notif_rel_num_alph_part,
            dt_update,
            dt_end_date,
            cd_publication_seq,
            cd_chapter,
            cd_department,
            cd_category,
            cd_branch,
            cd_item_number,
            cd_chapter_2,
            cd_department_2,
            cd_category_2,
            cd_branch_2,
            cd_item_number_2,
            si_min_age_add_code1,
            si_max_age_add_code1,
            cd_add_code1,
            si_min_age_add_code2,
            si_max_age_add_code2,
            cd_add_code2,
            si_min_age_add_code3,
            si_max_age_add_code3,
            cd_add_code3,
            si_min_age_add_code4,
            si_max_age_add_code4,
            cd_add_code4,
            cd_transfer_related,
            ds_basic_kanji_name,
            si_endo_add_sinus_surgery,
            si_add_bone_soft_tissue_equip,
            si_long_term_anesth_add,
            si_score_tab_classif_num,
            si_non_invasive_hemo_monit,
            si_cryo_allogeneic_add,
            si_malignant_tumor_spec_add,
            si_external_fixator_add,
            si_ultra_cut_equip_addition,
            si_classif_left_atrial_append
        ) VALUES (
            nr_sequencia_w,
            dt_sysdate_s,
            nm_usuario_p,
            dt_sysdate_s,
            nm_usuario_p,
            nr_seq_edition_p,
            si_change_classif_w,
            si_master_type_w,
            cd_medical_practice_code_w,
            qt_valid_digits_kanji_w,
            ds_abbreviated_kanji_name_w,
            qt_valid_digits_w,
            ds_abbreviated_kana_w,
            cd_data_standard_code_w,
            qt_effective_kanji_digits_w,
            si_unit_measurement_w,
            si_score_identification_w,
            qt_current_score_w,
            si_applicable_classif_w,
            si_elderly_category_w,
            qt_column_tab_dest_ident_w,
            si_comprehensive_inspec_w,
            si_dpc_category_w,
            si_hospital_classification_w,
            si_surgical_img_addition_w,
            si_obs_law_target_classif_w,
            si_nursing_addition_w,
            si_anesthesia_ident_classif_w,
            si_basic_hosp_fee_addition_w,
            si_injury_name_rel_classif_w,
            si_medical_manage_fee_w,
            qt_real_days_w,
            qt_number_of_times_w,
            qt_pharm_categ_w,
            si_step_value_calc_id_w,
            qt_lower_limit_w,
            qt_upper_limit_w,
            qt_step_value_w,
            qt_step_score_w,
            qt_upper_lower_lim_err_w,
            qt_max_num_times_w,
            qt_max_error_handling_w,
            cd_note_add_code_w,
            cd_add_serial_num_w,
            cd_general_age_w,
            cd_min_age_w,
            cd_max_age_w,
            qt_times_add_classif_w,
            cd_conformity_classif_w,
            cd_target_facility_w,
            cd_treat_inf_add_classif_w,
            si_low_birth_w,
            si_ident_basic_hosp_w,
            si_donor_classif_w,
            si_insp_impl_jud_classif_w,
            si_gradual_red_target_w,
            si_add_class_spinal_measur_w,
            si_neck_dissection_add_w,
            si_aut_suture_device_add_w,
            si_outpatient_man_add_w,
            si_score_identif_2_w,
            si_old_score_w,
            cd_kanji_name_change_classif_w,
            cd_kana_name_change_classif_w,
            si_specimen_test_comment_w,
            si_gen_add_presc_point_w,
            si_comprehensive_dec_classif_w,
            si_ultrasound_endo_add_w,
            si_point_col_tab_dest_ident_w,
            si_aut_anast_dev_add_classif_w,
            si_ident_classif_not_1_w,
            si_ident_classif_not_2_w,
            si_regional_addition_w,
            qt_number_beds_w,
            cd_facility_code_1_w,
            cd_facility_code_2_w,
            cd_facility_code_3_w,
            cd_facility_code_4_w,
            cd_facility_code_5_w,
            cd_facility_code_6_w,
            cd_facility_code_7_w,
            cd_facility_code_8_w,
            cd_facility_code_9_w,
            cd_facility_code_10_w,
            cd_add_ultra_coag_incision_w,
            cd_short_stay_surg_w,
            cd_dental_app_classif_w,
            cd_number_tab_alph_part_w,
            cd_notif_rel_num_alph_part_w,
            dt_update_w,
            dt_end_date_w,
            cd_publication_seq_w,
            cd_chapter_w,
            cd_department_w,
            cd_category_w,
            cd_branch_w,
            cd_item_number_w,
            cd_chapter_2_w,
            cd_department_2_w,
            cd_category_2_w,
            cd_branch_2_w,
            cd_item_number_2_w,
            si_min_age_add_code1_w,
            si_max_age_add_code1_w,
            cd_add_code1_w,
            si_min_age_add_code2_w,
            si_max_age_add_code2_w,
            cd_add_code2_w,
            si_min_age_add_code3_w,
            si_max_age_add_code3_w,
            cd_add_code3_w,
            si_min_age_add_code4_w,
            si_max_age_add_code4_w,
            cd_add_code4_w,
            cd_transfer_related_w,
            ds_basic_kanji_name_w,
            si_endo_add_sinus_surgery_w,
            si_bone_soft_tissue_w,
            si_long_term_anesth_add_w,
            si_score_tab_classif_num_w,
            si_non_invasive_hemo_monit_w,
            si_cryo_allogeneic_add_w,
            si_malignant_tumor_spec_add_w,
            si_external_fixator_add_w,
            su_ultra_cut_add_w,
            si_atrial_append_w
        );
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        CALL WHEB_MENSAGEM_PCK.EXIBIR_MENSAGEM_ABORT(1023582);
    END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_guidance_pkg.imp_med_guidance ( nr_seq_edition_p JPN_MEDICAL_GUIDANCE.NR_SEQ_EDITION%type, nm_usuario_p JPN_MEDICAL_GUIDANCE.NM_USUARIO%type, ds_file_p text ) FROM PUBLIC;
