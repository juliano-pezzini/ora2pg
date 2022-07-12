-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION adicionar_minutos_data (cd_estabelecimento_p bigint, dt_referencia_p timestamp, qt_minutos_p bigint, ie_tipo_p text) RETURNS timestamp AS $body$
DECLARE


/*
ie_tipo_p
COR - Tempo corrido
COM - Tempo comercial, considerando 08 até 18 e dias úteis
*/
dt_retorno_w		timestamp;
qt_minutos_w		bigint := qt_minutos_p;
dt_ini_com_w		timestamp;
dt_fim_com_w		timestamp;
dt_retorno_ww		timestamp;
ie_feriado_w		bigint;
is_business_day_w	bigint;


BEGIN

if (qt_minutos_p > 0) and (dt_referencia_p IS NOT NULL AND dt_referencia_p::text <> '') then

	if (ie_tipo_p = 'COM') then

		dt_retorno_w := dt_referencia_p;
		qt_minutos_w := 0;

		while(qt_minutos_p > qt_minutos_w) loop

			if (trunc(dt_retorno_ww) <> trunc(dt_retorno_w)) or (coalesce(dt_retorno_ww::text, '') = '') then
				dt_retorno_ww 		:= dt_retorno_w;
				dt_ini_com_w		:= trunc(dt_retorno_w) + 8/24;
				dt_fim_com_w		:= trunc(dt_retorno_w) + 18/24;
				ie_feriado_w		:= obter_se_feriado(cd_estabelecimento_p, dt_retorno_w);
				is_business_day_w	:= pkg_date_utils.IS_BUSINESS_DAY(dt_retorno_w);
			end if;

			dt_retorno_w 	:= dt_retorno_w + 1/1440;

			if (dt_retorno_w between dt_ini_com_w and dt_fim_com_w) and (is_business_day_w = 1) and (ie_feriado_w = 0) then
				qt_minutos_w := qt_minutos_w +1;
			end if;
		end loop;
	else
		dt_retorno_w := dt_referencia_p + qt_minutos_p/1440;
	end if;

end if;

return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION adicionar_minutos_data (cd_estabelecimento_p bigint, dt_referencia_p timestamp, qt_minutos_p bigint, ie_tipo_p text) FROM PUBLIC;
