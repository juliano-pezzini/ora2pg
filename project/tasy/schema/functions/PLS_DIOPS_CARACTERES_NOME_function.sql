-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_diops_caracteres_nome ( ds_campo_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(200);
i				integer;


BEGIN

if (ds_campo_p IS NOT NULL AND ds_campo_p::text <> '') then
	begin
	for	i in 1 .. length(ds_campo_p) loop
		begin
		if	not(substr(ds_campo_p,i,1) in ('(',')')) then
			ds_retorno_w	:= ds_retorno_w || substr(ds_campo_p,i,1);
		end if;
		end;
	end loop;
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_diops_caracteres_nome ( ds_campo_p text) FROM PUBLIC;

