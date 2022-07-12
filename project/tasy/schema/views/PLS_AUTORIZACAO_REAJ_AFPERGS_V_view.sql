-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_autorizacao_reaj_afpergs_v (tp_registro, dt_referencia, nr_seq_empresa, vl_anterior, vl_reajuste, cd_cgc) AS select	1 tp_registro,
	to_char(LOCALTIMESTAMP,'yyyymm') dt_referencia,
	max(a.nr_sequencia) nr_seq_empresa,
	null vl_anterior,
	null vl_reajuste,
	a.cd_cgc cd_cgc
FROM	pls_desc_empresa a
group by 1, to_char(LOCALTIMESTAMP,'yyyymm'), null, null, a.cd_cgc

union

select	2 tp_registro,
	null dt_referencia,
	null nr_seq_empresa,
	e.vl_preco_ant vl_anterior,
	e.vl_preco_atual vl_reajuste,
	CASE WHEN(	select	max(x.cd_cgc)			from	pls_desc_empresa	x			where	x.nr_sequencia = c.nr_seq_empresa) IS NULL THEN (	select	max(y.cd_cgc)										from	pls_desc_empresa		y,											pls_contrato_pagador_fin	x										where	x.nr_seq_empresa = y.nr_sequencia										and	x.nr_seq_pagador = d.nr_seq_pagador) END  cd_cgc
from	w_pls_interface_mens	a,
	pls_mensalidade 	b,
	pls_lote_mensalidade 	c,
	pls_segurado		d,
	pls_segurado_preco	e
where	c.nr_sequencia       	= b.nr_seq_lote
and	a.nr_seq_mensalidade 	= b.nr_sequencia
and	a.nr_seq_segurado	= d.nr_sequencia
and	e.nr_seq_segurado	= d.nr_sequencia
and	trunc(e.dt_reajuste, 'yy') = trunc(LOCALTIMESTAMP, 'yy');

