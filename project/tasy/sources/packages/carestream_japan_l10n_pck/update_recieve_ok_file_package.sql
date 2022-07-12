-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

   
   /** 
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	For inbound message on Successfull update in tasy , move file to OK Folder
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   **/
CREATE OR REPLACE PROCEDURE carestream_japan_l10n_pck.update_recieve_ok_file (ds_file_p text, log_file_name_w text, message_type_p text) AS $body$
DECLARE

    cd_integartion_event_w philips_json;

BEGIN 
        select carestream_japan_l10n_pck.get_directory_event_code(message_type_p, null) into STRICT cd_integartion_event_w;

        CALL jpn_utl_file_pck.copy_file(cd_integartion_event_w.get['cd_event_index'].value_of(),ds_file_p,cd_integartion_event_w.get['cd_event_index_ok'].value_of(),ds_file_p,1,6); -- copying file from index folder to index_ok folder
        CALL jpn_utl_file_pck.delete_file(cd_integartion_event_w.get['cd_event_index'].value_of(),ds_file_p);

        CALL jpn_utl_file_pck.copy_file(cd_integartion_event_w.get['cd_event_data'].value_of(),ds_file_p,cd_integartion_event_w.get['cd_event_data_ok'].value_of(),ds_file_p,1,6);-- copying file from data folder to data_ok folder
        CALL jpn_utl_file_pck.delete_file(cd_integartion_event_w.get['cd_event_data'].value_of(),ds_file_p);

        PERFORM set_config('carestream_japan_l10n_pck.ds_log_message_w', 'Successfully processed and moved the file: '||ds_file_p||', '||'Time of Transmission = '||to_char(clock_timestamp(),'hh24:mi:ss'), false);
        CALL CALL carestream_japan_l10n_pck.save_log(cd_integartion_event_w.get['cd_event_log'].value_of(), log_file_name_w, current_setting('carestream_japan_l10n_pck.ds_log_message_w')::varchar(32767)); -- updating log file
   END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE carestream_japan_l10n_pck.update_recieve_ok_file (ds_file_p text, log_file_name_w text, message_type_p text) FROM PUBLIC;