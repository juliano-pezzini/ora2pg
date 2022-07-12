-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_setor_obito (nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE

cd_setor_obito_w	bigint;

BEGIN
 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
	select	coalesce(max(cd_setor_obito),0) 
	into STRICT	cd_setor_obito_w 
	from	atendimento_paciente 
	where	nr_atendimento = nr_atendimento_p;
end if;
 
return	cd_setor_obito_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_setor_obito (nr_atendimento_p bigint) FROM PUBLIC;

