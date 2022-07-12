-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_perfil_adicional ( ds_codigo_p text) RETURNS varchar AS $body$
DECLARE


lista_perfis_w		lista_varchar_pck.tabela_varchar;

ds_codigo_w	varchar(4000);
ds_retorno_w	varchar(32000);
ds_perfil_w	varchar(40);

BEGIN

ds_codigo_w	:= ds_codigo_p;

if (ds_codigo_w IS NOT NULL AND ds_codigo_w::text <> '') then
	begin

	lista_perfis_w := obter_lista_string2(ds_codigo_w, ',');

	for	i in lista_perfis_w.first..lista_perfis_w.last loop
			begin
			select	obter_desc_perfil((lista_perfis_w(i))::numeric )
			into STRICT	ds_perfil_w
			;

			ds_retorno_w	:= ds_perfil_w ||', '||ds_retorno_w;
			exception
			when others then
				ds_retorno_w := ds_retorno_w;
			end;
	end loop;
	end;
end if;

return substr(ds_retorno_w,1,4000);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_perfil_adicional ( ds_codigo_p text) FROM PUBLIC;

