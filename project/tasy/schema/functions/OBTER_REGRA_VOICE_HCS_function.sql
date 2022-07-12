-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_voice_hcs ( ie_status_p text) RETURNS varchar AS $body$
DECLARE

		
ie_integra_w	varchar(1);
ie_existe_regra_w smallint;
		

BEGIN

/*
S - Existe a regra/evento 
N - Nao existe a regra/evento 
V - Nao existe nenhuma regra cadastrada
*/
select	count(*)
into STRICT	ie_existe_regra_w
from	REGRA_VOICE_HCS
where   cd_estabelecimento = OBTER_ESTABELECIMENTO_ATIVO
and ie_situacao = 'A';
			
if (ie_existe_regra_w > 0) then
	begin
	select 'S'
	into STRICT ie_integra_w
	from REGRA_VOICE_HCS
	where ie_evento = ie_status_p
	and cd_estabelecimento = OBTER_ESTABELECIMENTO_ATIVO
	and ie_situacao = 'A';
	exception
	when others then
		ie_integra_w := 'N';
	end;
else
	ie_integra_w := 'V';
end if;
return ie_integra_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_voice_hcs ( ie_status_p text) FROM PUBLIC;
