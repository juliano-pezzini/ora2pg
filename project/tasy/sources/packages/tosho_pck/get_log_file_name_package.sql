-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION tosho_pck.get_log_file_name (control_code_p text , receiver_code_p text, sender_code_p text default 'AB', file_classification text default 'S') RETURNS varchar AS $body$
DECLARE

   file_name_w varchar(100) := null;

BEGIN
       file_name_w := 'H' || file_classification || sender_code_p || receiver_code_p || control_code_p || to_char(clock_timestamp(), 'YYYYMMDD') || '.log';
       return file_name_w;
   END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION tosho_pck.get_log_file_name (control_code_p text , receiver_code_p text, sender_code_p text default 'AB', file_classification text default 'S') FROM PUBLIC;