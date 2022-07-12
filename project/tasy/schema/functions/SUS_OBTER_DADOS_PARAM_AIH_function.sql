-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_dados_param_aih ( cd_estabelecimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(100);
cd_diretor_clinico_w	varchar(10);
cd_medico_autorizador_w varchar(10);
/*
Opções
DC - Diretor clínico
MA - Médico autorizador
*/
BEGIN

select	cd_diretor_clinico,
	cd_medico_autorizador
into STRICT	cd_diretor_clinico_w,
	cd_medico_autorizador_w
from	SUS_PARAMETROS_AIH
where	cd_estabelecimento = cd_estabelecimento_p;

if (ie_opcao_p = 'DC') then
	ds_retorno_w := cd_diretor_clinico_w;
elsif (ie_opcao_p = 'MA') then
	ds_retorno_w := cd_medico_autorizador_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_dados_param_aih ( cd_estabelecimento_p bigint, ie_opcao_p text) FROM PUBLIC;
