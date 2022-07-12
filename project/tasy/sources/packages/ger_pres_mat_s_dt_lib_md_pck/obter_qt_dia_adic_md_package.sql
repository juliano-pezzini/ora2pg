-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ger_pres_mat_s_dt_lib_md_pck.obter_qt_dia_adic_md ( ie_urgente_ant_p text, cd_funcao_origem_p bigint, ie_etapa_especial_p text, nr_seq_prescr_old_p bigint, nr_seq_prescr_p bigint, ds_hora_p text, qt_dia_adic_p bigint) RETURNS bigint AS $body$
DECLARE

    qt_dia_adic_w bigint;

BEGIN
    qt_dia_adic_w := qt_dia_adic_p;

    if	((ie_urgente_ant_p = 'N') or (cd_funcao_origem_p = 2314) or
        ((ie_urgente_ant_p = 'S') and (ie_etapa_especial_p = 'S')
        and (coalesce(nr_seq_prescr_old_p, -1) = coalesce(nr_seq_prescr_p, 1)))) then

      if (position('A' in ds_hora_p) > 0) and (qt_dia_adic_p = 0) then
        qt_dia_adic_w	:= 1;
      elsif (position('AA' in ds_hora_p) > 0) then
        qt_dia_adic_w	:= coalesce(qt_dia_adic_p,0) + 1;
      end if;
    end if;

    return coalesce(qt_dia_adic_w,0);
  end;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ger_pres_mat_s_dt_lib_md_pck.obter_qt_dia_adic_md ( ie_urgente_ant_p text, cd_funcao_origem_p bigint, ie_etapa_especial_p text, nr_seq_prescr_old_p bigint, nr_seq_prescr_p bigint, ds_hora_p text, qt_dia_adic_p bigint) FROM PUBLIC;
