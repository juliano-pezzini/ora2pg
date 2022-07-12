-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sup_obter_param_padrao_funcao ( nr_parametro_p bigint, cd_funcao_p bigint ) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);


BEGIN

select	coalesce(a.vl_parametro,vl_parametro_padrao) vl_parametro
into STRICT	ds_retorno_w
from 	funcao_parametro a,
	funcao b
where 	a.cd_funcao = b.cd_funcao
and	a.nr_sequencia = nr_parametro_p
and	b.cd_funcao = cd_funcao_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sup_obter_param_padrao_funcao ( nr_parametro_p bigint, cd_funcao_p bigint ) FROM PUBLIC;
