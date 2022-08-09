-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_idade_ag_pac_exame (cd_agenda_p bigint, dt_agenda_p timestamp, qt_idade_p bigint, ds_erro_p INOUT text, nm_usuario_p text, ie_dia_semana_p bigint default null) AS $body$
DECLARE


ie_dia_semana_w		bigint;
qt_idade_min_w		bigint;
qt_idade_max_w		bigint;
ds_erro_w			varchar(255)	:= '';

ie_consiste_idademin_zero_w	varchar(1) := 'S';
qt_age_hor_w			smallint;


BEGIN

if (coalesce(ie_dia_semana_p, 0) > 0) then
	ie_dia_semana_w := ie_dia_semana_p;
else
	ie_dia_semana_w := pkg_date_utils.get_WeekDay(dt_agenda_p);
end if;

select	coalesce(max(1),0)
into STRICT	qt_age_hor_w
from (	SELECT  1
	from	agenda_horario
	where	cd_agenda	= cd_agenda_p
	and	dt_dia_semana	= ie_dia_semana_w
	and	(qt_idade_min IS NOT NULL AND qt_idade_min::text <> '')
	
union all

	SELECT  1
	from	agenda_horario
	where	cd_agenda	= cd_agenda_p
	and	dt_dia_semana	= ie_dia_semana_w
	and 	(qt_idade_max IS NOT NULL AND qt_idade_max::text <> '')) alias4;

if (qt_age_hor_w = 0) then
	return;
end if;

select	coalesce(max(qt_idade_min),0),
	coalesce(max(qt_idade_max),0)
into STRICT	qt_idade_min_w,
	qt_idade_max_w
from	agenda_horario
where	cd_agenda	= cd_agenda_p
and	dt_dia_semana	= ie_dia_semana_w
and	to_date('01/01/1899 ' || to_char(hr_inicial, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss') <=
	to_date('01/01/1899 ' || to_char(dt_agenda_p, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss')
and	to_date('01/01/1899 ' || to_char(hr_final, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss') >= 
	to_date('01/01/1899 ' || to_char(dt_agenda_p, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss')
and	((coalesce(dt_inicio_vigencia::text, '') = '') or (trunc(dt_inicio_vigencia) <= trunc(dt_agenda_p)))
and	((coalesce(dt_final_vigencia::text, '') = '') or (trunc(dt_final_vigencia) >= trunc(dt_agenda_p)));

if	((qt_idade_min_w > 0) or (ie_consiste_idademin_zero_w = 'S' AND qt_idade_min_w = 0)) and (qt_idade_max_w > 0) and (qt_idade_p > 0) then
	begin

	if (qt_idade_min_w > qt_idade_p) then
		ds_erro_w	:= ds_erro_w || WHEB_MENSAGEM_PCK.get_texto(277649,null);
	end if;		
	
	if (qt_idade_max_w < qt_idade_p) then
		ds_erro_w	:= ds_erro_w || WHEB_MENSAGEM_PCK.get_texto(277651,null);
	end if;		

	end;
end if;	

if (qt_idade_min_w = 0) and (qt_idade_max_w = 0) then
	begin

	select	coalesce(max(qt_idade_min),0),
		coalesce(max(qt_idade_max),0)
	into STRICT	qt_idade_min_w,
		qt_idade_max_w
	from	agenda_horario
	where	cd_agenda	= cd_agenda_p
	and	dt_dia_semana	= 9
	and	dt_agenda_p between dt_inicio_vigencia and dt_final_vigencia + 86399/86400
	and	to_date('01/01/1899 ' || to_char(hr_inicial, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss') <=
		to_date('01/01/1899 ' || to_char(dt_agenda_p, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss')
	and	to_date('01/01/1899 ' || to_char(hr_final, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss') >= 
		to_date('01/01/1899 ' || to_char(dt_agenda_p, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss')
	and	((coalesce(dt_inicio_vigencia::text, '') = '') or (trunc(dt_inicio_vigencia) <= trunc(dt_agenda_p)))
	and	((coalesce(dt_final_vigencia::text, '') = '') or (trunc(dt_final_vigencia) >= trunc(dt_agenda_p)));


	if	((qt_idade_min_w > 0) or (ie_consiste_idademin_zero_w = 'S' AND qt_idade_min_w = 0)) and (qt_idade_max_w > 0) and (qt_idade_p > 0) then
		begin

		if (qt_idade_min_w > qt_idade_p) then
			ds_erro_w	:= ds_erro_w || WHEB_MENSAGEM_PCK.get_texto(277649,null);
		end if;		
	
		if (qt_idade_max_w < qt_idade_p) then
			ds_erro_w	:= ds_erro_w || WHEB_MENSAGEM_PCK.get_texto(277651,null);
		end if;		

		end;
	end if;	

	end;
end if;

ds_erro_p	:= ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_idade_ag_pac_exame (cd_agenda_p bigint, dt_agenda_p timestamp, qt_idade_p bigint, ds_erro_p INOUT text, nm_usuario_p text, ie_dia_semana_p bigint default null) FROM PUBLIC;
