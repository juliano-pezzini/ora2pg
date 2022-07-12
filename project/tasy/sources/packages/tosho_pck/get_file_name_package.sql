-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



    
    /** 
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	create file name
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   **/
 


CREATE OR REPLACE FUNCTION tosho_pck.get_file_name (control_code text, receiver_code text, sender_code_p text, sequence_num_p text) RETURNS varchar AS $body$
DECLARE

   file_name_w varchar(100);


BEGIN
       file_name_w := 'H' || sender_code_p || receiver_code || control_code || to_char(clock_timestamp(), 'YYYYMMDD') || lpad(sequence_num_p,4,0) || '.dat';
       return file_name_w;
   END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION tosho_pck.get_file_name (control_code text, receiver_code text, sender_code_p text, sequence_num_p text) FROM PUBLIC;
