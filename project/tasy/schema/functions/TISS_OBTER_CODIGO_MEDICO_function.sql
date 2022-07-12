-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_codigo_medico (cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_pessoa_fisica_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
ie_opcao_p
'CIM' - Código Interno TasyMed
'CPF'
*/
cd_interno_w	varchar(255) := null;
nr_cpf_w	varchar(255) := null;
ds_retorno_w	varchar(255) := null;


BEGIN

select	max(cd_medico_tasymed_tiss)
into STRICT	cd_interno_w
from	medico_convenio
where	cd_convenio					= cd_convenio_p
and	cd_pessoa_fisica					= cd_pessoa_fisica_p
and	coalesce(cd_estabelecimento,coalesce(cd_estabelecimento_p,0))	= coalesce(cd_estabelecimento_p,0)
and	clock_timestamp() between coalesce(dt_inicio_vigencia,to_date('01/01/2000','dd/mm/yyyy')) and coalesce(dt_final_vigencia,clock_timestamp() + interval '1 days');

select	max(nr_cpf)
into STRICT	nr_cpf_w
from	pessoa_fisica
where	cd_pessoa_fisica	= cd_pessoa_fisica_p;

if (ie_opcao_p = 'CIM') then
	ds_retorno_w	:= cd_interno_w;
elsif (cd_interno_w IS NOT NULL AND cd_interno_w::text <> '') then
	ds_retorno_w	:= null;
elsif (ie_opcao_p = 'CPF') then
	ds_retorno_w	:= nr_cpf_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_codigo_medico (cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_pessoa_fisica_p text, ie_opcao_p text) FROM PUBLIC;
