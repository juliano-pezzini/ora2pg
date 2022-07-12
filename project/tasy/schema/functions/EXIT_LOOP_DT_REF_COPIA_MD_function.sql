-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION exit_loop_dt_ref_copia_md ( dt_ref_cop_fut_p timestamp, dt_ref_copia_p timestamp, qt_horas_p bigint ) RETURNS varchar AS $body$
BEGIN
    if (dt_ref_cop_fut_p >= dt_ref_copia_p + (dividir_sem_round_md(qt_horas_p,24))) then
      return 'S';
    else
      return 'N';
    end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION exit_loop_dt_ref_copia_md ( dt_ref_cop_fut_p timestamp, dt_ref_copia_p timestamp, qt_horas_p bigint ) FROM PUBLIC;

