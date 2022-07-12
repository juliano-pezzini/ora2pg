-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION calcular_velocidade_infusao_md ( qt_dose_terap_p bigint, ie_peso_p text, qt_peso_p bigint, qt_concentracao_p bigint, ie_tempo_p text, ie_unidade_vel_p text ) RETURNS bigint AS $body$
DECLARE

  qt_dose_terap_w      bigint;
  qt_vel_infusao_mlh_w bigint;
  qt_vel_infusao_w     bigint;

BEGIN

  qt_dose_terap_w := qt_dose_terap_p;

  -- Conversao p/ unidade direta do elemento se for por peso
  if (ie_peso_p IS NOT NULL AND ie_peso_p::text <> '') then
    qt_dose_terap_w := coalesce(qt_peso_p, 0) * coalesce(qt_dose_terap_w, 0);
  end if;

  qt_vel_infusao_mlh_w := dividir_sem_round_md(qt_dose_terap_w, qt_concentracao_p);

  if (ie_tempo_p ='M') then
    qt_vel_infusao_mlh_w := coalesce(qt_vel_infusao_mlh_w, 0) * 60;
  end if;

  qt_vel_infusao_w := converte_velocidade_infusao_md('mlh',
                                                     ie_unidade_vel_p,
                                                     qt_vel_infusao_mlh_w
                                                     );
  return qt_vel_infusao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION calcular_velocidade_infusao_md ( qt_dose_terap_p bigint, ie_peso_p text, qt_peso_p bigint, qt_concentracao_p bigint, ie_tempo_p text, ie_unidade_vel_p text ) FROM PUBLIC;
