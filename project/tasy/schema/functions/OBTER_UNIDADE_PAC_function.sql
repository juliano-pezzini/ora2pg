-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_unidade_pac ( cd_pessoa_fisica_p text, ie_opcao_p text, ie_informacao_p text) RETURNS varchar AS $body$
DECLARE

		 
nr_atendimento_w	bigint;		
ds_unidade_w		varchar(255);
		

BEGIN 
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '') and (ie_informacao_p IS NOT NULL AND ie_informacao_p::text <> '') then 
	begin 
	select	coalesce(max(nr_atendimento),0) 
	into STRICT	nr_atendimento_w 
	from	atendimento_paciente 
	where	cd_pessoa_fisica = cd_pessoa_fisica_p 
	and	coalesce(dt_alta::text, '') = '' 
	and	coalesce(obter_setor_atendimento(nr_atendimento),0) > 0;
	 
	if (nr_atendimento_W > 0) then 
		begin 
		ds_unidade_w := obter_unidade_atendimento(nr_atendimento_w, ie_opcao_p, ie_informacao_p);
		end;
	end if;
	end;
end if;
return ds_unidade_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_unidade_pac ( cd_pessoa_fisica_p text, ie_opcao_p text, ie_informacao_p text) FROM PUBLIC;
