-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE add_nursing_import_items ( NR_SEQ_IMPORT_P NURSING_CARE_IMPORT_ITEMS.NR_SEQ_IMPORT%TYPE, NR_SEQ_FILE_P bigint, NR_LINE_P bigint, NR_FACILITY_P NURSING_CARE_IMPORT_ITEMS.NR_FACILITY%TYPE, NR_IDENTIFICATION_DATA_P NURSING_CARE_IMPORT_ITEMS.NR_IDENTIFICATION_DATA%TYPE, DT_DISCHARGE_P text, DT_ADMISSION_P text, NR_CLASSIF_DATA_P NURSING_CARE_IMPORT_ITEMS.NR_CLASSIF_DATA%TYPE, NR_SEQ_REGISTER_P NURSING_CARE_IMPORT_ITEMS.NR_SEQ_REGISTER%TYPE, NR_SEQ_ACTION_P NURSING_CARE_IMPORT_ITEMS.NR_SEQ_ACTION%TYPE, DS_SCORE_CODE_P NURSING_CARE_IMPORT_ITEMS.DS_SCORE_CODE%TYPE, NR_COMPUTER_CODE_P NURSING_CARE_IMPORT_ITEMS.NR_COMPUTER_CODE%TYPE, NR_INTERPRETATION_P NURSING_CARE_IMPORT_ITEMS.NR_INTERPRETATION%TYPE, DS_DETAIL_NAME_P NURSING_CARE_IMPORT_ITEMS.DS_DETAIL_NAME%TYPE, QT_USAGE_AMOUNT_P NURSING_CARE_IMPORT_ITEMS.QT_USAGE_AMOUNT%TYPE, NR_DEFAULT_UNIT_P NURSING_CARE_IMPORT_ITEMS.NR_DEFAULT_UNIT%TYPE, QT_SCORE_DETAIL_AMOUNT_P NURSING_CARE_IMPORT_ITEMS.QT_SCORE_DETAIL_AMOUNT%TYPE, NR_CLASSIF_YEN_P NURSING_CARE_IMPORT_ITEMS.NR_CLASSIF_YEN%TYPE, QT_SCORE_VOLUME_P NURSING_CARE_IMPORT_ITEMS.QT_SCORE_VOLUME%TYPE, DS_CLASSIF_ACTION_P NURSING_CARE_IMPORT_ITEMS.DS_CLASSIF_ACTION%TYPE, NR_SCORE_ACTION_P NURSING_CARE_IMPORT_ITEMS.NR_SCORE_ACTION%TYPE, NR_FEE_ACTION_DRUG_P NURSING_CARE_IMPORT_ITEMS.NR_FEE_ACTION_DRUG%TYPE, NR_FEE_ACTION_MATERIAL_P NURSING_CARE_IMPORT_ITEMS.NR_FEE_ACTION_MATERIAL%TYPE, QT_ACTIONS_P NURSING_CARE_IMPORT_ITEMS.QT_ACTIONS%TYPE, NR_INSURER_P NURSING_CARE_IMPORT_ITEMS.NR_INSURER%TYPE, NR_RECEIPT_TYPE_P NURSING_CARE_IMPORT_ITEMS.NR_RECEIPT_TYPE%TYPE, DT_IMPLEMENTATION_P text, NR_CLASSIF_RECEIPT_P NURSING_CARE_IMPORT_ITEMS.NR_CLASSIF_RECEIPT%TYPE, NR_CLASSIF_DEPARTMENT_P NURSING_CARE_IMPORT_ITEMS.NR_CLASSIF_DEPARTMENT%TYPE, NR_DOCTOR_CODE_P NURSING_CARE_IMPORT_ITEMS.NR_DOCTOR_CODE%TYPE, NR_WARD_CODE_P NURSING_CARE_IMPORT_ITEMS.NR_WARD_CODE%TYPE, NR_CLASSIF_WARD_P NURSING_CARE_IMPORT_ITEMS.NR_CLASSIF_WARD%TYPE, NR_CLASSIF_ENTRY_EXIT_P NURSING_CARE_IMPORT_ITEMS.NR_CLASSIF_ENTRY_EXIT%TYPE, NR_TYPE_INSTALATION_P NURSING_CARE_IMPORT_ITEMS.NR_TYPE_INSTALATION%TYPE ) AS $body$
DECLARE

    NM_USUARIO_W nursing_care_import_items.nm_usuario%TYPE;
    NR_SEQUENCIA_W bigint := null;
    DT_DISCHARGE_W timestamp := null;
    DT_ADMISSION_W timestamp := null;
    DT_IMPLEMENTATION_W timestamp := null;

BEGIN
    NM_USUARIO_W := wheb_usuario_pck.get_nm_usuario();
    DT_DISCHARGE_W := CASE WHEN DT_DISCHARGE_P = '00000000' THEN null else TO_DATE(DT_DISCHARGE_P,'YYYYMMDD') END;
    DT_ADMISSION_W := CASE WHEN DT_ADMISSION_P = '00000000' THEN null else TO_DATE(DT_ADMISSION_P,'YYYYMMDD') END;
    DT_IMPLEMENTATION_W := CASE WHEN DT_IMPLEMENTATION_P = '00000000' THEN null else TO_DATE(DT_IMPLEMENTATION_P,'YYYYMMDD') END;

    SELECT MAX(NR_SEQUENCIA)
    INTO STRICT NR_SEQUENCIA_W 
    FROM nursing_care_import_items 
    WHERE 
        NR_FACILITY = NR_FACILITY_P AND
        ((coalesce(DT_DISCHARGE_W::text, '') = '' AND coalesce(DT_DISCHARGE::text, '') = '')
            OR (DT_DISCHARGE_W = DT_DISCHARGE)
        ) AND
        ((coalesce(DT_ADMISSION_W::text, '') = '' AND coalesce(DT_ADMISSION::text, '') = '')
            OR (DT_ADMISSION_W = DT_ADMISSION)
        ) AND
        ((coalesce(DT_IMPLEMENTATION_W::text, '') = '' AND coalesce(DT_IMPLEMENTATION::text, '') = '')
            OR (DT_IMPLEMENTATION_W = DT_IMPLEMENTATION)
        ) AND
        NR_CLASSIF_DATA = NR_CLASSIF_DATA_P AND 
        NR_SEQ_REGISTER = NR_SEQ_REGISTER_P AND 
        NR_SEQ_ACTION = NR_SEQ_ACTION_P AND
        NR_CLASSIF_DEPARTMENT = NR_CLASSIF_DEPARTMENT_P AND
	NR_IDENTIFICATION_DATA = NR_IDENTIFICATION_DATA_P AND
        NR_SEQ_IMPORT = NR_SEQ_IMPORT_P;

    IF (coalesce(NR_SEQUENCIA_W::text, '') = '') THEN

        SELECT
            nextval('nursing_care_import_items_seq')
        INTO STRICT NR_SEQUENCIA_W
;

        INSERT INTO nursing_care_import_items(
            nr_sequencia,
            nr_seq_import,
            nr_facility,
            dt_atualizacao,
            nm_usuario,
            dt_atualizacao_nrec,
            nm_usuario_nrec,
            dt_discharge,
            nr_identification_data,
            dt_admission,
            nr_classif_data,
            nr_seq_register,
            nr_seq_action,
            ds_score_code,
            nr_computer_code,
            nr_interpretation,
            ds_detail_name,
            qt_usage_amount,
            nr_default_unit,
            qt_score_detail_amount,
            nr_classif_yen,
            qt_score_volume,
            ds_classif_action,
            nr_score_action,
            nr_fee_action_drug,
            NR_FEE_action_material,
            qt_actions,
            nr_insurer,
            nr_receipt_type,
            dt_implementation,
            nr_classif_receipt,
            nr_classif_department,
            nr_doctor_code,
            nr_ward_code,
            nr_classif_ward,
            nr_classif_entry_exit,
            nr_type_instalation
        ) VALUES (
            NR_SEQUENCIA_W,
            NR_SEQ_IMPORT_P,
            NR_FACILITY_P,
            clock_timestamp(),
            NM_USUARIO_W,
            clock_timestamp(),
            NM_USUARIO_W,
            DT_DISCHARGE_W,
            NR_IDENTIFICATION_DATA_P,
            DT_ADMISSION_W,
            NR_CLASSIF_DATA_P,
            NR_SEQ_REGISTER_P,
            NR_SEQ_ACTION_P,
            DS_SCORE_CODE_P,
            NR_COMPUTER_CODE_P,
            NR_INTERPRETATION_P,
            DS_DETAIL_NAME_P,
            QT_USAGE_AMOUNT_P,
            NR_DEFAULT_UNIT_P,
            QT_SCORE_DETAIL_AMOUNT_P,
            NR_CLASSIF_YEN_P,
            QT_SCORE_VOLUME_P,
            DS_CLASSIF_ACTION_P,
            NR_SCORE_ACTION_P,
            NR_FEE_ACTION_DRUG_P,
            NR_FEE_ACTION_MATERIAL_P,
            QT_ACTIONS_P,
            NR_INSURER_P,
            NR_RECEIPT_TYPE_P,
            DT_IMPLEMENTATION_W,
            NR_CLASSIF_RECEIPT_P,
            NR_CLASSIF_DEPARTMENT_P,
            NR_DOCTOR_CODE_P,
            NR_WARD_CODE_P,
            NR_CLASSIF_WARD_P,
            NR_CLASSIF_ENTRY_EXIT_P,
            NR_TYPE_INSTALATION_P
        );

		CALL INS_UPD_NURSING_IMPORT_RESULTS(NR_IDENTIFICATION_DATA_P, DT_ADMISSION_W, NR_COMPUTER_CODE_P, DT_IMPLEMENTATION_W, NR_SEQUENCIA_W);
    END IF;

    INSERT INTO nursing_import_file_item(
        NR_SEQUENCIA,
        NR_SEQ_FILE,
        NR_SEQ_ITEM,
        NR_ROW
    ) VALUES (
        nextval('nursing_import_file_item_seq'),
        NR_SEQ_FILE_P,
        NR_SEQUENCIA_W,
        NR_LINE_P
    );
    commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE add_nursing_import_items ( NR_SEQ_IMPORT_P NURSING_CARE_IMPORT_ITEMS.NR_SEQ_IMPORT%TYPE, NR_SEQ_FILE_P bigint, NR_LINE_P bigint, NR_FACILITY_P NURSING_CARE_IMPORT_ITEMS.NR_FACILITY%TYPE, NR_IDENTIFICATION_DATA_P NURSING_CARE_IMPORT_ITEMS.NR_IDENTIFICATION_DATA%TYPE, DT_DISCHARGE_P text, DT_ADMISSION_P text, NR_CLASSIF_DATA_P NURSING_CARE_IMPORT_ITEMS.NR_CLASSIF_DATA%TYPE, NR_SEQ_REGISTER_P NURSING_CARE_IMPORT_ITEMS.NR_SEQ_REGISTER%TYPE, NR_SEQ_ACTION_P NURSING_CARE_IMPORT_ITEMS.NR_SEQ_ACTION%TYPE, DS_SCORE_CODE_P NURSING_CARE_IMPORT_ITEMS.DS_SCORE_CODE%TYPE, NR_COMPUTER_CODE_P NURSING_CARE_IMPORT_ITEMS.NR_COMPUTER_CODE%TYPE, NR_INTERPRETATION_P NURSING_CARE_IMPORT_ITEMS.NR_INTERPRETATION%TYPE, DS_DETAIL_NAME_P NURSING_CARE_IMPORT_ITEMS.DS_DETAIL_NAME%TYPE, QT_USAGE_AMOUNT_P NURSING_CARE_IMPORT_ITEMS.QT_USAGE_AMOUNT%TYPE, NR_DEFAULT_UNIT_P NURSING_CARE_IMPORT_ITEMS.NR_DEFAULT_UNIT%TYPE, QT_SCORE_DETAIL_AMOUNT_P NURSING_CARE_IMPORT_ITEMS.QT_SCORE_DETAIL_AMOUNT%TYPE, NR_CLASSIF_YEN_P NURSING_CARE_IMPORT_ITEMS.NR_CLASSIF_YEN%TYPE, QT_SCORE_VOLUME_P NURSING_CARE_IMPORT_ITEMS.QT_SCORE_VOLUME%TYPE, DS_CLASSIF_ACTION_P NURSING_CARE_IMPORT_ITEMS.DS_CLASSIF_ACTION%TYPE, NR_SCORE_ACTION_P NURSING_CARE_IMPORT_ITEMS.NR_SCORE_ACTION%TYPE, NR_FEE_ACTION_DRUG_P NURSING_CARE_IMPORT_ITEMS.NR_FEE_ACTION_DRUG%TYPE, NR_FEE_ACTION_MATERIAL_P NURSING_CARE_IMPORT_ITEMS.NR_FEE_ACTION_MATERIAL%TYPE, QT_ACTIONS_P NURSING_CARE_IMPORT_ITEMS.QT_ACTIONS%TYPE, NR_INSURER_P NURSING_CARE_IMPORT_ITEMS.NR_INSURER%TYPE, NR_RECEIPT_TYPE_P NURSING_CARE_IMPORT_ITEMS.NR_RECEIPT_TYPE%TYPE, DT_IMPLEMENTATION_P text, NR_CLASSIF_RECEIPT_P NURSING_CARE_IMPORT_ITEMS.NR_CLASSIF_RECEIPT%TYPE, NR_CLASSIF_DEPARTMENT_P NURSING_CARE_IMPORT_ITEMS.NR_CLASSIF_DEPARTMENT%TYPE, NR_DOCTOR_CODE_P NURSING_CARE_IMPORT_ITEMS.NR_DOCTOR_CODE%TYPE, NR_WARD_CODE_P NURSING_CARE_IMPORT_ITEMS.NR_WARD_CODE%TYPE, NR_CLASSIF_WARD_P NURSING_CARE_IMPORT_ITEMS.NR_CLASSIF_WARD%TYPE, NR_CLASSIF_ENTRY_EXIT_P NURSING_CARE_IMPORT_ITEMS.NR_CLASSIF_ENTRY_EXIT%TYPE, NR_TYPE_INSTALATION_P NURSING_CARE_IMPORT_ITEMS.NR_TYPE_INSTALATION%TYPE ) FROM PUBLIC;

