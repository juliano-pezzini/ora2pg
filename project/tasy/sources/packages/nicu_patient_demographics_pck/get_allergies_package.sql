-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION nicu_patient_demographics_pck.get_allergies (nr_seq_patient_p bigint) RETURNS varchar AS $body$
DECLARE


cAlergies CURSOR FOR
	SELECT	ds_allergy
	from	nicu_patient_allergy
	where	nr_seq_patient = nr_seq_patient_p;
  r_parent RECORD;

BEGIN

	ds_allergies_w := '';
	ds_complemento_w := '';

	for rAllergy in cAlergies loop
	begin

		if (ds_complemento_w IS NOT NULL AND ds_complemento_w::text <> '') then
			ds_allergies_w := ds_allergies_w || ds_complemento_w;
		end if;

		ds_allergies_w := ds_allergies_w || rAllergy.ds_allergy;

		if (coalesce(ds_complemento_w::text, '') = '') then
			ds_complemento_w := ', ';
		end if;

	end;
	end loop;

	return ds_allergies_w;

end;

begin
	select  max(per.ds_given_name),
            max(per.ds_family_name),
            max(per.ds_component_name_1),
            max(pat.ie_gender),
            max(CASE WHEN upper(pat.ie_gender)='F' THEN  wheb_mensagem_pck.get_texto(1177521) WHEN upper(pat.ie_gender)='M' THEN  wheb_mensagem_pck.get_texto(1177522) WHEN upper(pat.ie_gender)='U' THEN  wheb_mensagem_pck.get_texto(1195403) WHEN upper(pat.ie_gender)='O' THEN  wheb_mensagem_pck.get_texto(1195404)  ELSE '' END ),
            max(pat.id_patient),
            max(pat.dt_birthdate),
            max(enc.dt_admission),
            max(ua.cd_unidade_basica),
            max(ua.cd_unidade_compl),
            max(pat.nr_sequencia),
            max(enc.id_visit_number)
	into STRICT
            ds_given_name_w,
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
            id_visit_number_w
	from    nicu_encounter enc,
			nicu_patient pat,
			person_name per,
			unidade_atendimento ua
	where   enc.nr_sequencia = nr_atendimento_p
	and		enc.nr_seq_patient = pat.nr_sequencia
	and     per.nr_sequencia = pat.nr_seq_person_name
	and     enc.id_location = ua.nm_leito_integracao;

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
	RETURN NEXT r_demographic_field_w;

	r_demographic_field_w.ds_field_name := 'CD_ENCOUNTER';
	r_demographic_field_w.ds_field_value := nr_atendimento_p;
	r_demographic_field_w.cd_exp_label := '1176111';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'S';
	r_demographic_field_w.nr_order := 10;
	RETURN NEXT r_demographic_field_w;
	
	r_demographic_field_w.ds_field_name := 'ID_VISIT_NUMBER';
	r_demographic_field_w.ds_field_value := id_visit_number_w;
	r_demographic_field_w.cd_exp_label := '1187151';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'S';
	r_demographic_field_w.nr_order := 10;
	RETURN NEXT r_demographic_field_w;

	r_demographic_field_w.ds_field_name := 'CD_MEDICAL_RECORD';
	r_demographic_field_w.ds_field_value := id_patient_w;
	r_demographic_field_w.cd_exp_label := '1176112';
	r_demographic_field_w.ie_obscured := 'S';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'S';
	r_demographic_field_w.nr_order := 20;
	RETURN NEXT r_demographic_field_w;

	r_demographic_field_w.ds_field_name := 'DS_SEXO';
	r_demographic_field_w.ds_field_value := ds_gender_w;
	r_demographic_field_w.cd_exp_label := '1176113';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'S';
	r_demographic_field_w.nr_order := 30;
	RETURN NEXT r_demographic_field_w;

	r_demographic_field_w.ds_field_name := 'DS_DOB';
	r_demographic_field_w.ds_field_value := ds_dob_w;
	r_demographic_field_w.cd_exp_label := '1176114';
	r_demographic_field_w.ie_obscured := 'S';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'S';
	r_demographic_field_w.nr_order := 40;
	RETURN NEXT r_demographic_field_w;

	r_demographic_field_w.ds_field_name := 'DS_ENTRY';
	r_demographic_field_w.ds_field_value := ds_entry_w;
	r_demographic_field_w.cd_exp_label := '1176115';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'S';
	r_demographic_field_w.nr_order := 50;
	RETURN NEXT r_demographic_field_w;

	r_demographic_field_w.ds_field_name := 'DS_BED';
	r_demographic_field_w.ds_field_value := ds_bed_w;
	r_demographic_field_w.cd_exp_label := '1176116';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	r_demographic_field_w.ie_visible := 'S';
	r_demographic_field_w.nr_order := 60;
	RETURN NEXT r_demographic_field_w;

	ds_allergies_w := nicu_patient_demographics_pck.get_allergies(nr_seq_patient_w);

	r_demographic_field_w.ds_field_name := 'DS_ALLERGIES';
	r_demographic_field_w.ds_field_value := ds_allergies_w;
	r_demographic_field_w.cd_exp_label := '';
	r_demographic_field_w.ie_obscured := 'N';
	r_demographic_field_w.ie_editable := 'N';
	RETURN NEXT r_demographic_field_w;

    if ('S' = ie_parent_p) then
	
        qt_todays_weight_w := nicu_patient_demographics_pck.get_obs_info_by_date(nr_seq_patient_w, clock_timestamp(), 'DEMOG_Daily_Weight');

        if (coalesce(qt_todays_weight_w, 0) > 0) then
            ds_todays_weight_w := qt_todays_weight_w || ' g';
        end if;

        r_demographic_field_w.ds_field_name := 'DS_TODAY_WEIGHT';
        r_demographic_field_w.ds_field_value := ds_todays_weight_w;
        r_demographic_field_w.cd_exp_label := '1187323';
        r_demographic_field_w.ie_obscured := 'N';
        r_demographic_field_w.ie_editable := 'N';
        r_demographic_field_w.ie_visible := 'S';
        r_demographic_field_w.nr_order := 70;
        r_demographic_field_w.ds_label := '';
        RETURN NEXT r_demographic_field_w;

        ds_birth_weight_w := nicu_patient_demographics_pck.get_birth_weight(nr_atendimento_p);
		
        if (ds_birth_weight_w <> ' ') then
            ds_birth_weight_w := ds_birth_weight_w || ' g';
        else
            ds_birth_weight_w := '';
        end if;

        r_demographic_field_w.ds_field_name := 'DS_BIRTH_WEIGHT';
        r_demographic_field_w.ds_field_value := ds_birth_weight_w;
        r_demographic_field_w.cd_exp_label := '1187325';
        r_demographic_field_w.ie_obscured := 'N';
        r_demographic_field_w.ie_editable := 'N';
        r_demographic_field_w.ie_visible := 'S';
        r_demographic_field_w.nr_order := 80;
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
        r_demographic_field_w.cd_exp_label := '1187326';
        r_demographic_field_w.ie_obscured := 'N';
        r_demographic_field_w.ie_editable := 'N';
        r_demographic_field_w.ie_visible := 'S';
        r_demographic_field_w.nr_order := 90;
        r_demographic_field_w.ds_add_info := '';
        r_demographic_field_w.ds_info_color := '';
        r_demographic_field_w.ds_label := '';
        RETURN NEXT r_demographic_field_w;

        ds_todays_goal_w := nicu_patient_demographics_pck.get_daily_goal(nr_atendimento_p);

        r_demographic_field_w.ds_field_name := 'DS_TODAY_GOAL';
        r_demographic_field_w.ds_field_value := ds_todays_goal_w;
        r_demographic_field_w.cd_exp_label := '1187327';
        r_demographic_field_w.ie_obscured := 'N';
        r_demographic_field_w.ie_editable := 'N';
        r_demographic_field_w.ie_visible := 'S';
        r_demographic_field_w.nr_order := 100;
        r_demographic_field_w.ds_add_info := '';
        r_demographic_field_w.ds_info_color := '';
        r_demographic_field_w.ds_label := '';
        RETURN NEXT r_demographic_field_w;

        i := 1;
		
        while i < 5 loop
		
            cd_exp_valor_dominio_w := 0;
            ds_professional_w := '';

            SELECT * FROM nicu_patient_demographics_pck.get_staff_info(nr_atendimento_p, i, cd_exp_valor_dominio_w, ds_professional_w) INTO STRICT cd_exp_valor_dominio_w, ds_professional_w;
			
			select	coalesce(max(nr_sequencia), 1187322)
			into STRICT	cd_dic_objeto_w
			from	dic_objeto
			where	cd_exp_informacao = cd_exp_valor_dominio_w			
			and		ie_tipo_objeto = 'T';

            r_demographic_field_w.ds_field_name := 'DS_PROFESSIONAL_' || i;
            r_demographic_field_w.ds_field_value := ds_professional_w;
            r_demographic_field_w.cd_exp_label := cd_dic_objeto_w;
            r_demographic_field_w.ie_obscured := 'N';
            r_demographic_field_w.ie_editable := 'N';
            r_demographic_field_w.ie_visible := 'S';
            r_demographic_field_w.nr_order := 110;
            r_demographic_field_w.ds_add_info := '';
            r_demographic_field_w.ds_info_color := '';
            r_demographic_field_w.ds_label := obter_desc_expressao(cd_exp_valor_dominio_w, wheb_usuario_pck.get_nr_seq_idioma);
			
            RETURN NEXT r_demographic_field_w;

            i := i + 1;
        end loop;

        for r_parent in (SELECT * from table(nicu_patient_demographics_pck.get_parents(nr_seq_patient_w))) loop
        begin
		
            r_demographic_field_w.ds_field_name := 'DS_PARENT_NAME' || r_parent.nr_seq_order;
            r_demographic_field_w.ds_field_value := r_parent.ds_full_name;
            r_demographic_field_w.cd_exp_label := '1187324';
            r_demographic_field_w.ie_obscured := 'N';
            r_demographic_field_w.ie_editable := 'N';
            r_demographic_field_w.ie_visible := 'S';
            r_demographic_field_w.nr_order := 120;
            r_demographic_field_w.ds_add_info := '';
            r_demographic_field_w.ds_info_color := '';
            r_demographic_field_w.ds_label := '';
            RETURN NEXT r_demographic_field_w;
			
        end;
        end loop;

    end if;

	return;

END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nicu_patient_demographics_pck.get_allergies (nr_seq_patient_p bigint) FROM PUBLIC;