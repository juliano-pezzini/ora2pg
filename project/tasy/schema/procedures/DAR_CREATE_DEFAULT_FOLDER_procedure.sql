-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dar_create_default_folder () AS $body$
DECLARE

    exist_shared_folder_w   varchar(2);
    exist_private_folder_w  varchar(2);
    exist_dm_view_logs      varchar(2);


BEGIN
    
    SELECT
        coalesce(MAX('S'), 'N')
    INTO STRICT exist_shared_folder_w
    FROM
        tree_query_dar
    WHERE
            nm_usuario = wheb_usuario_pck.get_nm_usuario
        AND ie_tipo_pasta = 'S';

    SELECT
        coalesce(MAX('S'), 'N')
    INTO STRICT exist_private_folder_w
    FROM
        tree_query_dar
    WHERE
            nm_usuario = wheb_usuario_pck.get_nm_usuario
        AND ie_tipo_pasta = 'P';

    IF ( exist_private_folder_w = 'N' ) THEN
        INSERT INTO tree_query_dar(
            nr_sequencia,
            nm_usuario,
            nm_usuario_nrec,
            dt_atualizacao,
            dt_atualizacao_nrec,
            nr_seq_pai,
            nr_seq_ordem_apres,
            ie_tipo,
            nr_seq_filter,
            ds_titulo,
            ie_tipo_pasta
        ) VALUES (
            nextval('tree_query_dar_seq'),
            wheb_usuario_pck.get_nm_usuario,
            wheb_usuario_pck.get_nm_usuario,
            clock_timestamp(),
            clock_timestamp(),
            NULL,
            1,
            'P',
            NULL,
            'Private',
            'P'
        );

    END IF;

    IF ( exist_shared_folder_w = 'N' ) THEN
        INSERT INTO tree_query_dar(
            nr_sequencia,
            nm_usuario,
            nm_usuario_nrec,
            dt_atualizacao,
            dt_atualizacao_nrec,
            nr_seq_pai,
            nr_seq_ordem_apres,
            ie_tipo,
            nr_seq_filter,
            ds_titulo,
            ie_tipo_pasta
        ) VALUES (
            nextval('tree_query_dar_seq'),
            wheb_usuario_pck.get_nm_usuario,
            wheb_usuario_pck.get_nm_usuario,
            clock_timestamp(),
            clock_timestamp(),
            NULL,
            2,
            'P',
            NULL,
            'Shared',
            'S'
        );

    END IF;

    COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dar_create_default_folder () FROM PUBLIC;
