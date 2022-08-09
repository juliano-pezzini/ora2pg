-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE generate_clinical_note_fields ( nr_sequencia_p bigint, ie_record_type_p text, ie_record_sub_type_p text, ie_data_type_p text, ie_stage_p bigint default null) AS $body$
DECLARE

    nr_domain_w   bigint;
    nr_seq_display_w bigint :=1;

    c01 CURSOR FOR
    SELECT vl_dominio
    FROM valor_dominio_v
    WHERE cd_dominio = nr_domain_w
	order by NR_SEQ_APRESENT;

BEGIN


/*Clinical Notes Settings*/

    IF ( ie_record_type_p = 'DIAGNOSIS' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 9840;
    ELSIF ( ie_record_type_p = 'PROBLEM' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 9841;
    ELSIF ( ie_record_type_p = 'CPOE_ITEMS' AND ie_record_sub_type_p = 0 AND ie_data_type_p ='CLINICAL_NOTE' and ie_stage_p = 1) THEN
        nr_domain_w := 9851;
    ELSIF ( ie_record_type_p = 'CPOE_ITEMS' AND ie_record_sub_type_p = 1 AND ie_data_type_p ='CLINICAL_NOTE' and ie_stage_p = 1) THEN
        nr_domain_w := 9852;
    ELSIF ( ie_record_type_p = 'CPOE_ITEMS' AND ie_record_sub_type_p = 2 AND ie_data_type_p ='CLINICAL_NOTE' and ie_stage_p = 1) THEN
        nr_domain_w := 9853;
    ELSIF ( ie_record_type_p = 'CPOE_ITEMS' AND ie_record_sub_type_p = 3 AND ie_data_type_p ='CLINICAL_NOTE' and ie_stage_p = 1) THEN
        nr_domain_w := 9859;
    ELSIF ( ie_record_type_p = 'CPOE_ITEMS' AND ie_record_sub_type_p = 4 AND ie_data_type_p ='CLINICAL_NOTE' and ie_stage_p = 1) THEN
        nr_domain_w := 9854;
    ELSIF ( ie_record_type_p = 'CPOE_ITEMS' AND ie_record_sub_type_p = 5 AND ie_data_type_p ='CLINICAL_NOTE' and ie_stage_p = 1) THEN
        nr_domain_w := 9866;
    ELSIF ( ie_record_type_p = 'CPOE_ITEMS' AND ie_record_sub_type_p = 6 AND ie_data_type_p ='CLINICAL_NOTE' and ie_stage_p = 1) THEN
        nr_domain_w := 9855;
    ELSIF ( ie_record_type_p = 'CPOE_ITEMS' AND ie_record_sub_type_p = 7 AND ie_data_type_p ='CLINICAL_NOTE' and ie_stage_p = 1) THEN
        nr_domain_w := 9858;
    ELSIF ( ie_record_type_p = 'CPOE_ITEMS' AND ie_record_sub_type_p = 8 AND ie_data_type_p ='CLINICAL_NOTE' and ie_stage_p = 1) THEN
        nr_domain_w := 9856;
    ELSIF ( ie_record_type_p = 'CPOE_ITEMS' AND ie_record_sub_type_p = 9 AND ie_data_type_p ='CLINICAL_NOTE' and ie_stage_p = 1) THEN
        nr_domain_w := 9857;
	ELSIF ( ie_record_type_p = 'CPOE_ITEMS' AND ie_record_sub_type_p = 0 AND ie_data_type_p ='CLINICAL_NOTE' and ie_stage_p = 2) THEN
		nr_domain_w := 10290;
    ELSIF ( ie_record_type_p = 'CPOE_ITEMS' AND ie_record_sub_type_p = 1 AND ie_data_type_p ='CLINICAL_NOTE' and ie_stage_p = 2) THEN
        nr_domain_w := 10216;
	ELSIF ( ie_record_type_p = 'CPOE_ITEMS' AND ie_record_sub_type_p = 2 AND ie_data_type_p ='CLINICAL_NOTE' and ie_stage_p = 2) THEN
        nr_domain_w := 10243;
	ELSIF ( ie_record_type_p = 'CPOE_ITEMS' AND ie_record_sub_type_p = 3 AND ie_data_type_p ='CLINICAL_NOTE' and ie_stage_p = 2) THEN
		nr_domain_w := 10163;
	ELSIF ( ie_record_type_p = 'CPOE_ITEMS' AND ie_record_sub_type_p = 4 AND ie_data_type_p ='CLINICAL_NOTE' and ie_stage_p = 2) THEN
        nr_domain_w := 10243;
	ELSIF ( ie_record_type_p = 'CPOE_ITEMS' AND ie_record_sub_type_p = 5 AND ie_data_type_p ='CLINICAL_NOTE' and ie_stage_p = 2) THEN
        nr_domain_w := 10216;
	ELSIF ( ie_record_type_p = 'CPOE_ITEMS' AND ie_record_sub_type_p = 6 AND ie_data_type_p ='CLINICAL_NOTE' and ie_stage_p = 2) THEN
        nr_domain_w := 10243;
	ELSIF ( ie_record_type_p = 'CPOE_ITEMS' AND ie_record_sub_type_p = 8 AND ie_data_type_p ='CLINICAL_NOTE' and ie_stage_p = 2) THEN
        nr_domain_w := 10243;
	ELSIF ( ie_record_type_p = 'CPOE_ITEMS' AND ie_record_sub_type_p = 9 AND ie_data_type_p ='CLINICAL_NOTE' and ie_stage_p = 2) THEN
        nr_domain_w := 10243;
    ELSIF ( ie_record_type_p = 'INPATIENT' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 9860;
    ELSIF ( ie_record_type_p = 'DEPT_TRANSFER' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 9861;
    ELSIF ( ie_record_type_p = 'WARD_TRANSFER' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 9862;
    ELSIF ( ie_record_type_p = 'BED_TRANSFER' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 9863;
    ELSIF ( ie_record_type_p = 'TEMP_LEAVE' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 9864;
    ELSIF ( ie_record_type_p = 'DISCHARGE' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 9865;
	ELSIF ( ie_record_type_p = 'CLNICAL_PATHWAY' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10118;
    ELSIF ( ie_record_type_p = 'DPC' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10124;
    ELSIF ( ie_record_type_p = 'CONSENT' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10127;
    ELSIF ( ie_record_type_p = 'PD_MED_TP' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10128;
    ELSIF ( ie_record_type_p = 'IP_MED_TP' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10129;
    ELSIF ( ie_record_type_p = 'CARE_PLAN' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10130;
    ELSIF ( ie_record_type_p = 'MED_CERT' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10131;
    ELSIF ( ie_record_type_p = 'DSCHRG_INSTR' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10137;
    ELSIF (((ie_record_type_p = 'CONS_SCHD' ) or (ie_record_type_p = 'SRVC_SCHD') or (ie_record_type_p = 'EXAM_SCHD')) AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10139;
    ELSIF ( ie_record_type_p = 'BED_RQST' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10140;
    ELSIF ( ie_record_type_p = 'TPM_ANALYSIS' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10141;
    ELSIF ( ie_record_type_p = 'INTERNAL_REF' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10142;
    ELSIF ( ie_record_type_p = 'INTERVENTION' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10143;
    ELSIF ( ie_record_type_p = 'BEDSORE_INF' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10144;
    ELSIF ( ie_record_type_p = 'PAT_ARRIVAL' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10146;
    ELSIF ( ie_record_type_p = 'EMERG_SERV_CONS' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10148;
    ELSIF ( ie_record_type_p = 'SURGERY' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10117;
    ELSIF ( ie_record_type_p = 'MED_GUIDANCE' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10149;
    ELSIF ( ie_record_type_p = 'GNRL_INSTRCT' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10267;
    ELSIF ( ie_record_type_p = 'DIALYSIS_SCHD' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10268;
    ELSIF ( ie_record_type_p = 'MED_DSCHG_REQ' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10250;
    ELSIF ( ie_record_type_p = 'EXT_REFERRAL' AND ie_record_sub_type_p = 1 AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10280;
    ELSIF ( ie_record_type_p = 'EXT_REFERRAL' AND ie_record_sub_type_p = 2 AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10282;
    ELSIF ( ie_record_type_p = 'EXT_REFERRAL' AND ie_record_sub_type_p = 3 AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10279;
    ELSIF ( ie_record_type_p = 'EXT_REFERRAL' AND ie_record_sub_type_p = 4 AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10281;
    ELSIF ( ie_record_type_p = 'SURG_ACHIEVE' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10278;
    ELSIF ( ie_record_type_p = 'PHYSIOLOGY' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10274;
	ELSIF ( ie_record_type_p = 'NURSE_CARE_NEED' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10501;
    ELSIF ( ie_record_type_p = 'RADIOLOGY' AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10276;
	ELSIF ( ie_record_type_p = 'REHAB' AND ie_record_sub_type_p = 1 AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10430;
    ELSIF ( ie_record_type_p = 'REHAB' AND ie_record_sub_type_p = 2 AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10431;
    ELSIF ( ie_record_type_p = 'REHAB' AND ie_record_sub_type_p = 3 AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10429;
	ELSIF ( ie_record_type_p = 'NUT_GUIDANCE' AND ie_record_sub_type_p = 1 AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10468;
    ELSIF ( ie_record_type_p = 'NUT_GUIDANCE' AND ie_record_sub_type_p = 2 AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10145;
	ELSIF ( ie_record_type_p = 'NUT_GUIDANCE' AND ie_record_sub_type_p = 3 AND ie_data_type_p ='CLINICAL_NOTE') THEN
        nr_domain_w := 10542;
	ELSIF ( ie_record_type_p = 'TRANS_CHECK' AND ie_data_type_p ='CLINICAL_NOTE' ) THEN
        nr_domain_w := 10638;
/*ClipBoard*/

    ELSIF ( ie_record_type_p = 'DIAGNOSIS' AND ie_data_type_p ='CLIPBOARD') THEN
        nr_domain_w := 10065;
    ELSIF ((ie_record_type_p = 'PRESCRIPTION' OR ie_record_type_p = 'CUR_MED') AND ie_data_type_p ='CLIPBOARD') THEN
        nr_domain_w := 10064;
    ELSIF ( ie_record_type_p = 'SURGERY' AND ie_data_type_p ='CLIPBOARD') THEN
        nr_domain_w := 10061;
    ELSIF ( ie_record_type_p = 'LAB_TEST' AND ie_data_type_p ='CLIPBOARD') THEN
        nr_domain_w := 10059;
    ELSIF ( ie_record_type_p = 'DPC' AND ie_data_type_p ='CLIPBOARD') THEN
        nr_domain_w := 10063;
    ELSIF ( ie_record_type_p = 'ADM_HIST' AND ie_data_type_p ='CLIPBOARD') THEN
        nr_domain_w := 10056;
    ELSIF ( ie_record_type_p = 'SUR_HIST' AND ie_data_type_p ='CLIPBOARD') THEN
        nr_domain_w := 10056;
    ELSIF ( ie_record_type_p = 'TRANS_HIST' AND ie_data_type_p ='CLIPBOARD') THEN
        nr_domain_w := 10056;
    ELSIF ( ie_record_type_p = 'SNCP' AND ie_data_type_p ='CLIPBOARD') THEN
        nr_domain_w := 10062;
    ELSIF ( ie_record_type_p = 'FAM_HIST' AND ie_data_type_p ='CLIPBOARD') THEN
        nr_domain_w := 10055;
    ELSIF ( ie_record_type_p = 'CLINIC_STAFF' AND ie_data_type_p ='CLIPBOARD') THEN
        nr_domain_w := 10057;
    ELSIF ( ie_record_type_p = 'HOSP_HIST' AND ie_data_type_p ='CLIPBOARD') THEN
        nr_domain_w := 10058;
    END IF;

    FOR C1 IN c01
    LOOP

        INSERT INTO clinical_note_fields(
            nr_sequencia,
            dt_atualizacao,
            nm_usuario,
            dt_atualizacao_nrec,
            nm_usuario_nrec,
            ie_field,
            nm_field,
            nr_seq_settings,
            nr_seq_display,
            ie_copy_field
        ) VALUES (
            nextval('clinical_note_fields_seq'),
            clock_timestamp(),
            wheb_usuario_pck.get_nm_usuario,
            clock_timestamp(),
            wheb_usuario_pck.get_nm_usuario,
            C1.vl_dominio,
            NULL,
            nr_sequencia_p,
            nr_seq_display_w,
            'S'
        );
        nr_seq_display_w := nr_seq_display_w+1;
        COMMIT;

    END LOOP;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE generate_clinical_note_fields ( nr_sequencia_p bigint, ie_record_type_p text, ie_record_sub_type_p text, ie_data_type_p text, ie_stage_p bigint default null) FROM PUBLIC;
