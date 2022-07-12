-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION somente_numero_deterministic ( ds_campo_p text) RETURNS bigint AS $body$
DECLARE


ds_campo_w     varchar(255);
cd_campo_w     numeric(38) := 0;
i       integer;


BEGIN
ds_campo_w  := '';
if (coalesce(ds_campo_p::text, '') = '') or (ds_campo_p = '') then
 cd_campo_w := 0;
else
 begin
 FOR i IN 1..length(ds_campo_p) LOOP
   begin
   if (substr(ds_campo_p, i, 1) in ('1','2','3','4','5','6','7','8','9','0')) then
     ds_campo_w := ds_campo_w || substr(ds_campo_p, i, 1);
  end if;
  end;
 END LOOP;
 if (coalesce(ds_campo_w::text, '') = '') OR (ds_campo_w = '') then
  cd_campo_w  := 0;
 else
  cd_campo_w := (substr(ds_campo_w,1,38))::numeric;
 end if;
 end;
end if;
RETURN cd_Campo_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION somente_numero_deterministic ( ds_campo_p text) FROM PUBLIC;

