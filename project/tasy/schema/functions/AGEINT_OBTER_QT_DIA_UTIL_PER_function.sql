-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_qt_dia_util_per (dt_inicial_p timestamp, dt_final_p timestamp, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE


dt_inicial_w	timestamp;
dt_final_w	timestamp;
ie_dia_util_w	varchar(1);
qt_dia_util_w	bigint	:= 0;


BEGIN
if (dt_inicial_p IS NOT NULL AND dt_inicial_p::text <> '') and (dt_final_p IS NOT NULL AND dt_final_p::text <> '') then
	dt_inicial_w	:= trunc(dt_inicial_p);
	dt_final_w	:= trunc(dt_final_p);

	while(dt_inicial_w <= dt_final_w) loop
		begin
		ie_dia_util_w	:= coalesce(Ageint_Obter_Se_Dia_Util(dt_inicial_w, cd_estabelecimento_p), 'S');

		if (coalesce(ie_dia_util_w, 'S') = 'S') then
			qt_dia_util_w	:= qt_dia_util_w + 1;
		end if;

		dt_inicial_w	:= dt_inicial_w + 1;
		end;
	end loop;
end if;
RETURN	qt_dia_util_w;
END	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_qt_dia_util_per (dt_inicial_p timestamp, dt_final_p timestamp, cd_estabelecimento_p bigint) FROM PUBLIC;

