-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION timezone_utils.truncwithtz (dateTime timestamp, timeZone text, field text, lastInstant boolean DEFAULT false) RETURNS timestamp AS $body$
DECLARE

        withTimeZone timestamp;
        truncated timestamp;

BEGIN
        withTimeZone := timezone_utils.converttimezone(dateTime, timezone_utils.getbaselinetimezone(), timeZone);
        truncated := trunc(withTimeZone, field);
        if (lastInstant) then
            case field
                when 'DD' then truncated := truncated + interval '1' day;
                when 'MM' then truncated := truncated + interval '1' month;
                when 'YY' then truncated := truncated + interval '1' year;
            end case;
            truncated := truncated - interval '1' second;
        end if;
        return timezone_utils.converttimezone(truncated, timeZone, timezone_utils.getbaselinetimezone());
    end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION timezone_utils.truncwithtz (dateTime timestamp, timeZone text, field text, lastInstant boolean DEFAULT false) FROM PUBLIC;