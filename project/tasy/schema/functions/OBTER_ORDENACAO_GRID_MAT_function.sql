-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ordenacao_grid_mat (cd_funcao_p text, ds_grid_p text, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(200) := '';


BEGIN

	select	max(ds_regra_ordem)
	into STRICT    ds_retorno_w
	from	usuario_ordem_grid
	where 	cd_funcao = cd_funcao_p
	and 	ds_grid_tabela = ds_grid_p
	and	nm_usuario = nm_usuario_p;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ordenacao_grid_mat (cd_funcao_p text, ds_grid_p text, nm_usuario_p text) FROM PUBLIC;
