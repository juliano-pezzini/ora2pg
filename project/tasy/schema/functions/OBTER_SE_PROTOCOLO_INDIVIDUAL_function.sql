-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_protocolo_individual ( cd_convenio_p convenio.cd_convenio%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) RETURNS varchar AS $body$
DECLARE

 
ie_protocolo_individual_w varchar(1) := 'N';
			

BEGIN 
 
begin 
	select	coalesce(ie_protocolo_individual,'N') 
	into STRICT	ie_protocolo_individual_w 
	from	convenio_estabelecimento 
	where	cd_convenio = cd_convenio_p 
	and	cd_estabelecimento = cd_estabelecimento_p;
exception 
	when others then 
		ie_protocolo_individual_w:='N';
end;
	 
return	ie_protocolo_individual_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_protocolo_individual ( cd_convenio_p convenio.cd_convenio%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

