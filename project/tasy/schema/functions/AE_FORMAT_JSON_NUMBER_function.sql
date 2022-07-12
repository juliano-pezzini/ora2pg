-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ae_format_json_number (value_param bigint) RETURNS varchar AS $body$
DECLARE
 value_result varchar(40);

BEGIN
    IF (value_param IS NOT NULL AND value_param::text <> '') THEN
        RETURN TO_CHAR(value_param);
    ELSE
        RETURN 'null';
    END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ae_format_json_number (value_param bigint) FROM PUBLIC;

