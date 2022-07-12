-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE nais_nutrition_pck.nais_common_header ( message_type_p text, cd_classif_p text, cd_contin_flag_p text, cd_estab_p text, nr_tele_length_p bigint ) AS $body$
DECLARE

    c01 CURSOR FOR
        SELECT 'H' system_code,
			message_type_p message_type,
			cd_contin_flag_p continuation_flag,
			'M' destination_code,
			'D' origin_code,
			clock_timestamp() processing_date,
			clock_timestamp() processing_time,
			' ' workstation_name,
			' ' user_number,
			cd_classif_p processing_classification,
			' ' response_type,
			nr_tele_length_p message_length,
			' ' eot,
			' ' medical_institution_code,
			' ' blank
;

BEGIN
    PERFORM set_config('nais_nutrition_pck.ds_line_w', null, false);
    generate_int_serial_number(1, message_type_p, cd_estab_p, current_setting('nais_nutrition_pck.nm_usuario_w')::varchar(20), current_setting('nais_nutrition_pck.filename_sequence_w')::varchar(255),162);
    for r_c01 in c01
    loop
        begin
			CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_nutrition_pck.append_text(to_char(current_setting('nais_nutrition_pck.filename_sequence_w')::varchar(255)), 5, 'L', '0');
			CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_nutrition_pck.append_text(r_c01.system_code, 1, 'R', ' ');
			CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_nutrition_pck.append_text(r_c01.message_type, 2, 'R', ' ');
			CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_nutrition_pck.append_text(r_c01.continuation_flag, 1, 'R', ' ');
			CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_nutrition_pck.append_text(r_c01.destination_code, 1, 'R', ' ');
			CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_nutrition_pck.append_text(r_c01.origin_code, 1, 'R', ' ');
			CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_nutrition_pck.append_text(to_char(r_c01.processing_date, 'yyyymmdd'), 8, 'L', '0');
			CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_nutrition_pck.append_text(to_char(r_c01.processing_time,'hh24miss'),6, 'L', '0');
			CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_nutrition_pck.append_text(r_c01.workstation_name, 8, 'R', ' ');
			CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_nutrition_pck.append_text(r_c01.user_number, 8, 'R', ' ');
			CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_nutrition_pck.append_text(r_c01.processing_classification, 2, 'R', ' ');
			CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_nutrition_pck.append_text(r_c01.response_type, 2, 'R', ' ');
			CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_nutrition_pck.append_text(r_c01.message_length, 5, 'L', '0');
			CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_nutrition_pck.append_text(r_c01.eot, 1, 'R', ' ');
			CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_nutrition_pck.append_text(r_c01.medical_institution_code, 2, 'R', ' ');
			CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_nutrition_pck.append_text(r_c01.blank, 11, 'R', ' ');
        end;
    end loop;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nais_nutrition_pck.nais_common_header ( message_type_p text, cd_classif_p text, cd_contin_flag_p text, cd_estab_p text, nr_tele_length_p bigint ) FROM PUBLIC;
