-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_gerar_eis_lab_etapa ( dt_parametro_p eis_lab_qt_exame_etapa.dt_referencia%TYPE ) AS $body$
DECLARE

    nr_seq_grupo_w             eis_lab_qt_exame_etapa.nr_seq_grupo%TYPE;
    nr_seq_exame_w             eis_lab_qt_exame_etapa.nr_seq_exame%TYPE;
    cd_setor_solic_w           eis_lab_qt_exame_etapa.cd_setor_solicitacao%TYPE;
    ie_tipo_atendimento_w      eis_lab_qt_exame_etapa.ie_tipo_atendimento%TYPE;
    cd_medico_w                eis_lab_qt_exame_etapa.cd_medico%TYPE;
    ie_etapa_w                 prescr_proc_etapa.ie_etapa%TYPE;
    nm_exame_w                 eis_lab_qt_exame_etapa.nm_exame%TYPE;
    nr_prescricao_w            prescr_proc_etapa.nr_prescricao%TYPE;
    nr_seq_prescr_w            prescr_proc_etapa.nr_seq_prescricao%TYPE;
    dt_prescricao_w            eis_lab_qt_exame_etapa.dt_prescricao%TYPE;
    cd_setor_prescricao_w      eis_lab_qt_exame_etapa.cd_setor_prescricao%TYPE;
    cd_setor_entrega_w         eis_lab_qt_exame_etapa.cd_setor_entrega%TYPE;
    dt_prev_execucao_w         prescr_procedimento.dt_prev_execucao%TYPE;
    dt_coleta_w                prescr_procedimento.dt_coleta%TYPE;
    dt_liberacao_w             prescr_medica.dt_liberacao%TYPE;
    ie_urgencia_w              eis_lab_qt_exame_etapa.ie_urgencia%TYPE;
    dt_etapa_mapa_w            prescr_proc_etapa.dt_atualizacao%TYPE;
    dt_etapa_coleta_w          prescr_proc_etapa.dt_atualizacao%TYPE;
    dt_etapa_distrib_w         prescr_proc_etapa.dt_atualizacao%TYPE;
    dt_etapa_digit_w           prescr_proc_etapa.dt_atualizacao%TYPE;
    dt_etapa_aprov_w           prescr_proc_etapa.dt_atualizacao%TYPE;
    dt_etapa_lib_exame_w       prescr_proc_etapa.dt_atualizacao%TYPE;
    dt_etapa_mapa_ant_w        prescr_proc_etapa.dt_atualizacao%TYPE;
    dt_etapa_coleta_ant_w      prescr_proc_etapa.dt_atualizacao%TYPE;
    dt_etapa_distrib_ant_w     prescr_proc_etapa.dt_atualizacao%TYPE;
    dt_etapa_digit_ant_w       prescr_proc_etapa.dt_atualizacao%TYPE;
    dt_etapa_aprov_ant_w       prescr_proc_etapa.dt_atualizacao%TYPE;
    dt_etapa_lib_exame_ant_w   prescr_proc_etapa.dt_atualizacao%TYPE;
    nr_min_mapa_w              eis_lab_qt_exame_etapa.nr_min_mapa%TYPE;
    nr_min_coleta_w            eis_lab_qt_exame_etapa.nr_min_coleta%TYPE;
    nr_min_distrib_w           eis_lab_qt_exame_etapa.nr_min_distribuicao%TYPE;
    nr_min_dig_w               eis_lab_qt_exame_etapa.nr_min_digitacao%TYPE;
    nr_min_aprov_w             eis_lab_qt_exame_etapa.nr_min_aprovacao%TYPE;
    nr_min_coleta_aprov_w      eis_lab_qt_exame_etapa.nr_min_coleta_aprov%TYPE;
    nr_min_lib_aprov_w         eis_lab_qt_exame_etapa.nr_min_lib_aprov%TYPE;
    nr_min_lib_coleta_w        eis_lab_qt_exame_etapa.nr_min_lib_coleta%TYPE;
    nr_min_lib_digit_w         eis_lab_qt_exame_etapa.nr_min_lib_digitacao%TYPE;
    nr_min_prev_coleta_w       eis_lab_qt_exame_etapa.nr_min_prev_coleta%TYPE;
    nr_min_prev_aprov_w        eis_lab_qt_exame_etapa.nr_min_prev_aprovacao%TYPE;
    nr_min_lib_lib_exame_w     eis_lab_qt_exame_etapa.nr_min_lib_exame%TYPE;
    nm_usuario_etapa_w         eis_lab_qt_exame_etapa.nm_usuario_etapa%TYPE;
    dt_parametro_w             eis_lab_qt_exame_etapa.dt_referencia%TYPE;
    nr_sequencia_w             eis_lab_qt_exame_etapa.nr_sequencia%TYPE;
    nr_sequencia_etapa_w       prescr_proc_etapa.nr_sequencia%TYPE;
    nr_seq_etapa_atual_w       prescr_proc_etapa.nr_sequencia%TYPE;
    nr_seq_etapa_ant_w         prescr_proc_etapa.nr_sequencia%TYPE;
    cd_pessoa_fisica_w         pessoa_fisica.cd_pessoa_fisica%TYPE;
    c01 CURSOR FOR
    SELECT
        b.nr_seq_grupo,
        a.nr_seq_exame,
        coalesce(d.cd_setor_entrega, d.cd_setor_atendimento),
        e.ie_tipo_atendimento,
        d.cd_medico,
        c.ie_etapa,
        substr(b.nm_exame, 1, 255),
        d.nr_prescricao,
        a.nr_sequencia,
        trunc(d.dt_prescricao, 'dd'),
        d.cd_setor_atendimento,
        d.cd_setor_entrega,
        a.dt_prev_execucao,
        a.dt_coleta,
        d.dt_liberacao,
        coalesce(a.ie_urgencia, 'N'),
        coalesce(c.nm_usuario, obter_desc_expressao(327119)),
        d.cd_pessoa_fisica
    FROM
        prescr_procedimento    a,
        exame_laboratorio      b,
        prescr_proc_etapa      c,
        prescr_medica          d,
        atendimento_paciente   e
    WHERE
        a.nr_seq_exame = b.nr_seq_exame
        AND a.nr_prescricao = c.nr_prescricao
        AND a.nr_sequencia = c.nr_seq_prescricao
        AND a.nr_prescricao = d.nr_prescricao
        AND d.nr_atendimento = e.nr_atendimento
        AND c.nr_sequencia = (
            SELECT
                MAX(nr_sequencia)
            FROM
                prescr_proc_etapa
            WHERE
                nr_prescricao = d.nr_prescricao
                AND nr_seq_prescricao = a.nr_sequencia
                AND ie_etapa = c.ie_etapa
        )
        AND (a.nr_seq_exame IS NOT NULL AND a.nr_seq_exame::text <> '')
        AND (d.dt_liberacao IS NOT NULL AND d.dt_liberacao::text <> '')
        AND trunc(d.dt_prescricao, 'dd') = dt_parametro_w
        AND pfcs_lab_obter_se_exame_covid(b.nr_seq_exame) = 'S';


BEGIN
    dt_parametro_w := trunc(dt_parametro_p, 'dd');
    DELETE FROM eis_lab_qt_exame_etapa
    WHERE
        dt_referencia = dt_parametro_w;

    OPEN c01;
    LOOP
        FETCH c01 INTO
            nr_seq_grupo_w,
            nr_seq_exame_w,
            cd_setor_solic_w,
            ie_tipo_atendimento_w,
            cd_medico_w,
            ie_etapa_w,
            nm_exame_w,
            nr_prescricao_w,
            nr_seq_prescr_w,
            dt_prescricao_w,
            cd_setor_prescricao_w,
            cd_setor_entrega_w,
            dt_prev_execucao_w,
            dt_coleta_w,
            dt_liberacao_w,
            ie_urgencia_w,
            nm_usuario_etapa_w,
            cd_pessoa_fisica_w;

        EXIT WHEN NOT FOUND; /* apply on c01 */
        BEGIN
            nr_min_mapa_w := NULL;
            nr_min_coleta_w := NULL;
            nr_min_distrib_w := NULL;
            nr_min_dig_w := NULL;
            nr_min_aprov_w := NULL;
            nr_min_coleta_aprov_w := NULL;
            nr_min_lib_aprov_w := NULL;
            nr_min_lib_coleta_w := NULL;
            nr_min_lib_digit_w := NULL;
            nr_min_prev_coleta_w := NULL;
            nr_min_prev_aprov_w := NULL;
            dt_etapa_mapa_w := NULL;
            dt_etapa_coleta_w := NULL;
            dt_etapa_distrib_w := NULL;
            dt_etapa_digit_w := NULL;
            dt_etapa_aprov_w := NULL;
            dt_etapa_mapa_ant_w := NULL;
            dt_etapa_coleta_ant_w := NULL;
            dt_etapa_distrib_ant_w := NULL;
            dt_etapa_digit_ant_w := NULL;
            dt_etapa_aprov_ant_w := NULL;
            SELECT
                coalesce(MAX(nr_sequencia), 0)
            INTO STRICT nr_sequencia_etapa_w
            FROM
                prescr_proc_etapa
            WHERE
                nr_prescricao = nr_prescricao_w
                AND nr_seq_prescricao = nr_seq_prescr_w
                AND ie_etapa = ie_etapa_w;

            SELECT
                MIN(nr_sequencia)
            INTO STRICT nr_seq_etapa_atual_w
            FROM
                prescr_proc_etapa
            WHERE
                nr_prescricao = nr_prescricao_w
                AND nr_seq_prescricao = nr_seq_prescr_w
                AND ie_etapa = ie_etapa_w;

            SELECT
                MAX(nr_sequencia)
            INTO STRICT nr_seq_etapa_ant_w
            FROM
                prescr_proc_etapa
            WHERE
                nr_prescricao = nr_prescricao_w
                AND nr_seq_prescricao = nr_seq_prescr_w
                AND nr_sequencia < nr_seq_etapa_atual_w;

            IF ( nr_sequencia_etapa_w > 0 ) THEN
                IF ( ie_etapa_w = 15 ) THEN
                    BEGIN
                        SELECT
                            coalesce(MAX(dt_atualizacao), NULL)
                        INTO STRICT dt_etapa_mapa_w
                        FROM
                            prescr_proc_etapa
                        WHERE
                            nr_prescricao = nr_prescricao_w
                            AND nr_seq_prescricao = nr_seq_prescr_w
                            AND ie_etapa = ie_etapa_w
                            AND nr_sequencia = nr_sequencia_etapa_w;

                        IF ( coalesce(nr_seq_etapa_ant_w::text, '') = '' ) THEN
                            dt_etapa_mapa_ant_w := dt_liberacao_w;
                        ELSE
                            SELECT
                                MAX(dt_atualizacao)
                            INTO STRICT dt_etapa_mapa_ant_w
                            FROM
                                prescr_proc_etapa
                            WHERE
                                nr_sequencia = nr_seq_etapa_ant_w
                                AND nr_prescricao = nr_prescricao_w
                                AND nr_seq_prescricao = nr_seq_prescr_w;

                        END IF;

                    END;
                ELSIF ( ie_etapa_w = 20 ) THEN
                    BEGIN
                        SELECT
                            coalesce(MAX(dt_atualizacao), NULL)
                        INTO STRICT dt_etapa_coleta_w
                        FROM
                            prescr_proc_etapa
                        WHERE
                            nr_prescricao = nr_prescricao_w
                            AND nr_seq_prescricao = nr_seq_prescr_w
                            AND ie_etapa = ie_etapa_w
                            AND nr_sequencia = nr_sequencia_etapa_w;

                        IF ( coalesce(nr_seq_etapa_ant_w::text, '') = '' ) THEN
                            dt_etapa_coleta_ant_w := dt_liberacao_w;
                        ELSE
                            SELECT
                                MAX(dt_atualizacao)
                            INTO STRICT dt_etapa_coleta_ant_w
                            FROM
                                prescr_proc_etapa
                            WHERE
                                nr_sequencia = nr_seq_etapa_ant_w
                                AND nr_prescricao = nr_prescricao_w
                                AND nr_seq_prescricao = nr_seq_prescr_w;

                        END IF;

                    END;
                ELSIF ( ie_etapa_w = 25 ) THEN
                    BEGIN
                        SELECT
                            coalesce(MAX(dt_atualizacao), NULL)
                        INTO STRICT dt_etapa_distrib_w
                        FROM
                            prescr_proc_etapa
                        WHERE
                            nr_prescricao = nr_prescricao_w
                            AND nr_seq_prescricao = nr_seq_prescr_w
                            AND ie_etapa = ie_etapa_w
                            AND nr_sequencia = nr_sequencia_etapa_w;

                        IF ( coalesce(nr_seq_etapa_ant_w::text, '') = '' ) THEN
                            dt_etapa_distrib_ant_w := dt_liberacao_w;
                        ELSE
                            SELECT
                                MAX(dt_atualizacao)
                            INTO STRICT dt_etapa_distrib_ant_w
                            FROM
                                prescr_proc_etapa
                            WHERE
                                nr_sequencia = nr_seq_etapa_ant_w
                                AND nr_prescricao = nr_prescricao_w
                                AND nr_seq_prescricao = nr_seq_prescr_w;

                        END IF;

                    END;
                ELSIF ( ie_etapa_w = 30 ) THEN
                    BEGIN
                        SELECT
                            coalesce(MAX(dt_atualizacao), NULL)
                        INTO STRICT dt_etapa_digit_w
                        FROM
                            prescr_proc_etapa
                        WHERE
                            nr_prescricao = nr_prescricao_w
                            AND nr_seq_prescricao = nr_seq_prescr_w
                            AND ie_etapa = ie_etapa_w
                            AND nr_sequencia = nr_sequencia_etapa_w;

                        IF ( coalesce(nr_seq_etapa_ant_w::text, '') = '' ) THEN
                            dt_etapa_digit_ant_w := dt_liberacao_w;
                        ELSE
                            SELECT
                                MAX(dt_atualizacao)
                            INTO STRICT dt_etapa_digit_ant_w
                            FROM
                                prescr_proc_etapa
                            WHERE
                                nr_sequencia = nr_seq_etapa_ant_w
                                AND nr_prescricao = nr_prescricao_w
                                AND nr_seq_prescricao = nr_seq_prescr_w;

                        END IF;

                    END;
                ELSIF ( ie_etapa_w = 35 ) THEN
                    BEGIN
                        SELECT
                            coalesce(MAX(dt_atualizacao), NULL)
                        INTO STRICT dt_etapa_aprov_w
                        FROM
                            prescr_proc_etapa
                        WHERE
                            nr_prescricao = nr_prescricao_w
                            AND nr_seq_prescricao = nr_seq_prescr_w
                            AND ie_etapa = ie_etapa_w
                            AND nr_sequencia = nr_sequencia_etapa_w;

                        IF ( coalesce(nr_seq_etapa_ant_w::text, '') = '' ) THEN
                            dt_etapa_aprov_ant_w := dt_liberacao_w;
                        ELSE
                            SELECT
                                MAX(dt_atualizacao)
                            INTO STRICT dt_etapa_aprov_ant_w
                            FROM
                                prescr_proc_etapa
                            WHERE
                                nr_sequencia = nr_seq_etapa_ant_w
                                AND nr_prescricao = nr_prescricao_w
                                AND nr_seq_prescricao = nr_seq_prescr_w;

                        END IF;

                    END;
                ELSIF ( ie_etapa_w = 40 ) THEN
                    BEGIN
                        SELECT
                            coalesce(MAX(dt_atualizacao), NULL)
                        INTO STRICT dt_etapa_lib_exame_w
                        FROM
                            prescr_proc_etapa
                        WHERE
                            nr_prescricao = nr_prescricao_w
                            AND nr_seq_prescricao = nr_seq_prescr_w
                            AND ie_etapa = ie_etapa_w
                            AND nr_sequencia = nr_sequencia_etapa_w;

                        IF ( coalesce(nr_seq_etapa_ant_w::text, '') = '' ) THEN
                            dt_etapa_lib_exame_ant_w := dt_liberacao_w;
                        ELSE
                            SELECT
                                MAX(dt_atualizacao)
                            INTO STRICT dt_etapa_lib_exame_ant_w
                            FROM
                                prescr_proc_etapa
                            WHERE
                                nr_sequencia = nr_seq_etapa_ant_w
                                AND nr_prescricao = nr_prescricao_w
                                AND nr_seq_prescricao = nr_seq_prescr_w;

                        END IF;

                    END;
                END IF;

                nr_min_mapa_w := ( dt_etapa_mapa_w - dt_etapa_mapa_ant_w );
                nr_min_coleta_w := ( dt_etapa_coleta_w - dt_etapa_coleta_ant_w );
                nr_min_distrib_w := ( dt_etapa_distrib_w - dt_etapa_distrib_ant_w );
                nr_min_dig_w := ( dt_etapa_digit_w - dt_etapa_digit_ant_w );
                nr_min_aprov_w := ( dt_etapa_aprov_w - dt_etapa_aprov_ant_w );
                nr_min_coleta_aprov_w := ( dt_etapa_aprov_w - dt_coleta_w );
				nr_min_lib_aprov_w := ( coalesce(dt_etapa_aprov_w, clock_timestamp()) - dt_liberacao_w );
                nr_min_lib_coleta_w := ( dt_coleta_w - dt_liberacao_w );
                nr_min_lib_digit_w := ( dt_etapa_digit_w - dt_liberacao_w );
                nr_min_prev_coleta_w := ( dt_etapa_coleta_w - dt_prev_execucao_w );
                nr_min_prev_aprov_w := ( dt_etapa_aprov_w - dt_prev_execucao_w );
                nr_min_lib_lib_exame_w := ( dt_etapa_lib_exame_w - dt_liberacao_w );
            END IF;

            SELECT
                nextval('eis_lab_qt_exame_etapa_seq')
            INTO STRICT nr_sequencia_w
;

            INSERT INTO eis_lab_qt_exame_etapa(
                nr_sequencia,
                dt_atualizacao,
                nm_usuario,
                dt_atualizacao_nrec,
                nm_usuario_nrec,
                nr_seq_grupo,
                nr_seq_exame,
                cd_setor_solicitacao,
                ie_tipo_atendimento,
                cd_medico,
                ie_etapa,
                dt_referencia,
                nm_exame,
                nr_prescricao,
                nr_seq_prescr,
                dt_prescricao,
                cd_setor_prescricao,
                cd_setor_entrega,
                nr_min_mapa,
                nr_min_coleta,
                nr_min_distribuicao,
                nr_min_digitacao,
                nr_min_aprovacao,
                nr_min_coleta_aprov,
                nr_min_lib_aprov,
                nr_min_lib_coleta,
                nr_min_lib_digitacao,
                dt_coleta,
                nr_min_prev_coleta,
                nr_min_prev_aprovacao,
                ie_urgencia,
                dt_aprovacao,
                nr_min_lib_exame,
                nm_usuario_etapa,
                cd_pessoa_fisica
            ) VALUES (
                nr_sequencia_w,
                clock_timestamp(),
                'COVID19',
                clock_timestamp(),
                'COVID19',
                nr_seq_grupo_w,
                nr_seq_exame_w,
                cd_setor_solic_w,
                ie_tipo_atendimento_w,
                cd_medico_w,
                ie_etapa_w,
                dt_parametro_w,
                nm_exame_w,
                nr_prescricao_w,
                nr_seq_prescr_w,
                dt_prescricao_w,
                cd_setor_prescricao_w,
                cd_setor_entrega_w,
                nr_min_mapa_w,
                nr_min_coleta_w,
                nr_min_distrib_w,
                nr_min_dig_w,
                nr_min_aprov_w,
                nr_min_coleta_aprov_w,
                nr_min_lib_aprov_w,
                nr_min_lib_coleta_w,
                nr_min_lib_digit_w,
                dt_coleta_w,
                nr_min_prev_coleta_w,
                nr_min_prev_aprov_w,
                ie_urgencia_w,
                dt_etapa_aprov_w,
                nr_min_lib_lib_exame_w,
                nm_usuario_etapa_w,
                cd_pessoa_fisica_w
            );

        END;

    END LOOP;

    CLOSE c01;
    COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_gerar_eis_lab_etapa ( dt_parametro_p eis_lab_qt_exame_etapa.dt_referencia%TYPE ) FROM PUBLIC;

