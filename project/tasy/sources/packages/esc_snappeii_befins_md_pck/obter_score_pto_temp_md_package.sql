-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION esc_snappeii_befins_md_pck.obter_score_pto_temp_md (qt_temp_p bigint ) RETURNS bigint AS $body$
DECLARE

		qt_pto_temp_w bigint;
	
BEGIN
		if (coalesce(qt_temp_p::text, '') = '') then
			qt_pto_temp_w:= 0;
		elsif (qt_temp_p < 35) then
			qt_pto_temp_w:= 15;
		elsif (qt_temp_p >= 35) and (qt_temp_p <= 35.6) then
			qt_pto_temp_w:= 8;
		elsif (qt_temp_p > 35.6) then
			qt_pto_temp_w:= 0;
		end if;

		return coalesce(qt_pto_temp_w,0);
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION esc_snappeii_befins_md_pck.obter_score_pto_temp_md (qt_temp_p bigint ) FROM PUBLIC;
