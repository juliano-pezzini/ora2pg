-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_computador ( nr_seq_computador_p bigint) RETURNS varchar AS $body$
DECLARE

nm_computador_w	varchar(40);

BEGIN
if (nr_seq_computador_p IS NOT NULL AND nr_seq_computador_p::text <> '') then
	select	max(nm_computador)
	into STRICT	nm_computador_w
	from	computador
	where	nr_sequencia = nr_seq_computador_p;
end if;
return upper(nm_computador_w);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_computador ( nr_seq_computador_p bigint) FROM PUBLIC;
