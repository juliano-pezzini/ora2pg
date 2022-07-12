-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_classif_evento ( ie_classificacao_p text, cd_empresa_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(80);


BEGIN

if (ie_classificacao_p IS NOT NULL AND ie_classificacao_p::text <> '') and (cd_empresa_p IS NOT NULL AND cd_empresa_p::text <> '') then
	select	max(ds_classificacao)
	into STRICT	ds_retorno_w
	from	qua_classif_evento
	where	ie_classificacao = ie_classificacao_p
	and	cd_empresa = cd_empresa_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_classif_evento ( ie_classificacao_p text, cd_empresa_p bigint) FROM PUBLIC;
