-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_idade_maior_md ( qt_idade_p bigint ) RETURNS varchar AS $body$
DECLARE

  ie_idade_maior_w varchar(1);

BEGIN

  ie_idade_maior_w := 'N';
  if (qt_idade_p >= 55) then
    ie_idade_maior_w := 'S';
  end if;

  return ie_idade_maior_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_idade_maior_md ( qt_idade_p bigint ) FROM PUBLIC;
