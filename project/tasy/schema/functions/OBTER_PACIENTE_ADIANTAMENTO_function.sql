-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_paciente_adiantamento ( nr_adiantamento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
/* 
c - código 
n - nome 
*/
 
 
cd_pessoa_fisica_w	varchar(10);
ds_retorno_w		varchar(60);
nr_atendimento_w		bigint;


BEGIN 
begin 
select	nr_atendimento, 
	cd_pessoa_adiant 
into STRICT	nr_atendimento_w, 
	cd_pessoa_fisica_w 
from	adiantamento 
where	nr_adiantamento = nr_adiantamento_p;
exception 
when others then 
	begin 
	nr_atendimento_w		:= null;
	cd_pessoa_fisica_w	:= null;
	end;
end;
 
if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then 
	begin 
	select	cd_pessoa_fisica 
	into STRICT	cd_pessoa_fisica_w 
	from	atendimento_paciente 
	where	nr_atendimento = nr_atendimento_w;	
	exception 
	when others then 
		cd_pessoa_fisica_w := null;
	end;
end if;
 
if (coalesce(ie_opcao_p,'N') = 'C') then 
	ds_retorno_w := cd_pessoa_fisica_w;
else 
	begin 
	select	substr(obter_nome_pf(cd_pessoa_fisica),1,60) 
	into STRICT	ds_retorno_w 
	from	pessoa_fisica 
	where	cd_pessoa_fisica = cd_pessoa_fisica_w;	
	exception 
	when others then 
		ds_retorno_w := null;
	end;
end if;
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_paciente_adiantamento ( nr_adiantamento_p bigint, ie_opcao_p text) FROM PUBLIC;

