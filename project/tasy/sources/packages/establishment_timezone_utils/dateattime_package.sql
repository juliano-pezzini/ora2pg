-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION establishment_timezone_utils.dateattime (datePart timestamp, timePart timestamp) RETURNS timestamp AS $body$
BEGIN
        return TIMEZONE_UTILS.dateAtTime(datePart, timePart, establishment_timezone_utils.gettimezone());
    end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION establishment_timezone_utils.dateattime (datePart timestamp, timePart timestamp) FROM PUBLIC;