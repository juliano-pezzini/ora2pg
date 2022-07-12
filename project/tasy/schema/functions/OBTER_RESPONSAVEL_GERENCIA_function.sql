-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_responsavel_gerencia ( nr_seq_gerencia_p bigint) RETURNS varchar AS $body$
DECLARE


cd_responsavel_w	varchar(10);


BEGIN
if (nr_seq_gerencia_p IS NOT NULL AND nr_seq_gerencia_p::text <> '') then
	begin
	select	max(cd_responsavel)
	into STRICT	cd_responsavel_w
	from	gerencia_wheb
	where	nr_sequencia = nr_seq_gerencia_p;
	end;
end if;
return cd_responsavel_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_responsavel_gerencia ( nr_seq_gerencia_p bigint) FROM PUBLIC;

