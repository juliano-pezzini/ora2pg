-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tre_obter_nr_status_reabilit (cd_pessoa_fisica_p text) RETURNS bigint AS $body$
DECLARE

nr_retorno_w	bigint;

BEGIN
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then

	select 	nr_seq_status
	into STRICT	nr_retorno_w
	from	RP_PACIENTE_REABILITACAO a
	where	a.cd_pessoa_fisica = cd_pessoa_fisica_p;

end if;

return	nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tre_obter_nr_status_reabilit (cd_pessoa_fisica_p text) FROM PUBLIC;

