-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_procedimento_regra (ie_responsavel_credito_p text) RETURNS varchar AS $body$
DECLARE


ie_pasta_credito_w varchar(3) := 'S';


BEGIN

if (ie_responsavel_credito_p IS NOT NULL AND ie_responsavel_credito_p::text <> '') then

     select coalesce(ie_pasta_credito,'S')
     into STRICT   ie_pasta_credito_w
     from   regra_honorario
     where  cd_regra = ie_responsavel_credito_p;

else
     return 'S';
end if;

return ie_pasta_credito_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_procedimento_regra (ie_responsavel_credito_p text) FROM PUBLIC;

