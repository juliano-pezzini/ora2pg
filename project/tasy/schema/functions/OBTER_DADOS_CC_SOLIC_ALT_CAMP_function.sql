-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_cc_solic_alt_camp ( ds_chave_composta_p tasy_solic_alt_campo.ds_chave_composta%type, ds_chave_p text) RETURNS varchar AS $body$
DECLARE

/*
	Retorna o campo indicado dentro do campo "Chave composta" passado por parametro.
*/
ds_retorno_w	varchar(4000);
ds_chave_w	varchar(4000);
ds_limitador_w	varchar(4) := '#@#@';

BEGIN

ds_chave_w := ds_chave_p;

-- tratamento para ver se já foi incluso o limitador #@#@ no campo, se não foi ele é concatenado
if (substr(ds_chave_w, 1, 4) != ds_limitador_w) then

	ds_chave_w := ds_limitador_w||ds_chave_w;

end if;


-- tratamento para ver se já foi incluso o limitador = no campo, se não foi ele é concatenado
if (substr(ds_chave_w, length(ds_chave_w), 1) != '=') then

	ds_chave_w := ds_chave_w||'=';

end if;

ds_retorno_w := '';

-- se a chave composta possui alguma incidencia do chave
if (position(ds_chave_w in ds_chave_composta_p) > 0) then

	-- Carrega o "inicio" da chave composta posicionado com a chave desejada,
	ds_retorno_w := substr(ds_chave_composta_p, position(ds_chave_w in ds_chave_composta_p) + length(ds_chave_w), length(ds_chave_composta_p));

	-- verifica se existe algum delimitador após o valor da chave composta, se tiver, limita por ele
	if (position(ds_limitador_w in ds_retorno_w) > 0) then

		ds_retorno_w := substr(ds_retorno_w, 1, position(ds_limitador_w in ds_retorno_w) -1);
	end if;

end if;


return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_cc_solic_alt_camp ( ds_chave_composta_p tasy_solic_alt_campo.ds_chave_composta%type, ds_chave_p text) FROM PUBLIC;

