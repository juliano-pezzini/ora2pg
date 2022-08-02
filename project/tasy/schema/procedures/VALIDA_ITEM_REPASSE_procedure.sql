-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE valida_item_repasse ( nr_interno_conta_p bigint ) AS $body$
DECLARE


    nr_sequencia_item_ww      repasse_terceiro_item.nr_sequencia_item%TYPE;
    ie_status_w               repasse_terceiro.ie_status%TYPE;
    qt_repasse_vencimento_w   bigint := 0;
    vl_repasse_w              repasse_terceiro_item.vl_repasse%TYPE;
    c01 CURSOR FOR
    SELECT
        r.nr_repasse_terceiro,
        r.nr_sequencia_item,
        r.vl_repasse,
        r.ds_observacao,
        r.nr_seq_terceiro,
        r.cd_medico,
        r.dt_liberacao,
        r.cd_centro_custo,
        c.ie_status_acerto
    FROM
        repasse_terceiro_item   r,
        conta_paciente          c
    WHERE
        r.nr_interno_conta = c.nr_interno_conta
        AND r.nr_interno_conta = nr_interno_conta_p;

BEGIN
    FOR item IN c01 LOOP
        IF (item.nr_sequencia_item IS NOT NULL AND item.nr_sequencia_item::text <> '') THEN
            IF (item.nr_repasse_terceiro IS NOT NULL AND item.nr_repasse_terceiro::text <> '') THEN
                SELECT
                    ie_status
                INTO STRICT ie_status_w
                FROM
                    repasse_terceiro
                WHERE
                    nr_repasse_terceiro = item.nr_repasse_terceiro;

                SELECT
                    COUNT(*)
                INTO STRICT qt_repasse_vencimento_w
                FROM
                    repasse_terceiro_venc
                WHERE
                    nr_repasse_terceiro = item.nr_repasse_terceiro;

                IF ( ie_status_w = 'F' OR qt_repasse_vencimento_w > 0 ) THEN
                    IF ( item.ie_status_acerto = 1 ) THEN
                        UPDATE repasse_terceiro_item
                        SET
                            nr_interno_conta  = NULL,
                            ds_observacao = item.ds_observacao
                                            || ' '
                                            || obter_desc_expressao(1058714)
                        WHERE
                            nr_sequencia_item = item.nr_sequencia_item
                            AND nr_repasse_terceiro = item.nr_repasse_terceiro;

                    END IF;

                    vl_repasse_w := item.vl_repasse * -1;
                    SELECT
                        coalesce(MAX(nr_sequencia_item), 0) + 1
                    INTO STRICT nr_sequencia_item_ww
                    FROM
                        repasse_terceiro_item
                    WHERE
                        coalesce(nr_repasse_terceiro::text, '') = '';

                    INSERT INTO repasse_terceiro_item(
                        nr_sequencia,
                        dt_atualizacao,
                        nm_usuario,
                        vl_repasse,
                        ds_observacao,
                        nr_repasse_terceiro,
                        nr_sequencia_item,
                        nr_seq_terceiro,
                        dt_lancamento,
                        cd_medico,
                        dt_liberacao,
                        cd_centro_custo
                    ) VALUES (
                        nextval('repasse_terceiro_item_seq'),
                        clock_timestamp(),
                        wheb_usuario_pck.get_nm_usuario,
                        vl_repasse_w,
                        item.ds_observacao
                        || ' '
                        || obter_desc_expressao(1058714),
                        NULL,
                        nr_sequencia_item_ww,
                        item.nr_seq_terceiro,
                        clock_timestamp(),
                        item.cd_medico,
                        item.dt_liberacao,
                        item.cd_centro_custo
                    );

                ELSE
                    INSERT INTO repasse_terceiro_item_log(
                        nr_sequencia,
                        dt_atualizacao,
                        nm_usuario,
                        dt_atualizacao_nrec,
                        nm_usuario_nrec,
                        vl_repasse,
                        ds_observacao,
                        nr_interno_conta
                    ) VALUES (
                        nextval('repasse_terceiro_item_log_seq'),
                        clock_timestamp(),
                        wheb_usuario_pck.get_nm_usuario,
                        clock_timestamp(),
                        wheb_usuario_pck.get_nm_usuario,
                        item.vl_repasse,
                        item.ds_observacao
                        || ' '
                        || obter_desc_expressao(1058714),
                        nr_interno_conta_p
                    );

                    DELETE FROM repasse_terceiro_item
                    WHERE
                        nr_sequencia_item = item.nr_sequencia_item
                        AND nr_interno_conta = nr_interno_conta_p
                        AND nr_repasse_terceiro = item.nr_repasse_terceiro;

                END IF;

            ELSE
                INSERT INTO repasse_terceiro_item_log(
                    nr_sequencia,
                    dt_atualizacao,
                    nm_usuario,
                    dt_atualizacao_nrec,
                    nm_usuario_nrec,
                    vl_repasse,
                    ds_observacao,
                    nr_interno_conta
                ) VALUES (
                    nextval('repasse_terceiro_item_log_seq'),
                    clock_timestamp(),
                    wheb_usuario_pck.get_nm_usuario,
                    clock_timestamp(),
                    wheb_usuario_pck.get_nm_usuario,
                    item.vl_repasse,
                    item.ds_observacao
                    || ' '
                    || obter_desc_expressao(1058714),
                    nr_interno_conta_p
                );

                DELETE FROM repasse_terceiro_item
                WHERE
                    nr_sequencia_item = item.nr_sequencia_item
                    AND nr_interno_conta = nr_interno_conta_p;

            END IF;

        END IF;
    END LOOP;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE valida_item_repasse ( nr_interno_conta_p bigint ) FROM PUBLIC;

