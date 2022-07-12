-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pfcs_pck_bed_requests.get_requested_unit ( nr_seq_encounter_p bigint, ie_option_p text ) RETURNS varchar AS $body$
DECLARE

        ds_return_w varchar(255);

BEGIN
        select max(CASE WHEN ie_option_p=current_setting('pfcs_pck_bed_requests.ie_option_cd_w')::varchar(2) THEN  to_char(sec.cd_setor_atendimento) WHEN ie_option_p=current_setting('pfcs_pck_bed_requests.ie_option_ds_w')::varchar(2) THEN  to_char(sec.ds_setor_atendimento) WHEN ie_option_p=current_setting('pfcs_pck_bed_requests.ie_option_cl_w')::varchar(2) THEN  CASE WHEN sec.ie_semi_intensiva=PFCS_PCK_CONSTANTS.IE_YES_BR THEN  PFCS_PCK_CONSTANTS.CD_TCU  ELSE sec.cd_classif_setor END  END )
        into STRICT ds_return_w
        from unidade_atendimento uni,
            setor_atendimento sec,
            pfcs_service_request svc
        where uni.cd_setor_atendimento = sec.cd_setor_atendimento
            and svc.nr_seq_location = uni.nr_seq_location
            and svc.nr_seq_encounter = nr_seq_encounter_p
            and svc.cd_service in (PFCS_PCK_CONSTANTS.CD_ADMISSION, PFCS_PCK_CONSTANTS.CD_TRANSFER)  LIMIT 1;
        return ds_return_w;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pfcs_pck_bed_requests.get_requested_unit ( nr_seq_encounter_p bigint, ie_option_p text ) FROM PUBLIC;