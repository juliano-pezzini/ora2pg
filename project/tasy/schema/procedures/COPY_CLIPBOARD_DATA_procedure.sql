-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copy_clipboard_data ( ie_record_type_p text, nr_sequencia_p bigint, nr_atendiment_p bigint ) AS $body$
DECLARE


    ds_txt_w                varchar(4000);
    dt_atualizacao_w        timestamp;
    nm_usuario_w            varchar(1000);
    dt_atualizacao_nrec_w   varchar(1000);
    nm_usuario_nrec_w       varchar(1000);

BEGIN
    IF ( ie_record_type_p = 'DI' ) THEN
        SELECT
            ds_doenca
            || ' '
            || cd_doenca
            || ' '
            || nr_seq_doenca
            || ' '
            || dt_inicio
            || ' '
            || dt_fim
            || ' '
            || ie_status
        INTO STRICT ds_txt_w
        FROM
            paciente_antec_clinico
        WHERE
            nr_sequencia = nr_sequencia_p
            AND nr_atendimento = nr_atendiment_p;

        SELECT
            nm_usuario,
            dt_atualizacao,
            dt_atualizacao_nrec,
            nm_usuario_nrec
        INTO STRICT
            nm_usuario_w,
            dt_atualizacao_w,
            dt_atualizacao_nrec_w,
            nm_usuario_nrec_w
        FROM
            paciente_antec_clinico where nr_sequencia = nr_sequencia_p
            AND nr_atendimento = nr_atendiment_p;

        INSERT INTO clipboard_data(
            nr_sequencia,
            cd_estabelecimento,
            dt_atualizacao,
            nm_usuario,
            dt_atualizacao_nrec,
            nm_usuario_nrec,
            ie_record_type,
            ie_clip_data,
            IE_SITUACAO
        ) VALUES (
            nr_sequencia_p,
            1,
            dt_atualizacao_w,
            nm_usuario_w,
            dt_atualizacao_nrec_w,
            nm_usuario_nrec_w,
            ie_record_type_p,
            ds_txt_w,
            'A'
        );

    END IF;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copy_clipboard_data ( ie_record_type_p text, nr_sequencia_p bigint, nr_atendiment_p bigint ) FROM PUBLIC;

