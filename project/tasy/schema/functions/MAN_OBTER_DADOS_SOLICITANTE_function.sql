-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_dados_solicitante ( cd_pessoa_solicitante_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
IE_OPÇÃO:
CC - Centro de custro;
DCC- Descrição do centro de custo;
*/
ds_retorno_w		varchar(255) := '';
cd_centro_custo_w	integer;


BEGIN

select	coalesce(max(b.cd_centro_custo),0)
into STRICT	cd_centro_custo_w
from	setor_atendimento b,
	usuario a
where	b.cd_setor_atendimento = a.cd_setor_atendimento
and    a.cd_pessoa_fisica = cd_pessoa_solicitante_p;

if (ie_opcao_p = 'CC') then
	begin
	ds_retorno_w := cd_centro_custo_w;
	end;
elsif (ie_opcao_p = 'DCC') then
	begin
	select	substr(coalesce(obter_desc_centro_custo(cd_centro_custo_w),''),1,255)
	into STRICT	ds_retorno_w
	;
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_dados_solicitante ( cd_pessoa_solicitante_p text, ie_opcao_p text) FROM PUBLIC;
