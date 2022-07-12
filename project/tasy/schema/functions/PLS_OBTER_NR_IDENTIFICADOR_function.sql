-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_nr_identificador (nr_seq_analise_p bigint) RETURNS bigint AS $body$
DECLARE


nr_identificador_w	bigint;


BEGIN
select	max(nr_identificador)
into STRICT	nr_identificador_w
from (SELECT	max(a.nr_id_analise) nr_identificador
	from	pls_conta_mat	a,
		pls_conta	b
	where	b.nr_sequencia		= a.nr_seq_conta
	and	b.nr_seq_analise	= nr_seq_analise_p
	
union all

	SELECT	max(a.nr_id_analise) nr_identificador
	from	pls_conta_proc	a,
		pls_conta	b
	where	b.nr_sequencia		= a.nr_seq_conta
	and	b.nr_seq_analise	= nr_seq_analise_p
	
union all

	select	max(a.nr_id_analise) nr_identificador
	from	pls_proc_participante	c,
		pls_conta_proc		a,
		pls_conta		b
	where	a.nr_sequencia		= c.nr_seq_conta_proc
	and	b.nr_sequencia		= a.nr_seq_conta
	and	b.nr_seq_analise	= nr_seq_analise_p) alias4;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_nr_identificador (nr_seq_analise_p bigint) FROM PUBLIC;

