-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_relatorio_coop ( cd_cooperativa_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_relatorio_w	bigint;
nr_seq_congenere_w	bigint;


BEGIN

begin
select	max(nr_sequencia)
into STRICT	nr_seq_congenere_w
from	pls_congenere
where	cd_cooperativa	= cd_cooperativa_p;
exception
when others then
	nr_seq_congenere_w	:= null;
end;

if (nr_seq_congenere_w IS NOT NULL AND nr_seq_congenere_w::text <> '') then
	select	max(nr_seq_relatorio)
	into STRICT	nr_seq_relatorio_w
	from	pls_congenere
	where	nr_sequencia	= nr_seq_congenere_w;
end if;

return	nr_seq_relatorio_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_relatorio_coop ( cd_cooperativa_p text) FROM PUBLIC;

