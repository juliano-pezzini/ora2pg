-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION dmed_obter_dados_prestador ( cd_prestador_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*	ie_opcao_p
NM - nome da pessoa prestadora
*/
ds_retorno_w	varchar(255):= '';


BEGIN
if (ie_opcao_p = 'NM') then
	if (length(trim(both cd_prestador_p)) = 11) then --cpf
		select	nm_pessoa_fisica
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_prestador_p;
	elsif (length(trim(both cd_prestador_p)) = 14) then --cnpj
		select	ds_razao_social
		into STRICT	ds_retorno_w
		from	pessoa_juridica
		where	cd_cgc = cd_prestador_p;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION dmed_obter_dados_prestador ( cd_prestador_p text, ie_opcao_p text) FROM PUBLIC;

