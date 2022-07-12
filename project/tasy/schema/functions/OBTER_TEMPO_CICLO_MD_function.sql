-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tempo_ciclo_md (qt_tempo_ciclo_p bigint) RETURNS varchar AS $body$
DECLARE

  v_result_w  varchar(100);
  v_hora_w    bigint;
  v_minutos_w bigint;


BEGIN
  if (qt_tempo_ciclo_p > 1440) then
    v_result_w := '23:59';
  else
    v_hora_w := trunc(qt_tempo_ciclo_p / 60);
    if (v_hora_w < 10) then
      v_result_w := '0' || v_hora_w;
    else
      v_result_w := v_hora_w;
    end if;
    v_result_w := v_result_w || ':';

    v_minutos_w := trunc(mod(qt_tempo_ciclo_p, 60));

    if (v_minutos_w < 10) then
      v_result_w := v_result_w || '0' || v_minutos_w;
    else
      v_result_w := v_result_w || v_minutos_w;
    end if;

  end if;
  return v_result_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tempo_ciclo_md (qt_tempo_ciclo_p bigint) FROM PUBLIC;
