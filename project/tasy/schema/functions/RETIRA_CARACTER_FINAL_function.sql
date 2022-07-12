-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION retira_caracter_final (ds_linha_p text, ds_caracter_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);
i		integer;
Inserir		boolean;



BEGIN

i	:= 1;
Inserir	:= True;

for	i in 1 .. length(ds_linha_p) loop
	begin
	if (substr(ds_linha_p,i,1) = ' ') and
		((substr(ds_linha_p,i - 1,1) = ' ') or (substr(ds_linha_p,i + 1,1) = ' ')) then
		Inserir	:= False;
	else
		Inserir	:= True;
	end if;

	if (Inserir = True) then
		ds_retorno_w	:= ds_retorno_w || substr(ds_linha_p,i,1);
	end if;
	end;
end loop;


return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION retira_caracter_final (ds_linha_p text, ds_caracter_p text) FROM PUBLIC;
