-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION prescricao_paciente_pck_md.calcular_dt_prim_horario_md (nr_agrupamento_ant_p bigint, dt_prescricao_p timestamp, qt_minutos_adic_p bigint, dt_inicio_prescr_p timestamp, dt_primeiro_horario_p timestamp) RETURNS timestamp AS $body$
DECLARE

    dt_primeiro_horario_w timestamp;

BEGIN
    dt_primeiro_horario_w := dt_primeiro_horario_p;
    if (nr_agrupamento_ant_p = -1) then
      dt_primeiro_horario_w := dt_prescricao_p + dividir_md(qt_minutos_adic_p, 1440);
    end if;

    if (dt_primeiro_horario_w < dt_inicio_prescr_p) then
      dt_primeiro_horario_w := dt_primeiro_horario_w + dividir_md(1, 1440);
    end if;

    return dt_primeiro_horario_w;
  end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION prescricao_paciente_pck_md.calcular_dt_prim_horario_md (nr_agrupamento_ant_p bigint, dt_prescricao_p timestamp, qt_minutos_adic_p bigint, dt_inicio_prescr_p timestamp, dt_primeiro_horario_p timestamp) FROM PUBLIC;
