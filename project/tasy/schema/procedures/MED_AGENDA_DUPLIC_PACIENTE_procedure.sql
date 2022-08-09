-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_agenda_duplic_paciente (nr_sequencia_p bigint, cd_agenda_p bigint, cd_pessoa_fisica_p text, dt_agenda_p timestamp, qt_dias_dif_p bigint, cd_medico_p text, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE

 
 
cd_agecons_w		bigint;
cd_agepaci_w		bigint;
nr_sequencia_w		bigint;
ds_erro_w		varchar(255);
ds_agenda_w		varchar(200);
dt_agenda_w		timestamp;
cd_estabelecimento_w	bigint;
ie_consiste_w		varchar(01)	:= 'S';


BEGIN 
 
select	max(cd_estabelecimento) 
into STRICT	cd_estabelecimento_w 
from	agenda 
where	cd_agenda	= cd_agenda_p;
 
ds_erro_w		:= '';
 
if (ie_consiste_w	= 'S') then 
	begin 
	 
	 
	select	max(a.nr_sequencia) 
	into STRICT	nr_sequencia_w 
	from	agenda_consulta a, 
		agenda b 
	where	a.cd_agenda 		= b.cd_agenda 
	and	b.cd_pessoa_fisica		= cd_medico_p 
	and	a.cd_pessoa_fisica		= cd_pessoa_fisica_p 
	and	trunc(a.dt_agenda) 		between(trunc(dt_agenda_p - qt_dias_dif_p)) and (trunc(dt_agenda_p + qt_dias_dif_p)) 
	--and	cd_agenda		= cd_agenda_p 
	and	a.nr_sequencia 		<> nr_sequencia_p 
	and	a.ie_status_agenda	not in ('C','B','IT','E','S');
	 
	select	coalesce(min(cd_agenda),0), 
			min(dt_agenda) 
	into STRICT	cd_agecons_w, 
			dt_agenda_w 
	from	agenda_consulta 
	where	nr_sequencia = nr_sequencia_w;
 
	if (cd_agecons_w <> 0) then 
 
		select	max(ds_agenda) 
		into STRICT	ds_agenda_w 
		from	agenda 
		where	cd_agenda	= cd_agecons_w;
 
		ds_erro_w	:= ds_erro_w || wheb_mensagem_pck.get_texto(278929, 'DS_AGENDA_P=' || ds_agenda_w || ';DT_AGENDA_P=' || dt_agenda_w);
	end if;
	 
	 
	select	max(a.nr_sequencia) 
	into STRICT	nr_sequencia_w 
	from	agenda_paciente a, 
		agenda b 
	where	a.cd_agenda 		= b.cd_agenda 
	and	b.cd_pessoa_fisica		= cd_medico_p 
	and	a.cd_pessoa_fisica		= cd_pessoa_fisica_p 
	and	trunc(a.dt_agenda) 		between(trunc(dt_agenda_p - qt_dias_dif_p)) and (trunc(dt_agenda_p + qt_dias_dif_p)) 
	--and	cd_agenda		= cd_agenda_p 
	and	a.nr_sequencia 		<> nr_sequencia_p 
	and	a.ie_status_agenda	not in ('C','B','IT','E','S');
	 
	select	coalesce(min(cd_agenda),0), 
			min(dt_agenda) 
	into STRICT	cd_agepaci_w, 
			dt_agenda_w 
	from	agenda_paciente 
	where	nr_sequencia = nr_sequencia_w;
 
	if (cd_agepaci_w <> 0) then 
 
		select	max(ds_agenda) 
		into STRICT	ds_agenda_w 
		from	agenda 
		where	cd_agenda	= cd_agepaci_w;
 
		ds_erro_w	:= ds_erro_w || wheb_mensagem_pck.get_texto(278932, 'DS_AGENDA_P=' || ds_agenda_w || ';DT_AGENDA_P=' || dt_agenda_w);
	end if;
 
	end;
end if;
 
ds_erro_p	:= substr(ds_erro_w,1,255);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_agenda_duplic_paciente (nr_sequencia_p bigint, cd_agenda_p bigint, cd_pessoa_fisica_p text, dt_agenda_p timestamp, qt_dias_dif_p bigint, cd_medico_p text, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
