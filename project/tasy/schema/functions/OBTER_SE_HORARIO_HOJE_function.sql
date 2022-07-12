-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_horario_hoje ( dt_prescricao_p timestamp, dt_prim_hora_prescr_p timestamp, hr_prim_hora_item_p text) RETURNS varchar AS $body$
DECLARE


ds_hora_prescr_w	varchar(8);
ds_retorno_w		varchar(1)	:= 'S';
hr_prim_hora_item_w	varchar(20);


BEGIN
hr_prim_hora_item_w	:= hr_prim_hora_item_p;
if (hr_prim_hora_item_p = '  :  ') then
	hr_prim_hora_item_w	:= '';
end if;

if (coalesce(dt_prim_hora_prescr_p::text, '') = '') then
	ds_hora_prescr_w	:= '00:00:00';
	ds_hora_prescr_w	:= '00:00:00';
else
	begin
	ds_hora_prescr_w	:= to_char(dt_prim_hora_prescr_p,'hh24:mi');
	exception
	when others then
		ds_hora_prescr_w	:= '00:00';
	end;
end if;

if (ds_hora_prescr_w > hr_prim_hora_item_w) then
	ds_retorno_w	:= 'N';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION obter_se_horario_hoje ( dt_prescricao_p timestamp, dt_prim_hora_prescr_p timestamp, hr_prim_hora_item_p text) FROM PUBLIC;
