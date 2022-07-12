-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_escala_lee_md ( ie_operacao_alto_risco_p text, ie_doenca_arterial_p text, ie_insuficiencia_cardiaca_p text, ie_doenca_cerebro_p text, ie_diabete_p text, ie_creatinina_p text ) RETURNS bigint AS $body$
DECLARE

  qt_pontuacao_w bigint;

BEGIN
  qt_pontuacao_w := 0;

  if (ie_operacao_alto_risco_p = 'S') then
    qt_pontuacao_w := qt_pontuacao_w + 1;
  end if;

  if (ie_doenca_arterial_p = 'S') then
    qt_pontuacao_w := qt_pontuacao_w + 1;
  end if;

  if (ie_insuficiencia_cardiaca_p = 'S') then
    qt_pontuacao_w := qt_pontuacao_w + 1;
  end if;

  if (ie_doenca_cerebro_p = 'S') then
    qt_pontuacao_w := qt_pontuacao_w + 1;
  end if;

  if (ie_diabete_p = 'S') then
    qt_pontuacao_w := qt_pontuacao_w + 1;
  end if;

  if (ie_creatinina_p = 'S') then
    qt_pontuacao_w := qt_pontuacao_w + 1;
  end if;

  return qt_pontuacao_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_escala_lee_md ( ie_operacao_alto_risco_p text, ie_doenca_arterial_p text, ie_insuficiencia_cardiaca_p text, ie_doenca_cerebro_p text, ie_diabete_p text, ie_creatinina_p text ) FROM PUBLIC;
