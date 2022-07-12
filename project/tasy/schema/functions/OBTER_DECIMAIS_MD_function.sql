-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_decimais_md (vl_campo_p bigint) RETURNS varchar AS $body$
DECLARE


  qt_casa_w     bigint;
  ds_decimais_w varchar(20) := '';
  i      bigint  := 0;

BEGIN
  qt_casa_w := length(vl_campo_p - trunc(vl_campo_p)) - 1;

  if (qt_casa_w >= 1) then
    ds_decimais_w := '.';
    for i in 1 .. qt_casa_w loop
      begin
        ds_decimais_w := ds_decimais_w || '9';
      end;
    end loop;
  end if;

  return ds_decimais_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_decimais_md (vl_campo_p bigint) FROM PUBLIC;
