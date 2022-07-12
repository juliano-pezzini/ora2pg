-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_consumo_continuo (qt_peso_paciente_p bigint, qt_velocidade_inf_p bigint, ie_tipo_dosagem_p text, hr_inicio_p timestamp, hr_fim_p timestamp ) RETURNS bigint AS $body$
DECLARE


/*
mlh             ml por hora
gtm             Gotas por minuto
mgm             Microgotas por minuto
lpm             Litros por minuto
mcgh            Micrograma por hora
mcgm            Micrograma por minuto
mgh             Miligrama por hora
mgkh            Miligrama / kilograma por hora
mcgkh           Micrograma / kilograma por hora
mcgkm           Micrograma / kilograma por minuto
mgkm            Miligrama / kilograma por minuto

*/
qt_minutos_w	double precision;
qt_retorno_w	double precision := 0;


BEGIN

select (abs(hr_fim_p - hr_inicio_p) * 1440)
into STRICT	qt_minutos_w
;

if (ie_tipo_dosagem_p = 'gtm') then
	qt_retorno_w	:= (qt_velocidade_inf_p * qt_minutos_w) / 20;
elsif (ie_tipo_dosagem_p = 'lpm') then
	qt_retorno_w	:= (qt_velocidade_inf_p * qt_minutos_w) * 1000;
elsif (ie_tipo_dosagem_p = 'mgm') then
	qt_retorno_w	:= (qt_velocidade_inf_p * qt_minutos_w) * 0.02;
elsif (ie_tipo_dosagem_p = 'mlh') then
	qt_retorno_w	:= (qt_velocidade_inf_p * (qt_minutos_w / 60));
end if;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_consumo_continuo (qt_peso_paciente_p bigint, qt_velocidade_inf_p bigint, ie_tipo_dosagem_p text, hr_inicio_p timestamp, hr_fim_p timestamp ) FROM PUBLIC;

