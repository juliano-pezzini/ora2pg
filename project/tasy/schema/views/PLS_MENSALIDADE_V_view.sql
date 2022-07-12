-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_mensalidade_v (nr_seq_lote, nr_seq_mensalidade, nr_seq_pagador, nr_seq_contrato) AS select	a.nr_seq_lote,
	a.nr_sequencia nr_seq_mensalidade,
	c.nr_seq_pagador,
	d.nr_sequencia nr_seq_contrato
FROM	pls_contrato			d,
	pls_segurado			c,
	pls_mensalidade_segurado	b,
	pls_mensalidade			a
where	a.nr_sequencia		= b.nr_seq_mensalidade
and	b.nr_seq_segurado	= c.nr_sequencia
and	c.nr_seq_contrato	= d.nr_sequencia
group by	a.nr_seq_lote,
	a.nr_sequencia,
	c.nr_seq_pagador,
	d.nr_sequencia;
