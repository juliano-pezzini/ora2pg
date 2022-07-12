-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pessoa_conta (nr_interno_conta_p bigint, ie_cod_desc_p text) RETURNS varchar AS $body$
DECLARE

 
 
ds_retorno_w		varchar(255);
nm_pessoa_fisica_w	varchar(255);
cd_pessoa_fisica_w	varchar(10);


BEGIN 
 
select	substr(obter_nome_pf(b.cd_pessoa_fisica),1,255), 
	b.cd_pessoa_fisica 
into STRICT	nm_pessoa_fisica_w, 
	cd_pessoa_fisica_w 
from	conta_paciente a, 
	atendimento_paciente b 
where	a.nr_atendimento	= b.nr_atendimento 
and	a.nr_interno_conta	= nr_interno_conta_p;
 
if (ie_cod_desc_p	= 'C') then	 
	ds_retorno_w	:= cd_pessoa_fisica_w;
else 
	ds_retorno_w	:= nm_pessoa_fisica_w;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pessoa_conta (nr_interno_conta_p bigint, ie_cod_desc_p text) FROM PUBLIC;

