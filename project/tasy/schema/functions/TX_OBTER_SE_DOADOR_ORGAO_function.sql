-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tx_obter_se_doador_orgao ( nr_seq_doador_p bigint, nr_seq_orgao_p bigint) RETURNS varchar AS $body$
DECLARE




ie_possui_orgao_w	varchar(1)	:= 'N';


BEGIN

if (nr_seq_doador_p IS NOT NULL AND nr_seq_doador_p::text <> '') and (nr_seq_orgao_p IS NOT NULL AND nr_seq_orgao_p::text <> '') then

	select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_possui_orgao_w
	from	tx_doador_orgao b,
		tx_orgao a
	where	a.nr_sequencia	= b.nr_seq_orgao
	and	b.nr_seq_doador = nr_seq_doador_p
	and	a.nr_sequencia	= nr_seq_orgao_p;

end if;

return ie_possui_orgao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tx_obter_se_doador_orgao ( nr_seq_doador_p bigint, nr_seq_orgao_p bigint) FROM PUBLIC;

