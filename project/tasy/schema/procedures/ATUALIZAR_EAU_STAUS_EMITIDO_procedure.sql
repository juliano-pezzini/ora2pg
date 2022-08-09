-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_eau_staus_emitido ( nm_usuario_p usuario.nm_usuario%TYPE ) AS $body$
DECLARE


    ds_status_sent_c        CONSTANT eau_issue_data.ie_status%TYPE := 'ENV';
    ds_status_issued_c      CONSTANT eau_issue_data.ie_status%TYPE := 'EMI';
    nr_days_subtraction_c   CONSTANT integer := 1;
    ds_username_c           CONSTANT usuario.nm_usuario%TYPE := coalesce(nm_usuario_p, obter_usuario_ativo);

BEGIN
    IF (ds_username_c IS NOT NULL AND ds_username_c::text <> '') THEN
        << update_eau_to_issued_after_24h >> UPDATE eau_issue_data
        SET
            ie_status = ds_status_issued_c,
            dt_atualizacao = clock_timestamp(),
            nm_usuario = ds_username_c
        WHERE
            ie_status = ds_status_sent_c
            AND dt_send <= clock_timestamp() - nr_days_subtraction_c;

        COMMIT;
    END IF;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_eau_staus_emitido ( nm_usuario_p usuario.nm_usuario%TYPE ) FROM PUBLIC;
