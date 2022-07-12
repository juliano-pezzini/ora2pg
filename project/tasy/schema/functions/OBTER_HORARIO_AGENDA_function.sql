-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_horario_agenda (cd_medico_p text, ie_dia_semana_p text, cd_agenda_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, hr_inicio_p timestamp, hr_final_p timestamp, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
/*ie_opcao_p 
I	- horário inicial 
F	- horário final */
 
 
dt_inicial_w	timestamp;
dt_final_w	timestamp;
ds_retorno_w	varchar(20);
hr_inicio_w	timestamp;
hr_final_w	timestamp;


BEGIN 
 
select	to_date('01/01/1900 ' || to_char(hr_inicio_p, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss'), 
	to_date('01/01/1900 ' || to_char(hr_final_p, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss') 
into STRICT	hr_inicio_w, 
	hr_final_w
;
 
 
select	min(dt_inicio), 
	max(dt_final) 
into STRICT	dt_inicial_w, 
	dt_final_w 
from	( 
	SELECT	to_date('01/01/1900 ' || to_char(a.hr_inicio, 
 
'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss') dt_inicio, 
		(to_date('01/01/1900 ' || to_char(a.hr_inicio, 
 
'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss')) dt_final 
	from	agenda_paciente a 
	where	a.cd_medico 	= cd_medico_p 
	and	a.cd_agenda	= cd_agenda_p 
	and	to_char(pkg_date_utils.get_WeekDay(dt_agenda)) = ie_dia_semana_p 
	and	dt_agenda between dt_inicial_p and dt_final_p 
	AND	a.ie_status_agenda NOT IN ('C','L','B','F') 
	and	to_date('01/01/1900 ' || to_char(a.hr_inicio, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss') >= hr_inicio_w 
	and	to_date('01/01/1900 ' || to_char(a.hr_inicio, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss') <= hr_final_w 
	group by to_date('01/01/1900 ' || to_char(a.hr_inicio, 
 
'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss'), 
		(to_date('01/01/1900 ' || to_char(a.hr_inicio, 
 
'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss')) 
	
union
 
	SELECT	to_date('01/01/1900 ' || to_char(a.dt_agenda, 
 
'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss'), 
		(to_date('01/01/1900 ' || to_char(a.dt_agenda, 
 
'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss')) 
	from	agenda b, agenda_classif c, agenda_consulta a	 
	where	a.cd_agenda		= b.cd_agenda 
	and	b.ie_situacao		= 'A' 
	and	b.cd_tipo_agenda	= 3 
	and	b.cd_pessoa_fisica 	= cd_medico_p 
	and	a.cd_agenda		= cd_agenda_p 
	and	to_char(pkg_date_utils.get_WeekDay(dt_agenda)) = ie_dia_semana_p 
	and	dt_agenda between dt_inicial_p and dt_final_p 
	AND	a.ie_status_agenda NOT IN ('C','L','B','F') 
	and	a.ie_classif_agenda	= c.cd_classificacao 
	and	c.cd_classif_tasy not in ('E', 'A', 'O', 'P') 
	and	c.ie_agenda in ('A','C') 
	and	to_date('01/01/1900 ' || to_char(a.dt_agenda, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss') >= hr_inicio_w 
	and	to_date('01/01/1900 ' || to_char(a.dt_agenda, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss') <= hr_final_w 
	group by to_date('01/01/1900 ' || to_char(a.dt_agenda,'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss'), 
		 to_date('01/01/1900 ' || to_char(a.dt_agenda,'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss')) alias37;
 
 
if (ie_opcao_p	= 'I') then 
	ds_retorno_w	:= to_char(dt_inicial_w,'hh24:mi:ss');
else	 
	ds_retorno_w	:= to_char(dt_final_w,'hh24:mi:ss');
end if;
 
return	ds_retorno_w;
 
end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_horario_agenda (cd_medico_p text, ie_dia_semana_p text, cd_agenda_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, hr_inicio_p timestamp, hr_final_p timestamp, ie_opcao_p text) FROM PUBLIC;

