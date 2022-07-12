-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION html_to_str_grid_new ( ds_texto_p text ) RETURNS text AS $body$
DECLARE


    ds_texto_w   varchar(32000);
    x            text;
    in_html      boolean := false;
    s            varchar(1);
BEGIN
    IF (ds_texto_p IS NOT NULL AND ds_texto_p::text <> '') AND ( ( position('<html' in ds_texto_p) > 0 ) OR ( position('<b' in ds_texto_p) > 0 ) OR ( position('</b' in ds_texto_p
    ) > 0 ) OR ( position('</center' in ds_texto_p) > 0 OR ( position('<br' in ds_texto_p) > 0 ) ) ) THEN
        FOR i IN 1..length(ds_texto_p) LOOP
            s := substr(ds_texto_p, i, 1);
            IF in_html THEN
                IF s = '>' THEN
                    in_html := false;
                    x := ltrim(x || ' ');
                END IF;

            ELSE
                IF s = '<' THEN
                    in_html := true;
                END IF;
            END IF;

            IF NOT in_html AND s != '>' THEN
                x := substr(x || s, 1, 32000);
            END IF;

        END LOOP;

        RETURN x;
    END IF;

    RETURN substr(ds_texto_w, 1, 32000);
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION html_to_str_grid_new ( ds_texto_p text ) FROM PUBLIC;

