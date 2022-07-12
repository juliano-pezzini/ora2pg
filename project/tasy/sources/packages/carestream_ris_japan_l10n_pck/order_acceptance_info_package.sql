-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE carestream_ris_japan_l10n_pck.order_acceptance_info (file_name_p text) AS $body$
DECLARE


        processing_type_w        varchar(1);
        occurred_date_w          varchar(8);
        processing_date_time_w   varchar(14);
        order_number_w           varchar(14);
        sequence_number_w        varchar(10);
        acceptance_status_w      varchar(1);
        discontinue_reason_w     varchar(2);
        nm_usuario_w             varchar(255);
        patient_arrival_date_w   varchar(8);
        cd_establishment_w       varchar(8);
        file_name_like_w         varchar(8);
        message_char_w             varchar(32000);

BEGIN
        PERFORM set_config('carestream_ris_japan_l10n_pck.ds_local_w', null, false);
        PERFORM set_config('carestream_ris_japan_l10n_pck.initial_position_w', 1, false);
        PERFORM set_config('carestream_ris_japan_l10n_pck.patient_id_w', null, false);
        PERFORM set_config('carestream_ris_japan_l10n_pck.patient_mrn_w', null, false);
        nm_usuario_w := 'carestream_ris';
        PERFORM set_config('carestream_ris_japan_l10n_pck.nm_interface_w', 'Japan Carestream - RIS', false);
        PERFORM set_config('carestream_ris_japan_l10n_pck.ds_message_w', 'CareStream RIS - Order Acceptance Info', false);
        PERFORM set_config('carestream_ris_japan_l10n_pck.log_sequence_number_w', 0, false);

        select carestream_japan_l10n_pck.get_directory_event_code(null, 'CARE_RIS_CHECKIN')
        into STRICT   current_setting('carestream_ris_japan_l10n_pck.cd_integartion_event_w')::philips_json                       
;

        select carestream_japan_l10n_pck.get_log_file_name(current_setting('carestream_ris_japan_l10n_pck.cd_integartion_event_w')::philips_json.get['control_code'].value_of(),
                  current_setting('carestream_ris_japan_l10n_pck.his_system_code')::varchar(2), current_setting('carestream_ris_japan_l10n_pck.radiology_dept_code_w')::varchar(2), 'R')
        into STRICT current_setting('carestream_ris_japan_l10n_pck.log_file_name_w')::varchar(100)
;

        file_name_like_w := 'H'||current_setting('carestream_ris_japan_l10n_pck.radiology_dept_code_w')::varchar(2)||current_setting('carestream_ris_japan_l10n_pck.his_system_code')::varchar(2)||current_setting('carestream_ris_japan_l10n_pck.cd_integartion_event_w')::philips_json.get['control_code'].value_of();

        begin
            current_setting('carestream_ris_japan_l10n_pck.ds_local_w')::varchar(32767) := carestream_japan_l10n_pck.read_file(file_name_p, file_name_like_w, current_setting('carestream_ris_japan_l10n_pck.cd_integartion_event_w')::philips_json.get['cd_event_data'].value_of(), current_setting('carestream_ris_japan_l10n_pck.ds_local_w')::varchar(32767));
            select utl_i18n.raw_to_char(current_setting('carestream_ris_japan_l10n_pck.ds_local_w')::varchar(32767))
            into STRICT message_char_w
;

             --retriving the relevant field from the inbound message
            select
                utl_i18n.raw_to_char(utl_raw.substr(current_setting('carestream_ris_japan_l10n_pck.ds_local_w')::varchar(32767), carestream_ris_japan_l10n_pck.update_initial_position(current_setting('carestream_ris_japan_l10n_pck.initial_position_w')::integer, 0), 2), 'JA16SJIS'), -- 1 
                trim(both utl_i18n.raw_to_char(utl_raw.substr(current_setting('carestream_ris_japan_l10n_pck.ds_local_w')::varchar(32767), carestream_ris_japan_l10n_pck.update_initial_position(current_setting('carestream_ris_japan_l10n_pck.initial_position_w')::integer, 2), 8), 'JA16SJIS')),  --3
                (utl_i18n.raw_to_char(utl_raw.substr(current_setting('carestream_ris_japan_l10n_pck.ds_local_w')::varchar(32767), carestream_ris_japan_l10n_pck.update_initial_position(current_setting('carestream_ris_japan_l10n_pck.initial_position_w')::integer, 26), 1), 'JA16SJIS'))::numeric ,  --29
                trim(both utl_i18n.raw_to_char(utl_raw.substr(current_setting('carestream_ris_japan_l10n_pck.ds_local_w')::varchar(32767), carestream_ris_japan_l10n_pck.update_initial_position(current_setting('carestream_ris_japan_l10n_pck.initial_position_w')::integer, 1), 14), 'JA16SJIS')),  --30
                (utl_i18n.raw_to_char(utl_raw.substr(current_setting('carestream_ris_japan_l10n_pck.ds_local_w')::varchar(32767), carestream_ris_japan_l10n_pck.update_initial_position(current_setting('carestream_ris_japan_l10n_pck.initial_position_w')::integer, 14), 10), 'JA16SJIS'))::numeric ,  --44
                trim(both utl_i18n.raw_to_char(utl_raw.substr(current_setting('carestream_ris_japan_l10n_pck.ds_local_w')::varchar(32767), carestream_ris_japan_l10n_pck.update_initial_position(current_setting('carestream_ris_japan_l10n_pck.initial_position_w')::integer, 10), 8), 'JA16SJIS')),  --54
                (utl_i18n.raw_to_char(utl_raw.substr(current_setting('carestream_ris_japan_l10n_pck.ds_local_w')::varchar(32767), carestream_ris_japan_l10n_pck.update_initial_position(current_setting('carestream_ris_japan_l10n_pck.initial_position_w')::integer, 29), 14), 'JA16SJIS'))::numeric ,  --83
                (utl_i18n.raw_to_char(utl_raw.substr(current_setting('carestream_ris_japan_l10n_pck.ds_local_w')::varchar(32767), carestream_ris_japan_l10n_pck.update_initial_position(current_setting('carestream_ris_japan_l10n_pck.initial_position_w')::integer, 14), 10), 'JA16SJIS'))::numeric ,  --97
                trim(both utl_i18n.raw_to_char(utl_raw.substr(current_setting('carestream_ris_japan_l10n_pck.ds_local_w')::varchar(32767), carestream_ris_japan_l10n_pck.update_initial_position(current_setting('carestream_ris_japan_l10n_pck.initial_position_w')::integer, 33), 1), 'JA16SJIS')),  -- 130
                trim(both utl_i18n.raw_to_char(utl_raw.substr(current_setting('carestream_ris_japan_l10n_pck.ds_local_w')::varchar(32767), carestream_ris_japan_l10n_pck.update_initial_position(current_setting('carestream_ris_japan_l10n_pck.initial_position_w')::integer, 1), 2), 'JA16SJIS')) -- 131
            into STRICT
                current_setting('carestream_ris_japan_l10n_pck.message_type_w')::varchar(2),
                patient_arrival_date_w,
                processing_type_w,
                processing_date_time_w,
                current_setting('carestream_ris_japan_l10n_pck.patient_mrn_w')::varchar(10),
                occurred_date_w,
                order_number_w,
                sequence_number_w,
                acceptance_status_w,
                discontinue_reason_w
;
        exception
            when others then
                CALL carestream_japan_l10n_pck.update_recieve_error_file(file_name_p, current_setting('carestream_ris_japan_l10n_pck.log_file_name_w')::varchar(100), current_setting('carestream_ris_japan_l10n_pck.message_type_w')::varchar(2));
                PERFORM set_config('carestream_ris_japan_l10n_pck.ds_log_message_w', 'Error occured while reading the integration message for order_acceptance_info'
                                    ||  chr(10)
                                    || 'Integration name : japan_carestream_ris(order_acceptance_info)'
                                    || chr(10)
                                    || 'Message Type:'
                                    || current_setting('carestream_ris_japan_l10n_pck.message_type_w')::varchar(2)
                                    || chr(10)
                                    || 'Time of faliure : '
                                    || clock_timestamp() || chr(10)
                                    || 'Patient MRN:'
                                    || current_setting('carestream_ris_japan_l10n_pck.patient_mrn_w')::varchar(10) || chr(10)
                                    ||' -ERROR- '
                                    || SQLERRM, false);

                record_integration_call_log(nm_usuario_w, nm_usuario_w, clock_timestamp(), current_setting('carestream_ris_japan_l10n_pck.nm_interface_w')::varchar(255), current_setting('carestream_ris_japan_l10n_pck.ds_message_w')::varchar(255),
                                            'F', 'R', null, current_setting('carestream_ris_japan_l10n_pck.ds_log_message_w')::varchar(32767), message_char_w,
                                            current_setting('carestream_ris_japan_l10n_pck.ds_log_message_w')::varchar(32767), file_name_p, current_setting('carestream_ris_japan_l10n_pck.log_sequence_number_w')::integration_message_log.nr_seq_int_call_log%type, current_setting('carestream_ris_japan_l10n_pck.patient_mrn_w')::varchar(10), null);

                CALL carestream_japan_l10n_pck.save_log(current_setting('carestream_ris_japan_l10n_pck.cd_integartion_event_w')::philips_json.get['cd_event_log'].value_of(), current_setting('carestream_ris_japan_l10n_pck.log_file_name_w')::varchar(100), current_setting('carestream_ris_japan_l10n_pck.ds_log_message_w')::varchar(32767));
                return;
          end;

            if (discontinue_reason_w IS NOT NULL AND discontinue_reason_w::text <> '') then
                discontinue_reason_w := (discontinue_reason_w)::numeric;
            end if;

         -- processing the inbound message and updating it in tasy 
            select  coalesce(max(a.cd_estabelecimento),obter_estabelecimento_ativo)
            into STRICT    cd_establishment_w
            from    prescr_medica b,
                    atendimento_paciente a
            where   a.nr_atendimento = b.nr_atendimento
            and     b.nr_prescricao = order_number_w;

            select
                obter_paciente_prontuario(current_setting('carestream_ris_japan_l10n_pck.patient_mrn_w')::varchar(10), 'C')
            into STRICT current_setting('carestream_ris_japan_l10n_pck.patient_id_w')::varchar(10)
;
         -- update info in tasy
            begin
                if ( current_setting('carestream_ris_japan_l10n_pck.message_type_w')::varchar(2) = '2R' and acceptance_status_w = '9') then
                    CALL gerar_cancelamento_exame(order_number_w, sequence_number_w, discontinue_reason_w, 'C', nm_usuario_w);
                    CALL carestream_japan_l10n_pck.update_exam_execution_status(order_number_w, sequence_number_w, '1', nm_usuario_w);
                elsif (current_setting('carestream_ris_japan_l10n_pck.message_type_w')::varchar(2) = '2Q' and acceptance_status_w = '0') then
                    CALL atualizar_status_prep_prescr(order_number_w, sequence_number_w, 'S', nm_usuario_w, cd_establishment_w,
                                                 to_date(processing_date_time_w,'YYYYMMDDhh24miss'), null);
                    CALL carestream_japan_l10n_pck.update_exam_execution_status(order_number_w, sequence_number_w,'7' , nm_usuario_w);
                end if;
             exception
                when others then
                    CALL carestream_japan_l10n_pck.update_recieve_error_file(file_name_p, current_setting('carestream_ris_japan_l10n_pck.log_file_name_w')::varchar(100), current_setting('carestream_ris_japan_l10n_pck.message_type_w')::varchar(2));
                    PERFORM set_config('carestream_ris_japan_l10n_pck.ds_log_message_w', 'Error occured while updating the information for order_acceptance_info in tasy'
                                        || chr(10)
                                        || 'Integration name : japan_carestream_ris(order_acceptance_info)'
                                        || chr(10)
                                        || 'Message Type:'
                                        || current_setting('carestream_ris_japan_l10n_pck.message_type_w')::varchar(2)
                                        || chr(10)
                                        || 'Time of faliure : '
                                        || clock_timestamp() || chr(10)
                                        || 'Patient MRN:'
                                        || current_setting('carestream_ris_japan_l10n_pck.patient_mrn_w')::varchar(10) || chr(10)
                                        ||' -ERROR- '
                                        || SQLERRM, false);

                    record_integration_call_log(nm_usuario_w, nm_usuario_w, clock_timestamp(), current_setting('carestream_ris_japan_l10n_pck.nm_interface_w')::varchar(255), current_setting('carestream_ris_japan_l10n_pck.ds_message_w')::varchar(255),
                                                'F', 'R', null, current_setting('carestream_ris_japan_l10n_pck.ds_log_message_w')::varchar(32767), message_char_w,
                                                current_setting('carestream_ris_japan_l10n_pck.ds_log_message_w')::varchar(32767), file_name_p, current_setting('carestream_ris_japan_l10n_pck.log_sequence_number_w')::integration_message_log.nr_seq_int_call_log%type, current_setting('carestream_ris_japan_l10n_pck.patient_mrn_w')::varchar(10), null);

                    CALL carestream_japan_l10n_pck.save_log(current_setting('carestream_ris_japan_l10n_pck.cd_integartion_event_w')::philips_json.get['cd_event_log'].value_of(), current_setting('carestream_ris_japan_l10n_pck.log_file_name_w')::varchar(100), current_setting('carestream_ris_japan_l10n_pck.ds_log_message_w')::varchar(32767));
                    return;
                end;

            -- if file succcessfully read and info saved in tasy,calling function to move the file to repective ok folder from data and index folder
            CALL carestream_japan_l10n_pck.update_recieve_ok_file(file_name_p, current_setting('carestream_ris_japan_l10n_pck.log_file_name_w')::varchar(100), current_setting('carestream_ris_japan_l10n_pck.message_type_w')::varchar(2));

            PERFORM set_config('carestream_ris_japan_l10n_pck.ds_log_message_w', 'Information for order Acceptance  is successfully updated in Tasy'
                                        || chr(10)
                                        || 'Integration name : japan_carestream_ris(order_acceptance_info)'
                                        || chr(10)
                                        || 'Message Type: '
                                        || current_setting('carestream_ris_japan_l10n_pck.message_type_w')::varchar(2)
                                        || chr(10)
                                        || 'Time of Success : '
                                        || clock_timestamp() || chr(10)
                                        || 'Patient MRN:'
                                        || current_setting('carestream_ris_japan_l10n_pck.patient_mrn_w')::varchar(10) , false);

            record_integration_call_log(nm_usuario_w, nm_usuario_w, clock_timestamp(), current_setting('carestream_ris_japan_l10n_pck.nm_interface_w')::varchar(255), current_setting('carestream_ris_japan_l10n_pck.ds_message_w')::varchar(255),
                                        'S', 'R', null, current_setting('carestream_ris_japan_l10n_pck.ds_log_message_w')::varchar(32767), message_char_w,
                                        null, file_name_p, current_setting('carestream_ris_japan_l10n_pck.log_sequence_number_w')::integration_message_log.nr_seq_int_call_log%type, current_setting('carestream_ris_japan_l10n_pck.patient_mrn_w')::varchar(10), null);
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE carestream_ris_japan_l10n_pck.order_acceptance_info (file_name_p text) FROM PUBLIC;
