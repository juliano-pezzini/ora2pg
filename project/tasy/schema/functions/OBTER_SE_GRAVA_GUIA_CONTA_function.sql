-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_grava_guia_conta ( cd_convenio_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w	varchar(1) := 'S';
				

BEGIN 
 
begin 
	select	coalesce(max(ie_grava_guia_conta),'S') 
	into STRICT	ds_retorno_w 
	from	convenio_estabelecimento 
	where	cd_convenio		= cd_convenio_p 
	and	cd_estabelecimento 	= cd_estabelecimento_p;				
exception 
when others then 
	ds_retorno_w := 'S';
end;
 
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_grava_guia_conta ( cd_convenio_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

