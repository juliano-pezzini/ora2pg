-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_obs_turno_agecon ( dt_agenda_p timestamp, cd_agenda_p bigint, cd_estabelecimento_p bigint, nm_paciente_p text) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w		varchar(255)	:= '';
ie_dia_semana_w		integer;
ie_feriado_w		varchar(1);
nr_seq_especial_w		bigint;
ie_horario_adicional_w	varchar(1);

C01 CURSOR FOR 
	SELECT	ds_observacao 
	from 	agenda_turno 
	where 	cd_agenda	= cd_agenda_p 
	 and 	ie_dia_semana	= ie_dia_semana_w 
	 and 	hr_inicial 		< hr_final 
	 and	((coalesce(dt_inicio_vigencia::text, '') = '') or (dt_inicio_vigencia <= trunc(dt_agenda_p))) 
	 and	((coalesce(dt_final_vigencia::text, '') = '') or (dt_final_vigencia >= trunc(dt_agenda_p))) 
	 and	ie_feriado_w 	<> 'S' 
	
union
	 
	SELECT 	ds_observacao 
	from 	agenda_turno 
	where 	cd_agenda   	= cd_agenda_p 
	 and 	ie_dia_semana	= 9 -- Dias de Trabalho 
	 and 	hr_inicial 		< hr_final 
	 and	((coalesce(dt_inicio_vigencia::text, '') = '') or (dt_inicio_vigencia <= trunc(dt_agenda_p))) 
	 and	((coalesce(dt_final_vigencia::text, '') = '') or (dt_final_vigencia >= trunc(dt_agenda_p))) 
	 and (ie_dia_semana_w between 2 and 6) 
	 and	ie_feriado_w 	<> 'S' 
	 and	not exists (	select	1 
				from 	agenda_turno 
				where 	cd_agenda	= cd_agenda_p 
				and 	ie_dia_semana	= ie_dia_semana_w) 
	
union
	 
	select 	ds_observacao 
	from 	agenda_turno_esp 
	where 	cd_agenda 	= cd_agenda_p 
	 and 	hr_inicial	< hr_final 
	 and	((coalesce(dt_agenda::text, '') = '') or (dt_agenda <= trunc(dt_agenda_p))) 
	 and	((coalesce(dt_agenda_fim::text, '') = '') or (dt_agenda_fim >= trunc(dt_agenda_p)));
			

BEGIN 
 
select	obter_cod_dia_semana(dt_agenda_p) 
into STRICT	ie_dia_semana_w
;
 
select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
into STRICT	ie_feriado_w 
from 	feriado a, 
		agenda b 
where 	a.cd_estabelecimento 	= cd_estabelecimento_p 
and		a.dt_feriado 	= dt_agenda_p 
and 	b.cd_agenda 		= cd_agenda_p;
	 
open C01;
loop 
fetch C01 into	 
	ds_retorno_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	if upper(ds_retorno_w) = upper(nm_paciente_p) then 
		ds_retorno_w 	:= nm_paciente_p;
		exit;
	end if;
	 
	end;
end loop;
close C01;
	 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_obs_turno_agecon ( dt_agenda_p timestamp, cd_agenda_p bigint, cd_estabelecimento_p bigint, nm_paciente_p text) FROM PUBLIC;

