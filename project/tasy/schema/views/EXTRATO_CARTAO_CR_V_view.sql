-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW extrato_cartao_cr_v (nr_seq_extrato, nr_seq_extrato_arq, nr_seq_extrato_movto, ie_tipo_arquivo, nr_seq_parcela, nr_seq_movto, ie_pagto_indevido, vl_bruto, vl_liquido) AS select	a.nr_sequencia nr_seq_extrato,
	b.nr_sequencia nr_seq_extrato_arq,
	c.nr_sequencia nr_seq_extrato_movto,
	b.ie_tipo_arquivo,
	d.nr_sequencia nr_seq_parcela,
	d.nr_seq_movto,
	c.ie_pagto_indevido,
	d.vl_parcela vl_bruto,
	d.vl_liquido
FROM	movto_cartao_cr_parcela d,
	extrato_cartao_cr_movto c,
	extrato_cartao_cr_arq b,
	extrato_cartao_cr a
where	a.nr_sequencia			= b.nr_seq_extrato
and	b.nr_sequencia			= c.nr_seq_extrato_arq
and	c.nr_seq_extrato_parcela	= d.nr_seq_extrato_parcela

union

/* obter os movtos financeiros conciliados com os movtos de crédito */

select	a.nr_sequencia nr_seq_extrato,
	b.nr_sequencia nr_seq_extrato_arq,
	c.nr_sequencia nr_seq_extrato_movto,
	b.ie_tipo_arquivo,
	null nr_seq_parcela,
	null nr_seq_movto,
	c.ie_pagto_indevido,
	(select	sum(n.vl_parcela)
	from	movto_cartao_cr_parcela n,
		extrato_cartao_cr_arq m,
		extrato_cartao_cr_movto w,
		ext_cartao_cr_movto_concil z,
		extrato_cartao_cr_parcela y,
		ext_cartao_cr_movto_concil x
	where	x.nr_seq_ext_movto		= c.nr_sequencia
	and	x.nr_seq_extrato_parcela	= y.nr_sequencia
	and	y.nr_sequencia			= z.nr_seq_extrato_parcela
	and	z.nr_sequencia			<> x.nr_sequencia
	and	z.nr_seq_ext_movto		= w.nr_sequencia
	and	w.nr_seq_extrato_arq		= m.nr_sequencia
	and	m.ie_tipo_arquivo		= 'C'
	and	w.nr_seq_extrato_parcela	= n.nr_seq_extrato_parcela) vl_bruto,
	(select	sum(n.vl_liquido)
	from	movto_cartao_cr_parcela n,
		extrato_cartao_cr_arq m,
		extrato_cartao_cr_movto w,
		ext_cartao_cr_movto_concil z,
		extrato_cartao_cr_parcela y,
		ext_cartao_cr_movto_concil x
	where	x.nr_seq_ext_movto		= c.nr_sequencia
	and	x.nr_seq_extrato_parcela	= y.nr_sequencia
	and	y.nr_sequencia			= z.nr_seq_extrato_parcela
	and	z.nr_sequencia			<> x.nr_sequencia
	and	z.nr_seq_ext_movto		= w.nr_sequencia
	and	w.nr_seq_extrato_arq		= m.nr_sequencia
	and	m.ie_tipo_arquivo		= 'C'
	and	w.nr_seq_extrato_parcela	= n.nr_seq_extrato_parcela) vl_liquido
from	extrato_cartao_cr_movto c,
	extrato_cartao_cr_arq b,
	extrato_cartao_cr a
where	a.nr_sequencia			= b.nr_seq_extrato
and	b.ie_tipo_arquivo		= 'F'
and	b.nr_sequencia			= c.nr_seq_extrato_arq
and	c.nr_seq_extrato_parcela	is null
and	c.vl_saldo_concil_fin		= 0

union

/* PAGAMENTOS INDEVIDOS */

select	a.nr_sequencia nr_seq_extrato,
	b.nr_sequencia nr_seq_extrato_arq,
	c.nr_sequencia nr_seq_extrato_movto,
	b.ie_tipo_arquivo,
	null nr_seq_parcela,
	null nr_seq_movto,
	c.ie_pagto_indevido,
	c.vl_parcela vl_bruto,
	c.vl_liquido
from	extrato_cartao_cr_movto c,
	extrato_cartao_cr_arq b,
	extrato_cartao_cr a
where	a.nr_sequencia		= b.nr_seq_extrato
and	b.nr_sequencia		= c.nr_seq_extrato_arq
and	c.ie_pagto_indevido	= 'S';

