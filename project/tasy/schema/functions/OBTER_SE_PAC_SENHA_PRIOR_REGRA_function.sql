-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_pac_senha_prior_regra ( cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1)	:= 'N';
qt_idade_pac_w	bigint;


BEGIN

begin
	qt_idade_pac_w	:= obter_idade_pf(cd_pessoa_fisica_p, clock_timestamp(), 'A');

	select	coalesce(max('S'),'N')
	into STRICT	ds_retorno_w
	from	regra_prioridade_senha_pac
	where ((qt_idade_maxima IS NOT NULL AND qt_idade_maxima::text <> '') and qt_idade_pac_w <= qt_idade_maxima)
	or ((qt_idade_minima IS NOT NULL AND qt_idade_minima::text <> '') and qt_idade_pac_w >= qt_idade_minima);

exception
when others then
	ds_retorno_w := 'N';
end;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_pac_senha_prior_regra ( cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type) FROM PUBLIC;
