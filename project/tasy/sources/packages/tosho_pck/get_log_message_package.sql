-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

    
    /** 
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	create log message
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   **/
 


CREATE OR REPLACE FUNCTION tosho_pck.get_log_message (data_file_p text, message_type_p text, receiver_code_p text, sender_code_p text default 'AB') RETURNS varchar AS $body$
BEGIN
        PERFORM set_config('tosho_pck.ds_log_message_w', 'FileName = '||data_file_p||', '
                          ||'Interface Message Code ='|| message_type_p||', '
                          ||'Date of Transmission = '||to_char(clock_timestamp(),'dd/mm/yyyy')||', '
                          ||'Time of Transmission = '||to_char(clock_timestamp(),'hh24:mi:ss')||', '
                          ||'Own System Code = ' || sender_code_p ||', '
                          ||'Counterpart System code =' || receiver_code_p
                          ||'Log Message = information updated sucesfully', false);
        return current_setting('tosho_pck.ds_log_message_w')::varchar(32767);
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION tosho_pck.get_log_message (data_file_p text, message_type_p text, receiver_code_p text, sender_code_p text default 'AB') FROM PUBLIC;
