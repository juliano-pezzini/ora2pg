-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_empresa_ref ( cd_empresa_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


nm_empresa_w		varchar(255);
ds_retorno_w		varchar(255);
cd_sistema_ant_w		varchar(20);


BEGIN

if (coalesce(cd_empresa_p,0) > 0) then

	select	nm_empresa,
		cd_sistema_ant
	into STRICT	nm_empresa_w,
		cd_sistema_ant_w
	from	empresa_referencia
	where	cd_empresa = cd_empresa_p;

	if (ie_opcao_p = 'N') then
		ds_retorno_w := nm_empresa_w;
	elsif (ie_opcao_p = 'A') then
		ds_retorno_w := cd_sistema_ant_w;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_empresa_ref ( cd_empresa_p bigint, ie_opcao_p text) FROM PUBLIC;

