-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_gro_status ( nr_atendimento_p atendimento_paciente.nr_atendimento%TYPE ) RETURNS varchar AS $body$
DECLARE


    gro_status_w             varchar(1) := 'I';
    gro_report_generated_w   parto.ie_mother_gro_generated%TYPE;
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
            ie_mother_gro_generated
        INTO STRICT gro_report_generated_w
        FROM
            parto
        WHERE
            nr_atendimento = nr_atendimento_p;

        IF gro_report_generated_w = 'Y' THEN
            gro_status_w := 'Y';
        ELSE
            FOR item IN (
                SELECT
                    is_mandatory_filled(strarray(n.nr_seq_pos_birth, n.nr_seq_typ_del, n.dt_nascimento, n.ie_sexo, n.qt_apgar_prim_min,
                                                n.qt_apgar_quinto_min, n.qt_apgar_decimo_min, n.qt_peso, n.qt_altura, n.qt_pc,
                                                n.cd_arterial_ph, n.cd_venous_ph, n.cd_arterial_base_excess, n.qt_sem_ig_total,
                                                n.qt_dia_ig_total, p.ie_ruprema, p.cd_tipo_anestesia, p.nr_seq_posicao_materna,
                                                p.dt_fim_parto, p.dt_contracao_regular, p.qt_feto, p.qt_gestacoes, p.qt_filhos_vivos,
                                                p.qt_natimortos, p.qt_parto_cesario,
                                                p.ds_prev_surg_vag_del, p.ie_tabagismo, p.ie_risco_gestacao, p.cd_episiotomy,
                                                CASE
                                                    WHEN EXISTS (
                                                        SELECT 1 FROM med_pac_pre_natal WHERE nr_atendimento = p.nr_atendimento
                                                    ) THEN obter_valor_pre_natal('MED_PAC_PRE_NATAL.QT_PESO_PRE_GESTACAO', p.nr_atendimento)
                                                    ELSE '0'
                                                END,
                                                CASE
                                                    WHEN EXISTS (
                                                        SELECT 1 FROM pre_parto WHERE nr_atendimento = p.nr_atendimento
                                                    ) THEN get_pre_parto_value('QT_PESO_MAE', p.nr_atendimento)
                                                    ELSE '0'
                                                END,
                                                CASE
                                                    WHEN EXISTS (
                                                        SELECT 1 FROM pre_parto WHERE nr_atendimento = p.nr_atendimento
                                                    ) THEN get_pre_parto_value('QT_ALTURA_CM', p.nr_atendimento)
                                                    ELSE '0'
                                                END
                    )) ie_mandatory_filled
                FROM
                    nascimento   n
                    INNER JOIN parto        p ON p.nr_atendimento = n.nr_atendimento
                WHERE
                    n.nr_atendimento = nr_atendimento_p
                    AND coalesce(n.dt_inativacao::text, '') = ''
            ) LOOP
                IF item.ie_mandatory_filled = 'N' THEN
                    gro_status_w := 'I';
                    EXIT;
                ELSE
                    gro_status_w := 'P';
                END IF;
            END LOOP;
        END IF;

    END IF;

    RETURN gro_status_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_gro_status ( nr_atendimento_p atendimento_paciente.nr_atendimento%TYPE ) FROM PUBLIC;

