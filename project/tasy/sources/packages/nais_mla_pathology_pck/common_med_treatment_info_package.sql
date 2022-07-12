-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


       /** 
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	NAIS MLA Common Medical treatment details information
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	**/
CREATE OR REPLACE PROCEDURE nais_mla_pathology_pck.common_med_treatment_info ( r_c03 medtreatmentinforedtyp ) AS $body$
BEGIN
        if ( r_c03.nr_data_class = '04' ) then
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pathology_pck.append_text(r_c03.nr_data_class, 2, 'L', '0');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pathology_pck.append_text(r_c03.days, 2, 'L', '0');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pathology_pck.append_text(r_c03.times_num_04, 2, 'L', '0');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pathology_pck.append_text(r_c03.days_num, 2, 'L', '0');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pathology_pck.append_text(r_c03.digit_times_num, 3, 'L', '0');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pathology_pck.append_text(r_c03.digit_days_num, 3, 'L', '0');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pathology_pck.append_text(' ', 50);
        else
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pathology_pck.append_text(r_c03.nr_data_class, 2, 'R');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pathology_pck.append_text(r_c03.internal_code, 6, 'R');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pathology_pck.append_text(r_c03.dosage, 9, 'L', '0');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pathology_pck.append_text(r_c03.unit, 2, 'R');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pathology_pck.append_text(r_c03.times_num, 2, 'L', '0');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pathology_pck.append_text(r_c03.free_input_flag, 1, 'L', '0');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pathology_pck.append_text(r_c03.free_comments, 40, 'R');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pathology_pck.append_text(r_c03.med_change_impossible_flg, 1, 'R');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pathology_pck.append_text(r_c03.general_name_med_flg, 1, 'R');
        end if;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nais_mla_pathology_pck.common_med_treatment_info ( r_c03 medtreatmentinforedtyp ) FROM PUBLIC;