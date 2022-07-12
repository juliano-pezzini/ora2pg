-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



    /** 
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	NAIS MLA Common Execution information
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	**/
CREATE OR REPLACE PROCEDURE nais_mla_treatunexe.common_execution_info ( r_c02 execinforedtyp ) AS $body$
BEGIN
        CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_treatunexe.append_text(r_c02.execution_classification, 1, 'L');
        CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_treatunexe.append_text(r_c02.execution_date, 8, 'L', '0');
        CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_treatunexe.append_text(r_c02.execution_time, 4, 'L', '0');
        CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_treatunexe.append_text(r_c02.execution_op_code, 3, 'L');
        CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_treatunexe.append_text(r_c02.execution_up_flag, 1, 'L');
        CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_treatunexe.append_text(r_c02.execution_weight, 6, 'L');
        CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_treatunexe.append_text(r_c02.out_of_hours_flag, 1, 'L');
        CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_treatunexe.append_text(r_c02.execution_blank, 8, 'R', ' ');
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nais_mla_treatunexe.common_execution_info ( r_c02 execinforedtyp ) FROM PUBLIC;
