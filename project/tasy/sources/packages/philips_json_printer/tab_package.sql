-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION philips_json_printer.tab (indent bigint, spaces boolean) RETURNS varchar AS $body$
DECLARE

    i varchar(200) := '';

BEGIN
    if (not spaces) then return ''; end if;
    for x in 1 .. indent loop i := i || current_setting('philips_json_printer.indent_string')::varchar(10); end loop;
    return i;
  end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION philips_json_printer.tab (indent bigint, spaces boolean) FROM PUBLIC;