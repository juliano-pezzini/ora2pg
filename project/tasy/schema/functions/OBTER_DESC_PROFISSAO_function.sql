-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_profissao (cd_profissao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(80);


BEGIN

if (cd_profissao_p IS NOT NULL AND cd_profissao_p::text <> '') then
	begin
	select	ds_profissao
	into STRICT	ds_retorno_w
	from	profissao
	where	cd_profissao	= cd_profissao_p;
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_profissao (cd_profissao_p bigint) FROM PUBLIC;

