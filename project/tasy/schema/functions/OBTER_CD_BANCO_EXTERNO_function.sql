-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cd_banco_externo (cd_banco_p bigint) RETURNS varchar AS $body$
DECLARE


cd_retorno_w	varchar(60);


BEGIN
if (cd_banco_p IS NOT NULL AND cd_banco_p::text <> '') then
	select	max(cd_banco_externo)
	into STRICT 	cd_retorno_w
	from 	banco
	where	cd_banco = cd_banco_p;
end if;

return	cd_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cd_banco_externo (cd_banco_p bigint) FROM PUBLIC;
