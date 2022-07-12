-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE nais_mla_pck.send_outpatient_presc_data (( nr_seq_register_p bigint, ie_tipo_file_p text, nr_order_unit_p cpoe_order_unit.nr_order_unit%type ) is nr_prescricao_w prescr_medica.nr_prescricao%type) RETURNS ACCINFORECTYP AS $body$
DECLARE

        PERFORM	nr_processing_class_w   process_classif,
				order_class_w           order_class,
				coalesce(a.nr_order_patient_seq, 0)  order_number,
				coalesce(nr_prontuario_w, 0)         patient_identifier,
				to_char(coalesce(c.dt_inicio, clock_timestamp()), 'YYYYMMDD') consultation_date,
                 case when (a.cd_especialidade_med IS NOT NULL AND a.cd_especialidade_med::text <> '') then
                         coalesce(nais_mla_pck.get_affairs_code('OS', 'ESPECIALIDADE_MEDICA', 'CD_ESPECIALIDADE', a.cd_especialidade_med), ' ') 
                    when (a.cd_departamento_med IS NOT NULL AND a.cd_departamento_med::text <> '') then 
                        coalesce(nais_mla_pck.get_affairs_code('OS', 'DEPARTAMENTO_MEDICO', 'CD_DEPARTAMENTO', a.cd_departamento_med), ' ')   
                    else '00'
                 end as department_code,
                CASE WHEN nais_mla_pck.get_in_out_patient_classif(f.cd_pessoa_fisica, coalesce(f.dt_liberacao,clock_timestamp()))='O' THEN 1  ELSE 2 END  patient_classification,
                coalesce(g.bed_id, ' ') ward_code,
                coalesce(g.room_id, ' ') room_number,
				'1' blood_tranfusion_type,
				coalesce(nais_insurance_w, 0) insurance_number,
				coalesce(f.cd_medico, '0') doctor_code,
				' ' patient_newborn,
				' ' prescription_classfication,
				' ' requestor_code,
				' ' mutual_exclusion_rule,
                coalesce(substr((SELECT max(x.nr_receita) 
                      from  fa_receita_farmacia x,
                            cpoe_material y, 
                            prescr_material z
                      where x.nr_sequencia = y.NR_SEQ_RECEITA_AMB
                      and   y.nr_sequencia = z.nr_seq_mat_cpoe
                      and   z.nr_prescricao = f.nr_prescricao), -4), '0') division_number,
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
        and (case
                    when( f.nr_prescricao = nr_seq_register_p and d.nr_seq_interno = nr_seq_interno_w and ie_tipo_file_p = 'OutpatientOrderNew') then (1)
                    when( d.nr_seq_interno = nr_seq_register_p and ie_tipo_file_p = 'OutpatientOrderCancel') then (1)
                    else 0
                end) = 1
        
union all

        select	nr_processing_class_w   process_classif,
				order_class_w           order_class,
				coalesce(a.nr_order_patient_seq, 0)  order_number,
				coalesce(nr_prontuario_w, 0)         patient_identifier,
				to_char(coalesce(c.dt_inicio, clock_timestamp()), 'YYYYMMDD') consultation_date,
                 case when (a.cd_especialidade_med IS NOT NULL AND a.cd_especialidade_med::text <> '') then 
                         coalesce(nais_mla_pck.get_affairs_code('OS', 'ESPECIALIDADE_MEDICA', 'CD_ESPECIALIDADE', a.cd_especialidade_med), ' ') 
                    when (a.cd_departamento_med IS NOT NULL AND a.cd_departamento_med::text <> '') then 
                        coalesce(nais_mla_pck.get_affairs_code('OS', 'DEPARTAMENTO_MEDICO', 'CD_DEPARTAMENTO', a.cd_departamento_med), ' ')   
                    else '00'
                 end as department_code,
                CASE WHEN nais_mla_pck.get_in_out_patient_classif(f.cd_pessoa_fisica, coalesce(f.dt_liberacao,clock_timestamp()))='O' THEN 1  ELSE 2 END  patient_classification,
                coalesce(g.bed_id, ' ') ward_code,
                coalesce(g.room_id, ' ') room_number,
				'1' blood_tranfusion_type,
				coalesce(nais_insurance_w, 0) insurance_number,
				coalesce(f.cd_medico, '0') doctor_code,
				' ' patient_newborn,
				' ' prescription_classfication,
				' ' requestor_code,
				' ' mutual_exclusion_rule,
                coalesce(substr((select max(x.nr_receita) 
                      from  fa_receita_farmacia x,
                            cpoe_material y, 
                            prescr_material z
                      where x.nr_sequencia = y.NR_SEQ_RECEITA_AMB
                      and   y.nr_sequencia = z.nr_seq_mat_cpoe
                      and   z.nr_prescricao = f.nr_prescricao), -4), '0') division_number,
				' ' blank_one,
				' ' blank_two
       from     cpoe_order_unit a,
                cpoe_material c,
                prescr_material d,
                prescr_medica f,
                bft_encounter_v g,
                ap_lote_review h
        where   a.nr_sequencia = c.nr_seq_cpoe_order_unit    
        and     c.nr_sequencia = d.nr_seq_mat_cpoe 
        and     d.nr_prescricao = f.nr_prescricao
        and     f.nr_atendimento = g.nr_atendimento
        and     f.nr_prescricao = h.nr_prescricao
        and     c.nr_seq_cpoe_order_unit = h.nr_seq_cpoe_order_unit 
        and     a.nr_order_unit = nr_order_unit_p
        and		g.encounter_id = nr_atendimento_w
        and     h.nr_seq_lote = nr_seq_register_p 
        and     ie_tipo_file_p = 'OutpatientOrderBatch';
    --  End of Accounting Information
        c02 CURSOR FOR
        SELECT  ' ' execution_classification,
                to_char(coalesce(c.dt_inicio, clock_timestamp()), 'YYYYMMDD') execution_date,
                to_char(coalesce(c.dt_inicio, clock_timestamp()), 'HH24MI') execution_time,
                '   ' execution_op_code,
                ' ' execution_up_flag,
                '000000' execution_weight,
                ' ' out_of_hours_flag,
                ' ' execution_blank
        from    cpoe_order_unit a,
                cpoe_material c,
                prescr_material d,
                prescr_medica f
        where   a.nr_sequencia = c.nr_seq_cpoe_order_unit
        and     c.nr_sequencia = d.nr_seq_mat_cpoe 
        and     d.nr_prescricao = f.nr_prescricao
        and     a.nr_order_unit = nr_order_unit_p
        and (case
                    when(d.nr_prescricao = nr_seq_register_p and d.nr_seq_interno = nr_seq_interno_w and ie_tipo_file_p = 'OutpatientOrderNew') then (1)
                    when(d.nr_seq_interno = nr_seq_register_p and ie_tipo_file_p = 'OutpatientOrderCancel') then (1)
                    else 0
                end) = 1
         
union  all

         PERFORM  '0' execution_classification,
                to_char(CASE WHEN ie_review_exists_w=1 THEN  execution_date_w  ELSE c.dt_inicio END , 'YYYYMMDD') execution_date,
                to_char(CASE WHEN ie_review_exists_w=1 THEN  execution_date_w  ELSE c.dt_inicio END , 'HH24MI') execution_time,
                '000' execution_op_code,
                '0' execution_up_flag,
                '000000' execution_weight,
                ' ' out_of_hours_flag,
                ' ' execution_blank
         from   cpoe_order_unit a,
                cpoe_material c,
                prescr_material d,
                prescr_medica f,
                ap_lote_review g
        where   a.nr_sequencia = c.nr_seq_cpoe_order_unit    
        and     c.nr_sequencia = d.nr_seq_mat_cpoe 
        and     d.nr_prescricao = f.nr_prescricao
        and     f.nr_prescricao = g.nr_prescricao
        and     c.nr_seq_cpoe_order_unit = g.nr_seq_cpoe_order_unit
        and     a.nr_order_unit = nr_order_unit_p
        and     g.nr_seq_lote = nr_seq_register_p 
        and     ie_tipo_file_p = 'OutpatientOrderBatch';
    -- End of Execution Information
        c03 CURSOR FOR
            SELECT  a.count_medi_details,
                    a.slip_code,
                    a.nr_data_class,
                    a.internal_code,
                    a.dosage,
                    a.unit,
                    a.times_num,
                    a.free_input_flag,
                    a.free_comments,
                    a.med_change_impossible_flg,
                    a.general_name_med_flg,
                    a.days,
                    a.times_num_04,
                    a.days_num,
                    a.digit_times_num,
                    a.digit_days_num,
                    a.medi_blank,
                    a.eot,
                    a.nr_seq_interno,
                    a.nr_seq_cpoe_rp
            from (
            SELECT  count(*) over () count_medi_details,
                    '   ' slip_code,
                    '01' nr_data_class,
                    coalesce(nais_mla_pck.get_affairs_code('ME', 'MATERIAL', 'CD_MATERIAL', d.cd_material), ' ') internal_code,
                    case when substr(cp.cd_intervalo,1,2) = '10'  then
						coalesce(obter_conversao_unidade_nais(d.nr_prescricao, d.nr_sequencia, c.qt_dose_dia), 0) * 1000 
					else
						coalesce(obter_conversao_unidade_nais(d.nr_prescricao, d.nr_sequencia, c.qt_dose), 0) * 1000
					end as dosage,
                    coalesce(d.cd_unidade_medida, ' ') unit,
                    1 times_num,
                    0 free_input_flag,
                    ' ' free_comments,
                    ' ' med_change_impossible_flg,
                    ' ' general_name_med_flg,
                    '00' days,
                    '00' times_num_04,
                    '00' days_num,
					case when substr(cp.cd_intervalo,1,2) = '10'  then 
                        001
                    else
                        coalesce(c.nr_ocorrencia, 1)
					end as digit_times_num,
                    CASE WHEN c.ie_duracao='P' THEN (to_date(to_char(coalesce(c.dt_fim, clock_timestamp()),'YYYY-MM-DD'), 'YYYY-MM-DD') - to_date(to_char(coalesce(c.dt_inicio, clock_timestamp()),'YYYY-MM-DD'), 'YYYY-MM-DD')) WHEN c.ie_duracao='C' THEN  1 END  digit_days_num,
                    ' ' medi_blank,
                    ' ' eot,
                    d.nr_seq_interno nr_seq_interno,
                    LEAD(c.nr_seq_cpoe_rp, 1, 0 ) OVER (ORDER BY c.nr_seq_cpoe_rp)  nr_seq_cpoe_rp
            from    cpoe_order_unit a,
                    cpoe_material c,
                    prescr_material d,
                    prescr_medica f,
					cpoe_rp cp
            where   a.nr_sequencia = c.nr_seq_cpoe_order_unit    
            and     c.nr_sequencia = d.nr_seq_mat_cpoe 
            and     d.nr_prescricao = f.nr_prescricao
			and     cp.nr_sequencia = c.nr_seq_cpoe_rp
            and     a.nr_order_unit = nr_order_unit_p
            and (case
                        when(ie_tipo_file_p = 'OutpatientOrderNew' and f.nr_prescricao = nr_seq_register_p) then (1)
                        when(ie_tipo_file_p = 'OutpatientOrderCancel' and d.nr_seq_interno = nr_seq_register_p)  then (1)
                        else 0

                    end) = 1 
            
union all

            select  count(*) over () count_medi_details,
                    '   ' slip_code,
                    '01' nr_data_class,
                    coalesce(nais_mla_pck.get_affairs_code('ME', 'MATERIAL', 'CD_MATERIAL', d.cd_material), ' ') internal_code,
                    case when substr(cp.cd_intervalo,1,2) = '10'  then 
						coalesce(obter_conversao_unidade_nais(d.nr_prescricao, d.nr_sequencia, c.qt_dose_dia), 0) * 1000 
					else
						coalesce(obter_conversao_unidade_nais(d.nr_prescricao, d.nr_sequencia, c.qt_dose), 0) * 1000
					end as dosage,
                    coalesce(d.cd_unidade_medida, ' ') unit,
                    1 times_num,
                    0 free_input_flag,
                    ' ' free_comments,
                    ' ' med_change_impossible_flg,
                    ' ' general_name_med_flg,
                    '00' days,
                    '00' times_num_04,
                    '00' days_num,
					case when substr(cp.cd_intervalo,1,2) = '10'  then 
                        001
                    else
                        coalesce(c.nr_ocorrencia, 1)
					end as digit_times_num,
                    CASE WHEN c.ie_duracao='P' THEN (to_date(to_char(coalesce(c.dt_fim, clock_timestamp()),'YYYY-MM-DD'), 'YYYY-MM-DD') - to_date(to_char(coalesce(c.dt_inicio, clock_timestamp()),'YYYY-MM-DD'), 'YYYY-MM-DD')) WHEN c.ie_duracao='C' THEN  1 END  digit_days_num,
                    ' ' medi_blank,
                    ' ' eot,
                    d.nr_seq_interno nr_seq_interno,
                    LEAD(c.nr_seq_cpoe_rp, 1, 0 ) OVER (ORDER BY c.nr_seq_cpoe_rp)  nr_seq_cpoe_rp
            from    cpoe_order_unit a,
                    cpoe_material c,
                    prescr_material d,
                    prescr_medica f,
                    ap_lote_review g,
                    cpoe_rp cp
            where   a.nr_sequencia = c.nr_seq_cpoe_order_unit    
            and     c.nr_sequencia = d.nr_seq_mat_cpoe 
            and     d.nr_prescricao = f.nr_prescricao
            and     f.nr_prescricao = g.nr_prescricao
            and     c.nr_seq_cpoe_order_unit = g.nr_seq_cpoe_order_unit 
            and     cp.nr_sequencia = c.nr_seq_cpoe_rp
            and     a.nr_order_unit = nr_order_unit_p
            and     g.nr_seq_lote = nr_seq_register_p 
            and     ie_tipo_file_p = 'OutpatientOrderBatch'

        ) a order by a.nr_seq_cpoe_rp asc;

        c04 CURSOR FOR

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
        and     a.nr_order_unit = nr_order_unit_p
        and     h.si_medical_account = 'Y'
        and     (h.cd_external IS NOT NULL AND h.cd_external::text <> '')
        and (case
                    when(d.nr_prescricao = nr_seq_register_p and d.nr_seq_interno = nr_seq_interno_w and ie_tipo_file_p = 'OutpatientOrderNew') then (1)
                    when(d.nr_seq_interno = nr_seq_register_p and ie_tipo_file_p = 'OutpatientOrderCancel') then (1)
                    else 0
                end) = 1
        
union all

        SELECT  distinct(h.nr_sequencia),
                substr(obter_conversao_externa_int(null,'CPOE_STD_COMMENT','CD_EXTERNAL', coalesce(i.cd_external,' '), nm_usuario_w ),1,6)
        from    cpoe_order_unit a,
                cpoe_material c,
                prescr_material d,
                prescr_medica f,
                ap_lote_review g,
                cpoe_comment_linkage    h,
                cpoe_std_comment    i
        where   a.nr_sequencia = c.nr_seq_cpoe_order_unit    
        and     c.nr_sequencia = d.nr_seq_mat_cpoe 
        and     d.nr_prescricao = f.nr_prescricao
        and     f.nr_prescricao = g.nr_prescricao
        and     a.nr_sequencia = g.nr_seq_cpoe_order_unit
        and     g.nr_seq_cpoe_order_unit = h.nr_seq_cpoe_order_unit
        and     h.nr_seq_std_comment = i.nr_sequencia
        and     i.si_medical_account = 'Y'
        and     (i.cd_external IS NOT NULL AND i.cd_external::text <> '')
        and     a.nr_order_unit = nr_order_unit_p
        and     g.nr_seq_lote = nr_seq_register_p
        and     ie_tipo_file_p = 'OutpatientOrderBatch';

        r_c03                 c03%rowtype;
        r_c01_w               accinforectyp;
        r_c02_w               execinforedtyp;
        r_c03_w               medtreatmentinforedtyp;
        cd_contin_flag_w      varchar(1) := 'C';
        loop_count_w          smallint := 0;
        inside_loop_count_w   smallint := 1;
        counter_w             smallint := 0;
        json_output_w         philips_json;
        med_treatment_count_w smallint := 0;
        type_of_prescription_w  cpoe_order_unit.si_type_of_prescription%type;
        ie_drug_info_w  cpoe_order_unit.ie_drug_info%type;
        drug_info_w nais_conversion_master%rowtype;
        l_med_rec_w nais_conversion_master%rowtype;
        previous_cd_rp_w                cpoe_material.nr_seq_cpoe_rp%type :=0;
        current_rp_w                    cpoe_material.nr_seq_cpoe_rp%type :=0;

BEGIN

        PERFORM set_config('nais_mla_pck.ds_line_w', null, false);
        counter_w := 0;
        inside_loop_count_w := 0;
        PERFORM set_config('nais_mla_pck.index_counter_w', 0, false);
        loop_count_w := 0;
        json_output_w := philips_json();
        PERFORM set_config('nais_mla_pck.med_treamtent', med_treamtent_array(), false);

        begin

            select  a.order_class,
                    a.nr_processing_class,
                    a.nais_insurance,
                    a.order_no,
                    a.mrn,
                    a.encounter_no,
                    a.nr_seq_interno
            into STRICT    order_class_w,
                    nr_processing_class_w,
                    nais_insurance_w,
                    nr_prescricao_w,
                    nr_prontuario_w,
                    nr_atendimento_w,
                    nr_seq_interno_w
            from (
            SELECT  CASE WHEN coalesce(max(a.si_type_of_prescription), 'OPIHO')='OPIHO' THEN  'H0' WHEN coalesce(max(a.si_type_of_prescription), 'OPIHO')='OPOOH' THEN  'H8' END  order_class,
                    CASE WHEN ie_tipo_file_p='OutpatientOrderCancel' THEN '03' WHEN ie_tipo_file_p='OutpatientOrderNew' THEN '01' END  nr_processing_class,
                    coalesce(max(c.nr_seq_nais_insurance), 00) nais_insurance,
                    coalesce(max(f.nr_prescricao), 0) order_no,
                    coalesce(max(g.nr_prontuario), 0) mrn,
                    coalesce(max(f.nr_atendimento), 0) encounter_no,
                    coalesce(max(d.nr_seq_interno), 0) nr_seq_interno
            from    cpoe_order_unit a,
                    cpoe_material c,
                    prescr_material d,
                    prescr_medica f,
                    pessoa_fisica g
            where   a.nr_sequencia = c.nr_seq_cpoe_order_unit
            and     c.nr_sequencia = d.nr_seq_mat_cpoe
            and     d.nr_prescricao = f.nr_prescricao
            and     f.cd_pessoa_fisica = g.cd_pessoa_fisica
            and     a.nr_order_unit = nr_order_unit_p
            and (case 
                          when(ie_tipo_file_p = 'OutpatientOrderNew') and f.nr_prescricao = nr_seq_register_p THEN (1)
                          when(ie_tipo_file_p = 'OutpatientOrderCancel') and d.nr_seq_interno = nr_seq_register_p  THEN (1)
                          else 0
                end) = 1
            
union all

            SELECT  CASE WHEN coalesce(max(a.si_type_of_prescription), 'OPIHO')='OPIHO' THEN  'H0' WHEN coalesce(max(a.si_type_of_prescription), 'OPIHO')='OPOOH' THEN  'H8' END  order_class,
                    CASE WHEN coalesce(max(ap.ie_status_review), 'A')='A' THEN  '01' WHEN coalesce(max(ap.ie_status_review), 'A')='C' THEN  '03' END  nr_processing_class,
                    coalesce(max(c.nr_seq_nais_insurance), 00) nais_insurance,
                    coalesce(max(f.nr_prescricao), 0) order_no,
                    coalesce(max(g.nr_prontuario), 0) mrn,
                    coalesce(max(f.nr_atendimento), 0) encounter_no,
                    coalesce(max(d.nr_seq_interno), 0) nr_seq_interno
            from    cpoe_order_unit a,
                    cpoe_material c,
                    prescr_material d,
                    prescr_medica f,
                    ap_lote_review ap,
                    pessoa_fisica g
            where   a.nr_sequencia = c.nr_seq_cpoe_order_unit    
            and     c.nr_sequencia = d.nr_seq_mat_cpoe
            and     d.nr_prescricao = f.nr_prescricao
            and     f.nr_prescricao = ap.nr_prescricao
            and     c.nr_seq_cpoe_order_unit = ap.nr_seq_cpoe_order_unit 
            and     f.cd_pessoa_fisica = g.cd_pessoa_fisica
            and     a.nr_order_unit = nr_order_unit_p
            and     ap.nr_seq_lote = nr_seq_register_p 
            and     ie_tipo_file_p = 'OutpatientOrderBatch'

         ) a
        where   (a.order_class IS NOT NULL AND a.order_class::text <> '')
        and     a.order_no <> 0;

        if (ie_tipo_file_p = 'OutpatientOrderBatch') then
            select  coalesce(1,0),
                    CASE WHEN ie_status_review='A' THEN  dt_review_accepted WHEN ie_status_review='C' THEN  dt_review_cancelled END
            into STRICT    ie_review_exists_w,
                    execution_date_w
            from    ap_lote_review
            where   nr_seq_lote = nr_seq_register_p;
        end if;

        exception
        when others then
            PERFORM set_config('nais_mla_pck.ds_error_w', current_setting('nais_mla_pck.ds_error_w')::varchar(4000)||' An error occured while retriving the Processing classification for '||nr_seq_register_p||' '||sqlerrm, false);
        end;

        begin
            open c03;
                loop
                    fetch c03 into r_c03_w;
                    EXIT WHEN NOT FOUND; /* apply on c03 */
                    current_rp_w :=nais_mla_pck.get_current_rp(r_c03_w.nr_seq_interno);

                    if previous_cd_rp_w <> current_rp_w then
                        current_setting('nais_mla_pck.ds_line_w')::varchar(32767) := nais_mla_pck.get_action_code_med_detail(order_class_w, r_c03_w, current_setting('nais_mla_pck.ds_line_w')::varchar(32767));
                        CALL CALL CALL CALL nais_mla_pck.add_med_treatment_detail_array(current_setting('nais_mla_pck.ds_line_w')::varchar(32767), current_setting('nais_mla_pck.index_counter_w')::smallint);
                    end if;

                    CALL CALL CALL CALL nais_mla_pck.common_med_treatment_info(r_c03_w);
                    CALL CALL CALL CALL nais_mla_pck.add_med_treatment_detail_array(current_setting('nais_mla_pck.ds_line_w')::varchar(32767), current_setting('nais_mla_pck.index_counter_w')::smallint);
                    select  coalesce(max(c.ie_drug_info), 'N')
                    into STRICT    ie_drug_info_w
                    from    cpoe_material           a,
                            prescr_material         b,
                            cpoe_order_unit         c,
                            cpoe_rp                 d
                    where   a.nr_sequencia = b.nr_seq_mat_cpoe
                    and 	a.nr_seq_cpoe_order_unit = c.nr_sequencia
                    and 	a.nr_seq_cpoe_rp = d.nr_sequencia
                    and 	b.nr_seq_interno = r_c03_w.nr_seq_interno;

                if current_rp_w <> r_c03_w.nr_seq_cpoe_rp  then
                    if ((coalesce(r_c03_w.digit_days_num, 0))::numeric <=0) then
                        r_c03_w.digit_days_num := 1;
                    end if;
                    current_setting('nais_mla_pck.ds_line_w')::varchar(32767) := nais_mla_pck.add_date_class_med_detail(order_class_w, r_c03_w, current_setting('nais_mla_pck.ds_line_w')::varchar(32767));
                    CALL CALL CALL CALL nais_mla_pck.add_med_treatment_detail_array(current_setting('nais_mla_pck.ds_line_w')::varchar(32767), current_setting('nais_mla_pck.index_counter_w')::smallint);
                end if;

                    previous_cd_rp_w :=current_rp_w;

            end loop;

            if (ie_drug_info_w = 'S') then
                drug_info_w := get_medicalaffair_code('ME','CPOE_ORDER_UNIT','IE_DRUG_INFO',ie_drug_info_w, null, null);
                if ( drug_info_w.ie_send_flaf   ='S' and (drug_info_w.cd_medical_affair IS NOT NULL AND drug_info_w.cd_medical_affair::text <> '')) then
                    r_c03_w.internal_code := drug_info_w.cd_medical_affair;
                    r_c03_w.dosage := 0;
                    r_c03_w.unit := ' ';
                    r_c03_w.digit_times_num :=1;
                    r_c03_w.digit_days_num := 1;

                    CALL CALL CALL CALL nais_mla_pck.common_med_treatment_info(r_c03_w);
                    CALL CALL CALL CALL nais_mla_pck.add_med_treatment_detail_array(current_setting('nais_mla_pck.ds_line_w')::varchar(32767), current_setting('nais_mla_pck.index_counter_w')::smallint);

                end if;
            end if;
            close c03;
        exception
        when others then
            PERFORM set_config('nais_mla_pck.ds_error_w', current_setting('nais_mla_pck.ds_error_w')::varchar(4000)||' An error occured while forming the Medical treatment information for Outpatient prescription message '||sqlerrm, false);
        end;

        begin
            open c04;
                loop
                fetch c04 into
                    nr_linkage_sequencia_w,
                    cd_external_w;
                    EXIT WHEN NOT FOUND; /* apply on c04 */
                        CALL CALL nais_mla_pck.process_receipt_comments(r_c03_w, cd_external_w, nr_linkage_sequencia_w);
                end loop;
            close c04;
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
                               810, 944);
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
-- REVOKE ALL ON PROCEDURE nais_mla_pck.send_outpatient_presc_data (( nr_seq_register_p bigint, ie_tipo_file_p text, nr_order_unit_p cpoe_order_unit.nr_order_unit%type ) is nr_prescricao_w prescr_medica.nr_prescricao%type) FROM PUBLIC;