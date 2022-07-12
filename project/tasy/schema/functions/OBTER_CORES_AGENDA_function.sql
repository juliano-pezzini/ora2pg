-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cores_agenda ( cd_agenda_p bigint, ie_opcao_p bigint ) RETURNS varchar AS $body$
DECLARE

/* 
1 - Fundo 
2 - Fonte 
*/
 
 
ds_cor_fundo_w	varchar(10);
ds_cor_fonte_w	varchar(10);
ds_retorno_w	varchar(10) := null;


BEGIN 
 
if (cd_agenda_p > 0) then 
	select	coalesce(max(ds_cor_fundo), ''), 
		coalesce(max(ds_cor_fonte), '') 
	into STRICT	ds_cor_fundo_w, 
		ds_cor_fonte_w 
	from	agenda 
	where	cd_agenda = cd_agenda_p;	
	 
	if (ie_opcao_p = 1) then 
		ds_retorno_w	:= ds_cor_fundo_w; 		
	elsif (ie_opcao_p = 2) then 
		ds_retorno_w	:= ds_cor_fonte_w;
	end if;
end if;
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cores_agenda ( cd_agenda_p bigint, ie_opcao_p bigint ) FROM PUBLIC;

