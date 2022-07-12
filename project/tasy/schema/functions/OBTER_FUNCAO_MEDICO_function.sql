-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_funcao_medico (cd_funcao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(80);


BEGIN

if (cd_funcao_p IS NOT NULL AND cd_funcao_p::text <> '') then
	select	ds_funcao
	into STRICT	ds_retorno_w
	from	funcao_medico
	where	cd_funcao = cd_funcao_p;
end if;

RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_funcao_medico (cd_funcao_p bigint) FROM PUBLIC;
