-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_util_uptodate (cd_estab_p bigint, nm_usuario_p text default null, ie_opcao_p text default 'I') RETURNS varchar AS $body$
DECLARE


cd_cgc_cliente_w	varchar(14);
cd_cgc_cliente_cad_w	varchar(14);
ie_retorno_w		varchar(1);
ds_url_w            varchar(4000);

C01 CURSOR FOR
	SELECT	CD_CGC_CLIENTE,
			DS_URL
	FROM	LIBERACAO_ACESSO_EXT_PEP
	WHERE    CD_CGC_CLIENTE = cd_cgc_cliente_w;


BEGIN
select	max(obter_cgc_estabelecimento(cd_estab_p))
into STRICT	cd_cgc_cliente_w
;

ie_retorno_w := 'N';

SELECT	MAX(DS_URL),
		coalesce(MAX('S'),'N')
into STRICT    ds_url_w,
		ie_retorno_w
FROM	 LIBERACAO_ACESSO_EXT_PEP
WHERE    CD_CGC_CLIENTE = cd_cgc_cliente_w
and 	coalesce(ie_sistema_externo,'UP')	= 'UP';




if (ie_opcao_p = 'U') then
	return	 replace_macro(ds_url_w,'@USUARIO',nm_usuario_p);
elsif (ie_opcao_p = 'UH') then

	if (ie_retorno_w	= 'N') then
		return null;
	end if;

	return	 replace_macro(ds_url_w,'@USUARIO',nm_usuario_p);
else
	return	ie_retorno_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_util_uptodate (cd_estab_p bigint, nm_usuario_p text default null, ie_opcao_p text default 'I') FROM PUBLIC;
