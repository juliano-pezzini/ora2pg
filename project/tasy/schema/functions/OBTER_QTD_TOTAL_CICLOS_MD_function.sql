-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qtd_total_ciclos_md (qt_horas_section_p bigint, qt_hora_duracao_p bigint) RETURNS bigint AS $body$
BEGIN

if (QT_HORAS_SECTION_P IS NOT NULL AND QT_HORAS_SECTION_P::text <> '') AND QT_HORAS_SECTION_P > 0 THEN
  return dividir_sem_round_md(qt_horas_section_p, qt_hora_duracao_p);
  else return 0;
  END IF;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qtd_total_ciclos_md (qt_horas_section_p bigint, qt_hora_duracao_p bigint) FROM PUBLIC;

