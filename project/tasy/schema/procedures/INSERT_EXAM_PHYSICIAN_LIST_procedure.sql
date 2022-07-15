-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_exam_physician_list ( nm_user_p lista_central_exame.nm_usuario%TYPE, nr_physician_list_sequence_p lista_central_exame.nr_seq_lista_medico%TYPE, nr_prescription_p lista_central_exame.nr_prescricao%TYPE, nr_prescription_sequence_p lista_central_exame.nr_sequencia_prescricao%TYPE ) AS $body$
DECLARE

    nr_sort_order_w lista_central_exame.nr_ordem_apresentacao%TYPE;

BEGIN
    CALL gravar_log_cdi('1605', 'nr_physician_list_sequence_p:'
                           || nr_physician_list_sequence_p
                           || ' nr_prescription_p:'
                           || nr_prescription_p
                           || ' nr_prescription_sequence_p: '
                           || nr_prescription_sequence_p, nm_user_p);

    SELECT
        coalesce(MAX(a.nr_ordem_apresentacao), 0) + 5
    INTO STRICT nr_sort_order_w
    FROM
        lista_central_exame a
    WHERE
        a.nr_seq_lista_medico = nr_physician_list_sequence_p
        AND a.nr_prescricao IN (
            SELECT
                pp.nr_prescricao
            FROM
                prescr_procedimento pp
            WHERE
                a.nr_prescricao = pp.nr_prescricao
                AND a.nr_sequencia_prescricao = pp.nr_sequencia
                AND pp.ie_status_execucao = '20'
        );

    INSERT INTO lista_central_exame(
        nr_sequencia,
        dt_atualizacao,
        nm_usuario,
        dt_atualizacao_nrec,
        nm_usuario_nrec,
        nr_seq_lista_medico,
        nr_prescricao,
        nr_sequencia_prescricao,
        nr_ordem_apresentacao
    ) VALUES (
        nextval('lista_central_exame_seq'),
        clock_timestamp(),
        nm_user_p,
        clock_timestamp(),
        nm_user_p,
        nr_physician_list_sequence_p,
        nr_prescription_p,
        nr_prescription_sequence_p,
        nr_sort_order_w
    );

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_exam_physician_list ( nm_user_p lista_central_exame.nm_usuario%TYPE, nr_physician_list_sequence_p lista_central_exame.nr_seq_lista_medico%TYPE, nr_prescription_p lista_central_exame.nr_prescricao%TYPE, nr_prescription_sequence_p lista_central_exame.nr_sequencia_prescricao%TYPE ) FROM PUBLIC;

