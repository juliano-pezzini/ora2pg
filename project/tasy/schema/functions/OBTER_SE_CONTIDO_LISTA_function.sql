-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_contido_lista (lista_1_p text, lista_2_p text) RETURNS varchar AS $body$
DECLARE



ds_retorno_w   	varchar(1);
i			   	integer;
lista_1_w			varchar(10);
lista_2_w			varchar(10);
BEGIN
ds_retorno_w	:= 'N';
if (lista_1_p IS NOT NULL AND lista_1_p::text <> '') and (lista_2_p IS NOT NULL AND lista_2_p::text <> '') then
	begin
	for	i in 1 .. length(lista_1_p) loop
		begin
		lista_1_w := substr(lista_1_p,i,1);
		if (lista_1_w not in (',', ' ')) then

			for j in 1 .. length(lista_2_p) loop
				begin
				lista_2_w := substr(lista_2_p,j,1);
				if (lista_2_w not in (',', ' ')) then

					if (lista_2_w = lista_1_w) then
						ds_retorno_w := 'S';
						exit;
					end if;
				end if;

				end;
			end loop;

			if (ds_retorno_w = 'S') then
				exit;
			end if;
		end if;
		end;
	end loop;
	end;
else
ds_retorno_w := 'N';

end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_contido_lista (lista_1_p text, lista_2_p text) FROM PUBLIC;
