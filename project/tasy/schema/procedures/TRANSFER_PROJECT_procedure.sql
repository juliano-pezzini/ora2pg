-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE transfer_project ( nr_sequencia_p bigint, ie_mouse_click_p text DEFAULT 'N', cd_project_p bigint DEFAULT NULL, ds_history_p text DEFAULT NULL) AS $body$
BEGIN
    IF ( ie_mouse_click_p = 'S' and (cd_project_p IS NOT NULL AND cd_project_p::text <> '')) THEN
        UPDATE latam_requisito
        SET
            ie_liberar_desenv = 'TP',
			ie_esforco_desenv  = NULL,
            ie_complexidade  = NULL,
            qt_tempo_horas  = NULL,
            pr_confianca  = NULL,
            cd_project = cd_project_p
        WHERE
            nr_sequencia = nr_sequencia_p;

    END IF;

    INSERT INTO latam_requisito_historico(
        nr_sequencia,
        dt_atualizacao,
        nm_usuario,
        nr_seq_requisito,
        ie_situacao,
        ds_historico
    ) VALUES (
        nextval('latam_requisito_historico_seq'),
        clock_timestamp(),
        wheb_usuario_pck.get_nm_usuario,
        nr_sequencia_p,
        'A',
        ds_history_p
    );

    COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE transfer_project ( nr_sequencia_p bigint, ie_mouse_click_p text DEFAULT 'N', cd_project_p bigint DEFAULT NULL, ds_history_p text DEFAULT NULL) FROM PUBLIC;
