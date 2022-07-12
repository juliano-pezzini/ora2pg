-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pessoa_age_integ (nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w		varchar(255)	:= null;
cd_pessoa_fisica_w	varchar(10);
nm_pessoa_fisica_w	varchar(80);


BEGIN 
 
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then 
	select	max(cd_pessoa_fisica), 
		max(obter_nome_pf(cd_pessoa_fisica)) 
	into STRICT	cd_pessoa_fisica_w, 
		nm_pessoa_fisica_w 
	from	agenda_integrada 
	where	nr_sequencia	= nr_sequencia_p;
 
	if (ie_opcao_p = 'C') then 
		ds_retorno_w	:= cd_pessoa_fisica_w;
	else 
		ds_retorno_w	:= nm_pessoa_fisica_w;
	end if;
end if;
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pessoa_age_integ (nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;

