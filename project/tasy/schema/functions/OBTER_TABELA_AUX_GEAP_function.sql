-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tabela_aux_geap (cd_setor_item_p bigint, cd_funcao_executor_p bigint) RETURNS bigint AS $body$
DECLARE


cd_retorno_w	bigint;


BEGIN

if (cd_setor_item_p in (641, 112)) then
	cd_retorno_w	:= 0;
else
	cd_retorno_w	:= cd_funcao_executor_p;
end if;

return	cd_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tabela_aux_geap (cd_setor_item_p bigint, cd_funcao_executor_p bigint) FROM PUBLIC;

