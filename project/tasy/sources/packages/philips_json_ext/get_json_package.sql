-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION philips_json_ext.get_json (obj philips_json, path text, base bigint default 1) RETURNS PHILIPS_JSON AS $body$
DECLARE

    temp philips_json_value;

BEGIN
    temp := philips_json_ext.get_json_value(obj, path, base);
    if (coalesce(temp::text, '') = '' or not temp.is_object) then
      return null;
    else
      return philips_json(temp);
    end if;
  end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION philips_json_ext.get_json (obj philips_json, path text, base bigint default 1) FROM PUBLIC;
