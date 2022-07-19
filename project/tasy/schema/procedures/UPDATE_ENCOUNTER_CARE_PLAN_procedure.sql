-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE update_encounter_care_plan (cd_pessoa_fisica_P text) AS $body$
DECLARE

 nr_atendimento_w   pe_prescricao.nr_atendimento%TYPE;
    dt_start_w         pe_prescr_diag.dt_start%TYPE;
    dt_entrad_w        pe_prescricao.dt_prescricao%TYPE;

BEGIN
    SELECT
        MAX(nr_atendimento)
    INTO STRICT nr_atendimento_w
    FROM
        pe_prescricao
    WHERE
        cd_pessoa_fisica = cd_pessoa_fisica_p;

    IF ( coalesce(nr_atendimento_w::text, '') = '' ) THEN
        SELECT
            MAX(nr_atendimento),
            MAX(dt_entrada)
        INTO STRICT
            nr_atendimento_w,
            dt_entrad_w
        FROM
            atendimento_paciente
        WHERE
            cd_pessoa_fisica = cd_pessoa_fisica_p;

        UPDATE pe_prescricao
        SET
            nr_atendimento = nr_atendimento_w,
            dt_prescricao = dt_entrad_w
        WHERE
            cd_pessoa_fisica = cd_pessoa_fisica_p
            AND coalesce(nr_atendimento::text, '') = '';

        COMMIT;
        SELECT
            MAX(a.dt_start)
        INTO STRICT dt_start_w
        FROM
            pe_prescr_diag   a,
            pe_prescricao    b
        WHERE
            a.nr_seq_prescr = b.nr_sequencia
            AND b.cd_pessoa_fisica = cd_pessoa_fisica_p;

        IF (dt_start_w IS NOT NULL AND dt_start_w::text <> '') THEN
            UPDATE pe_prescr_diag a
            SET
                a.dt_start = dt_entrad_w
            WHERE
                a.nr_seq_prescr IN (
                    SELECT
                        b.nr_sequencia
                    FROM
                        pe_prescricao b
                    WHERE
                        b.cd_pessoa_fisica = cd_pessoa_fisica_p
                );

            COMMIT;
        END IF;

    END IF;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE update_encounter_care_plan (cd_pessoa_fisica_P text) FROM PUBLIC;

