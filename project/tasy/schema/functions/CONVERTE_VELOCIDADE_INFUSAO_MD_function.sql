-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION converte_velocidade_infusao_md ( ie_vel_origem_p text, ie_vel_destino_p text, qt_velocidade_p bigint ) RETURNS bigint AS $body$
DECLARE


  qt_velocidade_w bigint := qt_velocidade_p;


BEGIN

  if (ie_vel_origem_p <> ie_vel_destino_p) then
    if (ie_vel_origem_p = 'mlh' and ie_vel_destino_p = 'gtm') then
        qt_velocidade_w	:= dividir_sem_round_md((qt_velocidade_p * 20),60);
    elsif (ie_vel_origem_p = 'gtm' and ie_vel_destino_p = 'mlh') then
        qt_velocidade_w	:= dividir_sem_round_md((qt_velocidade_p * 60),20);
    elsif (ie_vel_origem_p = 'gtm' and ie_vel_destino_p = 'mgm') then
        qt_velocidade_w	:= dividir_sem_round_md(dividir_sem_round_md((qt_velocidade_p * 60),20) * 60,60);
    elsif (ie_vel_origem_p = 'mgm' and ie_vel_destino_p = 'gtm') then
        qt_velocidade_w	:= dividir_sem_round_md((dividir_sem_round_md((qt_velocidade_p * 60),60) * 20),60);
    end if;
  end if;

  return qt_velocidade_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION converte_velocidade_infusao_md ( ie_vel_origem_p text, ie_vel_destino_p text, qt_velocidade_p bigint ) FROM PUBLIC;

