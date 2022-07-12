-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_perm_alt_proc_serv (cd_agenda_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w	varchar(1) := 'S';
									

BEGIN 
 
if (cd_agenda_p IS NOT NULL AND cd_agenda_p::text <> '')then 
	select	coalesce(max(a.ie_alterar_proc), 'S') 
	into STRICT	ds_retorno_w 
	from	agenda a 
	where	a.cd_agenda 		= cd_agenda_p 
	and		a.cd_tipo_agenda	= 5 
	and		a.ie_situacao		= 'A' 
	order by 1;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_perm_alt_proc_serv (cd_agenda_p bigint) FROM PUBLIC;

