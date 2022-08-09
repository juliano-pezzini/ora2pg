-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE psa_subject_delete ( nm_usuario_p text ) AS $body$
DECLARE


    v_id_client        client.id%TYPE;
    v_id_application   application.id%TYPE;
    v_id_subject       subject.id%TYPE;
    v_id_datasource    datasource.id%TYPE;

BEGIN
    BEGIN
        SELECT
            id
        INTO STRICT v_id_subject
        FROM
            subject s
        WHERE
            s.ds_login = nm_usuario_p;

    EXCEPTION
        WHEN no_data_found THEN
            v_id_subject := NULL;
    END;

    v_id_application := psa_is_configured;
    v_id_client := psa_is_configured_client;
    v_id_datasource := psa_is_configured_datasource;
    IF
        (v_id_subject IS NOT NULL AND v_id_subject::text <> '') AND (v_id_application IS NOT NULL AND v_id_application::text <> '') AND (v_id_client IS NOT NULL AND v_id_client::text <> '') AND (v_id_datasource IS NOT NULL AND v_id_datasource::text <> '')
    THEN

       /* DEPRECATED since philips-security 2.0 - Begin */

        DELETE FROM application_subject
        WHERE
            id_subject = v_id_subject
            AND id_application = v_id_application;

        DELETE FROM subject_datasource
        WHERE
            id_subject = v_id_subject
            AND id_datasource = v_id_datasource;
        /* DEPRECATED since philips-security 2.0 - End */

        /* Removes the link between tasy client and subject */

        DELETE FROM subject_client
        WHERE
            id_subject = v_id_subject
            AND id_client = v_id_client;

        /* Removes linked tokens */

        DELETE FROM token
        WHERE
            id_subject = v_id_subject;

        /* Deletes the subject only if there isn't any other application,client or datasource linked to it */

        DELETE FROM subject
        WHERE
            id = v_id_subject
            /* DEPRECATED since philips-security 2.0 - Begin */

            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    application_subject ap
                WHERE
                    ap.id_subject = v_id_subject
            )
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    subject_datasource sd
                WHERE
                    sd.id_subject = v_id_subject
            )
            /* DEPRECATED since philips-security 2.0 - End */

            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    subject_client sc
                WHERE
                    sc.id_subject = v_id_subject
            );

    END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE psa_subject_delete ( nm_usuario_p text ) FROM PUBLIC;
