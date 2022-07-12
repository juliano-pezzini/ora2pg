-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION calcular_ponto_gravidade_md ( ie_anterocolo_retrocolo_p text, ie_rotacao_p bigint, ie_laterocolo_p bigint, ie_anterocolo_p bigint, ie_retrocolo_p bigint, ie_mudanca_lateral_p bigint, ie_mudanca_sagital_p bigint, ie_fator_duracao_p bigint, ie_efeito_truque_sensorial_p bigint, ie_elevacao_ombro_p bigint, ie_amplitude_movimento_p bigint, ie_tempo_p bigint ) RETURNS bigint AS $body$
BEGIN
  if (ie_anterocolo_retrocolo_p = 'A') then

    return coalesce(ie_rotacao_p, 0) + coalesce(ie_laterocolo_p, 0) + coalesce(ie_anterocolo_p, 0) +
           coalesce(ie_mudanca_lateral_p, 0) + coalesce(ie_mudanca_sagital_p, 0) +
           (coalesce(ie_fator_duracao_p, 0) * 2) +  coalesce(ie_efeito_truque_sensorial_p, 0) +
           coalesce(ie_elevacao_ombro_p, 0) + coalesce(ie_amplitude_movimento_p, 0) + coalesce(ie_tempo_p, 0);

  elsif (ie_anterocolo_retrocolo_p = 'R') then

    return coalesce(ie_rotacao_p, 0) + coalesce(ie_laterocolo_p, 0) + coalesce(ie_retrocolo_p, 0) +
           coalesce(ie_mudanca_lateral_p, 0) + coalesce(ie_mudanca_sagital_p, 0) +
           coalesce(ie_fator_duracao_p, 0) + coalesce(ie_efeito_truque_sensorial_p, 0) +
           coalesce(ie_elevacao_ombro_p, 0) + coalesce(ie_amplitude_movimento_p, 0) + coalesce(ie_tempo_p, 0);

  else
  
    return 0;

  end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION calcular_ponto_gravidade_md ( ie_anterocolo_retrocolo_p text, ie_rotacao_p bigint, ie_laterocolo_p bigint, ie_anterocolo_p bigint, ie_retrocolo_p bigint, ie_mudanca_lateral_p bigint, ie_mudanca_sagital_p bigint, ie_fator_duracao_p bigint, ie_efeito_truque_sensorial_p bigint, ie_elevacao_ombro_p bigint, ie_amplitude_movimento_p bigint, ie_tempo_p bigint ) FROM PUBLIC;

