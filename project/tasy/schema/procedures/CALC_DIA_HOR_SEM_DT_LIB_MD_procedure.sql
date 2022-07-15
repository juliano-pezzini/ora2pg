-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calc_dia_hor_sem_dt_lib_md ( ie_proc_urgente_p text, ds_hora_proc_p INOUT text, qt_dia_adic_p INOUT bigint) AS $body$
BEGIN
    if (position('A' in ds_hora_proc_p) > 0) and (ie_proc_urgente_p = 'N') and (qt_dia_adic_p = 0) then
        qt_dia_adic_p := 1;
    elsif (position('AA' in ds_hora_proc_p) > 0) and ( ie_proc_urgente_p = 'N' )	then
        qt_dia_adic_p := qt_dia_adic_p + 1;
    end if;

    ds_hora_proc_p := replace(ds_hora_proc_p, 'A', '');
    ds_hora_proc_p := replace(ds_hora_proc_p, 'A', '');
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calc_dia_hor_sem_dt_lib_md ( ie_proc_urgente_p text, ds_hora_proc_p INOUT text, qt_dia_adic_p INOUT bigint) FROM PUBLIC;

