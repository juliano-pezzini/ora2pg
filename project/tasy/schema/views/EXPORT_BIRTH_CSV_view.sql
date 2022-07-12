-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW export_birth_csv (campo_1, campo_2, campo_3, campo_4, campo_5, campo_6, campo_7, campo_8, campo_9, campo_10, campo_11, campo_12, campo_13, campo_14, campo_15, campo_16, campo_17, campo_18, campo_19, campo_20, campo_21, campo_22, campo_23, campo_24, campo_25, campo_26, campo_27, campo_28, campo_29, campo_30, campo_31, campo_32, campo_33, campo_34, campo_35, campo_36, campo_37, campo_38, campo_39, campo_40, campo_41, campo_42, campo_43, campo_44, campo_45, campo_46, campo_47, campo_48, campo_49, campo_50, campo_51, campo_52, campo_53, campo_54, campo_55, campo_56, campo_57, campo_58, campo_59, campo_60, campo_61, campo_62, campo_63, campo_64, campo_65, campo_66, campo_67, campo_68, campo_69, campo_70, campo_71, campo_72, campo_73, campo_74, campo_75, campo_76, campo_77, campo_78, campo_79, campo_80, campo_81, campo_82, campo_83, campo_84, campo_85, campo_86, campo_87, campo_88, campo_89, dt_nascimento, nr_atendimento) AS SELECT
        obter_estab_atendimento(n.nr_atendimento) campo_1,
        lpad(n.nr_birth_number, 4, '0') || '/' || EXTRACT(YEAR FROM dt_nascimento) campo_2,
        '16/1' campo_3,
        n.nr_birth_number               campo_4,
        p.qt_feto                   campo_5,
        n.nr_sequencia campo_6,
        CASE WHEN p.ie_ruprema='S' THEN  '1'  ELSE '0' END  campo_7,
        n.nm_mbu_test               campo_8,
        CASE WHEN p.cd_tipo_anestesia IS NULL THEN  0  ELSE 1 END  campo_9,
        CASE WHEN p.cd_tipo_anestesia='1' THEN  '1'  ELSE '0' END  campo_10,
        CASE WHEN p.cd_tipo_anestesia='3' THEN  '1'  ELSE '0' END  campo_11,
        CASE WHEN p.cd_tipo_anestesia='2' THEN  '1'  ELSE '0' END  campo_12,
        CASE WHEN p.ie_parto_analgesia='S' THEN  '1'  ELSE '0' END  campo_13,
        CASE WHEN p.cd_tipo_anestesia='10' THEN  '1'  ELSE '0' END  campo_14,
        n.nr_seq_pos_birth          campo_15,
        p.nr_seq_posicao_materna    campo_16,
        coalesce(trunc((p.dt_fim_parto - p.dt_contracao_regular) * 24), 0) campo_17,
        n.nr_seq_typ_del            campo_18,
        CASE WHEN n.ie_shoulder_dis='Y' THEN  '1'  ELSE '0' END  campo_19,
        CASE WHEN p.ie_eme_cesarean='S' THEN  '1'  ELSE '0' END  campo_20,
        p.cd_resptime_min campo_21,
        CASE WHEN p.ie_amniotic_inf='Y' THEN  '1'  ELSE '0' END  campo_22,
        CASE WHEN p.ie_intrauterine_asp='Y' THEN  '1'  ELSE '0' END  campo_23,
        CASE WHEN p.ie_pathol_ctg='Y' THEN  '1'  ELSE '0' END  campo_24,
        CASE WHEN p.ie_pathol_doppler='Y' THEN  '1'  ELSE '0' END  campo_25,
        CASE WHEN p.ie_mbu_patho_res='Y' THEN  '1'  ELSE '0' END  campo_26,
        CASE WHEN p.ie_frust_induc='Y' THEN  '1'  ELSE '0' END  campo_27,
        CASE WHEN p.ie_birth_stag='Y' THEN  '1'  ELSE '0' END  campo_28,
        p.ds_stag_min               campo_29,
        CASE WHEN p.ie_birth_stag_dilat='Y' THEN  '1'  ELSE '0' END  campo_30,
        p.ds_min_open               campo_31,
        CASE WHEN p.ie_exhaustion_mot='Y' THEN  '1'  ELSE '0' END  campo_32,
        CASE WHEN p.ie_multi_preg='Y' THEN  '1'  ELSE '0' END  campo_33,
        CASE WHEN p.ie_dis_head_pelv='Y' THEN  '1'  ELSE '0' END  campo_34,
        CASE WHEN p.ie_umbilical_prolap='Y' THEN  '1'  ELSE '0' END  campo_35,
        CASE WHEN p.ie_placenta_perv='Y' THEN  '1'  ELSE '0' END  campo_36,
        CASE WHEN p.ie_loc_anomalies='Y' THEN  '1'  ELSE '0' END  campo_37,
        CASE WHEN p.ie_oth_floid_inf='Y' THEN  '1'  ELSE '0' END  campo_38,
        CASE WHEN p.ie_fetal_malformation='Y' THEN  '1'  ELSE '0' END  campo_39,
        CASE WHEN p.ie_premature_birth='Y' THEN  '1'  ELSE '0' END  campo_40,
        CASE WHEN p.ie_preeclampsia='S' THEN  '1'  ELSE '0' END  campo_41,
        CASE WHEN p.ie_comp_uterine_rup='Y' THEN  '1'  ELSE '0' END  campo_42,
        CASE WHEN p.ie_prema_placenta='Y' THEN  '1'  ELSE '0' END  campo_43,
        CASE WHEN p.ie_sec_without_med='Y' THEN  '1'  ELSE '0' END  campo_44,
        CASE WHEN p.ie_after_c_section='Y' THEN  '1'  ELSE '0' END  campo_45,
        CASE WHEN p.ie_after_sev_section='Y' THEN  '1'  ELSE '0' END  campo_46,
        CASE WHEN p.is_after_uter_surgery='Y' THEN  '1'  ELSE '0' END  campo_47,
        CASE WHEN p.ie_after_frust='Y' THEN  '1'  ELSE '0' END  campo_48,
        CASE WHEN p.cd_midwife IS NULL THEN  0  ELSE 1 END  campo_49,
        CASE WHEN p.cd_gynec IS NULL THEN  0  ELSE 1 END  campo_50,
        CASE WHEN p.cd_anestesista IS NULL THEN  0  ELSE 1 END  campo_51,
        CASE WHEN p.cd_neonatologist IS NULL THEN  0  ELSE 1 END  campo_52,
        CASE WHEN p.cd_pediatrician IS NULL THEN  0  ELSE 1 END  campo_53,
        CASE WHEN p.cd_phy_wo_gynec_spec IS NULL THEN  0  ELSE 1 END  campo_54,
        to_char(n.dt_nascimento, 'DD.MM.YYYY') campo_55,
        to_char(n.dt_nascimento, 'HH:MI') campo_56,
        CASE WHEN n.ie_sexo='M' THEN  '1' WHEN n.ie_sexo='F' THEN  '2'  ELSE '3' END  campo_57,
        n.qt_apgar_prim_min         campo_58,
        n.qt_apgar_quinto_min       campo_59,
        n.qt_apgar_decimo_min       campo_60,
        n.qt_peso                   campo_61,
        n.qt_altura                 campo_62,
        n.qt_pc                     campo_63,
        CASE WHEN n.ie_blood_gas_umbilical='Y' THEN  1  ELSE 0 END     campo_64,
        n.cd_arterial_ph            campo_65,
        n.cd_venous_ph              campo_66,
        n.cd_arterial_base_excess   campo_67,
        CASE WHEN ne.cd_recus_anesthetist IS NULL THEN  0  ELSE 1 END  campo_68,
        CASE WHEN ne.cd_recus_obstetrician IS NULL THEN  0  ELSE 1 END  campo_69,
        CASE WHEN ne.cd_recus_midwife IS NULL THEN  0  ELSE 1 END  campo_70,
        CASE WHEN ne.cd_recus_pediatrician IS NULL THEN  0  ELSE 1 END  campo_71,
        CASE WHEN ne.cd_recus_neonat IS NULL THEN  0  ELSE 1 END  campo_72,
        CASE
            WHEN ne.ie_malformation_skull = 'N' THEN
                '0'
            WHEN ne.ie_malformation_skull = 'Y'
                 AND ne.ie_skull_prenatal = 'N' THEN
                '1'
            WHEN ne.ie_malformation_skull = 'Y'
                 AND ne.ie_skull_prenatal = 'Y' THEN
                '2'
        END campo_73,
        CASE
            WHEN ne.ie_malformation_thorax = 'N' THEN
                '0'
            WHEN ne.ie_malformation_thorax = 'Y'
                 AND ne.ie_thorax_prenatal = 'N' THEN
                '1'
            WHEN ne.ie_malformation_thorax = 'Y'
                 AND ne.ie_thorax_prenatal = 'Y' THEN
                '2'
        END campo_74,
        CASE
            WHEN ne.ie_malformation_abdo = 'N' THEN
                '0'
            WHEN ne.ie_malformation_abdo = 'Y'
                 AND ne.ie_abdomen_prenatal = 'N' THEN
                '1'
            WHEN ne.ie_malformation_abdo = 'Y'
                 AND ne.ie_abdomen_prenatal = 'Y' THEN
                '2'
        END campo_75,
        CASE
            WHEN ne.ie_malformation_skeleton = 'N' THEN
                '0'
            WHEN ne.ie_malformation_skeleton = 'Y'
                 AND ne.id_skeleton_prenatal = 'N' THEN
                '1'
            WHEN ne.ie_malformation_skeleton = 'Y'
                 AND ne.id_skeleton_prenatal = 'Y' THEN
                '2'
        END campo_76,
        CASE
            WHEN ne.ie_malformation_other = 'N' THEN
                '0'
            WHEN ne.ie_malformation_other = 'Y'
                 AND ne.ie_others_prenatal = 'N' THEN
                '1'
            WHEN ne.ie_malformation_other = 'Y'
                 AND ne.ie_others_prenatal = 'Y' THEN
                '2'
        END campo_77,
        CASE
            WHEN ne.ie_malformation_genetic = 'N' THEN
                '0'
            WHEN ne.ie_malformation_genetic = 'Y'
                 AND ne.ie_genetic_prenatal = 'N' THEN
                '1'
            WHEN ne.ie_malformation_genetic = 'Y'
                 AND ne.ie_genetic_prenatal = 'Y' THEN
                '2'
        END campo_78,
        n.ie_hearing_test campo_79,
        (select	to_char(a.dt_alta, 'DD.MM.YYYY') from atendimento_paciente a where a.nr_atendimento = n.nr_atendimento) campo_80,
        obter_setor_atendimento(p.nr_atendimento) campo_81,
        CASE WHEN n.ie_birth_wt_high_low='Y' THEN  '1'  ELSE '0' END  campo_82,
        CASE WHEN n.ie_ataptation_dis='Y' THEN  '1'  ELSE '0' END  campo_83,
        CASE WHEN n.ie_fetal_malformation='Y' THEN  '1'  ELSE '0' END  campo_84,
        CASE WHEN n.ie_infection='Y' THEN  '1'  ELSE '0' END  campo_85,
        obter_valor_dominio(10372, n.ds_transferred)            campo_86,
        n.ie_situacao_rn campo_87,
        to_char(n.dt_obito, 'DD.MM.YYYY') campo_88,
        CASE WHEN n.ie_unico_nasc_vivo='Y' THEN  '0'  ELSE '1' END  campo_89,
        n.dt_nascimento,
        n.nr_atendimento
    FROM
    nascimento   n
    INNER JOIN parto        p ON p.nr_atendimento = n.nr_atendimento
    LEFT JOIN(
            SELECT ne.* FROM nascimento_evento ne
            INNER JOIN( SELECT nr_seq_nascimento, nr_atendimento, MAX(dt_atualizacao) dt_atualizacao
                           FROM nascimento_evento
                       GROUP BY nr_seq_nascimento, nr_atendimento
            ) sne ON sne.nr_atendimento = ne.nr_atendimento
                 AND sne.nr_seq_nascimento = ne.nr_seq_nascimento
                 AND sne.dt_atualizacao = ne.dt_atualizacao
            ) ne ON ne.nr_atendimento = n.nr_atendimento AND ne.nr_seq_nascimento = n.nr_sequencia
    WHERE n.dt_inativacao is NULL
    AND EXISTS (
            SELECT 1
            FROM atendimento_paciente ap
            INNER JOIN classif_especial_paciente ce ON ce.nr_sequencia = ap.nr_seq_classif_esp
            WHERE
                ap.nr_atendimento = n.nr_atendimento
                AND lower(ce.ds_classificacao) LIKE( 'e%' )
        );

