-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION verifica_se_atendpa ( NR_ATEND_ORIGEM_PA_p bigint, cd_pessoa_fisica_p bigint) RETURNS varchar AS $body$
DECLARE


cd_pessoa_fisica_cop_w   varchar(10);
ds_retorno_w		 varchar(10);

BEGIN

if	(NR_ATEND_ORIGEM_PA_p IS NOT NULL AND NR_ATEND_ORIGEM_PA_p::text <> '' AND cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
   select  max(cd_pessoa_fisica)
   into STRICT	   cd_pessoa_fisica_cop_w
   from    atendimento_paciente
   where   nr_atendimento = NR_ATEND_ORIGEM_PA_p;
end if;

if (cd_pessoa_fisica_cop_w IS NOT NULL AND cd_pessoa_fisica_cop_w::text <> '' AND cd_pessoa_fisica_cop_w = cd_pessoa_fisica_p) then
   ds_retorno_w := 'S';
else
   ds_retorno_w := 'N';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION verifica_se_atendpa ( NR_ATEND_ORIGEM_PA_p bigint, cd_pessoa_fisica_p bigint) FROM PUBLIC;
