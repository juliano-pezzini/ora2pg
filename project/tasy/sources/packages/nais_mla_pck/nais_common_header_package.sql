-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


    /** 
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	NAIS MLA Common Header
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	**/
CREATE OR REPLACE PROCEDURE nais_mla_pck.nais_common_header ( message_type_p text, nr_prescricao_p bigint, cd_classif_p text, cd_contin_flag_p text, cd_estab_p text, nr_tele_length_p bigint, nr_seq_evento_p bigint ) AS $body$
DECLARE


        c01 CURSOR FOR
        SELECT
            'H' system_code,
            message_type_p     message_type,
            cd_contin_flag_p   continuation_flag,
            'M' destination_code,
            'D' origin_code,
            clock_timestamp()            processing_date,
            clock_timestamp()            processing_time,
            'TASY' workstation_name,
            ' ' user_number,
            cd_classif_p  processing_classification,
            ' ' response_type,
            nr_tele_length_p message_length,
            ' ' eot,
            '01' medical_institution_code,
            ' ' blank
;


BEGIN
        PERFORM set_config('nais_mla_pck.nm_usuario_w', coalesce(wheb_usuario_pck.get_nm_usuario, current_setting('nais_mla_pck.nm_usuario_w')::varchar(20)), false);
        generate_int_serial_number(nr_prescricao_p, message_type_p, cd_estab_p, current_setting('nais_mla_pck.nm_usuario_w')::varchar(20), current_setting('nais_mla_pck.filename_sequence_w')::varchar(255),
                                   nr_seq_evento_p);
        for r_c01 in c01 loop begin
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pck.append_text(to_char(current_setting('nais_mla_pck.filename_sequence_w')::varchar(255)), 5, 'L', '0');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pck.append_text(r_c01.system_code, 1, 'R');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pck.append_text(r_c01.message_type, 2, 'R');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pck.append_text(r_c01.continuation_flag, 1, 'R');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pck.append_text(r_c01.destination_code, 1, 'R');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pck.append_text(r_c01.origin_code, 1, 'R');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pck.append_text(to_char(r_c01.processing_date, 'YYYYMMDD'), 8, 'L', '0');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pck.append_text(to_char(r_c01.processing_time, 'HH24MISS'), 6, 'L', '0');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pck.append_text(r_c01.workstation_name, 8, 'R');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pck.append_text(current_setting('nais_mla_pck.nm_usuario_w')::varchar(20), 8, 'R');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pck.append_text(r_c01.processing_classification, 2, 'R');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pck.append_text(r_c01.response_type, 2, 'R');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pck.append_text(r_c01.message_length, 5, 'L', '0');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pck.append_text(r_c01.eot, 1, 'R');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pck.append_text(r_c01.medical_institution_code, 2, 'R');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pck.append_text(r_c01.blank, 11, 'R');
        end;
        end loop;

    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nais_mla_pck.nais_common_header ( message_type_p text, nr_prescricao_p bigint, cd_classif_p text, cd_contin_flag_p text, cd_estab_p text, nr_tele_length_p bigint, nr_seq_evento_p bigint ) FROM PUBLIC;
