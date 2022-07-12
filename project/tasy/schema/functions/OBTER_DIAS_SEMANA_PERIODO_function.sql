-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dias_semana_periodo (dt_inicial_p timestamp, dt_final_p timestamp) RETURNS bigint AS $body$
DECLARE


dt_aux_w		timestamp;
qt_diarias_w		bigint;
ie_feriado_w		varchar(01);


BEGIN

dt_aux_w	:= pkg_date_utils.start_of(dt_inicial_p, 'DD', 0);
qt_diarias_w	:= 0;

while(dt_aux_w <= dt_final_p) loop
	begin

	If (to_char(dt_aux_w,'d') in (2,3,4,5,6)) then

		qt_diarias_w	:= qt_diarias_w + 1;

	end if;

	dt_aux_w	:= dt_aux_w + 1;

	end;
end loop;

RETURN qt_diarias_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION obter_dias_semana_periodo (dt_inicial_p timestamp, dt_final_p timestamp) FROM PUBLIC;

