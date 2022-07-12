-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pkg_date_formaters_tz.localize_mask (ds_mask text, lang_tag text ) RETURNS varchar AS $body$
DECLARE

    ds_retorno_w locale_formats.DS_LOCALIZED_MASK%TYPE;

BEGIN
    begin
        Select DS_LOCALIZED_MASK
        into STRICT   ds_retorno_w
        from   LOCALE_FORMATS
        where  ID_LOCALE = lang_tag
        and    ID_MASK = ds_mask;
    exception
        when no_data_found then
            RAISE EXCEPTION '%', 'Invalid date format: ' || coalesce(ds_mask, -1) || ', ' || coalesce(lang_tag, -1) USING ERRCODE = '45011';
    end;
    return ds_retorno_w;
  end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION pkg_date_formaters_tz.localize_mask (ds_mask text, lang_tag text ) FROM PUBLIC;