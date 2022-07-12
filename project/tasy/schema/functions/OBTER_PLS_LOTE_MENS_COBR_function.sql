-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pls_lote_mens_cobr (nr_seq_cobr_escrit_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_pls_lote_mens_w	bigint;


BEGIN

select	max(nr_seq_lote)
into STRICT	nr_seq_pls_lote_mens_w
from	pls_mensalidade
where	nr_seq_cobranca	= nr_seq_cobr_escrit_p;

if (coalesce(nr_seq_pls_lote_mens_w::text, '') = '') then
	select	max(nr_seq_lote_mensalidade)
	into STRICT	nr_seq_pls_lote_mens_w
	from	cobranca_escritural
	where	nr_sequencia = nr_seq_cobr_escrit_p;
end if;

return	nr_seq_pls_lote_mens_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pls_lote_mens_cobr (nr_seq_cobr_escrit_p bigint) FROM PUBLIC;
