-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pkg_date_formaters.getcalendar (cd_estabelcimento_p bigint, nm_usuario_p text, ds_mask text default null) RETURNS varchar AS $body$
DECLARE
 ds_retorno_w varchar(100);

BEGIN
    if (ds_mask IS NOT NULL AND ds_mask::text <> '') then
        select max(ds_language)
        into STRICT ds_retorno_w
        from locale_formats
        where id_locale = pkg_date_formaters.getuserlanguagetag(cd_estabelcimento_p, nm_usuario_p)
        and id_mask = ds_mask;

        if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
            ds_retorno_w := concat('NLS_DATE_LANGUAGE=', ds_retorno_w);
        end if;
    end if;
    return ds_retorno_w;
   end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION pkg_date_formaters.getcalendar (cd_estabelcimento_p bigint, nm_usuario_p text, ds_mask text default null) FROM PUBLIC;
