-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_estabelecimento_convenio (cd_convenio_p bigint, cd_estab_original_p bigint, cd_estab_convenio_p INOUT bigint) AS $body$
DECLARE

 
cd_estab_retorno_w	smallint;


BEGIN 
 
select	coalesce(max(a.cd_estabelecimento),0) 
into STRICT	cd_estab_retorno_w 
from	convenio_estabelecimento a 
where	a.cd_convenio 		= cd_convenio_p 
and	not exists (SELECT	1 
	from	convenio_estabelecimento b 
	where	b.cd_convenio		= a.cd_convenio 
	and	b.cd_estabelecimento	= cd_estab_original_p);
 
if (cd_estab_retorno_w = 0) then 
	cd_estab_retorno_w	:= cd_estab_original_p;
end if;
 
 
cd_estab_convenio_p	:= cd_estab_retorno_w;
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_estabelecimento_convenio (cd_convenio_p bigint, cd_estab_original_p bigint, cd_estab_convenio_p INOUT bigint) FROM PUBLIC;

