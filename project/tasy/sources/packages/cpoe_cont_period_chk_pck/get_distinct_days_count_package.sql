-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION cpoe_cont_period_chk_pck.get_distinct_days_count ( dt_start_p timestamp, dt_end_p timestamp) RETURNS bigint AS $body$
BEGIN
	
		if (coalesce(dt_start_p::text, '') = '' or coalesce(dt_end_p::text, '') = '') then
			return 0;
		end if;
			
		return ceil(trunc(dt_end_p) - trunc(dt_start_p));
		
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_cont_period_chk_pck.get_distinct_days_count ( dt_start_p timestamp, dt_end_p timestamp) FROM PUBLIC;
