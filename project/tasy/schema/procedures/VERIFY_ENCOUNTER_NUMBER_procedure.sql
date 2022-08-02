-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE verify_encounter_number ( cd_pessoa_fisica_p text, nr_atendimento_p bigint, nr_acesso_dicom_p text, qt_count_p INOUT bigint ) AS $body$
BEGIN
    SELECT
        COUNT(c.nr_atendimento)
    INTO STRICT qt_count_p
    FROM
        prescr_procedimento    a,
        prescr_medica          b,
        atendimento_paciente   c
    WHERE
        a.nr_prescricao = b.nr_prescricao
        AND b.nr_atendimento = c.nr_atendimento
        AND c.cd_pessoa_fisica = cd_pessoa_fisica_p
        AND c.nr_atendimento = coalesce(nr_atendimento_p, b.nr_atendimento)
        AND a.nr_acesso_dicom = nr_acesso_dicom_p;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verify_encounter_number ( cd_pessoa_fisica_p text, nr_atendimento_p bigint, nr_acesso_dicom_p text, qt_count_p INOUT bigint ) FROM PUBLIC;

