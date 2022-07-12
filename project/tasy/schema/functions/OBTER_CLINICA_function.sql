-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_clinica (ie_clinica_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);

BEGIN

if (ie_clinica_p IS NOT NULL AND ie_clinica_p::text <> '') then

	select	max(ds_expressao)
	into STRICT	ds_retorno_w
	from	valor_dominio_v
	where	cd_dominio	= 17
	and 	vl_dominio = ie_clinica_p;
	
end if;

return 	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_clinica (ie_clinica_p text) FROM PUBLIC;

