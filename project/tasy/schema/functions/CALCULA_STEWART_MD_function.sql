-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION calcula_stewart_md (ie_consciencia_p bigint, ie_via_aerea_p bigint, ie_movimento_p bigint, ie_sao2_p text, ie_normotermia_p text, ie_dor_controlada_p text, ie_ausencia_vomito_p text, ie_ausencia_sangramento_p text, ie_sinais_estaveis_p text) RETURNS bigint AS $body$
DECLARE

  qt_pontuacao_w bigint;

BEGIN

  qt_pontuacao_w := coalesce(ie_consciencia_p, 0) + coalesce(ie_via_aerea_p, 0) + coalesce(ie_movimento_p, 0);

  if (coalesce(ie_sao2_p, 'N') = 'S') then
    qt_pontuacao_w := qt_pontuacao_w + 1;
  end if;
  if (coalesce(ie_normotermia_p, 'N') = 'S') then
    qt_pontuacao_w := qt_pontuacao_w + 1;
  end if;
  if (coalesce(ie_dor_controlada_p, 'N') = 'S') then
    qt_pontuacao_w := qt_pontuacao_w + 1;
  end if;
  if (coalesce(ie_ausencia_vomito_p, 'N') = 'S') then
    qt_pontuacao_w := qt_pontuacao_w + 1;
  end if;
  if (coalesce(ie_ausencia_sangramento_p, 'N') = 'S') then
    qt_pontuacao_w := qt_pontuacao_w + 1;
  end if;
  if (coalesce(ie_sinais_estaveis_p, 'N') = 'S') then
    qt_pontuacao_w := qt_pontuacao_w + 1;
  end if;

  return qt_pontuacao_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION calcula_stewart_md (ie_consciencia_p bigint, ie_via_aerea_p bigint, ie_movimento_p bigint, ie_sao2_p text, ie_normotermia_p text, ie_dor_controlada_p text, ie_ausencia_vomito_p text, ie_ausencia_sangramento_p text, ie_sinais_estaveis_p text) FROM PUBLIC;
