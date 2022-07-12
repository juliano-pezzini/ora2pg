-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


	/** 
   +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Common Header among Systems
	unique_key :- prescription number / encounter number
	message type:- 1D -> Order Request confirm information
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   **/
CREATE OR REPLACE PROCEDURE carestream_ris_japan_l10n_pck.common_header ( unique_key_p text, sequence_number_p bigint, file_sequence_p bigint ) AS $body$
DECLARE


        c05 CURSOR FOR
        SELECT
            b.patient_id                    patient_id,
            obter_prontuario_paciente(b.patient_id) patient_mrn,
            a.release_date_time             order_date,
            a.prescription_number           prescription_number,
            b.encounter_id                  encounter_number,
            null unique_id,
            'F0'||to_char(clock_timestamp(), 'YYMMDD')|| lpad(file_sequence_p, 5, '0') ||'00' accession_number,
            coalesce(CASE WHEN b.type_encounter_id=1 THEN  2 WHEN b.type_encounter_id=8 THEN  1 END , 1) encounter_type,
            b.department_id                 department_code,
            b.department_name               department_name,
            b.room_id                       ward_code,
            b.bed_id                        ward_name,
            b.encounter_doctor_id           requested_physician_id,
            (SELECT p.DS_GIVEN_NAME || ' ' || p.DS_FAMILY_NAME from person_name p, pessoa_fisica ps where p.DS_TYPE = 'translated' and p.nr_sequencia = ps.nr_seq_person_name and ps.cd_pessoa_fisica = b.encounter_doctor_id) requested_physician_kana,
            b.encounter_doctor_given_name   requested_physician_name,
            (select coalesce(max(ps.nr_telefone_celular), 0) from pessoa_fisica ps where ps.cd_pessoa_fisica = b.encounter_doctor_id)  requested_physician_phone_num,
            b.encouter_admit_date           request_date,
            coalesce(a.suspended_time , c.dt_cancelamento)     discontinue_date,
            CASE WHEN coalesce(coalesce(a.suspended_time, c.dt_cancelamento)::text, '') = '' THEN ' '  ELSE '0' END      discontinue_reason  -- 0: Stop 1: Stop for change 2: New by change
        from
            bft_order_v                a,
            bft_encounter_v            b,
            prescr_procedimento   c
        where
            a.encounter_id = b.encounter_id
            and a.prescription_number = c.nr_prescricao
            and a.prescription_number = unique_key_p
            and c.nr_sequencia = sequence_number_p  LIMIT 1;


BEGIN
        for r_c05 in c05 loop
            begin
				-- Order KEY  information
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(r_c05.patient_mrn, 10, 'L', '0'); -- PT_ID
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(to_char(r_c05.order_date, 'YYYYMMDD'), 8, 'L'); -- HASSEI_DATE
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(to_char(r_c05.order_date, 'HH24MISS'), 6, 'L'); -- SEQ_NO
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(' ', 4, 'L'); -- WS_NO,
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text('2', 1, 'L'); --INDEX_KBN
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text('16', 2, 'L'); --XX_KBN
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(' ', 3, 'L'); --XX_SYBT
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(' ', 5, 'L'); -- XX-SEQ
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(unique_key_p, 14, 'L', 0); -- Common Order No.
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(sequence_number_p, 10, 'L', 0); --Unique ID
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(r_c05.accession_number, 15, 'L'); --Accession No. 
				-- Requestor information
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(r_c05.encounter_type, 1, 'L'); -- NYUGAI_KBN
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(r_c05.department_code, 3, 'L', '0'); -- KA_CD
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(r_c05.department_name, 20, 'R', ' '); -- KA_NAME
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(r_c05.ward_code, 3, 'L', '0'); -- BYOTO_CD 
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(r_c05.ward_name, 20, 'R', ' '); -- BYOTO_NAME
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(r_c05.requested_physician_id, 10, 'L', '0'); -- DR_ID
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(r_c05.requested_physician_kana, 20, 'R', ' '); -- SH_KANA_NAME
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(r_c05.requested_physician_name, 20, 'R', ' '); -- SH_NAME
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(r_c05.requested_physician_phone_num, 15, 'L', '0'); -- PHS
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(to_char(r_c05.request_date, 'YYYYMMDD'), 8, 'L'); -- IN_DATE
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(to_char(r_c05.discontinue_date, 'YYYYMMDD'), 8, 'L'); -- STOP_DATE
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_ris_japan_l10n_pck.append_text(r_c05.discontinue_reason, 1, 'L'); -- STOP_RSN_FLG
            end;
        end loop;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE carestream_ris_japan_l10n_pck.common_header ( unique_key_p text, sequence_number_p bigint, file_sequence_p bigint ) FROM PUBLIC;
