-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION campo_numerico_md ( ds_campo_p text ) RETURNS bigint AS $body$
DECLARE


  ds_campo_w varchar(2000);
  cd_campo_w bigint;
  i          integer;


BEGIN
  ds_campo_w := '';
  if (coalesce(ds_campo_p::text, '') = '') or (ds_campo_p = '') then
    cd_campo_w := 0;
  else
    begin
      for i in 1..length(ds_campo_p) loop
        begin
          if (substr(ds_campo_p, i, 1) in ('1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '.')) then
            ds_campo_w := ds_campo_w || substr(ds_campo_p, i, 1);
          end if;
        end;
      end loop;
      if (coalesce(ds_campo_w::text, '') = '') or (ds_campo_w = '') then
        cd_campo_w := 0;
      else
        begin
          cd_campo_w := to_number(ds_campo_w, '9999999999d9999', ' NLS_NUMERIC_CHARACTERS = ''.,''');
        exception
          when others then
            cd_campo_w := 0;
        end;
      end if;
    end;
  end if;
  return cd_campo_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION campo_numerico_md ( ds_campo_p text ) FROM PUBLIC;
