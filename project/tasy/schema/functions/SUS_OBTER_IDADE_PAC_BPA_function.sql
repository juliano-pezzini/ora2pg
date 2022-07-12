-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_idade_pac_bpa ( cd_pessoa_fisica_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, dt_atual_p timestamp, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE



dt_nascimento_w		timestamp;
ie_idade_aplica_w	varchar(1)	:= 'N';
ds_retorno_w		varchar(5)	:= '';



BEGIN

select	dt_nascimento
into STRICT	dt_nascimento_w
from	pessoa_fisica
where	cd_pessoa_fisica = cd_pessoa_fisica_p;

/*
select	nvl(max(ie_idade_aplica),'N')
into	ie_idade_aplica_w
from	sus_procedimento
where	cd_procedimento		= cd_procedimento_p
and	ie_origem_proced	= ie_origem_proced_p;
*/
if (cd_procedimento_p in (0301010013, 0301010021, 0301010030, 0301010048, 0301010056, 0301010064, 0301010072,
				0301010080, 0301010099, 0301010102, 0301010110, 0301010129, 0301010137, 0301010153)) then
	ie_idade_aplica_w	:= 'S';
end if;

if (ie_idade_aplica_w	= 'S') then
	return obter_idade(dt_nascimento_w, dt_atual_p, ie_opcao_p);
elsif (ie_idade_aplica_w	= 'N') then
	return ds_retorno_w;
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_idade_pac_bpa ( cd_pessoa_fisica_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, dt_atual_p timestamp, ie_opcao_p text) FROM PUBLIC;

