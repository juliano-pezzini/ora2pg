-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_param_pacs ( cd_estabelecimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


retorno_w			varchar(255);
ie_verificacao_envio_laudo_w	varchar(10);


/*
VL = IE_VERIFICACAO_ENVIO_LAUDO
*/
BEGIN


select	max(ie_verificacao_envio_laudo)
into STRICT	ie_verificacao_envio_laudo_w
from	parametro_integracao_pacs
where	cd_estabelecimento = cd_estabelecimento_p;

if (upper(ie_opcao_p) = 'VL') then
	begin
	retorno_w	:=	ie_verificacao_envio_laudo_w;
	end;
end if;


return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_param_pacs ( cd_estabelecimento_p bigint, ie_opcao_p text) FROM PUBLIC;

