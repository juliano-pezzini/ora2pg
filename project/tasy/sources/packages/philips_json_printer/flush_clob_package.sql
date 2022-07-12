-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE philips_json_printer.flush_clob (buf_lob INOUT text, buf_str INOUT text) AS $body$
BEGIN

    dbms_lob.writeappend(buf_lob, length(buf_str), buf_str);
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE philips_json_printer.flush_clob (buf_lob INOUT text, buf_str INOUT text) FROM PUBLIC;