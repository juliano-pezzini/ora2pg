-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE med_guidance_pkg.upsert_med_guid_order ( nr_sequencia_p INOUT MEDICAL_GUIDANCE_ORDER.NR_SEQUENCIA%type, nm_usuario_p MEDICAL_GUIDANCE_ORDER.NM_USUARIO%type, cd_estabelecimento_p MEDICAL_GUIDANCE_ORDER.CD_ESTABELECIMENTO%type, cd_medical_practice_code_p JPN_MEDICAL_GUIDANCE.CD_MEDICAL_PRACTICE_CODE%type, nr_seq_tipo_avaliacao_p MEDICAL_GUIDANCE_ORDER.NR_SEQ_TIPO_AVALIACAO%type, cd_pessoa_fisica_p MEDICAL_GUIDANCE_ORDER.CD_PESSOA_FISICA%type, nr_atendimento_p MEDICAL_GUIDANCE_ORDER.NR_ATENDIMENTO%type, nr_seq_proc_interno_p MEDICAL_GUIDANCE_ORDER.NR_SEQ_PROC_INTERNO%type, cd_procedimento_p MEDICAL_GUIDANCE_ORDER.CD_PROCEDIMENTO%type, ie_origem_proced_p MEDICAL_GUIDANCE_ORDER.IE_ORIGEM_PROCED%type, ds_medical_instruction_p MEDICAL_GUIDANCE_ORDER.DS_MEDICAL_INSTRUCTION%type, qt_score_p MEDICAL_GUIDANCE_ORDER.QT_SCORE%type, ds_general_explanation_p MEDICAL_GUIDANCE_ORDER.DS_GENERAL_EXPLANATION%type, ds_diseases_applicable_p MEDICAL_GUIDANCE_ORDER.DS_DISEASES_APPLICABLE%type, ds_calculation_method_p MEDICAL_GUIDANCE_ORDER.DS_CALCULATION_METHOD%type, ds_departments_p MEDICAL_GUIDANCE_ORDER.DS_DEPARTMENTS%type, dt_guidance_p MEDICAL_GUIDANCE_ORDER.DT_GUIDANCE%type, dt_calculation_p MEDICAL_GUIDANCE_ORDER.DT_CALCULATION%type, qt_guidance_time_p MEDICAL_GUIDANCE_ORDER.QT_GUIDANCE_TIME%type, dt_guidance_start_time_p MEDICAL_GUIDANCE_ORDER.DT_GUIDANCE_START_TIME%type, ds_text_p MEDICAL_GUIDANCE_ORDER.DS_TEXT%type, nr_seq_clinical_board_p AGENDA_LISTA_ESPERA.NR_SEQUENCIA%type default null) AS $body$
DECLARE


    dt_sysdate_s                timestamp := clock_timestamp();
    ie_situacao_ativa_s         MEDICAL_GUIDANCE_ORDER.IE_SITUACAO%type := 'A';
    nr_seq_jpn_med_guid_w       MEDICAL_GUIDANCE_ORDER.NR_SEQ_JPN_MED_GUID%type;
    nr_seq_proc_interno_w       MEDICAL_GUIDANCE_ORDER.NR_SEQ_PROC_INTERNO%type;
    nr_seq_tipo_avaliacao_w     MEDICAL_GUIDANCE_ORDER.NR_SEQ_TIPO_AVALIACAO%type;


BEGIN
        SELECT  MAX(NR_SEQUENCIA) 
        INTO STRICT    nr_seq_jpn_med_guid_w
        FROM    JPN_MEDICAL_GUIDANCE 
        WHERE   CD_MEDICAL_PRACTICE_CODE = cd_medical_practice_code_p;

        nr_seq_proc_interno_w := MED_GUIDANCE_PKG.VALIDATE_NR_SEQ_VALUE(nr_seq_proc_interno_p);
        nr_seq_tipo_avaliacao_w := MED_GUIDANCE_PKG.VALIDATE_NR_SEQ_VALUE(nr_seq_tipo_avaliacao_p);

        IF (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') AND nr_sequencia_p <> 0 THEN
            UPDATE  MEDICAL_GUIDANCE_ORDER
            SET     NR_SEQ_JPN_MED_GUID     = nr_seq_jpn_med_guid_w,
                    NR_SEQ_TIPO_AVALIACAO   = nr_seq_tipo_avaliacao_w,
                    CD_PESSOA_FISICA        = cd_pessoa_fisica_p,
                    NR_ATENDIMENTO          = nr_atendimento_p,
                    NR_SEQ_PROC_INTERNO     = nr_seq_proc_interno_w,
                    CD_PROCEDIMENTO         = cd_procedimento_p,
                    IE_ORIGEM_PROCED        = ie_origem_proced_p,
                    DS_MEDICAL_INSTRUCTION  = ds_medical_instruction_p,
                    QT_SCORE                = qt_score_p,
                    DS_GENERAL_EXPLANATION  = ds_general_explanation_p,
                    DS_DISEASES_APPLICABLE  = ds_diseases_applicable_p,
                    DS_CALCULATION_METHOD   = ds_calculation_method_p,
                    DS_DEPARTMENTS          = ds_departments_p,
                    DT_GUIDANCE             = dt_guidance_p,
                    DT_CALCULATION          = dt_calculation_p,
                    QT_GUIDANCE_TIME        = qt_guidance_time_p,
                    DT_GUIDANCE_START_TIME  = dt_guidance_start_time_p,
                    DS_TEXT                 = ds_text_p,
                    DT_ATUALIZACAO          = dt_sysdate_s,
                    DT_ATUALIZACAO_NREC     = dt_sysdate_s,
                    NM_USUARIO              = nm_usuario_p,
                    NM_USUARIO_NREC         = nm_usuario_p,
                    CD_ESTABELECIMENTO      = cd_estabelecimento_p
            WHERE   NR_SEQUENCIA            = nr_sequencia_p;
        ELSE
            SELECT  nextval('medical_guidance_order_seq')
            INTO STRICT    nr_sequencia_p
;

            INSERT INTO MEDICAL_GUIDANCE_ORDER(
                NR_SEQUENCIA,
                DT_ATUALIZACAO,
                DT_ATUALIZACAO_NREC,
                NM_USUARIO,
                NM_USUARIO_NREC,
                CD_ESTABELECIMENTO,
                NR_SEQ_JPN_MED_GUID,
                NR_SEQ_TIPO_AVALIACAO,
                CD_PESSOA_FISICA,
                NR_ATENDIMENTO,
                IE_SITUACAO,
                NR_SEQ_PROC_INTERNO,
                CD_PROCEDIMENTO,
                IE_ORIGEM_PROCED,
                DS_MEDICAL_INSTRUCTION,
                QT_SCORE,
                DS_GENERAL_EXPLANATION,
                DS_DISEASES_APPLICABLE,
                DS_CALCULATION_METHOD,
                DS_DEPARTMENTS,
                DT_GUIDANCE,
                DT_CALCULATION,
                QT_GUIDANCE_TIME,
                DT_GUIDANCE_START_TIME,
                DS_TEXT
            ) VALUES (
                nr_sequencia_p,
                dt_sysdate_s,
                dt_sysdate_s,
                nm_usuario_p,
                nm_usuario_p,
                cd_estabelecimento_p,
                nr_seq_jpn_med_guid_w,
                nr_seq_tipo_avaliacao_w,
                cd_pessoa_fisica_p,
                nr_atendimento_p,
                ie_situacao_ativa_s,
                nr_seq_proc_interno_w,
                cd_procedimento_p,
                ie_origem_proced_p,
                ds_medical_instruction_p,
                qt_score_p,
                ds_general_explanation_p,
                ds_diseases_applicable_p,
                ds_calculation_method_p,
                ds_departments_p,
                dt_guidance_p,
                dt_calculation_p,
                qt_guidance_time_p,
                dt_guidance_start_time_p,
                ds_text_p
            );

        END IF;

        DELETE  FROM MEDI_GUIDANCE_ORDER_INCONS
        WHERE   NR_SEQ_MED_GUIDANCE = nr_sequencia_p
        AND     NR_ATENDIMENTO = nr_atendimento_p;

		if (nr_seq_clinical_board_p IS NOT NULL AND nr_seq_clinical_board_p::text <> '') then
			update agenda_lista_espera
			set nr_seq_med_guid_order =  nr_sequencia_p
			where nr_sequencia = nr_seq_clinical_board_p;
        end if;

        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        CALL WHEB_MENSAGEM_PCK.EXIBIR_MENSAGEM_ABORT(799570, 'DS_ERRO_W=UPSERT_MED_GUID_ORDER'|| chr(10) ||SQLERRM);
    END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_guidance_pkg.upsert_med_guid_order ( nr_sequencia_p INOUT MEDICAL_GUIDANCE_ORDER.NR_SEQUENCIA%type, nm_usuario_p MEDICAL_GUIDANCE_ORDER.NM_USUARIO%type, cd_estabelecimento_p MEDICAL_GUIDANCE_ORDER.CD_ESTABELECIMENTO%type, cd_medical_practice_code_p JPN_MEDICAL_GUIDANCE.CD_MEDICAL_PRACTICE_CODE%type, nr_seq_tipo_avaliacao_p MEDICAL_GUIDANCE_ORDER.NR_SEQ_TIPO_AVALIACAO%type, cd_pessoa_fisica_p MEDICAL_GUIDANCE_ORDER.CD_PESSOA_FISICA%type, nr_atendimento_p MEDICAL_GUIDANCE_ORDER.NR_ATENDIMENTO%type, nr_seq_proc_interno_p MEDICAL_GUIDANCE_ORDER.NR_SEQ_PROC_INTERNO%type, cd_procedimento_p MEDICAL_GUIDANCE_ORDER.CD_PROCEDIMENTO%type, ie_origem_proced_p MEDICAL_GUIDANCE_ORDER.IE_ORIGEM_PROCED%type, ds_medical_instruction_p MEDICAL_GUIDANCE_ORDER.DS_MEDICAL_INSTRUCTION%type, qt_score_p MEDICAL_GUIDANCE_ORDER.QT_SCORE%type, ds_general_explanation_p MEDICAL_GUIDANCE_ORDER.DS_GENERAL_EXPLANATION%type, ds_diseases_applicable_p MEDICAL_GUIDANCE_ORDER.DS_DISEASES_APPLICABLE%type, ds_calculation_method_p MEDICAL_GUIDANCE_ORDER.DS_CALCULATION_METHOD%type, ds_departments_p MEDICAL_GUIDANCE_ORDER.DS_DEPARTMENTS%type, dt_guidance_p MEDICAL_GUIDANCE_ORDER.DT_GUIDANCE%type, dt_calculation_p MEDICAL_GUIDANCE_ORDER.DT_CALCULATION%type, qt_guidance_time_p MEDICAL_GUIDANCE_ORDER.QT_GUIDANCE_TIME%type, dt_guidance_start_time_p MEDICAL_GUIDANCE_ORDER.DT_GUIDANCE_START_TIME%type, ds_text_p MEDICAL_GUIDANCE_ORDER.DS_TEXT%type, nr_seq_clinical_board_p AGENDA_LISTA_ESPERA.NR_SEQUENCIA%type default null) FROM PUBLIC;
