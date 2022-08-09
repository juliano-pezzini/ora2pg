-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insere_insurance_eligibility ( nr_social_segurity_p W_INSURANCE_ELIGIBILITY.NR_SOCIAL_SEGURITY%type, cd_document_number_p W_INSURANCE_ELIGIBILITY.CD_DOCUMENT_NUMBER%type, ds_partner_type_p W_INSURANCE_ELIGIBILITY.DS_PARTNER_TYPE%type, ds_refusal_reason_p W_INSURANCE_ELIGIBILITY.DS_REFUSAL_REASON%type, cd_insurance_p W_INSURANCE_ELIGIBILITY.CD_INSURANCE%type, nm_usuario_p W_INSURANCE_ELIGIBILITY.NM_USUARIO%type, ds_estado_integrante_p W_INSURANCE_ELIGIBILITY.DS_ESTADO_INTEGRANTE%type, ds_plano_convenio_p W_INSURANCE_ELIGIBILITY.DS_PLANO_CONVENIO%type, ds_given_name_p W_INSURANCE_ELIGIBILITY.DS_GIVEN_NAME%type, ds_family_name_p W_INSURANCE_ELIGIBILITY.DS_FAMILY_NAME%type, ds_component_name_1_p W_INSURANCE_ELIGIBILITY.DS_COMPONENT_NAME_1%type, ds_status_elegibilidade_p W_INSURANCE_ELIGIBILITY.DS_STATUS_ELEGIBILIDADE%type, ds_insurance_category_p W_INSURANCE_ELIGIBILITY.DS_INSURANCE_CATEGORY%type ) AS $body$
DECLARE


dt_current_date_s CONSTANT W_INSURANCE_ELIGIBILITY.DT_VALIDITY_END%TYPE := clock_timestamp();


BEGIN

INSERT INTO W_INSURANCE_ELIGIBILITY(
                NR_SEQUENCIA,
                NM_USUARIO,
                DT_ATUALIZACAO,
                NR_SOCIAL_SEGURITY,
                DS_PARTNER_TYPE,
                DS_REFUSAL_REASON,
                CD_INSURANCE,
                DS_ESTADO_INTEGRANTE,
                DS_PLANO_CONVENIO,
                DS_GIVEN_NAME,
                DS_FAMILY_NAME,
                DS_COMPONENT_NAME_1,
                CD_DOCUMENT_NUMBER,
                DS_STATUS_ELEGIBILIDADE,
                DT_VALIDITY_END,
                DS_INSURANCE_CATEGORY)
        VALUES (nextval('w_insurance_eligibility_seq'),
                nm_usuario_p,
                clock_timestamp(),
                nr_social_segurity_p,
                ds_partner_type_p,
                ds_refusal_reason_p,
                cd_insurance_p,
                ds_estado_integrante_p,
                ds_plano_convenio_p,
                ds_given_name_p,
                ds_family_name_p,
                ds_component_name_1_p,
                cd_document_number_p,
                CASE WHEN ds_status_elegibilidade_p=0 THEN  'N' WHEN ds_status_elegibilidade_p=1 THEN  'S' END ,
                CASE WHEN ds_status_elegibilidade_p=0 THEN  NULL WHEN ds_status_elegibilidade_p=1 THEN  dt_current_date_s + 1 END ,
                ds_insurance_category_p
                );
COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insere_insurance_eligibility ( nr_social_segurity_p W_INSURANCE_ELIGIBILITY.NR_SOCIAL_SEGURITY%type, cd_document_number_p W_INSURANCE_ELIGIBILITY.CD_DOCUMENT_NUMBER%type, ds_partner_type_p W_INSURANCE_ELIGIBILITY.DS_PARTNER_TYPE%type, ds_refusal_reason_p W_INSURANCE_ELIGIBILITY.DS_REFUSAL_REASON%type, cd_insurance_p W_INSURANCE_ELIGIBILITY.CD_INSURANCE%type, nm_usuario_p W_INSURANCE_ELIGIBILITY.NM_USUARIO%type, ds_estado_integrante_p W_INSURANCE_ELIGIBILITY.DS_ESTADO_INTEGRANTE%type, ds_plano_convenio_p W_INSURANCE_ELIGIBILITY.DS_PLANO_CONVENIO%type, ds_given_name_p W_INSURANCE_ELIGIBILITY.DS_GIVEN_NAME%type, ds_family_name_p W_INSURANCE_ELIGIBILITY.DS_FAMILY_NAME%type, ds_component_name_1_p W_INSURANCE_ELIGIBILITY.DS_COMPONENT_NAME_1%type, ds_status_elegibilidade_p W_INSURANCE_ELIGIBILITY.DS_STATUS_ELEGIBILIDADE%type, ds_insurance_category_p W_INSURANCE_ELIGIBILITY.DS_INSURANCE_CATEGORY%type ) FROM PUBLIC;
