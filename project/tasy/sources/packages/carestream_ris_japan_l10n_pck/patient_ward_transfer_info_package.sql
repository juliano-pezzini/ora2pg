-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


	/** 
   +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Patient Ward Change Information
	unique_key :- movement id
	message type:- 3J -> Ward change information 
	-- This message contains a common header and ward and room information respective to patient.
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   **/
CREATE OR REPLACE PROCEDURE carestream_ris_japan_l10n_pck.patient_ward_transfer_info ( unique_key_p bigint, processing_type_p text, nm_usuario_p text, log_sequence_number_p text default 0, file_name_p text default null, cd_establishment_p bigint default 1, ie_retransmit_p text  DEFAULT NULL) AS $body$
DECLARE


        c02 CURSOR FOR
        SELECT obter_pessoa_atendimento(a.encounter_id, 'C') patient_id,
                a.encounter_id            encounter_id,
                a.department_admit_date   transfer_date,
                a.department_id           destination_ward,
                a.room_id                 destination_room
        from    bft_encounter_movement_v a
        where   a.movement_id = unique_key_p;


BEGIN

        PERFORM set_config('carestream_ris_japan_l10n_pck.ds_line_w', null, false);
        PERFORM set_config('carestream_ris_japan_l10n_pck.data_file_name_w', null, false);
        PERFORM set_config('carestream_ris_japan_l10n_pck.nm_interface_w', null, false);
        PERFORM set_config('carestream_ris_japan_l10n_pck.file_sequence_w', null, false);
        PERFORM set_config('carestream_ris_japan_l10n_pck.message_type_w', '3J', false);
        PERFORM set_config('carestream_ris_japan_l10n_pck.file_seq_directory_w', 'CARE_RIS_PDATA', false);
        PERFORM set_config('carestream_ris_japan_l10n_pck.ds_message_w', 'Patient Ward Change Information', false);
        PERFORM set_config('carestream_ris_japan_l10n_pck.log_sequence_number_w', log_sequence_number_p, false);
        PERFORM set_config('carestream_ris_japan_l10n_pck.interface_event_w', 932, false);

        select is_integration_exist(931, m.patient_mrn),
               m.patient_mrn
        into STRICT   current_setting('carestream_ris_japan_l10n_pck.ie_exist_w')::varchar(1),
               current_setting('carestream_ris_japan_l10n_pck.patient_mrn_w')::varchar(10)
        from (SELECT obter_prontuario_atendimento(a.encounter_id) patient_mrn
                from   bft_encounter_movement_v a 
                where  a.movement_id = unique_key_p) m;

        if (current_setting('carestream_ris_japan_l10n_pck.ie_exist_w')::varchar(1) = 'N')then
            return;
        end if;

        SELECT * FROM carestream_japan_l10n_pck.get_interface_event_details(current_setting('carestream_ris_japan_l10n_pck.interface_event_w')::integer, current_setting('carestream_ris_japan_l10n_pck.ds_message_w')::varchar(255), current_setting('carestream_ris_japan_l10n_pck.nm_interface_w')::varchar(255)) INTO STRICT current_setting('carestream_ris_japan_l10n_pck.ds_message_w')::varchar(255), current_setting('carestream_ris_japan_l10n_pck.nm_interface_w')::varchar(255);

        select carestream_japan_l10n_pck.get_directory_event_code(current_setting('carestream_ris_japan_l10n_pck.message_type_w')::varchar(2))
        into STRICT   current_setting('carestream_ris_japan_l10n_pck.cd_integartion_event_w')::philips_json
;

        select carestream_japan_l10n_pck.get_log_file_name(current_setting('carestream_ris_japan_l10n_pck.cd_integartion_event_w')::philips_json.get['control_code'].value_of(), current_setting('carestream_ris_japan_l10n_pck.radiology_dept_code_w')::varchar(2), current_setting('carestream_ris_japan_l10n_pck.his_system_code')::varchar(2))
        into STRICT   current_setting('carestream_ris_japan_l10n_pck.log_file_name_w')::varchar(100)
;

		--creating message for integration
        begin
            SELECT * FROM carestream_japan_l10n_pck.carestream_header(unique_key_p, current_setting('carestream_ris_japan_l10n_pck.message_type_w')::varchar(2), current_setting('carestream_ris_japan_l10n_pck.radiology_dept_code_w')::varchar(2), processing_type_p, current_setting('carestream_ris_japan_l10n_pck.ds_line_w')::varchar(32767), current_setting('carestream_ris_japan_l10n_pck.patient_id_w')::varchar(10), current_setting('carestream_ris_japan_l10n_pck.encounter_id_w')::varchar(10)) INTO STRICT current_setting('carestream_ris_japan_l10n_pck.ds_line_w')::varchar(32767), current_setting('carestream_ris_japan_l10n_pck.patient_id_w')::varchar(10), current_setting('carestream_ris_japan_l10n_pck.encounter_id_w')::varchar(10);

            for r_c02 in c02 loop begin
                PERFORM set_config('carestream_ris_japan_l10n_pck.patient_id_w', r_c02.patient_id, false);
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(to_char(r_c02.transfer_date, 'YYYYMMDD'), 8, 'L'); --SYORI_DATE
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(to_char(r_c02.transfer_date, 'HH24MISS'), 6, 'L'); --SYORI_TIME
                    --appending message body 
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(current_setting('carestream_ris_japan_l10n_pck.patient_mrn_w')::varchar(10), 10, 'L', '0'); -- PT_ID
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(to_char(r_c02.transfer_date, 'YYYYMMDD'), 8, 'L'); -- CHG_DATE
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(r_c02.destination_ward, 3, 'L', '0'); -- IDO_BYOTO_CD
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(r_c02.destination_room, 4, 'L', '0'); -- IDO_ROOM_CD
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(' ', 25, 'L'); -- FILLER
            end;
            end loop;
        exception
            when others then
                PERFORM set_config('carestream_ris_japan_l10n_pck.ds_log_message_w', 'Error occured while sending the integration message for'
                                    || current_setting('carestream_ris_japan_l10n_pck.ds_message_w')::varchar(255) || chr(10)
                                    || 'Integration name - japan_carestream_ris('
                                    || current_setting('carestream_ris_japan_l10n_pck.ds_message_w')::varchar(255)
                                    || ').'
                                    || chr(10)
                                    || 'Message Type:'
                                    || current_setting('carestream_ris_japan_l10n_pck.message_type_w')::varchar(2)
                                    || chr(10)
                                    || 'Time of faliure : '
                                    || clock_timestamp() || chr(10)
                                    || 'Movement Id:'
                                    || unique_key_p
                                    ||' -ERROR- '
                                    || SQLERRM, false);


                record_integration_call_log(nm_usuario_p, nm_usuario_p, clock_timestamp(), 'japan_carestream_ris', current_setting('carestream_ris_japan_l10n_pck.ds_message_w')::varchar(255),
                                            'F', 'E', null, current_setting('carestream_ris_japan_l10n_pck.ds_log_message_w')::varchar(32767), current_setting('carestream_ris_japan_l10n_pck.ds_line_w')::varchar(32767),
                                            current_setting('carestream_ris_japan_l10n_pck.ds_log_message_w')::varchar(32767), current_setting('carestream_ris_japan_l10n_pck.data_file_name_w')::varchar(100), current_setting('carestream_ris_japan_l10n_pck.log_sequence_number_w')::integration_message_log.nr_seq_int_call_log%type, current_setting('carestream_ris_japan_l10n_pck.patient_mrn_w')::varchar(10), current_setting('carestream_ris_japan_l10n_pck.interface_event_w')::integer);

                CALL carestream_japan_l10n_pck.save_log(current_setting('carestream_ris_japan_l10n_pck.cd_integartion_event_w')::philips_json.get['cd_event_log'].value_of(), current_setting('carestream_ris_japan_l10n_pck.log_file_name_w')::varchar(100), current_setting('carestream_ris_japan_l10n_pck.ds_log_message_w')::varchar(32767));
                return;
        end;
        -- generating the file name for first time integration else assign the existing one while resending the same message 
        if (file_name_p IS NOT NULL AND file_name_p::text <> '') then
            PERFORM set_config('carestream_ris_japan_l10n_pck.data_file_name_w', file_name_p, false);
        else
            generate_int_serial_number(0, current_setting('carestream_ris_japan_l10n_pck.file_seq_directory_w')::varchar(15), cd_establishment_p, nm_usuario_p, current_setting('carestream_ris_japan_l10n_pck.file_sequence_w')::smallint, current_setting('carestream_ris_japan_l10n_pck.interface_event_w')::integer);
            select carestream_japan_l10n_pck.get_file_name(current_setting('carestream_ris_japan_l10n_pck.cd_integartion_event_w')::philips_json.get['control_code'].value_of(), current_setting('carestream_ris_japan_l10n_pck.radiology_dept_code_w')::varchar(2), current_setting('carestream_ris_japan_l10n_pck.his_system_code')::varchar(2), current_setting('carestream_ris_japan_l10n_pck.file_sequence_w')::smallint)
            into STRICT current_setting('carestream_ris_japan_l10n_pck.data_file_name_w')::varchar(100)
;

        end if;

        -- it is helpful while resend the information
        PERFORM set_config('carestream_ris_japan_l10n_pck.ds_script_w', 'carestream_ris_japan_l10n_pck.patient_ward_transfer_info ('
                       || unique_key_p
                       || ', '''
                       || processing_type_p
                       || ''', '''
                       || ':nm_exec_user' 
                       || ''' , '
                       || ':nr_seq_int_call_log'
                       || ', '''
                       || current_setting('carestream_ris_japan_l10n_pck.data_file_name_w')::varchar(100)
                       || ''' ,'
                       || cd_establishment_p
                       || ', ''S'');', false);

        CALL CALL carestream_ris_japan_l10n_pck.perform_integration(unique_key_p, current_setting('carestream_ris_japan_l10n_pck.message_type_w')::varchar(2), nm_usuario_p, log_sequence_number_p, current_setting('carestream_ris_japan_l10n_pck.data_file_name_w')::varchar(100),
                            current_setting('carestream_ris_japan_l10n_pck.log_file_name_w')::varchar(100), cd_establishment_p, current_setting('carestream_ris_japan_l10n_pck.file_seq_directory_w')::varchar(15), current_setting('carestream_ris_japan_l10n_pck.cd_integartion_event_w')::philips_json, current_setting('carestream_ris_japan_l10n_pck.ds_message_w')::varchar(255),
                            current_setting('carestream_ris_japan_l10n_pck.ds_script_w')::integration_call_log.ds_resend_script%type, current_setting('carestream_ris_japan_l10n_pck.nm_interface_w')::varchar(255), current_setting('carestream_ris_japan_l10n_pck.interface_event_w')::integer, current_setting('carestream_ris_japan_l10n_pck.patient_mrn_w')::varchar(10), ie_retransmit_p);
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE carestream_ris_japan_l10n_pck.patient_ward_transfer_info ( unique_key_p bigint, processing_type_p text, nm_usuario_p text, log_sequence_number_p text default 0, file_name_p text default null, cd_establishment_p bigint default 1, ie_retransmit_p text  DEFAULT NULL) FROM PUBLIC;