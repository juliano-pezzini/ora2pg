-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_perc_prev_real ( nm_usuario_p text) RETURNS bigint AS $body$
DECLARE


pr_usuario_w		double precision;
qt_real_w			double precision;
qt_prev_w			double precision;


BEGIN

select	sum(a.qt_minuto)
into STRICT	qt_real_w
from	man_ordem_servico b,
		man_ordem_serv_ativ a
where	b.nr_sequencia		= a.nr_seq_ordem_serv
and		b.ie_status_ordem	= '3'
and		(a.nr_seq_ativ_prev IS NOT NULL AND a.nr_seq_ativ_prev::text <> '')
and		a.nm_usuario_exec	= nm_usuario_p
and exists (SELECT	1
			from	grupo_desenvolvimento c,
					gerencia_wheb g
			where	g.nr_sequencia		= c.nr_seq_gerencia
			and		g.ie_area_gerencia	= 'PDES'
			and		c.nr_sequencia		= b.nr_seq_grupo_des);


select	sum(a.qt_min_prev)
into STRICT	qt_prev_w
from	man_ordem_servico b,
		man_ordem_ativ_prev a
where	b.nr_sequencia		= a.nr_seq_ordem_serv
and		b.ie_status_ordem	= '3'
and		a.nm_usuario_prev	= nm_usuario_p
and	exists (SELECT	1
			from	man_ordem_serv_ativ t
			where	a.nr_sequencia		= t.nr_seq_ativ_prev
			and		t.nr_seq_ordem_serv	= b.nr_sequencia)
and exists (select	1
			from	grupo_desenvolvimento c,
					gerencia_wheb g
			where	g.nr_sequencia		= c.nr_seq_gerencia
			and		g.ie_area_gerencia	= 'PDES'
			and		c.nr_sequencia		= b.nr_seq_grupo_des);


pr_usuario_w	:= 	dividir(qt_real_w * 100,qt_prev_w);

return pr_usuario_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_perc_prev_real ( nm_usuario_p text) FROM PUBLIC;

