-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_data_hora_form ( dt_referencia_p timestamp, hr_prim_horario_p text) RETURNS timestamp AS $body$
DECLARE


dt_retorno_w	timestamp := dt_referencia_p;


BEGIN
begin
if (dt_referencia_p IS NOT NULL AND dt_referencia_p::text <> '') and (hr_prim_horario_p IS NOT NULL AND hr_prim_horario_p::text <> '') and (position(':' in hr_prim_horario_p) > 0)then
	dt_retorno_w := trunc(ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_referencia_p, coalesce(hr_prim_horario_p, '00:00')), 'mi');
end if;

exception
when others then
	null;
end;

return dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_data_hora_form ( dt_referencia_p timestamp, hr_prim_horario_p text) FROM PUBLIC;

