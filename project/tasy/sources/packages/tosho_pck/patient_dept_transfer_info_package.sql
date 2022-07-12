-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

    
    
    
	/** 
   +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Patient Department Change Information
	unique_key :- encounter number
	message type:- 3M -> Department change information
	-- This message contains a common header and destination department information.
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   **/
CREATE OR REPLACE PROCEDURE tosho_pck.patient_dept_transfer_info ( unique_key_p bigint, processing_type_p text, nm_usuario_p text, log_sequence_number_p text, file_name_p text, cd_establishment_p bigint, ie_retransmit_p text ) AS $body$
DECLARE


        c03 CURSOR FOR
         SELECT x.*  ,   coalesce(obter_nome_pf(x.physician_code), ' ') physician_name
          from (SELECT obter_pessoa_atendimento(a.nr_atendimento, 'C') patient_id,
                a.dt_transferencia   transfer_date,
                a.cd_depart_destino            dest_medical_department_code,
                obter_nome_departamento_medico( a.cd_depart_destino )  dest_medical_department_name,
                tosho_pck.get_attending_physician(a.nr_atendimento)  physician_code
            from    transf_departamento_medico  a
            where    a.nr_atend_paciente_unidade = unique_key_p 
            order by a.nr_sequencia desc LIMIT 1) x;


BEGIN
        PERFORM set_config('tosho_pck.ds_line_w', null, false);
        PERFORM set_config('tosho_pck.data_file_name_w', null, false);
        PERFORM set_config('tosho_pck.file_sequence_w', null, false);
        PERFORM set_config('tosho_pck.nm_interface_w', null, false);
        PERFORM set_config('tosho_pck.message_type_w', '3M', false);
        PERFORM set_config('tosho_pck.interface_event_w', 948, false);
        PERFORM set_config('tosho_pck.file_seq_directory_w', 'TOSHO_PDATA', false);
        PERFORM set_config('tosho_pck.ds_message_w', 'Patient Dept Change Information', false);
        PERFORM set_config('tosho_pck.log_sequence_number_w', log_sequence_number_p, false);

         select is_integration_exist(929, m.patient_mrn),
                m.patient_mrn
        into STRICT    current_setting('tosho_pck.ie_exist_w')::varchar(1),
                current_setting('tosho_pck.patient_mrn_w')::varchar(10)
        from (SELECT obter_prontuario_atendimento(a.encounter_id) patient_mrn 
                from bft_encounter_movement_v a 
                where   a.movement_id = unique_key_p) m;

        if (current_setting('tosho_pck.ie_exist_w')::varchar(1) = 'N')then
            return;
        end if;

        -- retrieving the event and company name for interface    
        SELECT * FROM tosho_pck.get_interface_event_details(current_setting('tosho_pck.interface_event_w')::integer, current_setting('tosho_pck.ds_message_w')::varchar(255), current_setting('tosho_pck.nm_interface_w')::varchar(255)) INTO STRICT current_setting('tosho_pck.ds_message_w')::varchar(255), current_setting('tosho_pck.nm_interface_w')::varchar(255);
   
        PERFORM set_config('tosho_pck.cd_integartion_event_w', tosho_pck.get_directory_event_code(current_setting('tosho_pck.message_type_w')::varchar(2)), false);

       PERFORM set_config('tosho_pck.log_file_name_w', tosho_pck.get_log_file_name(current_setting('tosho_pck.cd_integartion_event_w')::philips_json.get['control_code'].value_of(), current_setting('tosho_pck.tosho_dept_code_w')::varchar(2), current_setting('tosho_pck.his_system_code')::varchar(2)), false);


        --creating interface message 
         begin
           
            for r_c03 in c03 loop begin
                PERFORM set_config('tosho_pck.patient_id_w', r_c03.patient_id, false);
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL tosho_pck.append_text(current_setting('tosho_pck.message_type_w')::varchar(2), 2, 'L'); --DENBUN_SYBT
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL tosho_pck.append_text(to_char(clock_timestamp(),'YYYYMMDD'), 8, 'L'); --SAKUSEI_DATE
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL tosho_pck.append_text(to_char(clock_timestamp(),'HH24MISS'), 6, 'L'); --SAKUSEI_TIME
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL tosho_pck.append_text(current_setting('tosho_pck.his_system_code')::varchar(2), 2, 'L'); --S_SYS_CD
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL tosho_pck.append_text(current_setting('tosho_pck.tosho_dept_code_w')::varchar(2), 2, 'L'); --S_SYS_CD
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL tosho_pck.append_text(1, 8 ,'L', '0');
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL tosho_pck.append_text(processing_type_p,1,'R',0); --SYORI_KBN
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL tosho_pck.append_text(to_char(r_c03.transfer_date, 'YYYYMMDD'), 8, 'L'); --SYORI_DATE
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL tosho_pck.append_text(to_char(r_c03.transfer_date, 'HH24MISS'), 6, 'L'); --SYORI_TIME
                --appending message body 
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL tosho_pck.append_text(current_setting('tosho_pck.patient_mrn_w')::varchar(10), 10, 'L', '0'); -- PT_ID
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL tosho_pck.append_text(to_char(r_c03.transfer_date, 'YYYYMMDD'), 8, 'L'); -- CHG_DATE
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL tosho_pck.append_text(r_c03.physician_code, 10, 'L', '0'); -- DR_ID
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL tosho_pck.append_text(r_c03.physician_name, 20, 'L', '0'); -- DR_NAME
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL tosho_pck.append_text(r_c03.dest_medical_department_code, 3, 'L', '0'); -- IDO_KA_CD
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL tosho_pck.append_text(r_c03.dest_medical_department_name, 20); -- IDO_KA_NAME
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL tosho_pck.append_text(' ', 29, 'L'); -- FILLER
            end;
            end loop;
        exception
            when others then
                PERFORM set_config('tosho_pck.ds_log_message_w', 'Error occured while sending the integration message for'
                                    || current_setting('tosho_pck.ds_message_w')::varchar(255) || chr(10)
                                    || 'Integration name - japan_tosho_('
                                    || current_setting('tosho_pck.ds_message_w')::varchar(255)
                                    || ').'
                                    || chr(10)
                                    || 'Message Type:'
                                    || current_setting('tosho_pck.message_type_w')::varchar(2)
                                    || chr(10)
                                    || 'Time of faliure : '
                                    || clock_timestamp() || chr(10)
                                    || 'Movement Id:'
                                    || unique_key_p
                                    ||' -ERROR- '
                                    || SQLERRM, false);

                record_integration_call_log(nm_usuario_p, nm_usuario_p, clock_timestamp(), 'japan_tosho_pdata', current_setting('tosho_pck.ds_message_w')::varchar(255),
                                            'F', 'E', null, current_setting('tosho_pck.ds_log_message_w')::varchar(32767), current_setting('tosho_pck.ds_line_w')::varchar(32767),
                                            current_setting('tosho_pck.ds_log_message_w')::varchar(32767), current_setting('tosho_pck.data_file_name_w')::varchar(100), current_setting('tosho_pck.log_sequence_number_w')::integration_message_log.nr_seq_int_call_log%type, current_setting('tosho_pck.patient_mrn_w')::varchar(10), current_setting('tosho_pck.interface_event_w')::integer);

                CALL CALL tosho_pck.save_log(current_setting('tosho_pck.cd_integartion_event_w')::philips_json.get['cd_event_log'].value_of(), current_setting('tosho_pck.log_file_name_w')::varchar(100), current_setting('tosho_pck.ds_log_message_w')::varchar(32767));
                return;
        end;
        -- generating the file name for first time integration else assign the existing one while resending the same message 
        if (file_name_p IS NOT NULL AND file_name_p::text <> '') then
            PERFORM set_config('tosho_pck.data_file_name_w', file_name_p, false);
        else
            generate_int_serial_number(0, current_setting('tosho_pck.file_seq_directory_w')::varchar(15), cd_establishment_p, nm_usuario_p, current_setting('tosho_pck.file_sequence_w')::smallint, current_setting('tosho_pck.interface_event_w')::integer);
            PERFORM set_config('tosho_pck.data_file_name_w', tosho_pck.get_file_name(current_setting('tosho_pck.cd_integartion_event_w')::philips_json.get['control_code'].value_of(), current_setting('tosho_pck.tosho_dept_code_w')::varchar(2), current_setting('tosho_pck.his_system_code')::varchar(2), current_setting('tosho_pck.file_sequence_w')::smallint), false);

        end if;

        -- it is helpful while resend the information
        PERFORM set_config('tosho_pck.ds_script_w', 'tosho_pck.patient_dept_transfer_info ('
                       || unique_key_p 
                       || ', '''
                       || processing_type_p
                       || ''', '''
                       || ':nm_exec_user' 
                       || ''' , '
                       || ':nr_seq_int_call_log'
                       || ', '''
                       || current_setting('tosho_pck.data_file_name_w')::varchar(100)
                       || ''' ,'
                       || cd_establishment_p
                       || ', ''S'');', false);

        CALL CALL tosho_pck.perform_integration(unique_key_p, current_setting('tosho_pck.message_type_w')::varchar(2), nm_usuario_p, log_sequence_number_p, current_setting('tosho_pck.data_file_name_w')::varchar(100),
                            current_setting('tosho_pck.log_file_name_w')::varchar(100), cd_establishment_p, current_setting('tosho_pck.file_seq_directory_w')::varchar(15), current_setting('tosho_pck.cd_integartion_event_w')::philips_json, current_setting('tosho_pck.ds_message_w')::varchar(255),
                            current_setting('tosho_pck.ds_script_w')::integration_call_log.ds_resend_script%type, current_setting('tosho_pck.nm_interface_w')::varchar(255), current_setting('tosho_pck.interface_event_w')::integer, current_setting('tosho_pck.patient_mrn_w')::varchar(10), ie_retransmit_p);

    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tosho_pck.patient_dept_transfer_info ( unique_key_p bigint, processing_type_p text, nm_usuario_p text, log_sequence_number_p text, file_name_p text, cd_establishment_p bigint, ie_retransmit_p text ) FROM PUBLIC;
