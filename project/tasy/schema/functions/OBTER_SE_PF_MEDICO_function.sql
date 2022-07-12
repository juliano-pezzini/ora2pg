-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_pf_medico ( cd_pessoa_fisica_p text, valida_medico_ativo_p text default 'N') RETURNS varchar AS $body$
DECLARE


ie_medico_w		varchar(01)	:= 'N';


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	begin

	select	coalesce(max('S'),'N')
	into STRICT	ie_medico_w
	from	medico m
	where	m.cd_pessoa_fisica	= cd_pessoa_fisica_p
	and     ((m.ie_situacao = 'A' and valida_medico_ativo_p = 'S') or (valida_medico_ativo_p = 'N'));
	end;
end if;

return	ie_medico_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_pf_medico ( cd_pessoa_fisica_p text, valida_medico_ativo_p text default 'N') FROM PUBLIC;

