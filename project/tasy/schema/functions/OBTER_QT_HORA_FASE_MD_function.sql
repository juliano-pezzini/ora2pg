-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_hora_fase_md (qt_hora_fase_p bigint, qt_tempo_aplicacao_p bigint, nr_etapas_p bigint) RETURNS bigint AS $body$
DECLARE


  qt_hora_fase_w bigint;


BEGIN
  qt_hora_fase_w := qt_hora_fase_p;

  if (coalesce(qt_hora_fase_p, 0) = 0) then
    qt_hora_fase_w := ceil(dividir_sem_round(qt_tempo_aplicacao_p,
                                             nr_etapas_p));
  end if;

  return qt_hora_fase_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_hora_fase_md (qt_hora_fase_p bigint, qt_tempo_aplicacao_p bigint, nr_etapas_p bigint) FROM PUBLIC;
