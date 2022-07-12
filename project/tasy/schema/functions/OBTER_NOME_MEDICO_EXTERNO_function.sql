-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_medico_externo ( cd_pessoa_fisica_paciente_p text) RETURNS varchar AS $body$
DECLARE


nm_medico_w               varchar(255):='';


BEGIN

if (cd_pessoa_fisica_paciente_p IS NOT NULL AND cd_pessoa_fisica_paciente_p::text <> '')then
	select  max(substr(obter_nome_medico(cd_medico, 'N'),1,255))
	into STRICT 	nm_medico_w
	from    pf_medico_externo 	
	where	cd_pessoa_fisica = cd_pessoa_fisica_paciente_p;
end if;

return  nm_medico_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_medico_externo ( cd_pessoa_fisica_paciente_p text) FROM PUBLIC;
