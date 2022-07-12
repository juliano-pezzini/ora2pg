-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



    	/** 
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Generate File with data
	file_name should be with extension
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	**/
 


CREATE OR REPLACE PROCEDURE carestream_japan_l10n_pck.generate_file (event_code_p bigint, file_name_p text, file_data_p text) AS $body$
DECLARE
 	

		qt_maximum_size_w	bigint	:= 32767;
		ie_windows_linux_w	varchar(2)	:= 'W';
	
BEGIN
        PERFORM set_config('carestream_japan_l10n_pck.ds_local_w', null, false);
        current_setting('carestream_japan_l10n_pck.ds_local_w')::varchar(100) := jpn_utl_file_pck.create_file(event_code_p, file_name_p, 'S', qt_maximum_size_w, current_setting('carestream_japan_l10n_pck.ds_local_w')::varchar(100), ie_windows_linux_w); -- Create the file
        CALL jpn_utl_file_pck.write_file(file_data_p); --Write the line in the file
        CALL jpn_utl_file_pck.close_file();  --Close the file and save
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE carestream_japan_l10n_pck.generate_file (event_code_p bigint, file_name_p text, file_data_p text) FROM PUBLIC;
