-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE clipboard_util_pkg.clipboard_data_format ( ie_record_type_p text, nr_atendiment_p bigint, config_option_p bigint, nr_sequencia_p text, id_sessao_p text DEFAULT NULL, cd_procedimento_p bigint DEFAULT NULL, nr_seq_interno_p bigint DEFAULT NULL, nr_exam_p bigint DEFAULT NULL) AS $body$
DECLARE

        ds_return_w        varchar(32000);
        nr_atendimento_p   bigint := nr_atendiment_p;

BEGIN
        IF ( ie_record_type_p = 'DIAGNOSIS' ) THEN
            ds_return_w := clipboard_util_pkg.get_content_diagnosis(nr_atendimento_p, nr_sequencia_p, ie_record_type_p, config_option_p);
        ELSIF ( ie_record_type_p = 'PRESCRIPTION' ) THEN
            ds_return_w := clipboard_util_pkg.get_content_prescription(nr_atendimento_p, nr_sequencia_p, ie_record_type_p, config_option_p);
        ELSIF ( ie_record_type_p = 'SURGERY' ) THEN
            ds_return_w := clipboard_util_pkg.get_content_surgery(nr_atendimento_p, nr_sequencia_p, ie_record_type_p, config_option_p);
        ELSIF ( ie_record_type_p = 'LAB_TEST' ) THEN
            ds_return_w := clipboard_util_pkg.get_content_labtest(nr_atendimento_p, nr_sequencia_p, ie_record_type_p, config_option_p, cd_procedimento_p
            ,
                    nr_seq_interno_p,nr_exam_p);
        ELSIF ( ie_record_type_p = 'HOSP_HIST' ) THEN
            ds_return_w := clipboard_util_pkg.get_content_hosp_hist(nr_atendimento_p, nr_sequencia_p, ie_record_type_p, config_option_p);
        ELSIF ( ie_record_type_p = 'DPC' ) THEN
            ds_return_w := clipboard_util_pkg.get_content_dpc(nr_atendimento_p, nr_sequencia_p, ie_record_type_p, config_option_p);
        ELSIF ( ie_record_type_p = 'ADM_HIST' ) THEN
            ds_return_w := clipboard_util_pkg.get_content_admis_hist(nr_atendimento_p, nr_sequencia_p, ie_record_type_p, config_option_p);
        ELSIF ( ie_record_type_p = 'SUR_HIST' ) THEN
            ds_return_w := clipboard_util_pkg.get_content_surg_hist(nr_atendimento_p, nr_sequencia_p, ie_record_type_p, config_option_p);
        ELSIF ( ie_record_type_p = 'TRANS_HIST' ) THEN
            ds_return_w := clipboard_util_pkg.get_content_trans_hist(nr_atendimento_p, nr_sequencia_p, ie_record_type_p, config_option_p);
        ELSIF ( ie_record_type_p = 'FAM_HIST' ) THEN
            ds_return_w := clipboard_util_pkg.get_content_family_hist(nr_atendimento_p, nr_sequencia_p, ie_record_type_p, config_option_p);
        ELSIF ( ie_record_type_p = 'SNCP' ) THEN
            ds_return_w := clipboard_util_pkg.get_content_sncp(nr_atendimento_p, nr_sequencia_p, ie_record_type_p, config_option_p);
        ELSIF ( ie_record_type_p = 'CLINIC_STAFF' ) THEN
            ds_return_w := clipboard_util_pkg.get_content_clinc_stf(nr_atendimento_p, nr_sequencia_p, ie_record_type_p, config_option_p);
        ELSIF ( ie_record_type_p = 'CUR_MED' ) THEN
            ds_return_w := clipboard_util_pkg.get_content_cur_med(nr_atendimento_p, nr_sequencia_p, ie_record_type_p, config_option_p);
        END IF;

        INSERT INTO clipboard_data(
            nr_sequencia,
            cd_estabelecimento,
            dt_atualizacao,
            nm_usuario,
            dt_atualizacao_nrec,
            nm_usuario_nrec,
            ie_record_type,
            ie_clip_data,
            ie_situacao,
            id_sessao
        ) VALUES (
            nextval('clipboard_data_seq'),
            wheb_usuario_pck.get_cd_estabelecimento,
            clock_timestamp(),
            wheb_usuario_pck.get_nm_usuario,
            clock_timestamp(),
            wheb_usuario_pck.get_nm_usuario,
            ie_record_type_p,
            ds_return_w,
            'A',
            id_sessao_p
        );

    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE clipboard_util_pkg.clipboard_data_format ( ie_record_type_p text, nr_atendiment_p bigint, config_option_p bigint, nr_sequencia_p text, id_sessao_p text DEFAULT NULL, cd_procedimento_p bigint DEFAULT NULL, nr_seq_interno_p bigint DEFAULT NULL, nr_exam_p bigint DEFAULT NULL) FROM PUBLIC;