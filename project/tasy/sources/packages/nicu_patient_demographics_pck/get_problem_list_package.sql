-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION nicu_patient_demographics_pck.get_problem_list (nr_seq_encounter_p bigint) RETURNS varchar AS $body$
DECLARE


	ds_problem_list_w	varchar(2000);

	cProblems CURSOR FOR
		SELECT	ds_problem
		from	nicu_problem_list
		where	nr_seq_encounter = nr_seq_encounter_p
		and		(ds_problem IS NOT NULL AND ds_problem::text <> '');

	
  r_parent RECORD;

BEGIN

		for rProblem in cProblems loop
		begin

			ds_problem_list_w := ds_problem_list_w || rProblem.ds_problem || chr(10) || chr(10);

		end;
		end loop;

		return ds_problem_list_w;

	end;

begin

	select  max(per.ds_given_name),
			max(per.ds_family_name),
			max(per.ds_component_name_1),
			max(pat.ie_gender),
			max(CASE WHEN upper(pat.ie_gender)='F' THEN  WHEB_MENSAGEM_PCK.get_texto(1177521) WHEN upper(pat.ie_gender)='M' THEN  WHEB_MENSAGEM_PCK.get_texto(1177522) WHEN upper(pat.ie_gender)='U' THEN  WHEB_MENSAGEM_PCK.get_texto(1195403) WHEN upper(pat.ie_gender)='O' THEN  WHEB_MENSAGEM_PCK.get_texto(1195404)  ELSE '' END ),
			max(pat.id_patient),
			max(pat.dt_birthdate),
			max(enc.dt_admission),
			max(ua.cd_unidade_basica),
			max(ua.cd_unidade_compl),
			max(pat.nr_sequencia),
			max(pat.dt_birth_ga),
			max(pat.qt_birth_weight)
	into STRICT    ds_given_name_w,
			ds_family_name_w,
			ds_middle_name_w,
			ie_gender_w,
			ds_gender_w,
			id_patient_w,
			dt_birthdate_w,
			dt_admission_w,
			cd_unidade_basica_w,
			cd_unidade_compl_w,
			nr_seq_patient_w,
			dt_birth_gestational_w,
			qt_birth_weight_w
	from    nicu_encounter enc,
			nicu_patient pat,
			person_name per,
			unidade_atendimento ua
	where   enc.nr_sequencia = nr_atendimento_p
	and		enc.nr_seq_patient = pat.nr_sequencia
	and   	per.nr_sequencia = pat.nr_seq_person_name
	and   	enc.id_location = ua.nm_leito_integracao;

	if (ds_family_name_w <> ' ' AND ds_given_name_w <> ' ') then

		ds_patient_name_w := ds_given_name_w || ' ' || ds_family_name_w;

	else

		if (ds_family_name_w <> ' ') then
			ds_patient_name_w := wheb_mensagem_pck.get_texto(1178973) || ' ' || ds_family_name_w;
		elsif (ie_gender_w = 'M') then
			ds_patient_name_w := wheb_mensagem_pck.get_texto(1178973) || ' ' || wheb_mensagem_pck.get_texto(1179557);
		elsif (ie_gender_w = 'F') then 	
			ds_patient_name_w := wheb_mensagem_pck.get_texto(1178973) || ' ' || wheb_mensagem_pck.get_texto(1179559);
		else
			ds_patient_name_w := wheb_mensagem_pck.get_texto(1178973);
		end if;

	end if;

	ds_bed_w := cd_unidade_basica_w || ' ' || cd_unidade_compl_w;

	ds_dob_w := to_char(dt_birthdate_w, 'YYYY-DD-MM') || ' (' || (trunc(current_date) - trunc(dt_birthdate_w) + 1) || 'd)';
	ds_entry_w := to_char(dt_admission_w, 'YYYY-DD-MM') || ' (' || (trunc(current_date) - trunc(dt_admission_w) + 1) || 'd)';

	r_demographic_field_w.ds_field_name := 'DS_NAME';
	r_demographic_field_w.ds_field_value := ds_patient_name_w;
	r_demographic_field_w.cd_exp_label := '';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'S';
	r_demographic_field_w.ds_add_info := '';
	r_demographic_field_w.ds_info_color := '';
	r_demographic_field_w.ds_label := '';
	RETURN NEXT r_demographic_field_w;

	r_demographic_field_w.ds_field_name := 'NR_ENCOUNTER';
	r_demographic_field_w.ds_field_value := nr_atendimento_p;
	r_demographic_field_w.cd_exp_label := '1176111';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'S';
	r_demographic_field_w.ds_add_info := '';
	r_demographic_field_w.ds_info_color := '';
	r_demographic_field_w.ds_label := '';
	RETURN NEXT r_demographic_field_w;

	r_demographic_field_w.ds_field_name := 'NR_PATIENT_MRN';
	r_demographic_field_w.ds_field_value := id_patient_w;
	r_demographic_field_w.cd_exp_label := '1176112';
	r_demographic_field_w.ie_obscured := 'S';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'S';
	r_demographic_field_w.ds_add_info := '';
	r_demographic_field_w.ds_info_color := '';
	r_demographic_field_w.ds_label := '';
	RETURN NEXT r_demographic_field_w;

	ds_privacy_id_w := nicu_patient_demographics_pck.get_last_obs_info(nr_seq_patient_w, 'DEMOG_ID_Privacy_Val');

	r_demographic_field_w.ds_field_name := 'NR_PRIVACY_ID';
	r_demographic_field_w.ds_field_value := ds_privacy_id_w;
	r_demographic_field_w.cd_exp_label := '';
	r_demographic_field_w.ie_obscured := 'S';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ds_label := '';
	RETURN NEXT r_demographic_field_w;

	r_demographic_field_w.ds_field_name := 'IE_PATIENT_GENDER';
	r_demographic_field_w.ds_field_value := ds_gender_w;
	r_demographic_field_w.cd_exp_label := '1176113';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'S';
	r_demographic_field_w.ds_add_info := '';
	r_demographic_field_w.ds_info_color := '';
	r_demographic_field_w.ds_label := '';
	RETURN NEXT r_demographic_field_w;

	r_demographic_field_w.ds_field_name := 'DS_BIRTH_DATE';
	r_demographic_field_w.ds_field_value := ds_dob_w;
	r_demographic_field_w.cd_exp_label := '1176114';
	r_demographic_field_w.ie_obscured := 'S';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'S';
	r_demographic_field_w.ds_add_info := '';
	r_demographic_field_w.ds_info_color := '';
	r_demographic_field_w.ds_label := '';
	RETURN NEXT r_demographic_field_w;

	ds_los_w := nicu_patient_demographics_pck.get_days_los(nr_atendimento_p);

	if (ds_los_w <> ' ') then
		ds_los_w := ds_los_w || ' d';
	end if;

	r_demographic_field_w.ds_field_name := 'DS_LOS';
	r_demographic_field_w.ds_field_value := ds_los_w;
	r_demographic_field_w.cd_exp_label := '1180654';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'S';
	r_demographic_field_w.ds_add_info := '';
	r_demographic_field_w.ds_info_color := '';
	r_demographic_field_w.ds_label := '';
	RETURN NEXT r_demographic_field_w;

	r_demographic_field_w.ds_field_name := 'DS_BED';
	r_demographic_field_w.ds_field_value := ds_bed_w;
	r_demographic_field_w.cd_exp_label := '1176116';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'S';
	r_demographic_field_w.ds_add_info := '';
	r_demographic_field_w.ds_info_color := '';
	r_demographic_field_w.ds_label := '';
	RETURN NEXT r_demographic_field_w;

	r_demographic_field_w.ds_field_name := 'DS_ALLERGIES';
	r_demographic_field_w.ds_field_value := '';
	r_demographic_field_w.cd_exp_label := '';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'N';
	r_demographic_field_w.ds_add_info := '';
	r_demographic_field_w.ds_info_color := '';
	r_demographic_field_w.ds_label := '';
	RETURN NEXT r_demographic_field_w;

	ds_birth_gestational_w := nicu_patient_demographics_pck.get_last_obs_info(nr_seq_patient_w, 'DEMOG_Birth_Gest_Age_Val');

	if (ds_birth_gestational_w <> ' ') then	
		
		r_demographic_field_w.ds_field_name := 'DS_BIRTH_GA';
		r_demographic_field_w.ds_field_value := ds_birth_gestational_w || ' w';
		r_demographic_field_w.cd_exp_label := '';
		r_demographic_field_w.ie_obscured := 'N';
		r_demographic_field_w.ie_editable := 'N';
		r_demographic_field_w.ie_visible := 'S';
		r_demographic_field_w.ds_add_info := '';
		r_demographic_field_w.ds_info_color := '';
		r_demographic_field_w.ds_label := '';
		RETURN NEXT r_demographic_field_w;		
	end if;

    ds_birth_weight_w := nicu_patient_demographics_pck.get_birth_weight(nr_atendimento_p);

	if (ds_birth_weight_w <> ' ') then
		ds_birth_weight_w := ds_birth_weight_w || ' g';
	else
		ds_birth_weight_w := '';
	end if;

	r_demographic_field_w.ds_field_name := 'DS_BIRTH_WEIGHT';
	r_demographic_field_w.ds_field_value := ds_birth_weight_w;
	r_demographic_field_w.cd_exp_label := '';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'S';
	r_demographic_field_w.ds_add_info := '';
	r_demographic_field_w.ds_info_color := '';
	r_demographic_field_w.ds_label := '';
	RETURN NEXT r_demographic_field_w;
		
	if (coalesce(ds_birth_gestational_w, 'XPTO') <> 'XPTO') then

		qt_pma_w := ds_birth_gestational_w;
		qt_weeks_w := 0;
		qt_days_w := 0;
		
		qt_days_of_life_w := pkg_date_utils.get_DiffDate(dt_birthdate_w, establishment_timezone_utils.getCurrentDate, 'DAY');
		
		if (qt_days_of_life_w <= 1) then
				
			qt_hours_of_life_w := pkg_date_utils.get_DiffDate(dt_birthdate_w, establishment_timezone_utils.getCurrentDate, 'MINUTE');
	
			if (qt_hours_of_life_w < 1440) then
				ds_post_menstrual_age_w := ds_birth_gestational_w || 'w ' || trunc(qt_hours_of_life_w / 60) || 'h';
			else
				ds_post_menstrual_age_w := ds_birth_gestational_w || 'w ' || '1d';
			end if;
		else	
		
			if (qt_days_of_life_w < 7) then
				ds_post_menstrual_age_w := ds_birth_gestational_w || 'w ' || qt_days_of_life_w || 'd';
			else		

				qt_weeks_w := trunc(qt_days_of_life_w / 7);
				qt_days_w := mod(qt_days_of_life_w, 7);
			
				ds_post_menstrual_age_w := ds_birth_gestational_w + qt_weeks_w || 'w ';
				
				if (qt_days_w > 0) then
					ds_post_menstrual_age_w := ds_post_menstrual_age_w || qt_days_w || 'd';		
				end if;
			end if;
		end if;		
	end if;

	r_demographic_field_w.ds_field_name := 'DS_POST_MA';
	r_demographic_field_w.ds_field_value := ds_post_menstrual_age_w;
	r_demographic_field_w.cd_exp_label := '';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'S';
	r_demographic_field_w.ds_add_info := '';
	r_demographic_field_w.ds_info_color := '';
	r_demographic_field_w.ds_label := '';
	RETURN NEXT r_demographic_field_w;

	ds_problem_list_w := nicu_patient_demographics_pck.get_problem_list(nr_atendimento_p);

	r_demographic_field_w.ds_field_name := 'DS_PROBLEM_LIST';
	r_demographic_field_w.ds_field_value := ds_problem_list_w;
	r_demographic_field_w.cd_exp_label := '';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'S';
	r_demographic_field_w.ds_add_info := '';
	r_demographic_field_w.ds_info_color := '';
	r_demographic_field_w.ds_label := '';
	RETURN NEXT r_demographic_field_w;

    i := 1;

	while i < 5 loop

		cd_exp_valor_dominio_w := 0;
		ds_professional_w := '';

		SELECT * FROM nicu_patient_demographics_pck.get_staff_info(nr_atendimento_p, i, cd_exp_valor_dominio_w, ds_professional_w) INTO STRICT cd_exp_valor_dominio_w, ds_professional_w;

		r_demographic_field_w.ds_field_name := 'DS_PROFESSIONAL_' || i;
		r_demographic_field_w.ds_field_value := ds_professional_w;
		r_demographic_field_w.cd_exp_label := cd_exp_valor_dominio_w;
		r_demographic_field_w.ie_obscured := 'N';
		r_demographic_field_w.ie_editable := 'S';
		r_demographic_field_w.ie_visible := 'S';
		r_demographic_field_w.ds_add_info := '';
		r_demographic_field_w.ds_info_color := '';
		r_demographic_field_w.ds_label := obter_desc_expressao(cd_exp_valor_dominio_w, wheb_usuario_pck.get_nr_seq_idioma);
		RETURN NEXT r_demographic_field_w;

		i := i + 1;

	end loop;

	ds_professional_w := nicu_patient_demographics_pck.get_employee_name(nr_atendimento_p, 'ATTENDING');

	r_demographic_field_w.ds_field_name := 'DS_ATTENDING';
	r_demographic_field_w.ds_field_value := ds_professional_w;
	r_demographic_field_w.cd_exp_label := '';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'N';
	r_demographic_field_w.ds_add_info := '';
	r_demographic_field_w.ds_info_color := '';
	r_demographic_field_w.ds_label := '';
	RETURN NEXT r_demographic_field_w;

	ds_professional_w := nicu_patient_demographics_pck.get_employee_name(nr_atendimento_p, 'NURSE');

	r_demographic_field_w.ds_field_name := 'DS_REG_NURSE';
	r_demographic_field_w.ds_field_value := ds_professional_w;
	r_demographic_field_w.cd_exp_label := '';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'N';
	r_demographic_field_w.ds_add_info := '';
	r_demographic_field_w.ds_info_color := '';
	r_demographic_field_w.ds_label := '';
	RETURN NEXT r_demographic_field_w;

	ds_professional_w := nicu_patient_demographics_pck.get_employee_name(nr_atendimento_p, 'FELLOW');

	r_demographic_field_w.ds_field_name := 'DS_FELLOW';
	r_demographic_field_w.ds_field_value := ds_professional_w;
	r_demographic_field_w.cd_exp_label := '';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'N';
	r_demographic_field_w.ds_add_info := '';
	r_demographic_field_w.ds_info_color := '';
	r_demographic_field_w.ds_label := '';
	RETURN NEXT r_demographic_field_w;

	ds_professional_w := nicu_patient_demographics_pck.get_employee_name(nr_atendimento_p, 'RT');

	r_demographic_field_w.ds_field_name := 'DS_RESP_THERAPIST';
	r_demographic_field_w.ds_field_value := ds_professional_w;
	r_demographic_field_w.cd_exp_label := '';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'N';
	r_demographic_field_w.ds_add_info := '';
	r_demographic_field_w.ds_info_color := '';
	r_demographic_field_w.ds_label := '';
	RETURN NEXT r_demographic_field_w;

	ds_problem_list_w := nicu_patient_demographics_pck.get_problem_list(nr_atendimento_p);

	r_demographic_field_w.ds_field_name := 'DS_PROBLEM_LIST';
	r_demographic_field_w.ds_field_value := ds_problem_list_w;
	r_demographic_field_w.cd_exp_label := '';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'S';
	r_demographic_field_w.ds_add_info := '';
	r_demographic_field_w.ds_info_color := '';
	r_demographic_field_w.ds_label := '';
	RETURN NEXT r_demographic_field_w;																
	for r_parent in (SELECT * from table(nicu_patient_demographics_pck.get_parents(nr_seq_patient_w))) loop
	begin

		r_demographic_field_w.ds_field_name := 'DS_PARENT_NAME' || r_parent.nr_seq_order;
		r_demographic_field_w.ds_field_value := r_parent.ds_full_name;
		r_demographic_field_w.cd_exp_label := '';
		r_demographic_field_w.ie_obscured := 'N';
		r_demographic_field_w.ie_editable := 'N';
		r_demographic_field_w.ie_visible := 'S';
		r_demographic_field_w.ds_add_info := '';
		r_demographic_field_w.ds_info_color := '';
		r_demographic_field_w.ds_label := '';
		RETURN NEXT r_demographic_field_w;

		r_demographic_field_w.ds_field_name := 'DS_TELECOM_PARENT' || r_parent.nr_seq_order;
		r_demographic_field_w.ds_field_value := r_parent.nr_phone_number;
		r_demographic_field_w.cd_exp_label := '';
		r_demographic_field_w.ie_obscured := 'N';
		r_demographic_field_w.ie_editable := 'N';
		r_demographic_field_w.ie_visible := 'N';
		r_demographic_field_w.ds_add_info := '';
		r_demographic_field_w.ds_info_color := '';
		r_demographic_field_w.ds_label := '';
		RETURN NEXT r_demographic_field_w;

	end;
	end loop;

	ds_todays_goal_w := nicu_patient_demographics_pck.get_daily_goal(nr_atendimento_p);

	r_demographic_field_w.ds_field_name := 'DS_TODAY_GOAL';
	r_demographic_field_w.ds_field_value := ds_todays_goal_w;
	r_demographic_field_w.cd_exp_label := '';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'S';
	r_demographic_field_w.ie_visible := 'S';
	r_demographic_field_w.ds_add_info := '';
	r_demographic_field_w.ds_info_color := '';
	r_demographic_field_w.ds_label := '';
	RETURN NEXT r_demographic_field_w;

	qt_todays_weight_w := nicu_patient_demographics_pck.get_obs_info_by_date(nr_seq_patient_w, clock_timestamp(), 'DEMOG_Daily_Weight');

	if (coalesce(qt_todays_weight_w, 0) > 0) then
		ds_todays_weight_w := qt_todays_weight_w || ' g';
	end if;

	qt_yesterdays_weight_w := nicu_patient_demographics_pck.get_obs_info_by_date(nr_seq_patient_w, clock_timestamp() - interval '1 days', 'DEMOG_Daily_Weight');

	if (coalesce(qt_yesterdays_weight_w, 0) > 0) then

		qt_weight_delta_w := qt_todays_weight_w - qt_yesterdays_weight_w;

		if (qt_weight_delta_w > 0) then

			ds_add_info_w := '+ ' || qt_weight_delta_w || ' g';
			ds_add_color_w := 'green';

		elsif (qt_weight_delta_w < 0) then

			ds_add_info_w := '- ' || qt_weight_delta_w || ' g';
			ds_add_color_w	:= 'red';

		end if;
	end if;

	r_demographic_field_w.ds_field_name := 'DS_TODAY_WEIGHT';
	r_demographic_field_w.ds_field_value := ds_todays_weight_w;
	r_demographic_field_w.cd_exp_label := '';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'S';
	r_demographic_field_w.ds_add_info := ds_add_info_w;
	r_demographic_field_w.ds_info_color := ds_add_color_w;
	r_demographic_field_w.ds_label := '';
	RETURN NEXT r_demographic_field_w;

	ds_add_info_w := '';
	ds_add_color_w := '';

	r_demographic_field_w.ds_field_name := 'DS_WEIGHT_CHANGE';
	r_demographic_field_w.ds_field_value := ds_weight_change_w;
	r_demographic_field_w.cd_exp_label := '';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'N';
	r_demographic_field_w.ds_add_info := '';
	r_demographic_field_w.ds_info_color := '';
	r_demographic_field_w.ds_label := '';
	RETURN NEXT r_demographic_field_w;

	r_demographic_field_w.ds_field_name := 'DS_CLINICIANS';
	r_demographic_field_w.ds_field_value := ds_clinicians_w;
	r_demographic_field_w.cd_exp_label := '';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'N';
	r_demographic_field_w.ds_add_info := '';
	r_demographic_field_w.ds_info_color := '';
	r_demographic_field_w.ds_label := '';
	RETURN NEXT r_demographic_field_w;

	r_demographic_field_w.ds_field_name := 'DS_LAST_SKIN';
	r_demographic_field_w.ds_field_value := '';
	r_demographic_field_w.cd_exp_label := '';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'N';
	r_demographic_field_w.ds_add_info := '';
	r_demographic_field_w.ds_info_color := '';
	r_demographic_field_w.ds_label := '';
	RETURN NEXT r_demographic_field_w;

	r_demographic_field_w.ds_field_name := 'DS_CGA';
	r_demographic_field_w.ds_field_value := '';
	r_demographic_field_w.cd_exp_label := '';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'N';
	r_demographic_field_w.ds_add_info := '';
	r_demographic_field_w.ds_info_color := '';
	r_demographic_field_w.ds_label := '';
	RETURN NEXT r_demographic_field_w;

	r_demographic_field_w.ds_field_name := 'DS_DOSING_WEIGHT';
	r_demographic_field_w.ds_field_value := '';
	r_demographic_field_w.cd_exp_label := '';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'N';
	r_demographic_field_w.ds_add_info := '';
	r_demographic_field_w.ds_info_color := '';
	r_demographic_field_w.ds_label := '';
	RETURN NEXT r_demographic_field_w;

	r_demographic_field_w.ds_field_name := 'DS_DAY_OF_LIFE';
	r_demographic_field_w.ds_field_value := '';
	r_demographic_field_w.cd_exp_label := '';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'N';
	r_demographic_field_w.ds_add_info := '';
	r_demographic_field_w.ds_info_color := '';
	r_demographic_field_w.ds_label := '';
	RETURN NEXT r_demographic_field_w;

	return;

END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nicu_patient_demographics_pck.get_problem_list (nr_seq_encounter_p bigint) FROM PUBLIC;