-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_dias_liberados (nr_seq_agenda_int_p bigint, dt_agenda_p timestamp, ds_retorno_p INOUT text) AS $body$
BEGIN

  ds_retorno_p := ageint_sugerir_horarios_pck.get_agendas_dias_liberados(nr_seq_agenda_int_p => nr_seq_agenda_int_p,
                                                                         dt_agenda_p         => dt_agenda_p);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_dias_liberados (nr_seq_agenda_int_p bigint, dt_agenda_p timestamp, ds_retorno_p INOUT text) FROM PUBLIC;
