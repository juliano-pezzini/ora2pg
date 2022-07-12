-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION esc_snappeii_befins_md_pck.obter_score_pto_ph_serico_md (qt_ph_serico_p bigint ) RETURNS bigint AS $body$
DECLARE

		qt_pto_ph_serico_w bigint;
	
BEGIN
		if (coalesce(qt_ph_serico_p::text, '') = '') then
			qt_pto_ph_serico_w:= 0;
		elsif (qt_ph_serico_p < 7.1) then
			qt_pto_ph_serico_w:= 16;
		elsif (qt_ph_serico_p >= 7.1) and (qt_ph_serico_p <= 7.19) then
			qt_pto_ph_serico_w:= 7;
		elsif (qt_ph_serico_p >= 7.2) then
			qt_pto_ph_serico_w:= 0;
		end if;

		return coalesce(qt_pto_ph_serico_w,0);
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION esc_snappeii_befins_md_pck.obter_score_pto_ph_serico_md (qt_ph_serico_p bigint ) FROM PUBLIC;