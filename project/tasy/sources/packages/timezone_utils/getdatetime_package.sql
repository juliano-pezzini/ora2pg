-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION timezone_utils.getdatetime (dateTime timestamp, timeZone text) RETURNS timestamp AS $body$
BEGIN
        if (not timezone_utils.hasbaselinetimezone()) then
            return dateTime;
        end if;
        return timezone_utils.converttimezone(dateTime, timezone_utils.getbaselinetimezone(), timeZone);
    end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION timezone_utils.getdatetime (dateTime timestamp, timeZone text) FROM PUBLIC;