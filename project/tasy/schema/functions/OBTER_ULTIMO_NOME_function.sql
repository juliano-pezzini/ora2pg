-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ultimo_nome (nm_pessoa_p text) RETURNS varchar AS $body$
DECLARE



ds_retorno_w		varchar(100);
nm_pessoa_w		varchar(100);
i			integer;
inicio			integer;


BEGIN

if (nm_pessoa_p IS NOT NULL AND nm_pessoa_p::text <> '') then

	inicio			:= 0;
	nm_pessoa_w		:= nm_pessoa_p;
	for	i in 1 .. length(nm_pessoa_w) loop
		begin
		if (substr(nm_pessoa_w,i,1) = ' ') then
			ds_retorno_w	:= '';
		else
			ds_retorno_w	:= ds_retorno_w || substr(nm_pessoa_w,i,1);
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
-- REVOKE ALL ON FUNCTION obter_ultimo_nome (nm_pessoa_p text) FROM PUBLIC;

