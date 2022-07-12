-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_glosa_guia_v (nr_seq_guia, nr_seq_guia_proc, nr_seq_motivo_glosa) AS select	a.nr_sequencia nr_seq_guia,
	null nr_seq_guia_proc,
	g.nr_seq_motivo_glosa
FROM	pls_guia_glosa		g,
	pls_guia_plano		a
where	a.nr_sequencia		= g.nr_seq_guia

union

select	a.nr_sequencia nr_seq_guia,
	b.nr_sequencia nr_seq_guia_proc,
	g.nr_seq_motivo_glosa
from	pls_guia_glosa		g,
	pls_guia_plano_proc	b,
	pls_guia_plano		a
where	a.nr_sequencia		= b.nr_seq_guia
and	b.nr_sequencia		= g.nr_seq_guia_proc;
