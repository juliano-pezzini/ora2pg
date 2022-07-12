-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_itaipu ( cd_pessoa_fisica_p text, nm_Pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE

 
 
ds_retorno_w		varchar(100);
nm_pessoa_w		varchar(100);
i			integer;
inicio			integer;
ie_sair_proximo_w	boolean	:= false;


BEGIN 
 
 
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') or (nm_Pessoa_fisica_p IS NOT NULL AND nm_Pessoa_fisica_p::text <> '') then 
 
	inicio			:= 0;
	if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then 
		nm_pessoa_w		:= obter_nome_pf(cd_pessoa_fisica_p);
	else 
		nm_pessoa_w		:= nm_Pessoa_fisica_p;
	end if;
	for	i in 1 .. length(nm_pessoa_w) loop 
		begin 
			ds_retorno_w	:= ds_retorno_w || substr(nm_pessoa_w,i,1);
		 
		if (ie_sair_proximo_w) then 
			exit;
		end if;
		if (substr(nm_pessoa_w,i,1) = ' ') then 
			ie_sair_proximo_w	:= true;
		end if;
		end;
	end loop;
 
end if;
 
return	ds_retorno_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_itaipu ( cd_pessoa_fisica_p text, nm_Pessoa_fisica_p text) FROM PUBLIC;
