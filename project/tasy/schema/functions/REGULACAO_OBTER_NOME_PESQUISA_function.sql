-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION regulacao_obter_nome_pesquisa (ds_nome_p text) RETURNS varchar AS $body$
DECLARE


ds_palavras_w	dbms_sql.varchar2_table;
ds_retorno_w	varchar(255) := '';
BEGIN
	if (ds_nome_p IS NOT NULL AND ds_nome_p::text <> '') then
		ds_palavras_w := obter_lista_string(ds_nome_p, ' ');

		for i in ds_palavras_w.first..ds_palavras_w.last loop

			if ((ds_palavras_w(i) IS NOT NULL AND (ds_palavras_w(i))::text <> '')) and (upper(ds_palavras_w(i)) not in ('DA', 'DE', 'DO', 'DAS', 'DOS', 'DAL')) then
				ds_retorno_w := ds_retorno_w || '%' || ds_palavras_w(i);
				ds_retorno_w := replace(ds_retorno_w, 'd' || chr(39), '');
				ds_retorno_w := elimina_acentuacao(ds_retorno_w);
			end if;

		end loop;
	end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION regulacao_obter_nome_pesquisa (ds_nome_p text) FROM PUBLIC;

