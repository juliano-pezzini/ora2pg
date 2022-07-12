-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_tempo_com ( cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_final_p timestamp, ie_tempo_p text) RETURNS bigint AS $body$
DECLARE


ie_dia_semana_w			varchar(1);
qt_dia_util_w				bigint	:= 0;
qt_retorno_w				numeric(22)	:= 0;
dt_ref_w				timestamp;
dt_inicial_w				timestamp;
dt_final_w				timestamp;
qt_min_total_w			numeric(22)	:= 0;

/*	MC - Minutos úteis comerciais
	DC - Dias úteis comerciais
*/
BEGIN

if (ie_tempo_p = 'DC') then
	begin
	dt_ref_w	:= trunc(dt_inicio_p);
	dt_final_w	:= trunc(dt_final_p);

	while(dt_ref_w < dt_final_w) loop
		BEGIN
		select	obter_se_dia_util(dt_ref_w,cd_estabelecimento_p)
		into STRICT	ie_dia_semana_w
		;

		if (ie_dia_semana_w = 'S') then
			qt_dia_util_w	:= qt_dia_util_w + 1;
		end if;

		dt_ref_w	:= dt_ref_w + 1;
		END;
	end loop;

	qt_retorno_w		:= qt_dia_util_w;
	end;
elsif (ie_tempo_p = 'MC') then
	begin
	qt_min_total_w			:= man_obter_min_com(cd_estabelecimento_p,dt_inicio_p,dt_final_p);
	qt_retorno_w				:= qt_min_total_w;
	end;
end if;

return qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_tempo_com ( cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_final_p timestamp, ie_tempo_p text) FROM PUBLIC;

