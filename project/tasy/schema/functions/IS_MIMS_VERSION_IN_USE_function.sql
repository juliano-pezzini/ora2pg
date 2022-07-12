-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION is_mims_version_in_use () RETURNS bigint AS $body$
DECLARE

  ds_retorno_w bigint;

BEGIN
    SELECT Count(*) 
    INTO STRICT   ds_retorno_w 
    FROM   mims_version a 
    WHERE  a.ie_status IN ( 1, 2 );

    RETURN ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION is_mims_version_in_use () FROM PUBLIC;
