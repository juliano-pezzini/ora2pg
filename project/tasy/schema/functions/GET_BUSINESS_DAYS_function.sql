-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_business_days (p_start_date timestamp, p_end_date timestamp, p_establishment bigint default 1) RETURNS bigint AS $body$
DECLARE

    v_start_date timestamp;
    v_end_date timestamp;
    v_startW bigint;
    v_endW bigint;
    v_days bigint;
    v_result bigint := 0;
    v_holidays bigint := 0;
	v_ret      bigint := 0;

BEGIN
    v_start_date := trunc(p_start_date);
    v_end_date := trunc(p_end_date);

	if coalesce(v_start_date::text, '') = '' or coalesce(v_end_date::text, '') = '' then
        -- return v_result;
		v_result := 0;
    elsif v_start_date > v_end_date then
        -- return v_result;
		v_result := 0;
    end if;
    -- get the difference of days between dates
    v_days := (v_end_date - v_start_date) + 1;

	v_startW := (to_char(v_start_date,'D','nls_date_language=english'))::numeric;
    v_endW := (to_char(v_end_date,'D','nls_date_language=english'))::numeric;
	
    -- special case
    -- when the range of dates starts and ends in the same weekend
	if (v_days <= 2 and v_startW in (1,7) and v_endW in (1,7)) then
        -- return v_result;
		v_result := 0;
    end if;

    -- remove weekends
    v_result := v_days - (2 * trunc(v_days/7));
    -- deal with the remainder
    if mod(v_days,7) != 0 then
        -- if the date start or end on sunday (1)
        if (v_startW = 1) then
            v_result := v_result - 1;
        elsif (v_endW = 1) then
            v_result := v_result - 2;
        -- if the date end on saturday (7)
        elsif (v_endW = 7) then
            v_result := v_result - 1;
        -- if the end weekday is lower then the start weekday
        -- remove the weekend
        elsif (v_endW < v_startW) then
            v_result := v_result - 2;
        end if;
    end if;

    select count(*) 
    into STRICT v_holidays
    from feriado 
    where dt_feriado between v_start_date and v_end_date
    and cd_estabelecimento = p_establishment
    and (to_char(dt_feriado,'D','nls_date_language=english'))::numeric  not in (1,7);

    select ceil(v_result - v_holidays) into STRICT v_ret;
	
	return v_ret;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_business_days (p_start_date timestamp, p_end_date timestamp, p_establishment bigint default 1) FROM PUBLIC;
