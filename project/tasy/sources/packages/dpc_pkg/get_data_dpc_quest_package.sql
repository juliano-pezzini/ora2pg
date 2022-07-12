-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION dpc_pkg.get_data_dpc_quest (nr_seq_dpc_quest_p bigint, CD_FORMULARY_P text) RETURNS SETOF T_DPC_QUEST_DATA AS $body$
DECLARE


	row_w t_dpc_quest_row;
	cd_mdc_w dpc_mdc.cd_mdc%type;
	nr_seq_mdc_w patient_dpc_general_cond.nr_seq_classification%type;
	si_pneumonia_state_w patient_dpc_general_cond.si_pneumonia_state%type;
	si_jcs_w patient_dpc_general_cond.si_jcs%type;
	vl_gaf_score_w patient_dpc_general_cond.vl_gaf_score%type;
	vl_burn_index_w patient_dpc_general_cond.vl_burn_index%type;
	qt_pregnancy_age_weeks_w patient_dpc_general_cond.qt_pregnancy_age_weeks%type;
	qt_birth_weight_grams_w patient_dpc_general_cond.qt_birth_weight_grams%type;
	si_stroke_onset_w patient_dpc_general_cond.si_stroke_onset%type;
	vl_acute_pancreatitis_0_2_w patient_dpc_general_cond.vl_acute_pancreatitis_0_2%type;
	vl_acute_pancreatitis_3_9_w patient_dpc_general_cond.vl_acute_pancreatitis_3_9%type;
	vl_rankin_scale_w patient_dpc_general_cond.vl_rankin_scale%type;
	vl_drop_score_w patient_dpc_general_cond.vl_drop_score%type;
	si_surgery_w patient_dpc.si_surgery%type;
	nr_seq_edition_w patient_dpc.nr_seq_edition%type;
	nr_atendimento_w patient_dpc.nr_atendimento%type;
	ie_gender_w varchar(2);
	cd_zip_code_w varchar(255);
	dt_birth_w timestamp;
	dt_hospitalization_w timestamp;
	dt_discharge_w timestamp;
  dt_form1_period_start_w timestamp;
	dt_form1_period_end_w timestamp;
  dt_last_discharge_w timestamp;
  dt_previous_disease_w timestamp;
	cd_department_w varchar(255);
	qt_height_w bigint;
	qt_weight_w bigint;
	qt_patient_age_w bigint;
	cd_nyha_classif_w escala_nyha.ie_classe%type;
	dt_adm_sofa_w ESCALA_SOFA.dt_avaliacao %type;
	qt_pont_adm_sofa_w ESCALA_SOFA.qt_pontuacao%type;
	dt_after_sofa_w ESCALA_SOFA.dt_avaliacao%type;
	qt_pont_after_sofa_w ESCALA_SOFA.qt_pontuacao%type;
	dt_leaving_sofa_w ESCALA_SOFA.dt_avaliacao%type;
	qt_pont_leaving_sofa_w ESCALA_SOFA.qt_pontuacao%type;
	dt_surgery_w patient_dpc_surgery.dt_surgery%type;
	si_surgery_side_w bigint;
	cd_times_surgery_w bigint;
	cd_anesthesia_w patient_dpc_surgery.cd_anesthesia%type;
	cd_k_surgery_w dpc_surgery.cd_k_surgery_1%type;
	ds_surgery_w dpc_surgery.ds_surgery_1%type;
        dt_surgery2_w patient_dpc_surgery.dt_surgery%type;
	si_surgery_side2_w bigint;
	cd_times_surgery2_w bigint;
	cd_anesthesia2_w patient_dpc_surgery.cd_anesthesia%type;
	cd_k_surgery2_w dpc_surgery.cd_k_surgery_1%type;
	ds_surgery2_w dpc_surgery.ds_surgery_1%type;
        dt_surgery3_w patient_dpc_surgery.dt_surgery%type;
	si_surgery_side3_w bigint;
	cd_times_surgery3_w bigint;
	cd_anesthesia3_w patient_dpc_surgery.cd_anesthesia%type;
	cd_k_surgery3_w dpc_surgery.cd_k_surgery_1%type;
	ds_surgery3_w dpc_surgery.ds_surgery_1%type;
        dt_surgery4_w patient_dpc_surgery.dt_surgery%type;
	si_surgery_side4_w bigint;
	cd_times_surgery4_w bigint;
	cd_anesthesia4_w patient_dpc_surgery.cd_anesthesia%type;
	cd_k_surgery4_w dpc_surgery.cd_k_surgery_1%type;
	ds_surgery4_w dpc_surgery.ds_surgery_1%type;
        dt_surgery5_w patient_dpc_surgery.dt_surgery%type;
	si_surgery_side5_w bigint;
	cd_times_surgery5_w bigint;
	cd_anesthesia5_w patient_dpc_surgery.cd_anesthesia%type;
	cd_k_surgery5_w dpc_surgery.cd_k_surgery_1%type;
	ds_surgery5_w dpc_surgery.ds_surgery_1%type;
	cd_main_disease_w diagnostico_doenca.cd_doenca%type;
	cd_reason_hosp_disease_w diagnostico_doenca.cd_doenca%type;
	cd_most_exp_disease_w diagnostico_doenca.cd_doenca%type;
	cd_sec_most_exp_disease_w diagnostico_doenca.cd_doenca%type;
	cd_injury_main_code_w		patient_dpc_diagnosis.nr_disease_number%type;
	cd_injury_hosp_code_w		patient_dpc_diagnosis.nr_disease_number%type;
	cd_injury_most_code_w		patient_dpc_diagnosis.nr_disease_number%type;
	cd_injury_sec_code_w		patient_dpc_diagnosis.nr_disease_number%type;
	ie_bilirrubina_w		escala_child_pugh.ie_bilirrubina%type;
	ie_albumina_w			escala_child_pugh.ie_albumina%type;
	ie_ascite_w			escala_child_pugh.ie_ascite%type;
	ie_encefalopatia_hepatica_w	escala_child_pugh.ie_encefalopatia_hepatica%type;
	ie_quick_w			escala_child_pugh.ie_quick%type;	

  C01 CURSOR FOR
	SELECT b.cd_doenca, a.nr_disease_number
	from	diagnostico_doenca b,
		patient_dpc_diagnosis a
	where	a.nr_seq_patient_dpc = (SELECT max(nr_seq_patient_dpc) from   patient_dpc_questionnaire
                                where  nr_sequencia = nr_seq_dpc_quest_p)
	and	b.nr_seq_interno = a.nr_seq_diagnosis
	and	a.si_comorbidity_before = 'Y'  LIMIT 10;

	cd_seq        bigint := 0;

  C02 CURSOR FOR
	SELECT b.cd_doenca, a.nr_disease_number
	from	diagnostico_doenca b,
		patient_dpc_diagnosis a
	where	a.nr_seq_patient_dpc = (SELECT max(nr_seq_patient_dpc) from   patient_dpc_questionnaire
                                where  nr_sequencia = nr_seq_dpc_quest_p)
	and	b.nr_seq_interno = a.nr_seq_diagnosis
	and	si_after_admission = 'Y'  LIMIT 10;
	
	cd_seq2        bigint := 0;

  
BEGIN 
  Select d.cd_mdc,
    a.nr_seq_classification,
    a.si_pneumonia_state,
    a.si_jcs,
    a.vl_gaf_score,
    a.vl_burn_index,
    a.qt_pregnancy_age_weeks,
    a.qt_birth_weight_grams,
    a.si_stroke_onset,
    a.vl_acute_pancreatitis_0_2,
    a.vl_acute_pancreatitis_3_9,
    a.vl_rankin_scale,
    a.vl_drop_score,
    b.si_surgery,
    b.nr_seq_edition,
    b.nr_atendimento,
    CASE WHEN obter_dados_pf(obter_dados_Atendimento(b.nr_atendimento,'CP'),'SE')='M' THEN 1  ELSE 2 END  ie_gender,
    obter_compl_pf(obter_dados_Atendimento(b.nr_atendimento,'CP'), 1, 'CEP') cd_zip_code,
    obter_data_nascto_pf(obter_dados_Atendimento(b.nr_atendimento,'CP')) dt_birth,
    (select max(x.dt_entrada) from atendimento_paciente x where x.nr_atendimento = b.nr_atendimento) dt_hospitalization,
    (select max(x.dt_alta) from atendimento_paciente x where x.nr_atendimento = b.nr_atendimento) dt_discharge,
    (select coalesce((select max(DT_ENTRADA_UNIDADE) from ATEND_PACIENTE_UNIDADE where NR_ATENDIMENTO = b.NR_ATENDIMENTO),(select DT_ENTRADA from ATENDIMENTO_PACIENTE where NR_ATENDIMENTO = b.NR_ATENDIMENTO)) ) dt_form1_period_start,
    (select coalesce((select max(DT_ENTRADA_UNIDADE)-1 from ATEND_PACIENTE_UNIDADE where NR_ATENDIMENTO = b.NR_ATENDIMENTO),(select DT_ALTA from ATENDIMENTO_PACIENTE where NR_ATENDIMENTO = b.NR_ATENDIMENTO)) ) dt_form1_period_end,
    (select coalesce((select DT_ALTA from ATENDIMENTO_PACIENTE where NR_ATENDIMENTO = b.NR_ATENDIMENTO),(select max(DT_ALTA) from ATENDIMENTO_PACIENTE where cd_pessoa_fisica = obter_cd_pes_fis_atend(b.nr_atendimento)) ) ) dt_last_discharge,
    get_dpc_previous_discharge(b.nr_atendimento,d.cd_mdc) dt_previous_disease,
    obter_departamento_data(b.nr_atendimento,clock_timestamp()) cd_department,
    obter_dados_pf(obter_dados_Atendimento(b.nr_atendimento,'CP'),'AL') qt_height,
    obter_dados_pf(obter_dados_Atendimento(b.nr_atendimento,'CP'),'KG') qt_weight
into STRICT    cd_mdc_w,
    nr_seq_mdc_w,
    si_pneumonia_state_w,
    si_jcs_w,
    vl_gaf_score_w,
    vl_burn_index_w,
    qt_pregnancy_age_weeks_w,
    qt_birth_weight_grams_w,
    si_stroke_onset_w,
    vl_acute_pancreatitis_0_2_w,
    vl_acute_pancreatitis_3_9_w,
    vl_rankin_scale_w,
    vl_drop_score_w,
    si_surgery_w,
    nr_seq_edition_w,
    nr_atendimento_w,
    ie_gender_w,
    cd_zip_code_w,
    dt_birth_w,
    dt_hospitalization_w,
    dt_discharge_w,
    dt_form1_period_start_w,
    dt_form1_period_end_w,
    dt_last_discharge_w,
    dt_previous_disease_w,
    cd_department_w,
    qt_height_w,
    qt_weight_w
from    dpc_mdc d,
    dpc_classification c,
    patient_dpc_general_cond a,
    patient_dpc b,
    patient_dpc_questionnaire e
where    a.nr_seq_mdc    = d.nr_sequencia
and    a.nr_seq_classification = c.nr_sequencia
and    a.nr_sequencia = (SELECT max(x.nr_sequencia)
                from patient_dpc_general_cond x
                where x.nr_seq_patient_dpc = b.nr_sequencia)
and    b.nr_sequencia = e.nr_seq_patient_dpc
and       e.nr_sequencia = nr_seq_dpc_quest_p;

Select obter_idade_pf(a.cd_pessoa_fisica,coalesce(a.dt_alta,clock_timestamp()),'A')
	into STRICT	qt_patient_age_w
from	atendimento_paciente a
	where	a.nr_atendimento	= nr_atendimento_w;

select 	max(ie_bilirrubina),
	max(ie_albumina),
	max(ie_ascite),
	max(ie_encefalopatia_hepatica),
	max(ie_quick)
into STRICT	ie_bilirrubina_w,
	ie_albumina_w,
	ie_ascite_w,
	ie_encefalopatia_hepatica_w,
	ie_quick_w
from	escala_child_pugh
where  nr_atendimento = nr_atendimento_w
and	ie_situacao = 'A';

select max(ie_classe)
	into STRICT   cd_nyha_classif_w
from   escala_nyha
	where  nr_atendimento = nr_atendimento_w
	and    ie_situacao = 'A';

select max(dt_adm_sofa),
	max(qt_pont_adm_sofa), 
	max(dt_after_sofa), 
	max(qt_pont_after_sofa), 
	max(dt_leaving_sofa), 
	max(qt_pont_leaving_sofa)
into STRICT   dt_adm_sofa_w, 
	qt_pont_adm_sofa_w, 
	dt_after_sofa_w,      
	qt_pont_after_sofa_w, 
	dt_leaving_sofa_w, 
	qt_pont_leaving_sofa_w
from (SELECT dt_avaliacao dt_adm_sofa, qt_pontuacao qt_pont_adm_sofa, null dt_after_sofa, null qt_pont_after_sofa, null dt_leaving_sofa, null qt_pont_leaving_sofa
	from ESCALA_SOFA
	where nr_atendimento = nr_atendimento_w
	and   ie_situacao = 'A'
	and   (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and   trunc(dt_avaliacao,'dd') = trunc(dt_hospitalization_w)
	
union all

	SELECT null dt_adm_sofa, null qt_pont_adm_sofa, dt_avaliacao dt_after_sofa, qt_pontuacao qt_pont_after_sofa, null dt_leaving_sofa, null qt_pont_leaving_sofa
	from ESCALA_SOFA
	where nr_atendimento = nr_atendimento_w
	and   ie_situacao = 'A'
	and   (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and   trunc(dt_avaliacao,'dd') <> trunc(dt_hospitalization_w)
	and   trunc(dt_avaliacao,'dd') <> trunc(dt_discharge_w)
	
union all

	select null dt_adm_sofa, null qt_pont_adm_sofa, null dt_after_sofa, null qt_pont_after_sofa, dt_avaliacao dt_leaving_sofa, qt_pontuacao qt_pont_leaving_sofa
	from ESCALA_SOFA
	where nr_atendimento = nr_atendimento_w
	and   ie_situacao = 'A'
	and   (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and   trunc(dt_avaliacao,'dd') = trunc(dt_discharge_w)) alias17;

if (cd_formulary_p = '1') then
    row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'IE_GENDER';
    row_w.ds_value := ie_gender_w;
    RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'CD_ZIP_CODE';
    row_w.ds_value := cd_zip_code_w;
    RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'DT_BIRTH';
    row_w.ds_value := dt_birth_w;
    row_w.dt_value := dt_birth_w; 	
    RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'DT_HOSPITALIZATION';
    row_w.ds_value := dt_hospitalization_w;
    row_w.dt_value := dt_hospitalization_w;
    RETURN NEXT row_w;
	
  row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'DT_FORM1_PERIOD_START';
    row_w.ds_value := dt_form1_period_start_w;
    row_w.dt_value := dt_form1_period_start_w;
    RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'DT_FORM1_PERIOD_END';
    row_w.ds_value := dt_form1_period_end_w;
    row_w.dt_value := dt_form1_period_end_w;
    RETURN NEXT row_w;

  row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'DT_LAST_DISCHARGE';
    row_w.ds_value := dt_last_discharge_w;
    row_w.dt_value := dt_last_discharge_w;
    RETURN NEXT row_w;

  row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'DT_PREVIOUS_DISEASE';
    row_w.ds_value := dt_previous_disease_w;
    row_w.dt_value := dt_previous_disease_w;
    RETURN NEXT row_w;

	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'DT_DISCHARGE';
    row_w.ds_value := dt_discharge_w;
    row_w.dt_value := dt_discharge_w;
    RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'CD_DEPARTMENT';
    row_w.ds_value := cd_department_w;
    RETURN NEXT row_w;
	
elsif (cd_formulary_p = '3') then
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'VL_HEIGHT';
    row_w.ds_value := qt_height_w;
    RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'VL_WEIGHT';
    row_w.ds_value := qt_weight_w;
    RETURN NEXT row_w;
	
	if (qt_pregnancy_age_weeks_w > 0) then
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'SI_PREGNANT';
    row_w.ds_value := '1';
    RETURN NEXT row_w;
	end if;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'VL_PREGNANCY_WEEK';
    row_w.ds_value := qt_pregnancy_age_weeks_w;
    RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'VL_BIRTH_WIEGHT';
    row_w.ds_value := qt_birth_weight_grams_w;
    RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'CD_COMA_SCALE_ADMISSION';
    row_w.ds_value := si_jcs_w;
    RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'CD_COMA_SCALE_DISCHARGE';
    row_w.ds_value := si_jcs_w;
    RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'SI_TIME_ONSET_STROKE';
    row_w.ds_value := si_stroke_onset_w;
    RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'SI_NOSOCOMIAL_PNEUMONIA';
    row_w.ds_value := si_pneumonia_state_w;
    RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'CD_PANCREATITIS_SEVERITY';
    row_w.ds_value := coalesce(vl_acute_pancreatitis_0_2_w,vl_acute_pancreatitis_3_9_w);
    RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'VL_BURN_INDEX';
    row_w.ds_value := vl_burn_index_w;
    RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'VL_GAF_ADM';
    row_w.ds_value := vl_gaf_score_w;
    RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'CD_STROKE_BEFORE_HOSP';
    row_w.ds_value := vl_rankin_scale_w;
    RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'CD_STROKE_DISCHARGE';
    row_w.ds_value := vl_rankin_scale_w;
    RETURN NEXT row_w;
	
    row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'CD_BIL';
    row_w.ds_value := ie_bilirrubina_w;
    RETURN NEXT row_w;

    row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'CD_ALB';
    row_w.ds_value := ie_albumina_w;
    RETURN NEXT row_w;

    row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'CD_ASCITES';
    row_w.ds_value := ie_ascite_w;
    RETURN NEXT row_w;

    row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'CD_ENCEPHALOPATHY';
    row_w.ds_value := ie_encefalopatia_hepatica_w;
    RETURN NEXT row_w;

    row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'CD_PT';
    row_w.ds_value := ie_quick_w;
    RETURN NEXT row_w;

    row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'CD_NYHA_CLASSIF';
    row_w.ds_value := cd_nyha_classif_w;
    RETURN NEXT row_w;
	
    row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'DT_SOFA_MES_ENTRY';
    row_w.ds_value := dt_adm_sofa_w;
    row_w.dt_value := dt_adm_sofa_w;
    RETURN NEXT row_w;
	
    row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'VL_SOFA_MES_ENTRY';
    row_w.ds_value := qt_pont_adm_sofa_w;
    RETURN NEXT row_w;
	
    row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'DT_SOFA_AFTER_ENTRY';
    row_w.ds_value := dt_after_sofa_w;
    row_w.dt_value := dt_after_sofa_w;
    RETURN NEXT row_w;
	
    row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'VL_SOFA_AFTER_ENTRY';
    row_w.ds_value := qt_pont_after_sofa_w;
    RETURN NEXT row_w;
	
    row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'DT_SOFA_LEAVING_DAY';
    row_w.ds_value := dt_leaving_sofa_w;
    row_w.dt_value := dt_leaving_sofa_w;
    RETURN NEXT row_w;
	
    row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
    row_w.cd_formulary := CD_FORMULARY_P;
    row_w.ds_field := 'VL_SOFA_LEAVING_ROOM';
    row_w.ds_value := qt_pont_leaving_sofa_w;
    RETURN NEXT row_w;
	
elsif (cd_formulary_p = '4') then
	Select 	a.dt_surgery,
		coalesce(	CASE WHEN a.cd_external_part=0 THEN 1 WHEN a.cd_external_part=1 THEN 3 END ,
			coalesce(	CASE WHEN a.cd_internal_part=0 THEN 2 WHEN a.cd_internal_part=1 THEN 3 END ,
				CASE WHEN a.cd_eyes=0 THEN 1 WHEN a.cd_eyes=1 THEN 3 END )) si_surgery_side,
		CASE WHEN a.cd_times_surgery=0 THEN 1 WHEN a.cd_times_surgery=1 THEN 2 END  cd_times_surgery,
		a.cd_anesthesia,
		d.cd_k_surgery_1, 
		d.ds_surgery_1,
		a.dt_surgery2,
		coalesce(	CASE WHEN a.cd_external_part2=0 THEN 1 WHEN a.cd_external_part2=1 THEN 3 END ,
			coalesce(	CASE WHEN a.cd_internal_part2=0 THEN 2 WHEN a.cd_internal_part2=1 THEN 3 END ,
				CASE WHEN a.cd_eyes2=0 THEN 1 WHEN a.cd_eyes2=1 THEN 3 END )) si_surgery_side2,
		CASE WHEN a.cd_times_surgery2=0 THEN 1 WHEN a.cd_times_surgery2=1 THEN 2 END  cd_times_surgery2,
		a.cd_anesthesia2,
		d.cd_k_surgery_2, 
		d.ds_surgery_2,
		a.dt_surgery3,
		coalesce(	CASE WHEN a.cd_external_part3=0 THEN 1 WHEN a.cd_external_part3=1 THEN 3 END ,
			coalesce(	CASE WHEN a.cd_internal_part3=0 THEN 2 WHEN a.cd_internal_part3=1 THEN 3 END ,
				CASE WHEN a.cd_eyes3=0 THEN 1 WHEN a.cd_eyes3=1 THEN 3 END )) si_surgery_side3,
		CASE WHEN a.cd_times_surgery3=0 THEN 1 WHEN a.cd_times_surgery3=1 THEN 2 END  cd_times_surgery3,
		a.cd_anesthesia3,
		d.cd_k_surgery_3, 
		d.ds_surgery_3,
		a.dt_surgery4,
		coalesce(	CASE WHEN a.cd_external_part4=0 THEN 1 WHEN a.cd_external_part4=1 THEN 3 END ,
			coalesce(	CASE WHEN a.cd_internal_part2=0 THEN 2 WHEN a.cd_internal_part2=1 THEN 3 END ,
				CASE WHEN a.cd_eyes2=0 THEN 1 WHEN a.cd_eyes2=1 THEN 3 END )) si_surgery_side4,
		CASE WHEN a.cd_times_surgery4=0 THEN 1 WHEN a.cd_times_surgery4=1 THEN 2 END  cd_times_surgery4,
		a.cd_anesthesia4,
		d.cd_k_surgery_4, 
		d.ds_surgery_4,
		a.dt_surgery5,
		coalesce(	CASE WHEN a.cd_external_part5=0 THEN 1 WHEN a.cd_external_part5=1 THEN 3 END ,
			coalesce(	CASE WHEN a.cd_internal_part5=0 THEN 2 WHEN a.cd_internal_part5=1 THEN 3 END ,
				CASE WHEN a.cd_eyes2=0 THEN 1 WHEN a.cd_eyes2=1 THEN 3 END )) si_surgery_side5,
		CASE WHEN a.cd_times_surgery5=0 THEN 1 WHEN a.cd_times_surgery5=1 THEN 2 END  cd_times_surgery5,
		a.cd_anesthesia5,
		d.cd_k_surgery_5, 
		d.ds_surgery_5                        
		into STRICT	dt_surgery_w, 
		si_surgery_side_w, 
		cd_times_surgery_w,       
		cd_anesthesia_w, 
		cd_k_surgery_w, 
		ds_surgery_w,
		dt_surgery2_w, 
		si_surgery_side2_w, 
		cd_times_surgery2_w,       
		cd_anesthesia2_w, 
		cd_k_surgery2_w, 
		ds_surgery2_w,
		dt_surgery3_w, 
		si_surgery_side3_w, 
		cd_times_surgery3_w,       
		cd_anesthesia3_w, 
		cd_k_surgery3_w, 
		ds_surgery3_w,
		dt_surgery4_w, 
		si_surgery_side4_w, 
		cd_times_surgery4_w,       
		cd_anesthesia4_w, 
		cd_k_surgery4_w, 
		ds_surgery4_w,
		dt_surgery5_w, 
		si_surgery_side5_w, 
		cd_times_surgery5_w,       
		cd_anesthesia5_w, 
		cd_k_surgery5_w, 
		ds_surgery5_w  
	from	patient_dpc_surgery a,
		patient_dpc b,
		patient_dpc_questionnaire c,
		dpc_surgery d
	where  	d.nr_sequencia = a.nr_seq_dpc_surgery
	and	a.nr_seq_patient_dpc = b.nr_sequencia
	and	b.nr_sequencia = c.nr_seq_patient_dpc 
	and   	c.nr_sequencia = nr_seq_dpc_quest_p;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'DT_SURGERY';
	row_w.ds_value := dt_surgery_w;
	row_w.dt_value := dt_surgery_w;	
	RETURN NEXT row_w;

	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'CD_SURGERY';
	row_w.ds_value := cd_k_surgery_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'CD_TIMES_SURGERY';
	row_w.ds_value := cd_times_surgery_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'SI_SURGERY_SIDE';
	row_w.ds_value := si_surgery_side_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'CD_ANESTHESIA';
	row_w.ds_value := cd_anesthesia_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'DS_SURGERY';
	row_w.ds_value := ds_surgery_w;
	RETURN NEXT row_w;
	
        row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'DT_SURGERY2';
	row_w.ds_value := dt_surgery2_w;
	row_w.dt_value := dt_surgery2_w;
	RETURN NEXT row_w;

	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'CD_SURGERY2';
	row_w.ds_value := cd_k_surgery2_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'CD_TIMES_SURGERY2';
	row_w.ds_value := cd_times_surgery2_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'SI_SURGERY_SIDE2';
	row_w.ds_value := si_surgery_side2_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'CD_ANESTHESIA2';
	row_w.ds_value := cd_anesthesia2_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'DS_SURGERY2';
	row_w.ds_value := ds_surgery2_w;
	RETURN NEXT row_w;

	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'DT_SURGERY3';
	row_w.ds_value := dt_surgery3_w;
	row_w.dt_value := dt_surgery3_w;
	RETURN NEXT row_w;

	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'CD_SURGERY3';
	row_w.ds_value := cd_k_surgery3_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'CD_TIMES_SURGERY3';
	row_w.ds_value := cd_times_surgery3_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'SI_SURGERY_SIDE3';
	row_w.ds_value := si_surgery_side3_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'CD_ANESTHESIA3';
	row_w.ds_value := cd_anesthesia3_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'DS_SURGERY3';
	row_w.ds_value := ds_surgery3_w;
	RETURN NEXT row_w;

	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'DT_SURGERY4';
	row_w.ds_value := dt_surgery4_w;
	row_w.dt_value := dt_surgery4_w;
	RETURN NEXT row_w;

	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'CD_SURGERY4';
	row_w.ds_value := cd_k_surgery4_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'CD_TIMES_SURGERY4';
	row_w.ds_value := cd_times_surgery4_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'SI_SURGERY_SIDE4';
	row_w.ds_value := si_surgery_side4_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'CD_ANESTHESIA4';
	row_w.ds_value := cd_anesthesia4_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'DS_SURGERY4';
	row_w.ds_value := ds_surgery4_w;
	RETURN NEXT row_w;

	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'DT_SURGERY5';
	row_w.ds_value := dt_surgery5_w;
	row_w.dt_value := dt_surgery5_w;
	RETURN NEXT row_w;

	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'CD_SURGERY5';
	row_w.ds_value := cd_k_surgery5_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'CD_TIMES_SURGERY5';
	row_w.ds_value := cd_times_surgery5_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'SI_SURGERY_SIDE5';
	row_w.ds_value := si_surgery_side5_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'CD_ANESTHESIA5';
	row_w.ds_value := cd_anesthesia5_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'DS_SURGERY5';
	row_w.ds_value := ds_surgery5_w;
	RETURN NEXT row_w;
elsif (cd_formulary_p = '5') then
	select (Select  	max(b.cd_doenca) cd_main_disease
	    from    	diagnostico_doenca b,
			patient_dpc_diagnosis a
	    where   	a.nr_seq_patient_dpc = x.nr_seq_patient_dpc
	    and    	b.nr_seq_interno = a.nr_seq_diagnosis
	    and    	si_main = 'Y') cd_main_disease,
	    (Select  max(a.nr_disease_number) cd_injury_main_code
	    from    patient_dpc_diagnosis a
	    where   a.nr_seq_patient_dpc = x.nr_seq_patient_dpc
	    and     si_main = 'Y') cd_injury_main_code,
	    (Select  	max(b.cd_doenca) cd_reason_hosp_disease
	    from    	diagnostico_doenca b,
			patient_dpc_diagnosis a
	    where     	a.nr_seq_patient_dpc = x.nr_seq_patient_dpc
	    and    	b.nr_seq_interno = a.nr_seq_diagnosis
	    and    	si_for_hospitalization = 'Y') cd_reason_hosp_disease,
	    (Select  max(a.nr_disease_number) cd_injury_hosp_code
	    from    patient_dpc_diagnosis a
	    where   a.nr_seq_patient_dpc = x.nr_seq_patient_dpc
	    and     si_for_hospitalization = 'Y') cd_injury_hosp_code,
	    (Select 	max(b.cd_doenca) cd_most_exp_disease
	    from    	diagnostico_doenca b,
			patient_dpc a
	    where     	a.nr_sequencia = x.nr_seq_patient_dpc
	    and    	b.nr_seq_interno = a.nr_seq_most_exp_diagnosis) cd_most_exp_disease,
	    (Select 	max(a.nr_disease_number) cd_injury_most_code
	    from    	patient_dpc a
	    where     	a.nr_sequencia = x.nr_seq_patient_dpc) cd_injury_most_code,
	    (Select 	max(b.cd_doenca) cd_sec_most_exp_disease
	    from    	diagnostico_doenca b,
			patient_dpc_diagnosis a
	    where    	a.nr_seq_patient_dpc = x.nr_seq_patient_dpc
	    and    	b.nr_seq_interno = a.nr_seq_diagnosis
	    and    	a.si_second_most_expensive = 'Y') cd_sec_most_exp_disease,
	   (Select  max(a.nr_disease_number) cd_injury_sec_code
	    from    patient_dpc_diagnosis a
	    where   a.nr_seq_patient_dpc = x.nr_seq_patient_dpc
	    and     si_second_most_expensive = 'Y') cd_injury_sec_code
	into STRICT     	cd_main_disease_w,
			cd_injury_main_code_w,
			cd_reason_hosp_disease_w,
			cd_injury_hosp_code_w,
			cd_most_exp_disease_w,
			cd_injury_most_code_w,
			cd_sec_most_exp_disease_w,
			cd_injury_sec_code_w
	from    patient_dpc_questionnaire x
	where    x.nr_sequencia = nr_seq_dpc_quest_p;

	for r01 in C01 loop
		cd_seq := cd_seq + 1;
		row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
		row_w.cd_formulary := CD_FORMULARY_P;
		row_w.ds_field := 'CD_COMORB_DISEASE_' || cd_seq;
		row_w.ds_value := r01.cd_doenca;
		RETURN NEXT row_w;
		
		row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
		row_w.cd_formulary := CD_FORMULARY_P;
		row_w.ds_field := 'CD_INJURY_COMORB' || cd_seq || '_CODE';
		row_w.ds_value := r01.nr_disease_number;
		RETURN NEXT row_w;
		
		row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
		row_w.cd_formulary := CD_FORMULARY_P;
		row_w.ds_field := 'DS_ADD_COMORB' || cd_seq || '_CODE';
		row_w.ds_value := r01.nr_disease_number;
		RETURN NEXT row_w;
	end loop;
	
	for r02 in C02 loop
		cd_seq2 := cd_seq2 + 1;
		row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
		row_w.cd_formulary := CD_FORMULARY_P;
		row_w.ds_field := 'CD_AFT_ADM_DISEASE_' || cd_seq2;
		row_w.ds_value := r02.cd_doenca;
		RETURN NEXT row_w;
		
		row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
		row_w.cd_formulary := CD_FORMULARY_P;
		row_w.ds_field := 'CD_INJURY_AFT' || cd_seq2 || '_CODE';
		row_w.ds_value := r02.nr_disease_number;
		RETURN NEXT row_w;
		
		row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
		row_w.cd_formulary := CD_FORMULARY_P;
		row_w.ds_field := 'DS_ADD_AFT' || cd_seq2 || '_CODE';
		row_w.ds_value := r02.nr_disease_number;
		RETURN NEXT row_w;
	end loop;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'CD_MAIN_DISEASE';
	row_w.ds_value := cd_main_disease_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'CD_INJURY_MAIN_CODE';
	row_w.ds_value := cd_injury_main_code_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'DS_ADD_MAIN_CODE';
	row_w.ds_value := cd_injury_main_code_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'CD_REASON_HOSP_DISEASE';
	row_w.ds_value := cd_reason_hosp_disease_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'CD_INJURY_HOSP_CODE';
	row_w.ds_value := cd_injury_hosp_code_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'DS_ADD_HOSP_CODE';
	row_w.ds_value := cd_injury_hosp_code_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'CD_MOST_EXP_DISEASE';
	row_w.ds_value := cd_most_exp_disease_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'CD_INJURY_MOST_CODE';
	row_w.ds_value := cd_injury_most_code_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'DS_ADDITIONAL_CODE';
	row_w.ds_value := cd_injury_most_code_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'CD_SEC_MOST_EXP_DISEASE';
	row_w.ds_value := cd_sec_most_exp_disease_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'CD_INJURY_SEC_CODE';
	row_w.ds_value := cd_injury_sec_code_w;
	RETURN NEXT row_w;
	
	row_w.nr_seq_dpc_quest := NR_SEQ_DPC_QUEST_P;
	row_w.cd_formulary := CD_FORMULARY_P;
	row_w.ds_field := 'DS_ADD_SEC_CODE';
	row_w.ds_value := cd_injury_sec_code_w;
	RETURN NEXT row_w;
end if;
return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION dpc_pkg.get_data_dpc_quest (nr_seq_dpc_quest_p bigint, CD_FORMULARY_P text) FROM PUBLIC;