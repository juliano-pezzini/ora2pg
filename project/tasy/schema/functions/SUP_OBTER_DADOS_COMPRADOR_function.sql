-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sup_obter_dados_comprador ( cd_estabelecimento_p bigint, cd_comprador_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/* ie_opcao
E - Email
*/
ds_retorno_w    		varchar(255);
ds_email_w		comprador.ds_email%type;


BEGIN

if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') and (cd_comprador_p IS NOT NULL AND cd_comprador_p::text <> '') then
	select	ds_email
	into STRICT	ds_email_w
	from	comprador
	where	cd_estabelecimento	= cd_estabelecimento_p
	and	cd_pessoa_fisica	= cd_comprador_p;
end if;

if (ie_opcao_p = 'E') then
	ds_retorno_w := ds_email_w;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sup_obter_dados_comprador ( cd_estabelecimento_p bigint, cd_comprador_p text, ie_opcao_p text) FROM PUBLIC;

