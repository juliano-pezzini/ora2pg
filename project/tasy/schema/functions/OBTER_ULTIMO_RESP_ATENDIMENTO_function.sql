-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ultimo_resp_atendimento (cd_pessoa_fisica_p bigint, cd_estabelecimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/*
'C' - código do responsavel
'N' - nome do responsavel
*/
cd_responsavel_w 	bigint:=null;
nm_responsavel_w	varchar(255):=null;


BEGIN

select  max(a.cd_pessoa_responsavel)
into STRICT	cd_responsavel_w
from	atendimento_paciente a
where	a.nr_atendimento = (
				SELECT 	max(a.nr_atendimento)
				from   	atendimento_paciente a
				where  	a.cd_pessoa_fisica 	=cd_pessoa_fisica_p
				and	(a.cd_pessoa_responsavel IS NOT NULL AND a.cd_pessoa_responsavel::text <> '')
				and	a.cd_estabelecimento 	=cd_estabelecimento_p
			);

if (ie_opcao_p = 'C') then
	return(cd_responsavel_w);
elsif (ie_opcao_p = 'N') then

	if (cd_responsavel_w IS NOT NULL AND cd_responsavel_w::text <> '') then
		return	obter_nome_pf(cd_responsavel_w);
	else
		return null;
	end if;

else return(null);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ultimo_resp_atendimento (cd_pessoa_fisica_p bigint, cd_estabelecimento_p bigint, ie_opcao_p text) FROM PUBLIC;
