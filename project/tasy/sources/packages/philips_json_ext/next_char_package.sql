-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE philips_json_ext.next_char () AS $body$
BEGIN
      if (current_setting('philips_json_ext.indx')::bigint <= length(json_path)) then
        buf := substr(json_path, current_setting('philips_json_ext.indx')::bigint, 1);
        PERFORM set_config('philips_json_ext.indx', current_setting('philips_json_ext.indx')::bigint + 1, false);
      else
        buf := null;
      end if;
    end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE philips_json_ext.next_char () FROM PUBLIC;
