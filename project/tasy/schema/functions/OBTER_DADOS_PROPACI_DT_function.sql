-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_propaci_dt (ie_opcao_p text, nr_seq_procedimento_p bigint) RETURNS timestamp AS $body$
DECLARE

/*
	DP - retorna data do procedimento
*/
dt_retorno_w	timestamp;


BEGIN

if (ie_opcao_p = 'DP') then

	select	a.dt_procedimento
	into STRICT	dt_retorno_w
	from	procedimento_paciente a
	where	nr_sequencia = nr_seq_procedimento_p;

end if;

return dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_propaci_dt (ie_opcao_p text, nr_seq_procedimento_p bigint) FROM PUBLIC;

