-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE nais_mla_surgery_pck.packagebody (( nr_order_unit_p text, nr_prescricao_p text ) is order_class_w varchar(5) DEFAULT 'S0') RETURNS ACCINFORECTYP AS $body$
DECLARE

		PERFORM
				'01' process_classif,                                                                    -- Mandatory (2)
				order_class_w   order_class,                                                                    -- Mandatory (2)
				coalesce(cu.nr_order_patient_seq, 0) order_number,                                   -- Mandatory (8)
				obter_prontuario_paciente(obter_dados_prescricao(c.nr_prescricao, 'P')) patient_identifier, -- Mandatory (10)
				coalesce(to_char(cp.dt_inicio, 'YYYYMMDD'), ' ') consultation_date,                                 -- Mandatory (8)
				coalesce(nais_mla_surgery_pck.get_affairs_code('OS', 'DEPARTAMENTO_MEDICO', 'CD_DEPARTAMENTO', b.medical_department_id), ' ') department_code,   -- Mandatory (2)
				CASE WHEN get_in_out_patient_clasif(c.cd_pessoa_fisica, coalesce(c.dt_inicio_real, clock_timestamp()))='O' THEN  1  ELSE 2 END  patient_classification
				,--Mandatory (1)
				coalesce(b.bed_id, '0') ward_code,                                                -- Not Used  (3)
				coalesce(b.room_id,' ')       room_number,                                                      -- Not Used  (5)
				'1' blood_tranfusion_type,                                                  -- Mandatory (1)
				coalesce(cp.nr_seq_nais_insurance, '00') insurance_number,                        -- Mandatory (2)
				'0' doctor_code,                                                            -- Mandatory (8)
				'0' patient_newborn,                                                        -- Not Used  (1)
				' ' prescription_classfication,                                             -- Not Used  (1)
				'088' requestor_code,                                                       -- Optional  (3)
				' ' mutual_exclusion_rule,                                                  -- Not Used  (1)
				'0123' division_number,                                                     -- Mandatory (4)
				' ' blank_one,                                                              -- ALL SPACE (1)
				' ' blank_two                                                                -- ALL SPACE (1)
		from
				cpoe_procedimento     cp,
				prescr_procedimento   p,
				cirurgia              c,
				bft_encounter_v       b,
				cpoe_order_unit       cu
		where
				cp.nr_sequencia = p.nr_seq_proc_cpoe
				and p.nr_prescricao = c.nr_prescricao
				and c.nr_atendimento = b.encounter_id
				and b.encounter_id = cp.nr_atendimento
				and cp.nr_seq_cpoe_order_unit = cu.nr_sequencia
				and cu.nr_order_unit =  nr_order_unit_p;
	
	    c02 CURSOR FOR
        SELECT
				'0' execution_classification,                -- Not Used  (1)
				to_char(cp.dt_inicio, 'YYYYMMDD') execution_date, -- Mandatory (8 - Get Only Date)
				to_char(cp.dt_inicio, 'HH24MI') execution_time,   -- Optional  (4 - Get time in HHMM)
				'000' execution_op_code,                          -- Not Used  (3)
				'0' execution_up_flag,                            -- Not Used  (1)
				'000000' execution_weight,                        -- Not Used  (6)
				'0' out_of_hours_flag,                            -- Optional  (1)
				' ' execution_blank  
				-- ALL SPACE (8)
        from    cpoe_procedimento     cp,
			    prescr_procedimento   p,
				cirurgia              c,
				bft_encounter_v       b,
			    cpoe_order_unit       cu
        where
				cp.nr_sequencia = p.nr_seq_proc_cpoe
				and p.nr_prescricao = c.nr_prescricao
				and c.nr_atendimento = b.encounter_id
				and b.encounter_id = cp.nr_atendimento
				and cp.nr_seq_cpoe_order_unit = cu.nr_sequencia
				and cu.nr_order_unit =  nr_order_unit_p;
    -- end of execution information
        c03 CURSOR FOR
        SELECT
				count(*) over () count_medi_details,
				'000' slip_code,
				'01' nr_data_class,
				c.nr_seq_proc_interno internal_code,
				'0' dosage,
				' ' unit,
				1 times_num,
				0 free_input_flag,
				' ' free_comments,
				' ' med_change_impossible_flg,
				' ' general_name_med_flg,
				0 days,
				0 times_num_04,
				0 days_num,
				1 digit_times_num,
				1 digit_days_num,
				' ' medi_blank,
				' ' eot
        from
				cpoe_procedimento     cp,
				prescr_procedimento   p,
				cirurgia              c,
				bft_encounter_v       b,
				cpoe_order_unit       cu
        where
				cp.nr_sequencia = p.nr_seq_proc_cpoe
				and p.nr_prescricao = c.nr_prescricao
				and c.nr_atendimento = b.encounter_id
				and b.encounter_id = cp.nr_atendimento
				and cp.nr_seq_cpoe_order_unit = cu.nr_sequencia
				and cu.nr_order_unit =  nr_order_unit_p;

        c04 CURSOR FOR
        SELECT
				count(*) over () count_medi_details,
				'000' slip_code,
				'01' nr_data_class,
				'51967' internal_code,
				'0' dosage,
				' ' unit,
				1 times_num,
				0 free_input_flag,
				' ' free_comments,
				' ' med_change_impossible_flg,
				' ' general_name_med_flg,
				0 days,
				0 times_num_04,
				0 days_num,
				1 digit_times_num,
				1 digit_days_num,
				' ' medi_blank,
				' ' eot
;--anasthesia detail is pending
    -- end of medical treatment details
        r_c03                   c03%rowtype;
        r_c04                   c04%rowtype;
        r_c01_w                 accinforectyp;
        r_c02_w                 execinforedtyp;
        r_c03_w                 medtreatmentinforedtyp;
        r_c04_w                 medtreatmentinforedtyp;
        cd_contin_flag_w        varchar(1) := 'C';
        loop_count_w            smallint := 0;
        inside_loop_count_w     smallint := 1;
        counter_w               smallint := 0;

        
    
BEGIN
        PERFORM set_config('nais_mla_surgery_pck.ds_line_w', null, false);
        counter_w := 0;
        inside_loop_count_w := 0;
        PERFORM set_config('nais_mla_surgery_pck.index_counter_w', 0, false);
        loop_count_w := 0;

        open c03;
        loop
            fetch c03 into r_c03_w;
            EXIT WHEN NOT FOUND; /* apply on c03 */
            current_setting('nais_mla_surgery_pck.ds_line_w')::varchar(32767) := nais_mla_surgery_pck.get_action_code_med_detail(order_class_w, r_c03_w, current_setting('nais_mla_surgery_pck.ds_line_w')::varchar(32767));
            CALL CALL CALL CALL nais_mla_surgery_pck.add_med_treatment_detail_array(current_setting('nais_mla_surgery_pck.ds_line_w')::varchar(32767), current_setting('nais_mla_surgery_pck.index_counter_w')::smallint);
            CALL CALL CALL CALL nais_mla_surgery_pck.common_med_treatment_info(r_c03_w);
            CALL CALL CALL CALL nais_mla_surgery_pck.add_med_treatment_detail_array(current_setting('nais_mla_surgery_pck.ds_line_w')::varchar(32767), current_setting('nais_mla_surgery_pck.index_counter_w')::smallint);
            current_setting('nais_mla_surgery_pck.ds_line_w')::varchar(32767) := nais_mla_surgery_pck.add_date_class_med_detail(order_class_w, r_c03_w, current_setting('nais_mla_surgery_pck.ds_line_w')::varchar(32767));
            CALL CALL CALL CALL nais_mla_surgery_pck.add_med_treatment_detail_array(current_setting('nais_mla_surgery_pck.ds_line_w')::varchar(32767), current_setting('nais_mla_surgery_pck.index_counter_w')::smallint);
        end loop;

        close c03;
        open c04;
        loop
            fetch c04 into r_c04_w;
            EXIT WHEN NOT FOUND; /* apply on c04 */
            current_setting('nais_mla_surgery_pck.ds_line_w')::varchar(32767) := nais_mla_surgery_pck.get_action_code_med_detail(order_w, r_c04_w, current_setting('nais_mla_surgery_pck.ds_line_w')::varchar(32767));
            CALL CALL CALL CALL nais_mla_surgery_pck.add_med_treatment_detail_array(current_setting('nais_mla_surgery_pck.ds_line_w')::varchar(32767), current_setting('nais_mla_surgery_pck.index_counter_w')::smallint);
            CALL CALL CALL CALL nais_mla_surgery_pck.common_med_treatment_info(r_c04_w);
            CALL CALL CALL CALL nais_mla_surgery_pck.add_med_treatment_detail_array(current_setting('nais_mla_surgery_pck.ds_line_w')::varchar(32767), current_setting('nais_mla_surgery_pck.index_counter_w')::smallint);
            current_setting('nais_mla_surgery_pck.ds_line_w')::varchar(32767) := nais_mla_surgery_pck.add_date_class_med_detail(order_w, r_c04_w, current_setting('nais_mla_surgery_pck.ds_line_w')::varchar(32767));
            CALL CALL CALL CALL nais_mla_surgery_pck.add_med_treatment_detail_array(current_setting('nais_mla_surgery_pck.ds_line_w')::varchar(32767), current_setting('nais_mla_surgery_pck.index_counter_w')::smallint);
        end loop;

        close c04;
        loop_count_w := ceil(current_setting('nais_mla_surgery_pck.index_counter_w')::smallint / 10);

        for i in 1..loop_count_w loop begin
            if ( i = loop_count_w ) then
                cd_contin_flag_w := 'E';
            end if;
            CALL CALL CALL CALL CALL CALL CALL nais_mla_surgery_pck.nais_common_header('KK', nr_prescricao_p, '01', cd_contin_flag_w, 1,
                               810);
            open c01;
            loop
                fetch c01 into r_c01_w;
                EXIT WHEN NOT FOUND; /* apply on c01 */
                CALL CALL CALL CALL CALL nais_mla_surgery_pck.common_accounting_info(r_c01_w);
            end loop;

            close c01;
            open c02;
            loop
                fetch c02 into r_c02_w;
                EXIT WHEN NOT FOUND; /* apply on c02 */
                CALL CALL CALL CALL CALL nais_mla_surgery_pck.common_execution_info(r_c02_w);
            end loop;

            close c02;
            open c03;
            fetch c03 into r_c03;
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_surgery_pck.append_text(r_c03.slip_code, 3, 'L');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_surgery_pck.append_text(coalesce(r_c03.count_medi_details, 0), 2, 'L', '0');
            close c03;
            inside_loop_count_w := counter_w + 1;
            for x in inside_loop_count_w..inside_loop_count_w + 9 loop
                counter_w := counter_w + 1;
                current_setting('nais_mla_surgery_pck.med_treamtent')::med_treamtent_array.extend;
                if ( cd_contin_flag_w = 'E' and current_setting('nais_mla_surgery_pck.med_treamtent')::coalesce(med_treamtent_array(x)::text, '') = '' ) then
                    CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_surgery_pck.append_text(' ', 64);
                else
                    CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_surgery_pck.append_text(current_setting('nais_mla_surgery_pck.med_treamtent')::med_treamtent_array(x), 64, 'L', ' ');
                end if;

            end loop;

            open c03;
            fetch c03 into r_c03;
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_surgery_pck.append_text(r_c03.medi_blank, 4, 'R', ' ');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_surgery_pck.append_text(r_c03.eot, 1, 'L');
            close c03;
        end;
        end loop;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nais_mla_surgery_pck.packagebody (( nr_order_unit_p text, nr_prescricao_p text ) is order_class_w varchar(5) DEFAULT 'S0') FROM PUBLIC;