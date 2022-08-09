-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE valid_dm_materialised_view ( nr_sequencia_p bigint, ie_valid_p INOUT text ) AS $body$
DECLARE


    c01 CURSOR FOR
    SELECT
        nr_sequencia,
        ds_sql,
        object_name
    FROM
        data_model
    WHERE
        (ds_sql IS NOT NULL AND ds_sql::text <> '')
        AND coalesce(ie_situacao, 'A') = 'A'
        AND ( coalesce(nr_sequencia_p::text, '') = ''
              OR nr_sequencia = nr_sequencia_p );

    c01_w       c01%rowtype;
    material_w  varchar(250);

BEGIN
    ie_valid_p := 'S';
    OPEN c01;
    LOOP
        FETCH c01 INTO c01_w;
        EXIT WHEN NOT FOUND; /* apply on c01 */
        material_w := upper(c01_w.object_name);
        BEGIN
            BEGIN
                EXECUTE 'select nvl(max(''S''),''N'') from ' || material_w;
			EXCEPTION
                WHEN OTHERS THEN
                    ie_valid_p := 'N';
                    EXECUTE 'DROP MATERIALIZED VIEW ' || material_w;
                    UPDATE data_model
                    SET
                        ie_situacao = 'I'
                    WHERE
                        nr_sequencia = c01_w.nr_sequencia;
            END;
			EXCEPTION
            WHEN OTHERS THEN
                ie_valid_p := 'N';
				UPDATE data_model
                    SET
                        ie_situacao = 'I'
                    WHERE
                        nr_sequencia = c01_w.nr_sequencia;
        END;
    END LOOP;
    COMMIT;
    CLOSE c01;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE valid_dm_materialised_view ( nr_sequencia_p bigint, ie_valid_p INOUT text ) FROM PUBLIC;
