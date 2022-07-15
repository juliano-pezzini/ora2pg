-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_hor_proc_sem_dt_lib_md ( hr_prim_horario_p text, dt_primeiro_horario_p timestamp, dt_prev_execucao_p timestamp, ds_hora_proc_p INOUT text, dt_horario_proc_p INOUT timestamp ) AS $body$
BEGIN

    ds_hora_proc_p := coalesce(hr_prim_horario_p, substr(to_char(dt_primeiro_horario_p, 'dd/mm/yyyy hh24:mi:ss'), 12, 5));

    dt_horario_proc_p := pkg_date_utils.get_time(dt_prev_execucao_p, ds_hora_proc_p, 0);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_hor_proc_sem_dt_lib_md ( hr_prim_horario_p text, dt_primeiro_horario_p timestamp, dt_prev_execucao_p timestamp, ds_hora_proc_p INOUT text, dt_horario_proc_p INOUT timestamp ) FROM PUBLIC;

