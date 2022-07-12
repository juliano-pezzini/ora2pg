-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_escala_frat_md ( ie_idade_p bigint, ie_queda_6_meses_p text, ie_eliminacao_p text, ie_medicacao_p text, ie_dispositivo_p text, ie_auxilio_superv_p text, ie_marcha_p text, ie_comprometimento_p text, ie_percepcao_p text, ie_impulsividade_p text, ie_limitacao_p text, ie_categoria_p text ) RETURNS bigint AS $body$
DECLARE

  qt_pontos_w smallint;

BEGIN
  qt_pontos_w := 0;
  if (ie_idade_p = 1) then
    qt_pontos_w := qt_pontos_w + 1;
  elsif (ie_idade_p = 2) then
    qt_pontos_w := qt_pontos_w + 2;
  elsif (ie_idade_p = 3) then
    qt_pontos_w := qt_pontos_w + 3;
  end if;

  if (ie_queda_6_meses_p = 'S') then
    qt_pontos_w := qt_pontos_w + 5;
  end if;

  if (ie_eliminacao_p = 'I') then
    qt_pontos_w := qt_pontos_w + 2;
  elsif (ie_eliminacao_p = 'F') then
    qt_pontos_w := qt_pontos_w + 2;
  elsif (ie_eliminacao_p = 'U') then
    qt_pontos_w := qt_pontos_w + 4;
  end if;

  if (ie_medicacao_p = 'U') then
    qt_pontos_w := qt_pontos_w + 3;
  elsif (ie_medicacao_p = 'D') then
    qt_pontos_w := qt_pontos_w + 5;
  elsif (ie_medicacao_p = 'P') then
    qt_pontos_w := qt_pontos_w + 7;
  end if;

  if (ie_dispositivo_p = 'U') then
    qt_pontos_w := qt_pontos_w + 1;
  elsif (ie_dispositivo_p = 'D') then
    qt_pontos_w := qt_pontos_w + 2;
  elsif (ie_dispositivo_p = 'T') then
    qt_pontos_w := qt_pontos_w + 3;
  end if;

  if (ie_auxilio_superv_p = 'S') then
    qt_pontos_w := qt_pontos_w + 2;
  end if;

  if (ie_marcha_p = 'S') then
    qt_pontos_w := qt_pontos_w + 2;
  end if;

  if (ie_comprometimento_p = 'S') then
    qt_pontos_w := qt_pontos_w + 2;
  end if;

  if (ie_percepcao_p = 'S') then
    qt_pontos_w := qt_pontos_w + 1;
  end if;

  if (ie_impulsividade_p = 'S') then
    qt_pontos_w := qt_pontos_w + 2;
  end if;

  if (ie_limitacao_p = 'S') then
    qt_pontos_w := qt_pontos_w + 4;
  end if;

  if (ie_categoria_p = 'C') then
    qt_pontos_w := 5;
  elsif (ie_categoria_p IS NOT NULL AND ie_categoria_p::text <> '') then
    qt_pontos_w := 14;
  end if;

  return qt_pontos_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_escala_frat_md ( ie_idade_p bigint, ie_queda_6_meses_p text, ie_eliminacao_p text, ie_medicacao_p text, ie_dispositivo_p text, ie_auxilio_superv_p text, ie_marcha_p text, ie_comprometimento_p text, ie_percepcao_p text, ie_impulsividade_p text, ie_limitacao_p text, ie_categoria_p text ) FROM PUBLIC;

