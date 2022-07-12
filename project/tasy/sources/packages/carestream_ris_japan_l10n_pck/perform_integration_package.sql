-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE carestream_ris_japan_l10n_pck.perform_integration ( unique_key_p text, message_type_p text, nm_usuario_p text default 'carestream_ris', log_sequence_number_p bigint DEFAULT NULL, data_file_name_p text DEFAULT NULL, log_file_name_p text DEFAULT NULL, cd_establishment_p text DEFAULT NULL, file_seq_directory_p text DEFAULT NULL, cd_integartion_event_w philips_json DEFAULT NULL, message_info_p text DEFAULT NULL, ds_script_p text DEFAULT NULL, nm_interface_p text default 'japan_carestream_ris', interface_event_p bigint default 0, patient_mrn_p text default null, ie_retransmit_p text default 'N') AS $body$
BEGIN
        PERFORM set_config('carestream_ris_japan_l10n_pck.log_sequence_number_w', log_sequence_number_p, false);	
        --for resend need to delete the file from index_err and data_err folder
        if ( log_sequence_number_p > 0 and ie_retransmit_p = 'S') then
            begin
                CALL carestream_japan_l10n_pck.delete_error_file(data_file_name_p, log_file_name_p, message_type_p);
            exception
                when others then
                    PERFORM set_config('carestream_ris_japan_l10n_pck.ds_log_message_w', 'Error occured while deleting the file from error folder  for'
                                        || message_info_p
                                        || '.'
                                        || chr(10)
                                        || 'Integration name - japan_carestream_ris('
                                        || message_info_p
                                        || ').'
                                        || chr(10)
                                        || 'Message Type:'
                                        || message_type_p
                                        || chr(10)
                                        || 'Time of faliure : '
                                        || clock_timestamp()
                                        || chr(10)
                                        || 'Patient MRN:'
                                        || patient_mrn_p
                                        || chr(10)
                                        || 'file Name :'
                                        || data_file_name_p, false);

                    record_integration_call_log(nm_usuario_p, nm_usuario_p, clock_timestamp(), nm_interface_p, message_info_p,
                                                'E', 'E', null, current_setting('carestream_ris_japan_l10n_pck.ds_log_message_w')::varchar(32767), current_setting('carestream_ris_japan_l10n_pck.ds_line_w')::varchar(32767),
                                                current_setting('carestream_ris_japan_l10n_pck.ds_log_message_w')::varchar(32767), data_file_name_p, current_setting('carestream_ris_japan_l10n_pck.log_sequence_number_w')::integration_message_log.nr_seq_int_call_log%type, patient_mrn_p, interface_event_p);
            end;
        end if;

        begin
        -- generate the message file in data folder
            CALL carestream_japan_l10n_pck.generate_file(current_setting('carestream_ris_japan_l10n_pck.cd_integartion_event_w')::philips_json.get['cd_event_data'].value_of(), data_file_name_p, current_setting('carestream_ris_japan_l10n_pck.ds_line_w')::varchar(32767));	
		-- on success message file in data folder update in file in index folder		
            CALL carestream_japan_l10n_pck.generate_file(current_setting('carestream_ris_japan_l10n_pck.cd_integartion_event_w')::philips_json.get['cd_event_index'].value_of(), data_file_name_p, data_file_name_p);

        exception
            when others then
                PERFORM set_config('carestream_ris_japan_l10n_pck.ds_log_message_w', 'File generation failed for data and index folder.'
                                    || chr(10)
                                    || 'Integration name - japan_carestream_ris('
                                    || message_info_p
                                    || ').'
                                    || chr(10)
                                    || 'Message Type:'
                                    || message_type_p
                                    || chr(10)
                                    || 'Time of faliure : '
                                    || clock_timestamp()
                                    || chr(10)
                                    || 'Patient MRN :'
                                    || patient_mrn_p
                                    || chr(10)
                                    || 'file Name'
                                    || data_file_name_p, false);

                record_integration_call_log(nm_usuario_p, nm_usuario_p, clock_timestamp(), nm_interface_p, message_info_p,
                                            'E', 'E', null, current_setting('carestream_ris_japan_l10n_pck.ds_log_message_w')::varchar(32767), current_setting('carestream_ris_japan_l10n_pck.ds_line_w')::varchar(32767),
                                            current_setting('carestream_ris_japan_l10n_pck.ds_log_message_w')::varchar(32767), data_file_name_p, current_setting('carestream_ris_japan_l10n_pck.log_sequence_number_w')::integration_message_log.nr_seq_int_call_log%type, patient_mrn_p, interface_event_p);

                CALL carestream_japan_l10n_pck.save_log(current_setting('carestream_ris_japan_l10n_pck.cd_integartion_event_w')::philips_json.get['cd_event_log'].value_of(), log_file_name_p, current_setting('carestream_ris_japan_l10n_pck.ds_log_message_w')::varchar(32767)
                );
                return;

        end;

        -- Updating Tasy Log in 
        PERFORM set_config('carestream_ris_japan_l10n_pck.ds_log_message_w', 'File successfully uploaded to data and index folder.'
                                    || chr(10)
                                    || 'Integration name - japan_carestream_ris('
                                    || message_info_p
                                    || ').'
                                    || chr(10)
                                    || 'Message Type:'
                                    || message_type_p
                                    || chr(10)
                                    || 'Time of upload : '
                                    || clock_timestamp()
                                    || chr(10)
                                    || 'Patient MRN :'
                                    || patient_mrn_p
                                    || chr(10)
                                    || 'File Name :'
                                    || data_file_name_p, false);
        record_integration_call_log(nm_usuario_p, nm_usuario_p, clock_timestamp(), nm_interface_p, message_info_p,
                                    'T', 'E', ds_script_p, current_setting('carestream_ris_japan_l10n_pck.ds_log_message_w')::varchar(32767), current_setting('carestream_ris_japan_l10n_pck.ds_line_w')::varchar(32767),
                                    null, data_file_name_p, current_setting('carestream_ris_japan_l10n_pck.log_sequence_number_w')::integration_message_log.nr_seq_int_call_log%type, patient_mrn_p, interface_event_p);

		-- update log file
        select
            carestream_japan_l10n_pck.get_log_message(data_file_name_p, message_type_p, current_setting('carestream_ris_japan_l10n_pck.radiology_dept_code_w')::varchar(2))
        into STRICT current_setting('carestream_ris_japan_l10n_pck.ds_log_message_w')::varchar(32767)
;

        CALL carestream_japan_l10n_pck.save_log(current_setting('carestream_ris_japan_l10n_pck.cd_integartion_event_w')::philips_json.get['cd_event_log'].value_of(), log_file_name_p, current_setting('carestream_ris_japan_l10n_pck.ds_log_message_w')::varchar(32767)
        );

    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE carestream_ris_japan_l10n_pck.perform_integration ( unique_key_p text, message_type_p text, nm_usuario_p text default 'carestream_ris', log_sequence_number_p bigint DEFAULT NULL, data_file_name_p text DEFAULT NULL, log_file_name_p text DEFAULT NULL, cd_establishment_p text DEFAULT NULL, file_seq_directory_p text DEFAULT NULL, cd_integartion_event_w philips_json DEFAULT NULL, message_info_p text DEFAULT NULL, ds_script_p text DEFAULT NULL, nm_interface_p text default 'japan_carestream_ris', interface_event_p bigint default 0, patient_mrn_p text default null, ie_retransmit_p text default 'N') FROM PUBLIC;
