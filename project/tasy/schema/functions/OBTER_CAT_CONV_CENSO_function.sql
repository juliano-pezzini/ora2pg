-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cat_conv_censo ( cd_convenio_p bigint, cd_categoria_p text, ie_opcao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(200);


BEGIN

if (ie_opcao_p	= 1) then
	ds_retorno_w	:= substr(coalesce(obter_categoria_convenio(cd_convenio_p,cd_categoria_p),wheb_mensagem_pck.get_texto(796842)),1,200);
else
	if (cd_categoria_p IS NOT NULL AND cd_categoria_p::text <> '') then
		ds_Retorno_w	:= substr(obter_nome_convenio(cd_convenio_p)||' - '||obter_categoria_convenio(cd_convenio_p,cd_categoria_p),1,200);
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cat_conv_censo ( cd_convenio_p bigint, cd_categoria_p text, ie_opcao_p bigint) FROM PUBLIC;

