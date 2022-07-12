-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dia_util_periodo_s_trunc (cd_estabelecimento_p bigint, dt_inicial_p timestamp, qt_dia_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_retorno_w	timestamp	:= null;
qt_dia_util_w	bigint;
qt_dia_corrido_w	bigint;


BEGIN

dt_retorno_w	:= dt_inicial_p;
qt_dia_corrido_w	:= 0;
qt_dia_util_w	:= 0;

while(qt_dia_util_w <= qt_dia_p) loop
	if (obter_se_dia_util(trunc(dt_retorno_w) + qt_dia_corrido_w, cd_estabelecimento_p) = 'S') then
		qt_dia_util_w	:= qt_dia_util_w + 1;
	end if;
	qt_dia_corrido_w	:= qt_dia_corrido_w + 1;

end loop;

return	dt_retorno_w + qt_dia_corrido_w - 1;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dia_util_periodo_s_trunc (cd_estabelecimento_p bigint, dt_inicial_p timestamp, qt_dia_p bigint) FROM PUBLIC;
