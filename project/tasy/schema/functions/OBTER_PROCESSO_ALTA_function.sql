-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_processo_alta (nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


cd_processo_w	bigint;


BEGIN
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	select	coalesce(max(cd_processo),0)
	into STRICT	cd_processo_w
	from	Processo_atendimento
	where	nr_atendimento	= nr_atendimento_p;
end if;

return cd_processo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_processo_alta (nr_atendimento_p bigint) FROM PUBLIC;
