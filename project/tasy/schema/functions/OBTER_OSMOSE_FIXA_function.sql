-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_osmose_fixa (nr_seq_ponto_acesso_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_osmose_w		bigint;


BEGIN

if (nr_seq_ponto_acesso_p IS NOT NULL AND nr_seq_ponto_acesso_p::text <> '') then

	select 	coalesce(nr_seq_osmose_fixa,0)
	into STRICT	nr_seq_osmose_w
	from	hd_ponto_acesso
	where	nr_sequencia = nr_seq_ponto_acesso_p;

end if;

return	nr_seq_osmose_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_osmose_fixa (nr_seq_ponto_acesso_p bigint) FROM PUBLIC;

