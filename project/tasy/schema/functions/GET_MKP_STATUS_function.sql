-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_mkp_status ( nr_atendimento_p atendimento_paciente.nr_atendimento%TYPE ) RETURNS varchar AS $body$
DECLARE


    mkp_status_w             varchar(1) := 'I';
    mkp_report_generated_w   parto.ie_mkp_generated%TYPE;
    row_count_w              smallint := 0;
  item RECORD;

BEGIN
    SELECT
        COUNT(*)
    INTO STRICT row_count_w
    FROM
        parto        p
        INNER JOIN nascimento   n ON p.nr_atendimento = n.nr_atendimento
    WHERE
        n.nr_atendimento = nr_atendimento_p
        AND coalesce(n.dt_inativacao::text, '') = '';

    IF row_count_w > 0 THEN
        SELECT
            ie_mkp_generated
        INTO STRICT mkp_report_generated_w
        FROM
            parto
        WHERE
            nr_atendimento = nr_atendimento_p;

        IF mkp_report_generated_w = 'Y' THEN
            mkp_status_w := 'Y';
        ELSE
            FOR item IN (
                SELECT
                    is_mandatory_filled(strarray(n.qt_sem_ig_total, n.qt_dia_ig_total, n.nr_seq_pos_birth, n.nr_seq_typ_del, n.ie_sexo,
                                                n.qt_peso, n.qt_altura, n.qt_pc, n.cd_arterial_ph, n.cd_arterial_base_excess,
                                                p.dt_fim_parto, p.dt_contracao_regular, p.qt_feto, p.cd_tipo_anestesia, p.cd_episiotomy
                                                )) ie_mandatory_filled
                FROM
                    nascimento   n
                    INNER JOIN parto        p ON p.nr_atendimento = n.nr_atendimento
                WHERE
                    n.nr_atendimento = nr_atendimento_p
                    AND coalesce(n.dt_inativacao::text, '') = ''
            ) LOOP
                IF item.ie_mandatory_filled = 'N' THEN
                    mkp_status_w := 'I';
                    EXIT;
                ELSE
                    mkp_status_w := 'S';
                END IF;
            END LOOP;
        END IF;

    END IF;

    RETURN mkp_status_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_mkp_status ( nr_atendimento_p atendimento_paciente.nr_atendimento%TYPE ) FROM PUBLIC;
