-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_evolucao_paciente ( cd_evolucao_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE
					
/*
Justificativa da inativação	JI
Nurse Transfer		NT
*/
ds_justificativa_w	varchar(255);
ds_retorno_w		varchar(255) := '';
					

BEGIN

if (cd_evolucao_p IS NOT NULL AND cd_evolucao_p::text <> '') and (ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '') then
	
	Select	ds_justificativa
	into STRICT	ds_justificativa_w
	from	evolucao_paciente
	where	cd_evolucao = cd_evolucao_p;
	
	If ( ie_opcao_p = 'JI') then
		ds_retorno_w := ds_justificativa_w;
	elsif (ie_opcao_p = 'NT') then
		select	max(a.ie_nurse_transfer)
		into STRICT	ds_retorno_w
		from	tipo_evolucao a
		where	a.cd_tipo_evolucao = (	SELECT	max(x.ie_evolucao_clinica)
						from	evolucao_paciente x
						where	x.cd_evolucao = cd_evolucao_p);
	end if;	
	
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_evolucao_paciente ( cd_evolucao_p bigint, ie_opcao_p text) FROM PUBLIC;

