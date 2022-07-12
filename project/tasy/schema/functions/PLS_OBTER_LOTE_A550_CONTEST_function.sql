-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_lote_a550_contest (nr_seq_lote_contest_p bigint) RETURNS bigint AS $body$
DECLARE


nr_retorno_w		bigint;


BEGIN
if (nr_seq_lote_contest_p IS NOT NULL AND nr_seq_lote_contest_p::text <> '') then
	select	max(a.nr_sequencia)
	into STRICT	nr_retorno_w
	from 	ptu_camara_contestacao a
	where 	a.nr_seq_lote_contest = nr_seq_lote_contest_p;
end if;

return	nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_lote_a550_contest (nr_seq_lote_contest_p bigint) FROM PUBLIC;

