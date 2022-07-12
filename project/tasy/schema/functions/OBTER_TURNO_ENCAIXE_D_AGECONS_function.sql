-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_turno_encaixe_d_agecons (cd_agenda_p bigint, dt_agenda_p timestamp, ie_turno_especial_p text default 'N') RETURNS bigint AS $body$
DECLARE

			
vl_retorno_w	bigint;
ie_dia_semana_w	smallint;


BEGIN

ie_dia_semana_w	:= obter_cod_dia_semana(dt_agenda_p);

if ie_turno_especial_p = 'S' then

	select	max(nr_sequencia)
	into STRICT	vl_retorno_w
	from	agenda_turno_esp
	where	((coalesce(dt_agenda::text, '') = '') or (trunc(dt_agenda) <= trunc(dt_agenda_p)))
	and	((coalesce(dt_agenda_fim::text, '') = '') or (trunc(dt_agenda_fim) >= trunc(dt_agenda_p)))
	and	nr_minuto_intervalo > 0
	and	((ie_dia_semana = ie_dia_semana_w) or ((ie_dia_semana = 9) and (ie_dia_semana_w not in (7,1))) or (coalesce(ie_dia_semana::text, '') = ''))
	and	cd_agenda = cd_agenda_p;

else

	select	max(nr_sequencia)
	into STRICT	vl_retorno_w
	from	agenda_turno
	where	((coalesce(dt_inicio_vigencia::text, '') = '') or (dt_inicio_vigencia <= trunc(dt_agenda_p)))
	and	((coalesce(dt_final_vigencia::text, '') = '') or (dt_final_vigencia >= trunc(dt_agenda_p)))
	and	nr_minuto_intervalo > 0
	and	((ie_dia_semana = ie_dia_semana_w) or ((ie_dia_semana = 9) and (ie_dia_semana_w not in (7,1))))
	and	cd_agenda = cd_agenda_p;
	
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_turno_encaixe_d_agecons (cd_agenda_p bigint, dt_agenda_p timestamp, ie_turno_especial_p text default 'N') FROM PUBLIC;

