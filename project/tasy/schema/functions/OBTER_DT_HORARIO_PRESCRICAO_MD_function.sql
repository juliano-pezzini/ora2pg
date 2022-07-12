-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dt_horario_prescricao_md (dt_prescricao_p timestamp, qt_dia_adic_p bigint, ds_hora_npt_p text) RETURNS timestamp AS $body$
BEGIN
     return trunc(ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_prescricao_p + qt_dia_adic_p, replace(ds_hora_npt_p,'A','')), 'mi');
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dt_horario_prescricao_md (dt_prescricao_p timestamp, qt_dia_adic_p bigint, ds_hora_npt_p text) FROM PUBLIC;

