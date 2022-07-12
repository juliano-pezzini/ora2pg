-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_indicacao_clinica (nr_atendimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(2000):= ' ';


BEGIN

select 	max(coalesce(ds_indicacao,' '))
into STRICT	ds_retorno_w
from 	autorizacao_convenio
where 	nr_atendimento 			= nr_atendimento_p
and 	cd_procedimento_principal 	= cd_procedimento_p
and 	ie_origem_proced		= ie_origem_proced_p;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_indicacao_clinica (nr_atendimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint) FROM PUBLIC;
