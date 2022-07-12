-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_pf_gravida (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);
ie_sexo_w	varchar(1);


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	select	a.ie_sexo
	into STRICT	ie_sexo_w
	from	pessoa_fisica a
	where	a.cd_pessoa_fisica = cd_pessoa_fisica_p;

	if (ie_sexo_w = 'F') then
		
		select	max(a.ie_pac_gravida)
		into STRICT	ds_retorno_w
		from	historico_saude_mulher a
		where	nr_sequencia = (SELECT max(nr_sequencia)
								from	historico_saude_mulher a
								where	a.cd_pessoa_fisica = cd_pessoa_fisica_p
								and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
								and		coalesce(dt_inativacao::text, '') = '');
	else
		ds_retorno_w := obter_desc_expressao(293950);
	end if;
	
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_pf_gravida (cd_pessoa_fisica_p text) FROM PUBLIC;

