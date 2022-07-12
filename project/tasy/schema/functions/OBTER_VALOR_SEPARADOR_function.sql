-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_separador (ds_conteudo_p text, nr_campo_p bigint, ds_separador_p text) RETURNS varchar AS $body$
DECLARE


/* Mesma lógica da function OBTER_VALOR_CAMPO_SEPARADOR, porém com tratamento para o caso
da posição (nr_campo_p) não existe na string, retornar null.
Na function OBTER_VALOR_CAMPO_SEPARADOR, retorna o último valor que foi encontrado.
*/
qt_campo_w	bigint;
ds_retorno_ww	varchar(4000);
ds_retorno_w	varchar(4000);



BEGIN

if (nr_campo_p = 1) then
	ds_retorno_w	:= substr(ds_conteudo_p, 1, coalesce(position(ds_separador_p in ds_conteudo_p), length(ds_conteudo_p))-1);
else
	qt_campo_w	:= 1;
	ds_retorno_w	:= ds_conteudo_p;
	while qt_campo_w <= nr_campo_p loop
		if (qt_campo_w = 1) then
			ds_retorno_ww	:= substr(ds_conteudo_p, position(ds_separador_p in ds_conteudo_p),length(ds_conteudo_p));
		else
			ds_retorno_ww	:= substr(ds_retorno_ww, position(ds_separador_p in ds_retorno_ww)+1,length(ds_retorno_ww));
		end if;
		if (qt_campo_w = nr_campo_p) then
			ds_retorno_ww	:= ds_retorno_ww || ds_separador_p;
			ds_retorno_w := substr(ds_retorno_ww, 1, coalesce(position(ds_separador_p in ds_retorno_ww), length(ds_retorno_ww))-1);
		elsif (qt_campo_w < nr_campo_p) and (position(ds_separador_p in ds_retorno_ww) = 0) then
			ds_retorno_ww := null;
			ds_retorno_w := null;
		end if;
		qt_campo_w	:= qt_campo_w + 1;
	end loop;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION obter_valor_separador (ds_conteudo_p text, nr_campo_p bigint, ds_separador_p text) FROM PUBLIC;

