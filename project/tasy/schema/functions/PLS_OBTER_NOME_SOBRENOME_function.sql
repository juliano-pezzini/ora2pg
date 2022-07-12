-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_nome_sobrenome (cd_pessoa_fisica_p text, ie_nome_sobrenome_p text) RETURNS varchar AS $body$
DECLARE

 
/*	P - Primeiro Nome 
 	S - Sobrenome */
 
 
ds_retorno_w		varchar(100);
nm_pessoa_w		varchar(100);
i			integer;
inicio			integer;


BEGIN 
inicio			:= 0;
 
select	obter_nome_pessoa_fisica(cd_pessoa_fisica_p, null) 
into STRICT	nm_pessoa_w
;
 
if (nm_pessoa_w IS NOT NULL AND nm_pessoa_w::text <> '') then 
	if (ie_nome_sobrenome_p = 'P') then 
		begin 
		for	i in 1 .. length(nm_pessoa_w) loop 
			begin 
 
			if (substr(nm_pessoa_w,i,1) = ' ') then 
				exit;
			else 
				ds_retorno_w	:= ds_retorno_w || substr(nm_pessoa_w,i,1);
			end if;
 
			end;
		end loop;
		end;
	elsif (ie_nome_sobrenome_p = 'S') then 
		begin 
 
		for	i in 1 .. length(nm_pessoa_w) loop 
			begin 
 
			if (substr(nm_pessoa_w,i,1) = ' ') then 
				inicio 		:= i + 1;
			end if;
 
			end;
		end loop;
 
		ds_retorno_w	:= substr(nm_pessoa_w,	inicio, (length(nm_pessoa_w) - inicio + 1));
 
		end;
	end if;
end if;	
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_nome_sobrenome (cd_pessoa_fisica_p text, ie_nome_sobrenome_p text) FROM PUBLIC;

