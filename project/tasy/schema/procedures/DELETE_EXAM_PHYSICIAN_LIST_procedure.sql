-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE delete_exam_physician_list ( nm_user_p lista_central_exame.nm_usuario%TYPE, nr_physician_list_sequence_p lista_central_exame.nr_seq_lista_medico%TYPE, nr_prescription_p lista_central_exame.nr_prescricao%TYPE, nr_prescription_sequence_p lista_central_exame.nr_sequencia_prescricao%TYPE ) AS $body$
BEGIN
    CALL gravar_log_cdi('1605', 'Remove: nr_physician_list_sequence_p:'
                           || nr_physician_list_sequence_p
                           || ' nr_prescription_p:'
                           || nr_prescription_p
                           || ' nr_prescription_number_p: '
                           || nr_prescription_sequence_p, nm_user_p);

    DELETE FROM lista_central_exame
    WHERE
        nr_seq_lista_medico = nr_physician_list_sequence_p
        AND nr_prescricao = nr_prescription_p
        AND nr_sequencia_prescricao = nr_prescription_sequence_p;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE delete_exam_physician_list ( nm_user_p lista_central_exame.nm_usuario%TYPE, nr_physician_list_sequence_p lista_central_exame.nr_seq_lista_medico%TYPE, nr_prescription_p lista_central_exame.nr_prescricao%TYPE, nr_prescription_sequence_p lista_central_exame.nr_sequencia_prescricao%TYPE ) FROM PUBLIC;
