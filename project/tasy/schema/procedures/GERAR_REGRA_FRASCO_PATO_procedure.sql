-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_regra_frasco_pato ( nr_atendimento_p bigint, nr_prescricao_p bigint, ie_tipo_atendimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_clinica_p bigint, cd_setor_atendimento_p bigint, ie_evento_geracao_p text, nm_usuario_p text ) AS $body$
DECLARE


    qt_frascos_w               bigint;
    ie_status_w                bigint;
    nr_seq_frasco_pato_loc_w   bigint;
    qt_regra_pato_w            bigint;
    nr_seq_regra_w             bigint;
    nr_prescricao_pato_w       bigint;
    qt_frascos_gravados_w      numeric(20) := 0;
    ie_clinica_w               bigint;
    ie_tipo_atendimento_w      smallint;
    qt_exames_w                bigint := 0;
    cd_procedimento_w          bigint;
    ie_origem_proced_w         bigint;
    nr_atendimento_w           bigint;
    cd_setor_atendimento_w     bigint;
    c01 CURSOR FOR
    SELECT
        a.nr_sequencia,
        coalesce(a.qt_frascos, 1),
        coalesce(a.ie_status, 10),
        a.cd_procedimento,
        a.ie_origem_proced
    FROM
        regra_frasco_pato a
    WHERE
        (
            (a.ie_evento_geracao = ie_evento_geracao_p AND a.cd_setor_atendimento = cd_setor_atendimento_p) OR
            ((coalesce(a.cd_setor_atendimento, cd_setor_atendimento_w) = cd_setor_atendimento_w) AND ( a.ie_evento_geracao = 'A' )
               AND NOT EXISTS (SELECT 1 FROM frasco_pato_loc x WHERE x.nr_atendimento = nr_atendimento_w))
        )
        AND coalesce(a.ie_clinica, 0) = CASE WHEN coalesce(a.ie_clinica::text, '') = '' THEN  0  ELSE ie_clinica_w END 
        AND coalesce(a.ie_tipo_atendimento, ie_tipo_atendimento_w) = ie_tipo_atendimento_w;


BEGIN
    SELECT COUNT(*)
    INTO STRICT qt_regra_pato_w
    FROM regra_frasco_pato;

    IF (coalesce(qt_regra_pato_w, 0) > 0) THEN
        IF (coalesce(nr_prescricao_p::text, '') = '') THEN
            SELECT MAX(nr_prescricao)
            INTO STRICT nr_prescricao_pato_w
            FROM prescr_medica
            WHERE nr_atendimento = nr_atendimento_p;
        ELSE
            nr_prescricao_pato_w := nr_prescricao_p;
        END IF;

        IF ( coalesce(nr_atendimento_p::text, '') = '' ) THEN
            SELECT
                coalesce(MAX(ie_clinica), 0),
                coalesce(MAX(ie_tipo_atendimento), 0),
                coalesce(MAX(a.nr_atendimento), 0)
            INTO STRICT
                ie_clinica_w,
                ie_tipo_atendimento_w,
                nr_atendimento_w
            FROM
                atendimento_paciente   a,
                prescr_medica          b
            WHERE
                a.nr_atendimento = b.nr_atendimento
                AND b.nr_prescricao = nr_prescricao_pato_w;

            cd_setor_atendimento_w := obter_setor_atendimento(nr_atendimento_w);
        ELSE
            ie_clinica_w := ie_clinica_p;
            ie_tipo_atendimento_w := ie_tipo_atendimento_p;
            nr_atendimento_w := nr_atendimento_p;
        END IF;

        OPEN c01;
        LOOP
            FETCH c01 INTO
                nr_seq_regra_w,
                qt_frascos_w,
                ie_status_w,
                cd_procedimento_w,
                ie_origem_proced_w;
            EXIT WHEN NOT FOUND; /* apply on c01 */
            BEGIN
                qt_exames_w := 0;
                IF (ie_evento_geracao_p IN ('PR', 'P')) THEN
                    IF (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') THEN
                        SELECT COUNT(*)
                        INTO STRICT qt_exames_w
                        FROM prescr_procedimento b
                        WHERE
                            b.cd_procedimento = cd_procedimento_w
                            AND b.ie_origem_proced = ie_origem_proced_w
                            AND b.nr_prescricao = nr_prescricao_pato_w;

                    ELSE
                        qt_exames_w := 1;
                    END IF;

                ELSE
                    IF ((coalesce(cd_procedimento_w, cd_procedimento_p) = cd_procedimento_p) AND (coalesce(ie_origem_proced_w, ie_origem_proced_p) = ie_origem_proced_p)) THEN
                        qt_exames_w := 1;
                    END IF;
                END IF;

                IF (coalesce(qt_exames_w, 0) > 0) THEN
                    qt_frascos_gravados_w := 0;
                    WHILE(qt_frascos_gravados_w < qt_frascos_w) LOOP
                        SELECT nextval('frasco_pato_loc_seq')
                        INTO STRICT nr_seq_frasco_pato_loc_w
;

                        INSERT INTO frasco_pato_loc(
                            nr_sequencia,
                            dt_atualizacao,
                            nm_usuario,
                            dt_atualizacao_nrec,
                            nm_usuario_nrec,
                            nr_atendimento,
                            ie_situacao,
                            ie_status,
                            ds_observacao,
                            nr_prescricao,
                            nr_seq_frasco_sup,
                            cd_setor_atendimento
                        ) VALUES (
                            nr_seq_frasco_pato_loc_w,
                            clock_timestamp(),
                            nm_usuario_p,
                            clock_timestamp(),
                            nm_usuario_p,
                            nr_atendimento_w,
                            'A',
                            ie_status_w,
                            NULL,
                            nr_prescricao_pato_w,
                            NULL,
                            cd_setor_atendimento_p
                        );

                        qt_frascos_gravados_w := qt_frascos_gravados_w + 1;
                    END LOOP;
                END IF;
            END;
        END LOOP;
        CLOSE c01;
    END IF;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_regra_frasco_pato ( nr_atendimento_p bigint, nr_prescricao_p bigint, ie_tipo_atendimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_clinica_p bigint, cd_setor_atendimento_p bigint, ie_evento_geracao_p text, nm_usuario_p text ) FROM PUBLIC;
