-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


	/** 
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	NAIS MLA Event - Treatment Gas-Therapy Test Starts Here
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	**/
CREATE OR REPLACE PROCEDURE nais_mla_treatment.send_treatment_data (( nr_seq_gasoterapia_p bigint, cd_classif_p text, file_output_p out text ) as c01 CURSOR ) AS $body$
DECLARE

          PERFORM * from (SELECT
                                    coalesce(cd_classif_p,'00')                                                                   process_classif, 
                                    'P0'                                                                                     order_class, 
                                    coalesce(co.nr_order_patient_seq,'00000000')                                                  order_number,            
                                    coalesce(c.medical_record_id,'0000000000')                                                    patient_identifier,  
                                    coalesce(to_char(d.dt_evento,'YYYYMMDD'),'00000000')                                          consultation_date,
                                    
                                    case when (co.cd_especialidade_med IS NOT NULL AND co.cd_especialidade_med::text <> '') then 
                                        coalesce(nais_mla_treatment.get_affairs_code('OS', 'ESPECIALIDADE_MEDICA', 'CD_ESPECIALIDADE', co.cd_especialidade_med), ' ') 
                                    when (co.cd_departamento_med IS NOT NULL AND co.cd_departamento_med::text <> '') then 
                                        coalesce(nais_mla_treatment.get_affairs_code('OS', 'DEPARTAMENTO_MEDICO', 'CD_DEPARTAMENTO', co.cd_departamento_med), ' ')   
                                    else '00'
                                    end as                                                                                   department_code,
                                    CASE WHEN get_patient_type(c.encounter_id, NULL)='IN' THEN  1 WHEN get_patient_type(c.encounter_id, NULL)='OP' THEN  2 END                          patient_classification,    
                                    coalesce(c.bed_id,'   ')                                                                      ward_code,                
                                    coalesce(c.room_id,'     ')                                                                   room_number,             
                                    '1'                                                                                      blood_tranfusion_type,     
                                    coalesce(a.nr_seq_nais_insurance,'00')                                                        insurance_number,          
                                    coalesce(a.cd_medico,'00000000')                                                              doctor_code,               
                                    '0'                                                                                      patient_newborn,         
                                    ' '                                                                                      prescription_classfication,
                                    '   '                                                                                    requestor_code,           
                                    ' '                                                                                      mutual_exclusion_rule,   
                                    '0000'                                                                                   division_number,       
                                    ' '                                                                                      blank_one,              
                                    ' '                                                                                      blank_two               
                        from        cpoe_gasoterapia a,
                                    prescr_gasoterapia b,
                                    bft_encounter_v c,
                                    prescr_gasoterapia_evento d,
                                    cpoe_order_unit co,
                                    cpoe_tipo_pedido ct
                        where       a.nr_sequencia = b.nr_seq_gas_cpoe
                        and         b.nr_sequencia = d.nr_seq_gasoterapia
                        and         a.nr_atendimento =  c.encounter_id
                        and         d.ie_evento = 'T' 
                        and         d.nr_seq_gasoterapia = nr_seq_gasoterapia_p
                        and         co.nr_seq_cpoe_tipo_pedido = ct.nr_sequencia 
                        and         co.nr_sequencia = a.nr_seq_cpoe_order_unit  
                        and         ct.nr_seq_sub_grp = 'PC' 
                        order by    d.nr_sequencia desc) alias17 LIMIT 1;

    --  End of Accounting Information
    
        c02 return;

    -- End of Execution Information
        c03 return;

    -- End of Medical treatment details
        r_c03                 c03%rowtype;
        r_c01_w               accinforectyp;
        r_c02_w               execinforedtyp;
        r_c03_w               medtreatmentinforedtyp;
        cd_contin_flag_w      varchar(1) := 'C';
        loop_count_w          smallint := 0;
        inside_loop_count_w   smallint := 1;
        counter_w             smallint := 0;
        json_output_w		  philips_json;
        json_output_list_w    philips_json_list;

        nr_seq_int_call_log_w bigint :=0;
        ds_log_message_w      varchar(500);
        nr_atendimento_w cpoe_gasoterapia.nr_atendimento%type;


BEGIN
        PERFORM set_config('nais_mla_treatment.ds_line_w', null, false);
        counter_w := 0;
        inside_loop_count_w :=0;
        PERFORM set_config('nais_mla_treatment.index_counter_w', 0, false);
        loop_count_w := 0;
        json_output_w   := philips_json();
        json_output_list_w	:= philips_json_list();
        
        begin
        select  a.nr_atendimento
        into STRICT    nr_atendimento_w
        from    cpoe_gasoterapia a,
                prescr_gasoterapia b,
                prescr_gasoterapia_evento d
        where   a.nr_sequencia = b.nr_seq_gas_cpoe
        and     b.nr_sequencia = d.nr_seq_gasoterapia
        and     d.nr_seq_gasoterapia = nr_seq_gasoterapia_p  LIMIT 1;

        exception when no_data_found then nr_atendimento_w:= null;
		end;

        open c03;
        loop
            begin
            fetch c03 into r_c03_w;
            --------------------------------------Logger_start Cursor for c03---------------------------------------------
                exception when others then
               
                   ds_log_message_w := 'Exception occured while forming cursor medical record for : '
                                    ||' Gasotherapia Sequence number Cursor "C-03"'
                                    || nr_seq_gasoterapia_p
                                    || ' '
                                    ||sqlerrm;


                    if length(ds_log_message_w) < 500 then
                        record_integration_call_log(coalesce(wheb_usuario_pck.get_nm_usuario , 'NAIS'), 'NAIS', clock_timestamp(), 'nais.treatment', 'nais.treatment' , 
                                'E', 'E', null, 'KK', null,ds_log_message_w, 0,nr_seq_int_call_log_w, nr_atendimento_w, 944,'E');
                    else
                        record_integration_call_log(coalesce(wheb_usuario_pck.get_nm_usuario , 'NAIS'), 'NAIS', clock_timestamp(), 'nais.treatment', 'nais.treatment' , 
                                'E', 'E', null, 'KK', null,substr(ds_log_message_w,1,499), 0,nr_seq_int_call_log_w, nr_atendimento_w, 944,'E');
                    end if;
            end;

            ---------------------------------------Logger_end Cursor for c03---------------------------------------------
            
            EXIT WHEN NOT FOUND; /* apply on c03 */
            current_setting('nais_mla_treatment.ds_line_w')::varchar(32767) := nais_mla_treatment.get_action_code_med_detail('P0', r_c03_w, current_setting('nais_mla_treatment.ds_line_w')::varchar(32767), nr_seq_gasoterapia_p);
            CALL CALL CALL CALL nais_mla_treatment.add_med_treatment_detail_array(current_setting('nais_mla_treatment.ds_line_w')::varchar(32767), current_setting('nais_mla_treatment.index_counter_w')::smallint);

            current_setting('nais_mla_treatment.ds_line_w')::varchar(32767) := nais_mla_treatment.add_first_medical(r_c03_w, current_setting('nais_mla_treatment.ds_line_w')::varchar(32767), nr_seq_gasoterapia_p);
            CALL CALL CALL CALL nais_mla_treatment.add_med_treatment_detail_array(current_setting('nais_mla_treatment.ds_line_w')::varchar(32767), current_setting('nais_mla_treatment.index_counter_w')::smallint);

            current_setting('nais_mla_treatment.ds_line_w')::varchar(32767) := nais_mla_treatment.add_second_medical(r_c03_w, nr_seq_gasoterapia_p, current_setting('nais_mla_treatment.ds_line_w')::varchar(32767));
            CALL CALL CALL CALL nais_mla_treatment.add_med_treatment_detail_array(current_setting('nais_mla_treatment.ds_line_w')::varchar(32767), current_setting('nais_mla_treatment.index_counter_w')::smallint);

            current_setting('nais_mla_treatment.ds_line_w')::varchar(32767) := nais_mla_treatment.add_date_class_med_detail('P0', r_c03_w, current_setting('nais_mla_treatment.ds_line_w')::varchar(32767));
            CALL CALL CALL CALL nais_mla_treatment.add_med_treatment_detail_array(current_setting('nais_mla_treatment.ds_line_w')::varchar(32767), current_setting('nais_mla_treatment.index_counter_w')::smallint);
        end loop;

        close c03;
        loop_count_w := ceil(current_setting('nais_mla_treatment.index_counter_w')::smallint / 10);

        
        for i in 1..loop_count_w loop begin
            if ( i = loop_count_w ) then
                cd_contin_flag_w := 'E';
            end if;
            CALL CALL CALL CALL CALL CALL CALL nais_mla_treatment.nais_common_header('KK', nr_seq_gasoterapia_p, cd_classif_p, cd_contin_flag_w, 1,
                               810);
            open c01;
            loop

            begin
                fetch c01 into r_c01_w;

            --------------------------------------Logger_start Cursor for c01---------------------------------------------
            
                exception when others then
               
                   ds_log_message_w := 'Exception occured while forming cursor medical record for : '
                                    ||' Gasotherapia Sequence number Cursor "C-01"'
                                    || nr_seq_gasoterapia_p
                                    || ' '
                                    ||sqlerrm;


                    if length(ds_log_message_w) < 500 then
                        record_integration_call_log(coalesce(wheb_usuario_pck.get_nm_usuario , 'NAIS'), 'NAIS', clock_timestamp(), 'nais.treatment', 'nais.treatment' , 
                                'E', 'E', null, 'KK', null,ds_log_message_w, 0,nr_seq_int_call_log_w, nr_atendimento_w, 944,'E');
                    else
                        record_integration_call_log(coalesce(wheb_usuario_pck.get_nm_usuario , 'NAIS'), 'NAIS', clock_timestamp(), 'nais.treatment', 'nais.treatment' , 
                                'E', 'E', null, 'KK', null,substr(ds_log_message_w,1,499), 0,nr_seq_int_call_log_w, nr_atendimento_w, 944,'E');
                    end if;
            end;

            ---------------------------------------Logger_end Cursor for c01---------------------------------------------
                
                EXIT WHEN NOT FOUND; /* apply on c01 */
                CALL CALL CALL CALL CALL nais_mla_treatment.common_accounting_info(r_c01_w);
            end loop;

            close c01;
            open c02;
            loop
                begin
                fetch c02 into r_c02_w;
                
            --------------------------------------Logger_start Cursor for c02---------------------------------------------            
                exception when others then
               
                   ds_log_message_w := 'Exception occured while forming cursor medical record for : '
                                    ||' Gasotherapia Sequence number Cursor "C-02"'
                                    || nr_seq_gasoterapia_p
                                    || ' '
                                    ||sqlerrm;


                    if length(ds_log_message_w) < 500 then
                        record_integration_call_log(coalesce(wheb_usuario_pck.get_nm_usuario , 'NAIS'), 'NAIS', clock_timestamp(), 'nais.treatment', 'nais.treatment' , 
                                'E', 'E', null, 'KK', null,ds_log_message_w, 0,nr_seq_int_call_log_w, nr_atendimento_w, 944,'E');
                    else
                        record_integration_call_log(coalesce(wheb_usuario_pck.get_nm_usuario , 'NAIS'), 'NAIS', clock_timestamp(), 'nais.treatment', 'nais.treatment' , 
                                'E', 'E', null, 'KK', null,substr(ds_log_message_w,1,499), 0,nr_seq_int_call_log_w, nr_atendimento_w, 944,'E');
                    end if;
            end;

            ---------------------------------------Logger_end Cursor for c02---------------------------------------------
                EXIT WHEN NOT FOUND; /* apply on c02 */
                CALL CALL CALL CALL CALL nais_mla_treatment.common_execution_info(r_c02_w);
            end loop;

            close c02;
            open c03;
            fetch c03 into r_c03;
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_treatment.append_text(r_c03.slip_code, 3, 'L');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_treatment.append_text(coalesce(r_c03.count_medi_details, 0), 2, 'L', '0');
            close c03;
            inside_loop_count_w := counter_w + 1;
            for x in inside_loop_count_w..inside_loop_count_w + 9 loop
                counter_w := counter_w + 1;

                current_setting('nais_mla_treatment.med_treamtent')::med_treamtent_array.extend;
                if ( cd_contin_flag_w = 'E' and current_setting('nais_mla_treatment.med_treamtent')::coalesce(med_treamtent_array(x)::text, '') = '' ) then
                    CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_treatment.append_text(' ', 64);
                else
                    CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_treatment.append_text(current_setting('nais_mla_treatment.med_treamtent')::med_treamtent_array(x), 64, 'L', ' ');
                end if;

            end loop;

            open c03;
            fetch c03 into r_c03;
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_treatment.append_text(r_c03.medi_blank, 4, 'R', ' ');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_treatment.append_text(r_c03.eot, 1, 'L');
            close c03;
           json_output_w := nais_mla_treatment.add_json_value(json_output_w, 'message', current_setting('nais_mla_treatment.ds_line_w')::varchar(32767));
           json_output_list_w.append(json_output_w.to_json_value());

        end;
        end loop;
        dbms_lob.createtemporary( file_output_p, true);
        json_output_list_w.(file_output_p);
        record_integration_call_log(coalesce(wheb_usuario_pck.get_nm_usuario , 'NAIS'), 'NAIS', clock_timestamp(), 'nais.mla.treatment', 'nais.mla.treatment' ,    --Success Logger
        'T', 'E', null, 'KK', file_output_p,null, 0,nr_seq_int_call_log_w, nr_atendimento_w, 944,'S');
        
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nais_mla_treatment.send_treatment_data (( nr_seq_gasoterapia_p bigint, cd_classif_p text, file_output_p out text ) as c01 CURSOR ) FROM PUBLIC;