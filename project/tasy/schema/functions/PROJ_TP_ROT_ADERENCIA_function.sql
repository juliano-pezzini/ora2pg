-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_tp_rot_aderencia ( nr_seq_cliente_p bigint, nr_seq_roteiro_p bigint) RETURNS bigint AS $body$
DECLARE


pr_grau_importancia_w	double precision;
qt_retorno_w			double precision;


BEGIN

select	sum(c.pr_grau_importancia)
into STRICT	pr_grau_importancia_w
from	proj_tp_rot_item c
where	c.nr_seq_roteiro = nr_seq_roteiro_p
and 	exists (	SELECT	1
			from	proj_tp_cli_rot b,
				proj_tp_cli_rot_item a
			where	a.nr_seq_rot_cli = b.nr_sequencia
			and	b.nr_seq_cliente = nr_seq_cliente_p
			and	b.nr_seq_roteiro = nr_seq_roteiro_p
			and	c.nr_seq_roteiro = b.nr_seq_roteiro
			and	c.nr_sequencia	 = a.nr_seq_item);

select	dividir((sum(a.pr_efetividade) * 100), pr_grau_importancia_w)
into STRICT	qt_retorno_w
from	proj_tp_cli_rot b,
	proj_tp_cli_rot_item a
where	a.nr_seq_rot_cli = b.nr_sequencia
and	b.nr_seq_cliente = nr_seq_cliente_p
and	b.nr_seq_roteiro = nr_seq_roteiro_p;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_tp_rot_aderencia ( nr_seq_cliente_p bigint, nr_seq_roteiro_p bigint) FROM PUBLIC;
