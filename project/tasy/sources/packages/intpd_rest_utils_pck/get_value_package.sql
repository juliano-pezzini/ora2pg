-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION intpd_rest_utils_pck.get_value (JSON_VALUE_P PHILIPS_JSON_VALUE) RETURNS varchar AS $body$
BEGIN
    IF ((JSON_VALUE_P IS NOT NULL AND JSON_VALUE_P::text <> '')
    AND JSON_VALUE_P.TYPEVAL BETWEEN 3 AND 5) THEN
       RETURN JSON_VALUE_P.VALUE_OF();
    ELSE
       RETURN NULL;
    END IF;
  END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION intpd_rest_utils_pck.get_value (JSON_VALUE_P PHILIPS_JSON_VALUE) FROM PUBLIC;