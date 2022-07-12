-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION calcula_uso_corticoide_md (ie_corticoide_cronico_p text) RETURNS bigint AS $body$
DECLARE

  qt_pontuacao_w smallint;

BEGIN
  qt_pontuacao_w := 0;

  if (ie_corticoide_cronico_p = 'S') then
    qt_pontuacao_w := 3;
  else
    qt_pontuacao_w := 0;
  end if;
  return qt_pontuacao_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION calcula_uso_corticoide_md (ie_corticoide_cronico_p text) FROM PUBLIC;

