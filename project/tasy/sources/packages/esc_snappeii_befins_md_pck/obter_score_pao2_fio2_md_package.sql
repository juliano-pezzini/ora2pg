-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION esc_snappeii_befins_md_pck.obter_score_pao2_fio2_md (qt_rel_po2_fio2_p bigint ) RETURNS bigint AS $body$
DECLARE

		qt_pto_rel_po2_fio2_w bigint;
	
BEGIN
		if (qt_rel_po2_fio2_p >= 1) and (qt_rel_po2_fio2_p <= 2.49) then
			qt_pto_rel_po2_fio2_w:= 5;
		elsif (qt_rel_po2_fio2_p >= 0.3) and (qt_rel_po2_fio2_p < 1) then
			qt_pto_rel_po2_fio2_w:= 16;
		elsif (qt_rel_po2_fio2_p < 0.3) then
			qt_pto_rel_po2_fio2_w:= 28;
		elsif (qt_rel_po2_fio2_p > 2.49) then
			qt_pto_rel_po2_fio2_w:= 0;
		end if;

		return coalesce(qt_pto_rel_po2_fio2_w,0);
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION esc_snappeii_befins_md_pck.obter_score_pao2_fio2_md (qt_rel_po2_fio2_p bigint ) FROM PUBLIC;