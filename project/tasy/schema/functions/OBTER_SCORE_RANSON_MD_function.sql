-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_ranson_md (ie_pancreatite_aguda_p text, qt_idade_p bigint, qt_leucocitos_p bigint, qt_glicemia_p bigint, qt_dhl_p bigint, qt_tgo_p bigint, pr_queda_hematocrito_p bigint, qt_aumento_bun_p bigint, qt_calcemia_p bigint, qt_pao2_p bigint, qt_base_excess_p bigint, qt_sequestro_liquido_p bigint) RETURNS bigint AS $body$
DECLARE

  qt_pontuacao_w bigint;

BEGIN
  qt_pontuacao_w := 0;

  if (ie_pancreatite_aguda_p = 'N') then
    if (qt_idade_p > 55) then
      qt_pontuacao_w := qt_pontuacao_w + 1;
    end if;
    if (qt_leucocitos_p > 16000) then
      qt_pontuacao_w := qt_pontuacao_w + 1;
    end if;
    if (qt_glicemia_p > 200) then
      qt_pontuacao_w := qt_pontuacao_w + 1;
    end if;
    if (qt_dhl_p > 350) then
      qt_pontuacao_w := qt_pontuacao_w + 1;
    end if;
    if (qt_tgo_p > 250) then
      qt_pontuacao_w := qt_pontuacao_w + 1;
    end if;
    if (pr_queda_hematocrito_p > 10) then
      qt_pontuacao_w := qt_pontuacao_w + 1;
    end if;
    if (qt_aumento_bun_p > 5) then
      qt_pontuacao_w := qt_pontuacao_w + 1;
    end if;
    if (qt_calcemia_p < 8) then
      qt_pontuacao_w := qt_pontuacao_w + 1;
    end if;
    if (qt_pao2_p < 60) then
      qt_pontuacao_w := qt_pontuacao_w + 1;
    end if;
    if (qt_base_excess_p > 4) then
      qt_pontuacao_w := qt_pontuacao_w + 1;
    end if;
    if (qt_sequestro_liquido_p > 6) then
      qt_pontuacao_w := qt_pontuacao_w + 1;
    end if;

  elsif (ie_pancreatite_aguda_p = 'B') then
    if (qt_idade_p > 70) then
      qt_pontuacao_w := qt_pontuacao_w + 1;
    end if;
    if (qt_leucocitos_p > 18000) then
      qt_pontuacao_w := qt_pontuacao_w + 1;
    end if;
    if (qt_glicemia_p > 220) then
      qt_pontuacao_w := qt_pontuacao_w + 1;
    end if;
    if (qt_dhl_p > 400) then
      qt_pontuacao_w := qt_pontuacao_w + 1;
    end if;
    if (qt_tgo_p > 250) then
      qt_pontuacao_w := qt_pontuacao_w + 1;
    end if;
    if (pr_queda_hematocrito_p > 10) then
      qt_pontuacao_w := qt_pontuacao_w + 1;
    end if;
    if (qt_aumento_bun_p > 2) then
      qt_pontuacao_w := qt_pontuacao_w + 1;
    end if;
    if (qt_calcemia_p < 8) then
      qt_pontuacao_w := qt_pontuacao_w + 1;
    end if;
    if (qt_base_excess_p > 5) then
      qt_pontuacao_w := qt_pontuacao_w + 1;
    end if;
    if (qt_sequestro_liquido_p > 4) then
      qt_pontuacao_w := qt_pontuacao_w + 1;
    end if;
  end if;

  return qt_pontuacao_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_ranson_md (ie_pancreatite_aguda_p text, qt_idade_p bigint, qt_leucocitos_p bigint, qt_glicemia_p bigint, qt_dhl_p bigint, qt_tgo_p bigint, pr_queda_hematocrito_p bigint, qt_aumento_bun_p bigint, qt_calcemia_p bigint, qt_pao2_p bigint, qt_base_excess_p bigint, qt_sequestro_liquido_p bigint) FROM PUBLIC;
