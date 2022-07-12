-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_estab_localizacao ( nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


cd_estabelecimento_w	smallint;


BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin
	select	cd_estabelecimento
	into STRICT	cd_estabelecimento_w
	from	man_localizacao
	where	nr_sequencia	= nr_sequencia_p;
	end;
end if;

return cd_estabelecimento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_estab_localizacao ( nr_sequencia_p bigint) FROM PUBLIC;

