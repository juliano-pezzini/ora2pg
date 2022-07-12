-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pfcs_pck_communications.format_message (ds_message_p text, ds_macro_p text, ds_value_p text) RETURNS varchar AS $body$
DECLARE

        ds_formatted_message_w          pfcs_communication_rule.ds_email_communication%type;

BEGIN
        select  replace(ds_message_p, ds_macro_p, ds_value_p)
          into STRICT  ds_formatted_message_w
;
        return ds_formatted_message_w;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pfcs_pck_communications.format_message (ds_message_p text, ds_macro_p text, ds_value_p text) FROM PUBLIC;