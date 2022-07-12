-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_dia_entrega_exame (dt_inicial_p timestamp, dt_final_p timestamp) RETURNS bigint AS $body$
DECLARE


qt_hora_w	bigint	:= 0;
qt_retorno_w	bigint	:= 0;


BEGIN
if (dt_inicial_p IS NOT NULL AND dt_inicial_p::text <> '') and (dt_final_p IS NOT NULL AND dt_final_p::text <> '') then

	select	(substr(obter_dif_horario(dt_inicial_p, dt_final_p),1,2))::numeric
	into STRICT	qt_hora_w
	;

	if (qt_hora_w IS NOT NULL AND qt_hora_w::text <> '') then
		if (qt_hora_w <= 24) then
			qt_retorno_w	:= 1;
		elsif (qt_hora_w > 24 and qt_hora_w <= 48 ) then
			qt_retorno_w	:= 2;
		elsif (qt_hora_w > 48 and qt_hora_w <= 72) then
			qt_retorno_w	:= 3;
		else	qt_retorno_w	:= 4;
		end if;
	end if;
end if;

RETURN	qt_retorno_w;

END	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_dia_entrega_exame (dt_inicial_p timestamp, dt_final_p timestamp) FROM PUBLIC;
