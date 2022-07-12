-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION dtt_templates_contents ( nr_sequencia_p bigint ) RETURNS varchar AS $body$
DECLARE


    ds_retorno_w    varchar(1) := 'N';
    ds_nm_table_w   varchar(255);

/*
S - Template details has data(recording)
N - Template details has no data(recording)
E - Invalid Table name in Template details(Error) 
*/
    c01 CURSOR FOR
    SELECT
        tc.nm_table
    FROM
        dm_exp_template_contents tc
    WHERE
        tc.ie_active = 'S'
		AND (tc.nm_table IS NOT NULL AND tc.nm_table::text <> '')
        AND tc.nr_seq_template = nr_sequencia_p;


BEGIN
    IF (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') THEN
        BEGIN
            OPEN c01;
            LOOP
                FETCH c01 INTO ds_nm_table_w;
                    ds_retorno_w := 'S';
                    EXECUTE 'select 1 from ' || ds_nm_table_w;
                EXIT WHEN NOT FOUND; /* apply on c01 */
            END LOOP;

            CLOSE c01;
        EXCEPTION
            WHEN OTHERS THEN
                ds_retorno_w := 'E';
        END;
    END IF;

    RETURN ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION dtt_templates_contents ( nr_sequencia_p bigint ) FROM PUBLIC;

