-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_agenda_gs (cd_agenda_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w	varchar(255);
		

BEGIN 
 
if (obter_tipo_agenda(cd_agenda_p) = 3) then 
 
	select	substr(obter_nome_medico_combo_agcons(cd_estabelecimento, cd_agenda, cd_tipo_agenda, coalesce(ie_ordenacao,'N')),1,255) 
	into STRICT	ds_retorno_w 
	from	agenda 
	where	cd_agenda	= cd_agenda_p;
elsif (obter_tipo_agenda(cd_agenda_p) = 4) then 
	select	coalesce(ds_curta, ds_agenda) 
	into STRICT	ds_retorno_w 
	from	agenda 
	where	cd_agenda = cd_agenda_p;
else	 
	select	ds_agenda 
	into STRICT	ds_retorno_w 
	from	agenda 
	where	cd_agenda = cd_agenda_p;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_agenda_gs (cd_agenda_p bigint) FROM PUBLIC;

