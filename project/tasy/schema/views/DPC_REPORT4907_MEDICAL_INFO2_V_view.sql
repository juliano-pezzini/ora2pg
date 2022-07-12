-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW dpc_report4907_medical_info2_v (nr_sequencia, currently_pregnant, birth_weight, weeks_pregnancy_birth, height, weight, smoking, jcs_disorder_hospitalization, jcs_disorder_discharge, adl_score_hospitalization, adl_score_discharge, ocurrence_cancer, primary_tumor, regional_lymph_node, distant_metastasis, cancer_stage, pre_symptom_rank_scale, modified_rank_scale_discharge, time_onset_stroke, hugh_jones_classification, nyha_cardiac_function_classif, nyha_heart_severity, nyha_myocardial_infarcation, severity_pneumonia_age, severity_pneumonia_bun, severity_pneumonia_spo290, severity_pneumonia_consc, severity_pneumonia_blood, severity_pneumonia_immunod, severity_pneumonia_factor, severity_pneumonia_nosocomial, nursing_related_pneumonia, child_pugh_bil, child_pugh_alb, child_pugh_ascites, child_pugh_encephalopathy, child_pugh_pt, severity_acute_pancreatitis, burn_index, severity_classif_names, severity_classif_numbers, pregnancy_weeks_admission, hospitalization_law, isolation_days_health, days_physical_restraint, gaf_scale_admission, additional_code, received_chemotherapy, presence_temozolomide, delivered_soon_hosp, bleeding_during_childbirth, uicc_edition, independence_degree, blood_pressure_systolic, treatment_anti_rheumatic, nursing_care_degree) AS select	coalesce(a.nr_sequencia, 0) nr_sequencia,
        coalesce(obter_valor_dominio_idioma(8685, dpc_pkg.get_value_report4907(a.nr_sequencia,'SI_PREGNANT','N'), 10), ' ') currently_pregnant,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'VL_BIRTH_WIEGHT','N'), ' ') birth_weight,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'VL_WEEKS_BIRTH_PREG','N'), ' ') weeks_pregnancy_birth,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'VL_HEIGHT','N'), ' ') height,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'VL_WEIGHT','N'), ' ') weight,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'VL_SMOKING','N'), ' ') smoking,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'CD_COMA_SCALE_ADMISSION','N'), ' ') jcs_disorder_hospitalization,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'CD_COMA_SCALE_DISCHARGE','N'), ' ') jcs_disorder_discharge,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'CD_ADL_SCORE_ADM','N'), ' ') adl_score_hospitalization,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'CD_ADL_SCORE_DIS','N'), ' ') adl_score_discharge,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'SI_CANCER_RECURR','N'), ' ') ocurrence_cancer,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'CD_UICC_PRIMARY_TUMOR','N'), ' ') primary_tumor,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'CD_UICC_REGIONAL_NODE','N'), ' ') regional_lymph_node,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'CD_UICC_DISTANT_METASTASIS','N'), ' ') distant_metastasis,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'SI_CAN_STAGE','N'), ' ') cancer_stage,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'CD_STROKE_BEFORE_HOSP','N'), ' ') pre_symptom_rank_scale,
		coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'CD_STROKE_DISCHARGE','N'), ' ') modified_rank_scale_discharge,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'SI_TIME_ONSET_STROKE','N'), ' ') time_onset_stroke,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'CD_HUGH_JONES_CLASSIF','N'), ' ') hugh_jones_classification,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'CD_NYHA_CLASSIF','N'), ' ') nyha_cardiac_function_classif,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'CD_NYHA_IS_HEART_SEVERITY','N'), ' ') nyha_heart_severity,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'CD_NYHA_MYOCARDIAL_INFARCATION','N'), ' ') nyha_myocardial_infarcation,
        (select	case    when (  ((coalesce(obter_idade_pf(d.cd_pessoa_fisica, LOCALTIMESTAMP, 'A'), 0) >= 70) and (d.ie_sexo = 'M')) or
                                ((coalesce(obter_idade_pf(d.cd_pessoa_fisica, LOCALTIMESTAMP, 'A'), 0) >= 75) and (d.ie_sexo = 'F'))) 
                        then 1
                        else 0
                end
        FROM    patient_dpc b,
                atendimento_paciente c,
                pessoa_fisica d
        where   b.nr_sequencia = a.nr_seq_patient_dpc
        and     c.nr_atendimento = b.nr_atendimento
        and     d.cd_pessoa_fisica = c.cd_pessoa_fisica) severity_pneumonia_age,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'SI_BUN21','N'), ' ') severity_pneumonia_bun,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'SI_SPO290','N'), ' ') severity_pneumonia_spo290,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'SI_IMPAIRED_CONSCIOUSNESS','N'), ' ') severity_pneumonia_consc,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'SI_BLOOD_PRESSURE','N'), ' ') severity_pneumonia_blood,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'SI_IMMUNODEFICIENCY','N'), ' ') severity_pneumonia_immunod,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'SI_PNEUMONIA_SEVERITY','N'), ' ') severity_pneumonia_factor,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'SI_NOSOCOMIAL_PNEUMONIA','N'), ' ') severity_pneumonia_nosocomial,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'SI_MEDICAL_NURSING_PNEUMO','N'), ' ') nursing_related_pneumonia,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'CD_BIL','N'), ' ') child_pugh_bil,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'CD_ALB','N'), ' ') child_pugh_alb,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'CD_ASCITES','N'), ' ') child_pugh_ascites,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'CD_ENCEPHALOPATHY','N'), ' ') child_pugh_encephalopathy,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'CD_PT','N'), ' ') child_pugh_pt,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'CD_PANCREATITIS_SEVERITY','N'), ' ') severity_acute_pancreatitis,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'VL_BURN_INDEX','N'), ' ') burn_index,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'DS_OTHER_MZZ_CLASS_NUM','N'), ' ') severity_classif_names,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'DS_OTHER_MZZ_CLASS_NAME','N'), ' ') severity_classif_numbers,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'VL_PREGNANCY_WEEK','N'), ' ') pregnancy_weeks_admission,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'SI_HOSPITALIZATION_LAW','N'), ' ') hospitalization_law,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'VL_ISOLATION_DAYS','N'), ' ') isolation_days_health,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'VL_PHYSICAL_RESTRAINT','N'), ' ') days_physical_restraint,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'VL_GAF_ADM','N'), ' ') gaf_scale_admission,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'DS_ADDITIONAL_CODE','N'), ' ') additional_code,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'SI_CHEMOTHERAPY','N'), ' ') received_chemotherapy,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'CD_BRAIN_TEMOZ','N'), ' ') presence_temozolomide,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'CD_CHILD_BIRTH_INFO','N'), ' ') delivered_soon_hosp,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'VL_BLEEDING_CHILDBIRTH','N'), ' ') bleeding_during_childbirth,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'CD_UICC_EDITION','N'), ' ') uicc_edition,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'VL_INDEPEDENCE_DEGREE','N'), ' ') independence_degree,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'SI_BLOOD_PRESSURE','N'), ' ') blood_pressure_systolic,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'SI_RHEUMATOID_INFO','N'), ' ') treatment_anti_rheumatic,
        coalesce(dpc_pkg.get_value_report4907(a.nr_sequencia,'VL_NURSING_CARE_DEGREE','N'), ' ') nursing_care_degree
from	patient_dpc_questionnaire a;
