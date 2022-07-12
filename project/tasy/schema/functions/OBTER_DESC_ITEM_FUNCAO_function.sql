-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_item_funcao ( nr_sequencia_p bigint, cd_funcao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255) := '';


BEGIN


if (nr_sequencia_p > 0) and (cd_funcao_p > 0) then

	select  max(substr(obter_desc_expressao(cd_exp_desc_item,ds_item),1,255))
	into STRICT	ds_retorno_w
	from 	funcao_item
	where 	cd_funcao = cd_funcao_p
	and		nr_sequencia = nr_sequencia_p;

end if;


return  ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_item_funcao ( nr_sequencia_p bigint, cd_funcao_p bigint) FROM PUBLIC;

