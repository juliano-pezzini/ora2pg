-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE nais_mla_pck.send_injection_data (( nr_seq_register_p bigint, ie_tipo_file_p text, nr_order_unit_p cpoe_order_unit.nr_order_unit%type ) is nr_prescricao_w prescr_solucao_evento.nr_prescricao%type) RETURNS ACCINFORECTYP AS $body$
DECLARE

        PERFORM  nr_processing_class_w process_classif,
                order_class_w order_class,
                coalesce(a.nr_order_patient_seq, 0)  order_number,
                coalesce(g.medical_record_id, 0) patient_identifier,
                to_char(f.dt_atualizacao, 'YYYYMMDD') consultation_date,
                case when (a.cd_especialidade_med IS NOT NULL AND a.cd_especialidade_med::text <> '') then
                         coalesce(nais_mla_pck.get_affairs_code('OS', 'ESPECIALIDADE_MEDICA', 'CD_ESPECIALIDADE', a.cd_especialidade_med), ' ') 
                     when (a.cd_departamento_med IS NOT NULL AND a.cd_departamento_med::text <> '') then 
                         coalesce(nais_mla_pck.get_affairs_code('OS', 'DEPARTAMENTO_MEDICO', 'CD_DEPARTAMENTO', a.cd_departamento_med), ' ')   
                     else '00'
                end as department_code,
                CASE WHEN nais_mla_pck.get_in_out_patient_classif(c.cd_pessoa_fisica, coalesce(e.dt_atualizacao,clock_timestamp()))='O' THEN 1  ELSE 2 END  patient_classification,
                coalesce(g.bed_id,' ') ward_code,
                coalesce(g.room_id,' ') room_number,
                '1' blood_tranfusion_type,
                coalesce(c.nr_seq_nais_insurance, 0) insurance_number,
                coalesce(c.cd_medico, '0') doctor_code,
                ' ' patient_newborn,
                ' ' prescription_classfication,
                ' ' requestor_code,
                ' ' mutual_exclusion_rule,
                '0' division_number,
                ' ' blank_one,
                ' ' blank_two
        from    cpoe_order_unit a,
                cpoe_material c,
                prescr_material d,
                prescr_solucao_evento e,
                prescr_medica f,
                bft_encounter_v g
        where   a.nr_sequencia = c.nr_seq_cpoe_order_unit    
        and     c.nr_sequencia = d.nr_seq_mat_cpoe
        and     d.nr_seq_mat_cpoe = e.nr_seq_cpoe
        and     d.nr_prescricao = f.nr_prescricao
        and     f.nr_atendimento = g.nr_atendimento
        and     a.nr_order_unit = nr_order_unit_p
        and		g.encounter_id = nr_atendimento_w
        and 	e.nr_sequencia = nr_seq_register_p
        and     ie_tipo_file_p = 'mlaInjection' 
        
union all

        SELECT  nr_processing_class_w process_classif,
                order_class_w order_class,
                coalesce(a.nr_order_patient_seq, 0)  order_number,
                coalesce(g.medical_record_id, 0) patient_identifier,
                to_char(coalesce(c.dt_inicio, clock_timestamp()), 'YYYYMMDD') consultation_date,
                case when (a.cd_especialidade_med IS NOT NULL AND a.cd_especialidade_med::text <> '') then 
                         coalesce(nais_mla_pck.get_affairs_code('OS', 'ESPECIALIDADE_MEDICA', 'CD_ESPECIALIDADE', a.cd_especialidade_med), ' ') 
                     when (a.cd_departamento_med IS NOT NULL AND a.cd_departamento_med::text <> '') then 
                         coalesce(nais_mla_pck.get_affairs_code('OS', 'DEPARTAMENTO_MEDICO', 'CD_DEPARTAMENTO', a.cd_departamento_med), ' ')   
                     else '00'
                end as department_code,
                CASE WHEN nais_mla_pck.get_in_out_patient_classif(f.cd_pessoa_fisica, coalesce(f.dt_liberacao,clock_timestamp()))='O' THEN 1  ELSE 2 END  patient_classification,
                coalesce(g.bed_id,' ') ward_code,
                coalesce(g.room_id,' ') room_number,
                '1' blood_tranfusion_type,
                00 insurance_number,
                coalesce(f.cd_medico, '0') doctor_code,
                ' ' patient_newborn,
                ' ' prescription_classfication,
                ' ' requestor_code,
                ' ' mutual_exclusion_rule,
                '0' division_number,
                ' ' blank_one,
                ' ' blank_two
        from    cpoe_order_unit a,
                cpoe_material c,
                prescr_material d,
                prescr_medica f,
                bft_encounter_v g
        where   a.nr_sequencia = c.nr_seq_cpoe_order_unit    
        and     c.nr_sequencia = d.nr_seq_mat_cpoe
        and     d.nr_prescricao = f.nr_prescricao
        and     f.nr_atendimento = g.nr_atendimento
        and     a.nr_order_unit = nr_order_unit_p
        and		g.encounter_id = nr_atendimento_w
        and 	f.nr_prescricao = nr_seq_register_p
        and     ie_tipo_file_p = 'mlaCpoeInjection'  LIMIT 1;

    --  End of Accounting Information
        c02 CURSOR FOR
        SELECT  ' ' execution_classification,
				to_char(coalesce(b.dt_atualizacao, clock_timestamp()), 'YYYYMMDD') execution_date,
                to_char(coalesce(b.dt_atualizacao, clock_timestamp()), 'HH24MI') execution_time,
                '   ' execution_op_code,
                ' ' execution_up_flag,
                '000000' execution_weight,
                '0' out_of_hours_flag,
                ' ' execution_blank
        from    cpoe_material   a,
                prescr_solucao_evento   b
        where   a.nr_sequencia = b.nr_seq_cpoe
        and     b.nr_sequencia = nr_seq_register_p
        and     ie_tipo_file_p = 'mlaInjection'

union all

        SELECT  ' ' execution_classification,
                to_char(coalesce(c.dt_inicio, clock_timestamp()), 'YYYYMMDD') execution_date,
                to_char(coalesce(c.dt_inicio, clock_timestamp()), 'HH24MI') execution_time,
                '   ' execution_op_code,
                ' ' execution_up_flag,
                '000000' execution_weight,
                '0' out_of_hours_flag,
                ' ' execution_blank
        from    cpoe_order_unit a,
                cpoe_material c,
                prescr_material d,
                prescr_medica f
        where   a.nr_sequencia = c.nr_seq_cpoe_order_unit    
        and     c.nr_sequencia = d.nr_seq_mat_cpoe 
        and     d.nr_prescricao = f.nr_prescricao
        and     a.nr_order_unit = nr_order_unit_p
        and     f.nr_prescricao = nr_seq_register_p
        and     ie_tipo_file_p = 'mlaCpoeInjection'  LIMIT 1;
    -- End of Execution Information
        c05 CURSOR FOR
        SELECT  f.cd_material,
                f.ie_via_aplicacao,
                coalesce(e.qt_dose_nais, 0) dosage,
                coalesce(e.qt_unid_medida_nais, ' ') unit,
                coalesce(h.ie_drip_shot, 'S') drip_shot
        from    cpoe_order_unit a,
                cpoe_material c,
                prescr_solucao_evento d,
                prescr_solucao e,
                prescr_material f,
                prescr_medica g,
                cpoe_rp h
        where   a.nr_sequencia = c.nr_seq_cpoe_order_unit
        and     c.nr_sequencia = d.nr_seq_cpoe
        and     d.nr_prescricao = e.nr_prescricao
        and     d.nr_seq_cpoe = f.nr_seq_mat_cpoe
        and     e.nr_prescricao = g.nr_prescricao
        and     c.nr_seq_cpoe_rp = h.nr_sequencia
        and     d.ie_alteracao  = ie_alteracao_w
        and     e.nr_prescricao = nr_prescricao_w
        and     d.nr_sequencia  = nr_seq_register_p
        and     a.nr_order_unit = nr_order_unit_p
        and     e.nr_seq_solucao = nr_seq_solucao_w
        and     ie_tipo_file_p = 'mlaInjection'

union all

        SELECT  d.cd_material,
                d.ie_via_aplicacao,
                coalesce(obter_conversao_unidade_nais(d.nr_prescricao, d.nr_sequencia, c.qt_dose), 0) dosage,
                coalesce(d.cd_unidade_medida, ' ') unit,
                coalesce(h.ie_drip_shot, 'S') drip_shot
         from   cpoe_order_unit a,
                cpoe_material c,
                prescr_material d,
                prescr_medica f,
                cpoe_rp h
        where   a.nr_sequencia = c.nr_seq_cpoe_order_unit    
        and     c.nr_sequencia = d.nr_seq_mat_cpoe
        and     d.nr_prescricao = f.nr_prescricao
        and     c.nr_seq_cpoe_rp = h.nr_sequencia
        and     f.nr_prescricao = nr_seq_register_p
        and     a.nr_order_unit = nr_order_unit_p
        and     ie_tipo_file_p = 'mlaCpoeInjection';

        c07 CURSOR FOR
        SELECT  distinct(g.nr_sequencia),
                substr(obter_conversao_externa_int(null,'CPOE_STD_COMMENT','CD_EXTERNAL', coalesce(h.cd_external,' '), nm_usuario_w ),1,6)
        from    cpoe_order_unit a,
                cpoe_material c,
                prescr_solucao_evento ps,
                prescr_material d,
                prescr_medica f,
                cpoe_comment_linkage    g,
                cpoe_std_comment    h
        where   a.nr_sequencia = c.nr_seq_cpoe_order_unit
        and     c.nr_sequencia = ps.nr_seq_cpoe 
        and     ps.nr_seq_cpoe = d.nr_seq_mat_cpoe
        and     d.nr_prescricao = f.nr_prescricao
        and     a.nr_sequencia = g.nr_seq_cpoe_order_unit
        and     g.nr_seq_std_comment = h.nr_sequencia
        and     h.si_medical_account = 'Y'
        and     (h.cd_external IS NOT NULL AND h.cd_external::text <> '')
        and     a.nr_order_unit = nr_order_unit_p
        and     ps.nr_sequencia = nr_seq_register_p
        and     ie_tipo_file_p = 'mlaInjection'
        
union all

        SELECT  distinct(g.nr_sequencia),
                substr(obter_conversao_externa_int(null,'CPOE_STD_COMMENT','CD_EXTERNAL', coalesce(h.cd_external,' '), nm_usuario_w ),1,6)
        from    cpoe_order_unit a,
                cpoe_material c,
                prescr_material d,
                prescr_medica f,
                cpoe_comment_linkage    g,
                cpoe_std_comment    h
        where   a.nr_sequencia = c.nr_seq_cpoe_order_unit    
        and     c.nr_sequencia = d.nr_seq_mat_cpoe 
        and     d.nr_prescricao = f.nr_prescricao
        and     a.nr_sequencia = g.nr_seq_cpoe_order_unit
        and     g.nr_seq_std_comment = h.nr_sequencia
        and     h.si_medical_account = 'Y'
        and     (h.cd_external IS NOT NULL AND h.cd_external::text <> '')
        and     a.nr_order_unit = nr_order_unit_p
        and     f.nr_prescricao = nr_seq_register_p
        and     ie_tipo_file_p = 'mlaCpoeInjection';

        c08 CURSOR FOR
        SELECT  add_months(dt_idade_pac_w, (coalesce(qt_idade_min, 0) * 12) + coalesce(qt_idade_min_mes, 0)) + coalesce(qt_idade_min_dia,0),
                qt_min_dosagem,
                ie_min_tipo_dosagem
        from    route_adm_additional_fee
        where   ie_via_aplicacao = ie_via_aplicacao_w;


        r_c01_w                      accinforectyp;
        r_c02_w                      execinforedtyp;
        r_c03_w                      medtreatmentinforedtyp;
        cd_contin_flag_w             varchar(1) := 'C';
        loop_count_w                 smallint := 0;
        inside_loop_count_w          smallint := 1;
        counter_w                    smallint := 0;
        additional_text_w            text;
        comment_loop_counter_w       smallint := 0;
        comment_index_w              smallint := 0;
        initial_length_w             smallint := 0;
        additional_comment_count_w   smallint := 0;
        med_treatment_count_w        smallint := 0;
        ds_additional_text_w         cpoe_comment_linkage.ds_additional_text%type;
        qt_dosagem_w                 prescr_solucao.qt_dosagem%type;
        cd_unidade_medida_w          prescr_solucao.cd_unidade_medida%type;
        injection_data_w			 nais_conversion_master%rowtype;
        medicine_route_w			 nais_conversion_master%rowtype;
        additional_points_data_w     nais_conversion_master%rowtype;
        cd_external_w                cpoe_std_comment.cd_external%type;
        json_output_w                philips_json;
        ie_via_aplicacao_prev_w      prescr_material.ie_via_aplicacao%type;
        dosage_quantity_w            prescr_solucao_evento.qt_dosagem%type;
        ie_tipo_dosagem_w            prescr_solucao_evento.ie_tipo_dosagem%type;
        ie_sterile_preparation_w     prescr_solucao_evento.ie_sterile_preparation%type;
        ie_drip_shot_w               cpoe_rp.ie_drip_shot%type;
        qt_min_dosagem_w    route_adm_additional_fee.qt_min_dosagem%type;
        ie_min_tipo_dosagem_w   route_adm_additional_fee.ie_min_tipo_dosagem%type;

BEGIN

        PERFORM set_config('nais_mla_pck.ds_line_w', null, false);
        counter_w := 0;
        inside_loop_count_w := 0;
        PERFORM set_config('nais_mla_pck.index_counter_w', 0, false);
        loop_count_w := 0;
        json_output_w := philips_json();
        ie_via_aplicacao_prev_w := null;
        PERFORM set_config('nais_mla_pck.med_treamtent', med_treamtent_array(), false);

        begin

            select 	a.order_number,
                    a.encounter_number,
                    a.alteracao,
                    a.mrn,
                    a.solution_no,
                    a.dosage,
                    a.type_of_dosage,
                    a.ie_sterile_preparation,
                    a.date_of_birth
            into STRICT    nr_prescricao_w,
                    nr_atendimento_w,
                    ie_alteracao_w,
                    nr_prontuario_w,
                    nr_seq_solucao_w,
                    dosage_quantity_w,
                    ie_tipo_dosagem_w,
                    ie_sterile_preparation_w,
                    dt_idade_pac_w
            from (
            SELECT  a.nr_prescricao order_number,
                    a.nr_atendimento encounter_number,
                    a.ie_alteracao alteracao,
                    b.nr_prontuario mrn,
                    coalesce(a.nr_seq_solucao, 0) solution_no,
                    coalesce(a.qt_dosagem, 0) dosage,
                    a.ie_tipo_dosagem type_of_dosage,
                    coalesce(a.ie_sterile_preparation, 'N') ie_sterile_preparation,
                    b.dt_nascimento date_of_birth
            from    prescr_solucao_evento   a,
                    pessoa_fisica           b
            where   a.cd_pessoa_fisica = b.cd_pessoa_fisica
            and     a.nr_sequencia = nr_seq_register_p
            and     ie_tipo_file_p like '%mlaInjection%'
            
union all

            SELECT  a.nr_prescricao,
                    a.nr_atendimento,
                    1,
                    b.nr_prontuario,
                    0,
                    0,
                    null,
                    'N',
                    b.dt_nascimento
            from    prescr_medica   a,
                    pessoa_fisica   b
            where   a.cd_pessoa_fisica = b.cd_pessoa_fisica
            and     a.nr_prescricao = nr_seq_register_p
            and     ie_tipo_file_p like '%mlaCpoeInjection%') a;

            select  CASE WHEN ie_alteracao_w=6 THEN  '03' WHEN ie_alteracao_w=1 THEN  '01' END
            into STRICT    nr_processing_class_w
;

        exception
        when others then
            PERFORM set_config('nais_mla_pck.ds_error_w', current_setting('nais_mla_pck.ds_error_w')::varchar(4000)||' An error occured while retriving the Processing classification for '||nr_seq_register_p||' '||sqlerrm, false);
        end;


        r_c03_w.slip_code := '   ';
        r_c03_w.nr_data_class := '01';
        r_c03_w.times_num := 1;
        r_c03_w.free_input_flag := 0;
        r_c03_w.free_comments := ' ';
        r_c03_w.med_change_impossible_flg := ' ';
        r_c03_w.general_name_med_flg := ' ';
        r_c03_w.days := 0;
        r_c03_w.times_num_04 := 0;
        r_c03_w.days_num := 0;
        r_c03_w.digit_times_num := 1;
        r_c03_w.digit_days_num := 1;
        r_c03_w.medi_blank := ' ';
        r_c03_w.eot := ' ';
        r_c03_w.nr_seq_interno := 0;
        begin

            open c05;
            loop
            fetch c05 into
                cd_material_w,
                ie_via_aplicacao_w,
                qt_dosagem_w,
                cd_unidade_medida_w,
                ie_drip_shot_w;
                EXIT WHEN NOT FOUND; /* apply on c05 */
                    r_c03_w.dosage := 0;
                    r_c03_w.unit := ' ';

                    if (ie_via_aplicacao_w IS NOT NULL AND ie_via_aplicacao_w::text <> '') then
                        medicine_route_w := get_medicalaffair_code('I','CPOE_MATERIAL','IE_VIA_APLICACAO',ie_via_aplicacao_w,null,null);

                        if (medicine_route_w.cd_medical_action IS NOT NULL AND medicine_route_w.cd_medical_action::text <> '') then
                            r_c03_w.internal_code := medicine_route_w.cd_medical_action;
                            current_setting('nais_mla_pck.ds_line_w')::varchar(32767) := nais_mla_pck.get_action_code_med_detail(order_class_w, r_c03_w, current_setting('nais_mla_pck.ds_line_w')::varchar(32767));
                            CALL CALL CALL CALL nais_mla_pck.add_med_treatment_detail_array(current_setting('nais_mla_pck.ds_line_w')::varchar(32767), current_setting('nais_mla_pck.index_counter_w')::smallint);
                        end if;

                        if (medicine_route_w.cd_medical_affair IS NOT NULL AND medicine_route_w.cd_medical_affair::text <> '') then
                            r_c03_w.internal_code := medicine_route_w.cd_medical_affair;
                            r_c03_w.dosage := 0;
                            r_c03_w.unit := ' ';
                            CALL nais_mla_pck.prepare_injection_data(r_c03_w);
                        end if;
                    end if;

                    ie_via_aplicacao_prev_w := ie_via_aplicacao_w;
                    injection_data_w :=	get_medicalaffair_code('I','MATERIAL','CD_MATERIAL',cd_material_w,null,null);

                    if (injection_data_w.cd_medical_affair IS NOT NULL AND injection_data_w.cd_medical_affair::text <> '') then
                        r_c03_w.internal_code := injection_data_w.cd_medical_affair;
                        r_c03_w.dosage := (coalesce(qt_dosagem_w, 0))::numeric *1000;
                        r_c03_w.unit := cd_unidade_medida_w;
                        CALL nais_mla_pck.prepare_injection_data(r_c03_w);
                    end if;
                    if (ie_tipo_file_p like '%mlaInjection%' and ie_drip_shot_w = 'D') then
                        begin
                            open c08;
                            loop
                                fetch c08 into	dt_idade_min_w,
                                                qt_min_dosagem_w,
                                                ie_min_tipo_dosagem_w;
                                EXIT WHEN NOT FOUND; /* apply on c08 */
                                begin
                                    if (dt_idade_min_w > clock_timestamp()) then
                                        if (qt_min_dosagem_w >= converte_vel_infusao(ie_tipo_dosagem_w, ie_min_tipo_dosagem_w, dosage_quantity_w)) then
                                            si_precise_cont_intravenous_w := 'S';
                                        end if;
                                    elsif (clock_timestamp() > dt_idade_min_w) then
                                        select  coalesce(max(si_precise_cont_intravenous), 'N')
                                        into STRICT    si_precise_intravenous_w
                                        from    material
                                        where   cd_material = cd_material_w;

                                        if (si_precise_intravenous_w = 'S' and (qt_min_dosagem_w >= converte_vel_infusao(ie_tipo_dosagem_w, ie_min_tipo_dosagem_w, dosage_quantity_w))) then
                                            si_precise_cont_intravenous_w := 'S';
                                        end if;
                                    end if;
                                end;
                            end loop;
                            close c08;
                        exception
                        when others then
                            PERFORM set_config('nais_mla_pck.ds_error_w', current_setting('nais_mla_pck.ds_error_w')::varchar(4000)||' An error occured while forming the Medical treatment information for Drip shot '||sqlerrm, false);
                        end;
                    elsif (ie_tipo_file_p like '%mlaCpoeInjection%') then -- check this condition after the injection is only drip injection
                        select  coalesce(max(si_precise_cont_intravenous), 'N')
                        into STRICT    si_precise_cont_intravenous_w
                        from    material
                        where   cd_material = cd_material_w;
                    end if;
                    if (si_precise_cont_intravenous_w = 'S') then
                        additional_points_data_w :=	get_medicalaffair_code('I','MATERIAL','SI_PRECISE_CONT_INTRAVENOUS',si_precise_cont_intravenous_w,null,null);
                        if (additional_points_data_w.cd_additional_item IS NOT NULL AND additional_points_data_w.cd_additional_item::text <> '') then
                            r_c03_w.internal_code := additional_points_data_w.cd_additional_item;
                            r_c03_w.dosage := 0;
                            r_c03_w.unit := ' ';
                            CALL nais_mla_pck.prepare_injection_data(r_c03_w);
                        end if;
                    end if;

                    if (ie_sterile_preparation_w <> 'N') then
                        additional_points_data_w :=	get_medicalaffair_code('I','PRESCR_SOLUCAO_EVENTO','IE_STERILE_PREPARATION',ie_sterile_preparation_w,null,null);
                        if (additional_points_data_w.cd_additional_item IS NOT NULL AND additional_points_data_w.cd_additional_item::text <> '') then
                            r_c03_w.internal_code := additional_points_data_w.cd_additional_item;
                            r_c03_w.dosage := 0;
                            r_c03_w.unit := ' ';
                            CALL nais_mla_pck.prepare_injection_data(r_c03_w);
                        end if;
                    end if;
            end loop;
            close c05;
        exception
        when others then
            PERFORM set_config('nais_mla_pck.ds_error_w', current_setting('nais_mla_pck.ds_error_w')::varchar(4000)||' An error occured while forming the Medical treatment information for route of administration '||sqlerrm, false);
        end;
        begin
            open c07;
            loop
            fetch c07 into
                nr_linkage_sequencia_w,
                cd_external_w;
                EXIT WHEN NOT FOUND; /* apply on c07 */
                    CALL CALL nais_mla_pck.process_receipt_comments(r_c03_w, cd_external_w, nr_linkage_sequencia_w);
            end loop;
            close c07;
        exception
        when others then
            PERFORM set_config('nais_mla_pck.ds_error_w', current_setting('nais_mla_pck.ds_error_w')::varchar(4000)||' An error occured while forming the Medical treatment information for comments and additional text '||sqlerrm, false);
        end;
        current_setting('nais_mla_pck.ds_line_w')::varchar(32767) := nais_mla_pck.add_date_class_med_detail(order_class_w, r_c03_w, current_setting('nais_mla_pck.ds_line_w')::varchar(32767));
        CALL CALL CALL CALL nais_mla_pck.add_med_treatment_detail_array(current_setting('nais_mla_pck.ds_line_w')::varchar(32767), current_setting('nais_mla_pck.index_counter_w')::smallint);

        loop_count_w := ceil(current_setting('nais_mla_pck.index_counter_w')::smallint / 10);
        for i in 1..loop_count_w loop begin
            if ( i = loop_count_w ) then
                cd_contin_flag_w := 'E';
            end if;
            CALL CALL CALL CALL CALL CALL CALL nais_mla_pck.nais_common_header('KK', 0, nr_processing_class_w, cd_contin_flag_w, 1,
                               810, 944);--658
            begin
                open c01;
                loop
                    fetch c01 into r_c01_w;
                    EXIT WHEN NOT FOUND; /* apply on c01 */

                    CALL CALL CALL CALL CALL nais_mla_pck.common_accounting_info(r_c01_w);

                end loop;
                close c01;
            exception
            when others then
                PERFORM set_config('nais_mla_pck.ds_error_w', current_setting('nais_mla_pck.ds_error_w')::varchar(4000)||' An error occured while forming the Accounting information for '||nr_seq_register_p||' '||sqlerrm, false);
            end;

            begin
                open c02;
                loop
                    fetch c02 into r_c02_w;
                    EXIT WHEN NOT FOUND; /* apply on c02 */

                    CALL CALL CALL CALL CALL nais_mla_pck.common_execution_info(r_c02_w);

                end loop;
                close c02;
            exception
            when others then
                PERFORM set_config('nais_mla_pck.ds_error_w', current_setting('nais_mla_pck.ds_error_w')::varchar(4000)||' An error occured while forming the Execution information for '||nr_seq_register_p||' '||sqlerrm, false);
            end;

            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pck.append_text('000', 3, 'R');
            med_treatment_count_w := mod(current_setting('nais_mla_pck.index_counter_w')::smallint,10);
            if (cd_contin_flag_w = 'C' or (cd_contin_flag_w = 'E' and med_treatment_count_w = 0)) then
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pck.append_text(10, 2, 'L', '0');
            else
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pck.append_text(med_treatment_count_w, 2, 'L', '0');
            end if;

            inside_loop_count_w := counter_w + 1;
            for x in inside_loop_count_w..inside_loop_count_w + 9 loop

                counter_w := counter_w + 1;
                current_setting('nais_mla_pck.med_treamtent')::med_treamtent_array.extend;
                if ( cd_contin_flag_w = 'E' and current_setting('nais_mla_pck.med_treamtent')::coalesce(med_treamtent_array(x)::text, '') = '' ) then
                    CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pck.append_text(' ', 64);
                else
                    PERFORM set_config('nais_mla_pck.ds_line_w', current_setting('nais_mla_pck.ds_line_w')::varchar(32767) || current_setting('nais_mla_pck.med_treamtent')::med_treamtent_array(x), false);
                end if;

            end loop;

            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pck.append_text(' ', 4, 'R');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pck.append_text(chr(13), 1, 'R');


            json_output_w := nais_mla_pck.add_json_value(json_output_w, 'message', current_setting('nais_mla_pck.ds_line_w')::varchar(32767));
            current_setting('nais_mla_pck.json_output_list_w')::philips_json_list.append(json_output_w.to_json_value());
            PERFORM set_config('nais_mla_pck.ds_line_w', null, false);
        end;
        end loop;

    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nais_mla_pck.send_injection_data (( nr_seq_register_p bigint, ie_tipo_file_p text, nr_order_unit_p cpoe_order_unit.nr_order_unit%type ) is nr_prescricao_w prescr_solucao_evento.nr_prescricao%type) FROM PUBLIC;
