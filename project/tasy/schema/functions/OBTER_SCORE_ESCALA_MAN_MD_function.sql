-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_escala_man_md ( qt_imc_p bigint, qt_circun_panturrilha_p bigint, ie_estresse_p bigint, ie_diminuicao_alimentar_p bigint, ie_perda_peso_p bigint, ie_mobilidade_p bigint, ie_neuropsicologicos_p bigint ) RETURNS bigint AS $body$
DECLARE

  qt_pontuacao_w real;

BEGIN
  qt_pontuacao_w := 0;

  if (qt_imc_p >= 19) and (qt_imc_p < 21) then
    qt_pontuacao_w := qt_pontuacao_w + 1;
  elsif (qt_imc_p >= 21) and (qt_imc_p < 23) then
    qt_pontuacao_w := qt_pontuacao_w + 2;
  elsif (qt_imc_p >= 23) then
    qt_pontuacao_w := qt_pontuacao_w + 3;
  end if;

  if (qt_circun_panturrilha_p >= 31) then
    qt_pontuacao_w := qt_pontuacao_w + 1;
  end if;

  qt_pontuacao_w := qt_pontuacao_w +
                    coalesce(ie_estresse_p, 0) +
					coalesce(ie_diminuicao_alimentar_p, 0)+
					coalesce(ie_perda_peso_p, 0)+
					coalesce(ie_mobilidade_p, 0)+
					coalesce(ie_neuropsicologicos_p, 0);

  return qt_pontuacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_escala_man_md ( qt_imc_p bigint, qt_circun_panturrilha_p bigint, ie_estresse_p bigint, ie_diminuicao_alimentar_p bigint, ie_perda_peso_p bigint, ie_mobilidade_p bigint, ie_neuropsicologicos_p bigint ) FROM PUBLIC;

