-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_horario_proced_interv ( cd_intervalo_p text, nr_prescricao_p bigint, dt_procedimento_p timestamp, dt_prescricao_p timestamp) RETURNS timestamp AS $body$
DECLARE


dt_prim_hor_w	varchar(255);
ds_horarios_w	varchar(255);
qt_dia_w	integer;
dt_retorno_w	timestamp;


BEGIN

select	max(obter_primeiro_horario(cd_intervalo_p, nr_prescricao_p,0,null))
into STRICT	dt_prim_hor_w
;

select	max(Padroniza_horario_prescr(dt_prim_hor_w, To_Char(dt_prescricao_p,'dd/mm/yyyy hh24:mi:ss')))
into STRICT	ds_horarios_w
;

if (length(dt_prim_hor_w) = 5) then
	dt_prim_hor_w	:= dt_prim_hor_w || ':00';
end if;

qt_dia_w	:= 0;
if (position('A' in ds_horarios_w) > 0) then
	qt_dia_w	:= 1;
end if;

select	to_date(to_char(coalesce(dt_procedimento_p,dt_prescricao_p) + qt_dia_w,'dd/mm/yyyy') ||' '||dt_prim_hor_w,'dd/mm/yyyy hh24:mi:ss')
into STRICT	dt_retorno_w
;

if (coalesce(dt_retorno_w::text, '') = '') or (dt_retorno_w < dt_prescricao_p) then
	dt_retorno_w	:= trunc(dt_procedimento_p,'hh24');
end if;

if (dt_retorno_w < dt_prescricao_p) then
	dt_retorno_w	:= dt_prescricao_p;
end if;

return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_horario_proced_interv ( cd_intervalo_p text, nr_prescricao_p bigint, dt_procedimento_p timestamp, dt_prescricao_p timestamp) FROM PUBLIC;

