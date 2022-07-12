-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ultimo_nr_same_paciente (cd_pessoa_fisica_p text, cd_estabelecimento_P bigint) RETURNS bigint AS $body$
DECLARE

nr_same_w	bigint;


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
	select	coalesce(max(nr_sequencia),null)
	into STRICT	nr_same_w
	from	prontuario_estab
	where	cd_pessoa_fisica   = cd_pessoa_fisica_p
	and	cd_estabelecimento = cd_estabelecimento_p;

end if;

return	nr_same_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ultimo_nr_same_paciente (cd_pessoa_fisica_p text, cd_estabelecimento_P bigint) FROM PUBLIC;

