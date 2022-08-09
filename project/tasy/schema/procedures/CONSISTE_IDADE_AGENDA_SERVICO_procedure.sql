-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_idade_agenda_servico (cd_agenda_p bigint, dt_agenda_p timestamp, qt_idade_p bigint, ds_erro_p INOUT text, nm_usuario_p text) AS $body$
DECLARE


ie_dia_semana_w		integer;
qt_idade_min_w		smallint;
qt_idade_max_w		smallint;
ds_erro_w		varchar(255)	:= '';


BEGIN

select	pkg_date_utils.get_WeekDay(dt_agenda_p)
into STRICT	ie_dia_semana_w
;

select	substr(coalesce(max(qt_idade_min),0),1,3),
	substr(coalesce(max(qt_idade_max),0),1,3)
into STRICT	qt_idade_min_w,
	qt_idade_max_w
from	agenda_turno
where	cd_agenda	= cd_agenda_p
and		ie_dia_semana	= ie_dia_semana_w
and	to_date('01/01/1899 ' || to_char(hr_inicial, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss') <=
	to_date('01/01/1899 ' || to_char(dt_agenda_p, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss')
and	to_date('01/01/1899 ' || to_char(hr_final, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss') >=
	to_date('01/01/1899 ' || to_char(dt_agenda_p, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss')
and	((coalesce(dt_inicio_vigencia::text, '') = '') or (trunc(dt_inicio_vigencia) <= trunc(dt_agenda_p)))
and	((coalesce(dt_final_vigencia::text, '') = '') or (trunc(dt_final_vigencia) >= trunc(dt_agenda_p)));

if (qt_idade_min_w >= 0) and (qt_idade_max_w > 0) and (qt_idade_p > 0) then
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

	select	substr(coalesce(max(qt_idade_min),0),1,3),
		substr(coalesce(max(qt_idade_max),0),1,3)
	into STRICT	qt_idade_min_w,
		qt_idade_max_w
	from	agenda_turno
	where	cd_agenda	= cd_agenda_p
	and	ie_dia_semana	= 9
	and	to_date('01/01/1899 ' || to_char(hr_inicial, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss') <=
		to_date('01/01/1899 ' || to_char(dt_agenda_p, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss')
	and	to_date('01/01/1899 ' || to_char(hr_final, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss') >=
		to_date('01/01/1899 ' || to_char(dt_agenda_p, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss')
	and	((coalesce(dt_inicio_vigencia::text, '') = '') or (trunc(dt_inicio_vigencia) <= trunc(dt_agenda_p)))
	and	((coalesce(dt_final_vigencia::text, '') = '') or (trunc(dt_final_vigencia) >= trunc(dt_agenda_p)));


	if (qt_idade_min_w > 0) and (qt_idade_max_w > 0) and (qt_idade_p > 0) then
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
-- REVOKE ALL ON PROCEDURE consiste_idade_agenda_servico (cd_agenda_p bigint, dt_agenda_p timestamp, qt_idade_p bigint, ds_erro_p INOUT text, nm_usuario_p text) FROM PUBLIC;
