-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW movto_estoque_ajuste_prod_v (nr_movimento_estoque, vl_movimento, cd_operacao_estoque, dt_movimento_estoque, cd_material, nr_documento, nr_lote_contabil, cd_local_estoque) AS select	/*+ ORDERED */	a.nr_movimento_estoque,
	sum(CASE WHEN b.ie_aumenta_diminui_valor='D' THEN (a.vl_movimento * -1)  ELSE a.vl_movimento END ) vl_movimento,
	c.cd_operacao_estoque,
	c.dt_movimento_estoque,
	c.cd_material,
	c.nr_documento,
	c.nr_lote_contabil,
	c.cd_local_estoque
FROM movimento_estoque c,
	movimento_estoque_valor a,
     tipo_valor b
where	a.nr_movimento_estoque = c.nr_movimento_estoque
and	a.cd_tipo_valor	= b.cd_tipo_valor
and	b.cd_tipo_valor = 17
group by a.nr_movimento_estoque,
	c.cd_operacao_estoque,
	c.dt_movimento_estoque,
	c.cd_material,
	c.nr_documento,
	c.nr_lote_contabil,
	c.cd_local_estoque;
