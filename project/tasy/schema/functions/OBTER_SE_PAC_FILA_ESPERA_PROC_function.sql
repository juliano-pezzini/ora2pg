-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_pac_fila_espera_proc ( cd_pessoa_fisica_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then

	select	coalesce(max('S'),'N')
	into STRICT	ds_retorno_w
	from	paciente_espera
	where	cd_pessoa_fisica = cd_pessoa_fisica_p
	and	cd_procedimento	 = cd_procedimento_p
	and	ie_origem_proced = ie_origem_proced_p
	and	coalesce(nr_atendimento::text, '') = '';

end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_pac_fila_espera_proc ( cd_pessoa_fisica_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint) FROM PUBLIC;

