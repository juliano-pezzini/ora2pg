-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_analise_conta_fatura_v (ie_tipo_analise, nr_seq_analise, nr_fatura, nr_nota_credito_debito, cd_unimed_origem) AS select	'P' ie_tipo_analise,
	a.nr_sequencia nr_seq_analise,
	c.nr_fatura,
	c.nr_nota_credito_debito,
	c.cd_unimed_origem
FROM	pls_analise_conta a,
	pls_conta b,
	ptu_fatura c
where	a.nr_sequencia	= b.nr_seq_analise
and	b.nr_seq_fatura	= c.nr_sequencia
and	a.nr_seq_analise_ref is null

UNION ALL

select	'F' ie_tipo_analise,
	a.nr_sequencia nr_seq_analise,
	d.nr_fatura,
	d.nr_nota_credito_debito,
	d.cd_unimed_origem
from	pls_analise_conta a,
	pls_analise_conta b,
	pls_conta c,
	ptu_fatura d
where	b.nr_sequencia	= a.nr_seq_analise_ref
and	c.nr_seq_analise	= b.nr_sequencia
and	c.nr_seq_fatura	= d.nr_sequencia
and	a.nr_seq_analise_ref is not null;

