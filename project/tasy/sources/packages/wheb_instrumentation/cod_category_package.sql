-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION wheb_instrumentation.cod_category () RETURNS varchar AS $body$
BEGIN
    IF current_setting('wheb_instrumentation.internal_definedcategory')::(varchar(30) IS NOT NULL AND (varchar(30))::text <> '') THEN
      RETURN current_setting('wheb_instrumentation.internal_definedcategory')::varchar(30);
    END IF;

    RETURN current_setting('wheb_instrumentation.default_category')::varchar(30);
  END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION wheb_instrumentation.cod_category () FROM PUBLIC;
