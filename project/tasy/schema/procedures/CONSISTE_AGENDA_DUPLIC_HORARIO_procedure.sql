-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_agenda_duplic_horario (cd_agenda_p bigint, cd_pessoa_fisica_p text, dt_agenda_p timestamp, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE

 
 
cd_agecons_w		bigint;
cd_agepaci_w		bigint;
ds_erro_w		varchar(255);
ds_agenda_w		varchar(200);
cd_estabelecimento_w	bigint;
ie_consiste_w		varchar(01)	:= 'N';


BEGIN 
 
select	max(cd_estabelecimento) 
into STRICT	cd_estabelecimento_w 
from	agenda 
where	cd_agenda	= cd_agenda_p;
 
select	coalesce(max(obter_valor_PARAM_usuario(39, 98, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w)), 'N') 
into STRICT	ie_consiste_w
;
 
ds_erro_w		:= '';
 
if (ie_consiste_w	= 'S') then 
	begin 
 
	select	coalesce(max(cd_agenda),0) 
	into STRICT	cd_agecons_w 
	from	agenda_consulta 
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p 
	and	dt_agenda		= dt_agenda_p 
	and	cd_agenda		<> cd_agenda_p 
	and	ie_status_agenda	not in ('C');
 
	if (cd_agecons_w <> 0) then 
 
		select	ds_agenda 
		into STRICT	ds_agenda_w 
		from	agenda 
		where	cd_agenda	= cd_agecons_w;
 
		ds_erro_w	:= ds_erro_w || wheb_mensagem_pck.get_texto(281828,'DS_AGENDA='|| ds_agenda_w)|| chr(13) || chr(10);
	end if;
 
 
	select	coalesce(max(cd_agenda),0) 
	into STRICT	cd_agepaci_w 
	from	agenda_paciente 
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p 
	and	hr_inicio		= dt_agenda_p 
	and	cd_agenda		<> cd_agenda_p 
	and	ie_status_agenda	not in ('C');
 
	if (cd_agepaci_w <> 0) then 
 
		select	ds_agenda 
		into STRICT	ds_agenda_w 
		from	agenda 
		where	cd_agenda	= cd_agepaci_w;
 
		ds_erro_w	:= ds_erro_w || wheb_mensagem_pck.get_texto(281829,'DS_AGENDA='|| ds_agenda_w);
	end if;
 
	end;
end if;
 
ds_erro_p	:= substr(ds_erro_w,1,255);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_agenda_duplic_horario (cd_agenda_p bigint, cd_pessoa_fisica_p text, dt_agenda_p timestamp, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;

