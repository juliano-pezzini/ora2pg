-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION esc_snappeii_befins_md_pck.obter_score_pto_snap_ii_md (qt_pto_rel_po2_fio2_p bigint, qt_pto_pam_p bigint, qt_pto_temp_p bigint, qt_pto_ph_serico_p bigint, qt_pto_diurese_p bigint, qt_pto_convul_p bigint ) RETURNS bigint AS $body$
DECLARE

		qt_snap_ii_w bigint := 0;
	
BEGIN
    qt_snap_ii_w := coalesce(qt_pto_rel_po2_fio2_p,0)	+
                    coalesce(qt_pto_pam_p,0)	        + 
                    coalesce(qt_pto_temp_p,0)	        +  
                    coalesce(qt_pto_ph_serico_p,0)	+ 
                    coalesce(qt_pto_diurese_p,0	)	+ 
                    coalesce(qt_pto_convul_p,0);

		return coalesce(qt_snap_ii_w,0);
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION esc_snappeii_befins_md_pck.obter_score_pto_snap_ii_md (qt_pto_rel_po2_fio2_p bigint, qt_pto_pam_p bigint, qt_pto_temp_p bigint, qt_pto_ph_serico_p bigint, qt_pto_diurese_p bigint, qt_pto_convul_p bigint ) FROM PUBLIC;