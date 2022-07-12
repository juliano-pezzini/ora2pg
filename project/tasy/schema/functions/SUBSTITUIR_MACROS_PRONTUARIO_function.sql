-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION substituir_macros_prontuario ( ds_lista_macros_p text, cd_pessoa_fisica_p text, nr_atendimento_p bigint, cd_pessoa_usuario_p text, cd_evolucao_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_lista_macros_w	varchar(2000);
nm_macro_w	varchar(50);
nm_atributo_w	varchar(50);
vl_atributo_w	varchar(50);
ds_retorno_w	varchar(2000);


BEGIN 
ds_retorno_w	:= '';
ds_lista_macros_w	:= ds_lista_macros_p;
 
while (ds_lista_macros_w IS NOT NULL AND ds_lista_macros_w::text <> '') loop 
	begin 
	nm_macro_w	:= substr(ds_lista_macros_w, 1, position(',' in ds_lista_macros_w) - 1);
	nm_atributo_w	:= obter_valor_macro_prontuario(nm_macro_w);
	ds_lista_macros_w	:= substr(ds_lista_macros_w, position(',' in ds_lista_macros_w) + 1, length(ds_lista_macros_w));
 
	vl_atributo_w	:= '';
	if (nm_atributo_w = 'CD_PESSOA_FISICA') then 
		vl_atributo_w	:= cd_pessoa_fisica_p;
	elsif (nm_atributo_w = 'NR_ATENDIMENTO') then 
		vl_atributo_w	:= nr_atendimento_p;
	elsif (nm_atributo_w = 'CD_PESSOA_USUARIO') then 
		vl_atributo_w	:= cd_pessoa_usuario_p;
	elsif (nm_atributo_w = 'CD_EVOLUCAO') then 
		vl_atributo_w	:= cd_evolucao_p;
	end if;
 
	ds_retorno_w	:= ds_retorno_w || '#@#@' || substituir_macro_texto_tasy(nm_macro_w, nm_atributo_w, vl_atributo_w);
	end;
end loop;
 
ds_retorno_w	:= substr(ds_retorno_w, 5, length(ds_retorno_w));
 
return	ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION substituir_macros_prontuario ( ds_lista_macros_p text, cd_pessoa_fisica_p text, nr_atendimento_p bigint, cd_pessoa_usuario_p text, cd_evolucao_p bigint) FROM PUBLIC;
