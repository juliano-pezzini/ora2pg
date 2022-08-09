-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE validate_diagnosis_record ( NR_SEQ_PATIENT_DPC_P bigint, NR_SEQ_PAT_DIAGNOSIS_P bigint, SI_MAIN_P text, SI_FOR_HOSPITALIZATION_P text, SI_SECOND_MOST_EXPENSIVE_P text, SI_SUB_DISEASE_P text, SI_COMORBIDITY_BEFORE_P text, SI_AFTER_ADMISSION_P text) AS $body$
BEGIN

CALL dpc_pkg.VALIDATE_DIAGNOSIS_RECORD(NR_SEQ_PATIENT_DPC_P,NR_SEQ_PAT_DIAGNOSIS_P,SI_MAIN_P,SI_FOR_HOSPITALIZATION_P,SI_SECOND_MOST_EXPENSIVE_P,SI_SUB_DISEASE_P,SI_COMORBIDITY_BEFORE_P,SI_AFTER_ADMISSION_P);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE validate_diagnosis_record ( NR_SEQ_PATIENT_DPC_P bigint, NR_SEQ_PAT_DIAGNOSIS_P bigint, SI_MAIN_P text, SI_FOR_HOSPITALIZATION_P text, SI_SECOND_MOST_EXPENSIVE_P text, SI_SUB_DISEASE_P text, SI_COMORBIDITY_BEFORE_P text, SI_AFTER_ADMISSION_P text) FROM PUBLIC;
