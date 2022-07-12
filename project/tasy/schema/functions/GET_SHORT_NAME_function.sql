-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_short_name ( ds_full_name_p text ) RETURNS varchar AS $body$
DECLARE


    ds_full_name_w   pessoa_fisica.nm_pessoa_fisica%TYPE NOT NULL := ds_full_name_p;
    ds_return_w      pessoa_fisica.nm_pessoa_fisica%TYPE;
    first_name_w     pessoa_fisica.nm_pessoa_fisica%TYPE;
    last_name_w      pessoa_fisica.nm_pessoa_fisica%TYPE;

BEGIN
    SELECT
        regexp_substr(trim(both ds_full_name_w), '^\w+'),
        regexp_replace(trim(both ds_full_name_w), '^\w+', '')
    INTO STRICT
        first_name_w,
        last_name_w
;

    IF (last_name_w IS NOT NULL AND last_name_w::text <> '') THEN
        /*Removing preposition of names (Brazil)*/

        last_name_w := trim(both regexp_replace(upper(last_name_w), '\sDA\s|\sDAS\s|\sDE\s|\sDO\s|\sDOS\s|\sE\s', ' '));

        last_name_w := regexp_replace(last_name_w, '(\w)\w+', '\1.');
        ds_return_w := first_name_w || ' ' || last_name_w;
    END IF;

    IF ( coalesce(ds_return_w::text, '') = '' ) THEN
        ds_return_w := first_name_w;
    END IF;
    RETURN ds_return_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_short_name ( ds_full_name_p text ) FROM PUBLIC;

