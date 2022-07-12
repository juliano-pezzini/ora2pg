-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_tempo_ativ_usu_mes ( nm_usuario_p text, dt_referencia_p timestamp, ie_tempo_p text) RETURNS bigint AS $body$
DECLARE


qt_tempo_w	double precision;
dt_atual_w	timestamp;
dt_final_w	timestamp;
nr_ctrl_loop_w	smallint := 1;


BEGIN
if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (dt_referencia_p IS NOT NULL AND dt_referencia_p::text <> '') then
	begin
	dt_atual_w	:= trunc(dt_referencia_p,'month');
	dt_final_w	:= last_day(dt_referencia_p);

	while(dt_atual_w <= dt_final_w) and (nr_ctrl_loop_w < 32) loop
		begin
		qt_tempo_w 	:= coalesce(qt_tempo_w,0) + coalesce(man_obter_tempo_ativ_usuario(nm_usuario_p, dt_atual_w, ie_tempo_p),0);
		dt_atual_w	:= dt_atual_w + 1;
		nr_ctrl_loop_w	:= nr_ctrl_loop_w + 1;
		end;
	end loop;
	end;
end if;
return qt_tempo_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_tempo_ativ_usu_mes ( nm_usuario_p text, dt_referencia_p timestamp, ie_tempo_p text) FROM PUBLIC;

