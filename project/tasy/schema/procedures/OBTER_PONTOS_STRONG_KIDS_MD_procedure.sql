-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_pontos_strong_kids_md ( ie_deficit_nut_p text, ie_diarreia_excessiva_new_p text, ie_diarreia_excessiva_old_p text, ie_diarreia_p INOUT text, ie_vomito_p INOUT text, ie_reducao_ingestao_p text, ie_intervencao_nutricional_p text, ie_ingestao_nutricional_p text, ie_sinal_deficit_p text, ie_doenca_cirurgia_p text, ie_desnutricao_p text, ie_diminuicao_alimentar_p text, ie_dificuldade_dor_p text, ie_intervencao_prev_p text, ie_perda_peso_p text, ie_diarreia_excessiva_p INOUT text, qt_ponto_p INOUT bigint ) AS $body$
DECLARE

  qt_total_w bigint := 0;

BEGIN
  if (ie_deficit_nut_p = 'S') then
    qt_total_w	:= qt_total_w + 1;
  end if;

  if (coalesce(ie_diarreia_excessiva_new_p, 'N') != coalesce(ie_diarreia_excessiva_old_p, 'N')) then
    ie_diarreia_p := ie_diarreia_excessiva_new_p;
    ie_vomito_p := ie_diarreia_excessiva_new_p;
  end if;

  if (ie_diarreia_p = 'S') or (ie_vomito_p = 'S') then
    ie_diarreia_excessiva_p := 'S';
  else
    ie_diarreia_excessiva_p := 'N';
  end if;

  if (ie_reducao_ingestao_p= 'S')  then
    qt_total_w := qt_total_w + 1;
  end if;

  if (ie_intervencao_nutricional_p = 'S')  then
    qt_total_w	:= qt_total_w + 1;
  end if;

  if (ie_ingestao_nutricional_p = 'S')  then
    qt_total_w	:= qt_total_w + 1;
  end if;

  if (ie_sinal_deficit_p = 'S')  then
    qt_total_w	:= qt_total_w + 1;
  end if;

  if (ie_doenca_cirurgia_p = 'S') or (ie_desnutricao_p = 'S') then
    qt_total_w	:= qt_total_w + 2;
  end if;

  if	((ie_diarreia_p = 'S') or (ie_diarreia_excessiva_new_p = 'S') or (ie_diminuicao_alimentar_p = 'S') or (ie_dificuldade_dor_p = 'S') or (ie_vomito_p = 'S') or (ie_intervencao_prev_p = 'S')) then
    qt_total_w	:= qt_total_w + 1;
  end if;

  if (ie_perda_peso_p = 'S') then
    qt_total_w	:= qt_total_w + 1;
  end if;

  qt_ponto_p := qt_total_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_pontos_strong_kids_md ( ie_deficit_nut_p text, ie_diarreia_excessiva_new_p text, ie_diarreia_excessiva_old_p text, ie_diarreia_p INOUT text, ie_vomito_p INOUT text, ie_reducao_ingestao_p text, ie_intervencao_nutricional_p text, ie_ingestao_nutricional_p text, ie_sinal_deficit_p text, ie_doenca_cirurgia_p text, ie_desnutricao_p text, ie_diminuicao_alimentar_p text, ie_dificuldade_dor_p text, ie_intervencao_prev_p text, ie_perda_peso_p text, ie_diarreia_excessiva_p INOUT text, qt_ponto_p INOUT bigint ) FROM PUBLIC;
