-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_admin_cursor.obter_desc_cursor_gigante ( cursor_p cursor_generico, ds_separador_p text default ',') RETURNS text AS $body$
DECLARE

  ds_retorno_w	text;
  ds_retorno_cursor varchar(1000);


BEGIN
  ds_retorno_w := null;
  ds_retorno_cursor := null;

  loop
      fetch cursor_p into ds_retorno_cursor;
      EXIT WHEN NOT FOUND; /* apply on cursor_p */

      if (coalesce(ds_retorno_w::text, '') = '') then
         ds_retorno_w := ds_retorno_cursor;
      else
	 ds_retorno_w := ds_retorno_w || ds_separador_p || ds_retorno_cursor;
      end if;

  end loop;
  close cursor_p;

  return ds_retorno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_admin_cursor.obter_desc_cursor_gigante ( cursor_p cursor_generico, ds_separador_p text default ',') FROM PUBLIC;
