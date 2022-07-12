-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_instrumentation.log_command (l_category text, l_group text, l_level bigint, l_text text) AS $body$
BEGIN
    CALL wheb_instrumentation.log_add(l_category, l_group, l_level, l_text, current_setting('wheb_instrumentation.type_command')::varchar(12));
  END;

  -- ERROR
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE wheb_instrumentation.log_command (l_category text, l_group text, l_level bigint, l_text text) FROM PUBLIC;
