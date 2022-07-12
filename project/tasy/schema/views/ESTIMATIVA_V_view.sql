-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW estimativa_v (ie_order, ie_tipo, ds_cliente, vl_mes, dt_mes) AS SELECT	1 ie_order,
	'VP' ie_tipo,
	'Vendas/Pós-vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_01),0) vl_mes,
	MIN(a.dt_mes_01) dt_mes
FROM	w_estimativa_proj_com a

UNION ALL

SELECT	2 ie_order,
	'VP' ie_tipo,
	'Vendas/Pós-vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_02),0) vl_mes,
	MIN(a.dt_mes_02) dt_mes
FROM	w_estimativa_proj_com a

UNION ALL

SELECT	3 ie_order,
	'VP' ie_tipo,
	'Vendas/Pós-vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_03),0) vl_mes,
	MIN(a.dt_mes_03) dt_mes
FROM	w_estimativa_proj_com a

UNION ALL

SELECT	4 ie_order,
	'VP' ie_tipo,
	'Vendas/Pós-vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_04),0) vl_mes,
	MIN(a.dt_mes_04) dt_mes
FROM	w_estimativa_proj_com a

UNION ALL

SELECT	5 ie_order,
	'VP' ie_tipo,
	'Vendas/Pós-vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_05),0) vl_mes,
	MIN(a.dt_mes_05) dt_mes
FROM	w_estimativa_proj_com a

UNION ALL

SELECT	6 ie_order,
	'VP' ie_tipo,
	'Vendas/Pós-vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_06),0) vl_mes,
	MIN(a.dt_mes_06) dt_mes
FROM	w_estimativa_proj_com a

UNION ALL

SELECT	7 ie_order,
	'VP' ie_tipo,
	'Vendas/Pós-vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_07),0) vl_mes,
	MIN(a.dt_mes_07) dt_mes
FROM	w_estimativa_proj_com a

UNION ALL

SELECT	8 ie_order,
	'VP' ie_tipo,
	'Vendas/Pós-vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_08),0) vl_mes,
	MIN(a.dt_mes_08) dt_mes
FROM	w_estimativa_proj_com a

UNION ALL

SELECT	9 ie_order,
	'VP' ie_tipo,
	'Vendas/Pós-vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_09),0) vl_mes,
	MIN(a.dt_mes_09) dt_mes
FROM	w_estimativa_proj_com a

UNION ALL

SELECT	10 ie_order,
	'VP' ie_tipo,
	'Vendas/Pós-vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_10),0) vl_mes,
	MIN(a.dt_mes_10) dt_mes
FROM	w_estimativa_proj_com a

UNION ALL

SELECT	11 ie_order,
	'VP' ie_tipo,
	'Vendas/Pós-vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_11),0) vl_mes,
	MIN(a.dt_mes_11) dt_mes
FROM	w_estimativa_proj_com a

UNION ALL

SELECT	12 ie_order,
	'VP' ie_tipo,
	'Vendas/Pós-vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_12),0) vl_mes,
	MIN(a.dt_mes_12) dt_mes
FROM	w_estimativa_proj_com a

UNION ALL

SELECT	1 ie_order,
	'V' ie_tipo,
	'Vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_01),0) vl_mes,
	MIN(a.dt_mes_01) dt_mes
FROM	w_estimativa_proj_com a,
	com_cliente b
WHERE	b.nr_sequencia = a.nr_seq_cliente
AND	b.ie_classificacao = 'P'

UNION ALL

SELECT	2 ie_order,
	'V' ie_tipo,
	'Vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_02),0) vl_mes,
	MIN(a.dt_mes_02) dt_mes
FROM	w_estimativa_proj_com a,
	com_cliente b
WHERE	b.nr_sequencia = a.nr_seq_cliente
AND	b.ie_classificacao = 'P'

UNION ALL

SELECT	3 ie_order,
	'V' ie_tipo,
	'Vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_03),0) vl_mes,
	MIN(a.dt_mes_03) dt_mes
FROM	w_estimativa_proj_com a,
	com_cliente b
WHERE	b.nr_sequencia = a.nr_seq_cliente
AND	b.ie_classificacao = 'P'

UNION ALL

SELECT	4 ie_order,
	'V' ie_tipo,
	'Vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_04),0) vl_mes,
	MIN(a.dt_mes_04) dt_mes
FROM	w_estimativa_proj_com a,
	com_cliente b
WHERE	b.nr_sequencia = a.nr_seq_cliente
AND	b.ie_classificacao = 'P'

UNION ALL

SELECT	5 ie_order,
	'V' ie_tipo,
	'Vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_05),0) vl_mes,
	MIN(a.dt_mes_05) dt_mes
FROM	w_estimativa_proj_com a,
	com_cliente b
WHERE	b.nr_sequencia = a.nr_seq_cliente
AND	b.ie_classificacao = 'P'

UNION ALL

SELECT	6 ie_order,
	'V' ie_tipo,
	'Vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_06),0) vl_mes,
	MIN(a.dt_mes_06) dt_mes
FROM	w_estimativa_proj_com a,
	com_cliente b
WHERE	b.nr_sequencia = a.nr_seq_cliente
AND	b.ie_classificacao = 'P'

UNION ALL

SELECT	7 ie_order,
	'V' ie_tipo,
	'Vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_07),0) vl_mes,
	MIN(a.dt_mes_07) dt_mes
FROM	w_estimativa_proj_com a,
	com_cliente b
WHERE	b.nr_sequencia = a.nr_seq_cliente
AND	b.ie_classificacao = 'P'

UNION ALL

SELECT	8 ie_order,
	'V' ie_tipo,
	'Vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_08),0) vl_mes,
	MIN(a.dt_mes_08) dt_mes
FROM	w_estimativa_proj_com a,
	com_cliente b
WHERE	b.nr_sequencia = a.nr_seq_cliente
AND	b.ie_classificacao = 'P'

UNION ALL

SELECT	9 ie_order,
	'V' ie_tipo,
	'Vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_09),0) vl_mes,
	MIN(a.dt_mes_09) dt_mes
FROM	w_estimativa_proj_com a,
	com_cliente b
WHERE	b.nr_sequencia = a.nr_seq_cliente
AND	b.ie_classificacao = 'P'

UNION ALL

SELECT	10 ie_order,
	'V' ie_tipo,
	'Vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_10),0) vl_mes,
	MIN(a.dt_mes_10) dt_mes
FROM	w_estimativa_proj_com a,
	com_cliente b
WHERE	b.nr_sequencia = a.nr_seq_cliente
AND	b.ie_classificacao = 'P'

UNION ALL

SELECT	11 ie_order,
	'V' ie_tipo,
	'Vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_11),0) vl_mes,
	MIN(a.dt_mes_11) dt_mes
FROM	w_estimativa_proj_com a,
	com_cliente b
WHERE	b.nr_sequencia = a.nr_seq_cliente
AND	b.ie_classificacao = 'P'

UNION ALL

SELECT	12 ie_order,
	'V' ie_tipo,
	'Vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_12),0) vl_mes,
	MIN(a.dt_mes_12) dt_mes
FROM	w_estimativa_proj_com a,
	com_cliente b
WHERE	b.nr_sequencia = a.nr_seq_cliente
AND	b.ie_classificacao = 'P'

UNION ALL

SELECT	1 ie_order,
	'P' ie_tipo,
	'Pós-Vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_01),0) vl_mes,
	MIN(a.dt_mes_01) dt_mes
FROM	w_estimativa_proj_com a,
	com_cliente b
WHERE	b.nr_sequencia = a.nr_seq_cliente
AND	b.ie_classificacao = 'C'

UNION ALL

SELECT	2 ie_order,
	'P' ie_tipo,
	'Pós-Vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_02),0) vl_mes,
	MIN(a.dt_mes_02) dt_mes
FROM	w_estimativa_proj_com a,
	com_cliente b
WHERE	b.nr_sequencia = a.nr_seq_cliente
AND	b.ie_classificacao = 'C'

UNION ALL

SELECT	3 ie_order,
	'P' ie_tipo,
	'Pós-Vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_03),0) vl_mes,
	MIN(a.dt_mes_03) dt_mes
FROM	w_estimativa_proj_com a,
	com_cliente b
WHERE	b.nr_sequencia = a.nr_seq_cliente
AND	b.ie_classificacao = 'C'

UNION ALL

SELECT	4 ie_order,
	'P' ie_tipo,
	'Pós-Vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_04),0) vl_mes,
	MIN(a.dt_mes_04) dt_mes
FROM	w_estimativa_proj_com a,
	com_cliente b
WHERE	b.nr_sequencia = a.nr_seq_cliente
AND	b.ie_classificacao = 'C'

UNION ALL

SELECT	5 ie_order,
	'P' ie_tipo,
	'Pós-Vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_05),0) vl_mes,
	MIN(a.dt_mes_05) dt_mes
FROM	w_estimativa_proj_com a,
	com_cliente b
WHERE	b.nr_sequencia = a.nr_seq_cliente
AND	b.ie_classificacao = 'C'

UNION ALL

SELECT	6 ie_order,
	'P' ie_tipo,
	'Pós-Vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_06),0) vl_mes,
	MIN(a.dt_mes_06) dt_mes
FROM	w_estimativa_proj_com a,
	com_cliente b
WHERE	b.nr_sequencia = a.nr_seq_cliente
AND	b.ie_classificacao = 'C'

UNION ALL

SELECT	7 ie_order,
	'P' ie_tipo,
	'Pós-Vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_07),0) vl_mes,
	MIN(a.dt_mes_07) dt_mes
FROM	w_estimativa_proj_com a,
	com_cliente b
WHERE	b.nr_sequencia = a.nr_seq_cliente
AND	b.ie_classificacao = 'C'

UNION ALL

SELECT	8 ie_order,
	'P' ie_tipo,
	'Pós-Vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_08),0) vl_mes,
	MIN(a.dt_mes_08) dt_mes
FROM	w_estimativa_proj_com a,
	com_cliente b
WHERE	b.nr_sequencia = a.nr_seq_cliente
AND	b.ie_classificacao = 'C'

UNION ALL

SELECT	9 ie_order,
	'P' ie_tipo,
	'Pós-Vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_09),0) vl_mes,
	MIN(a.dt_mes_09) dt_mes
FROM	w_estimativa_proj_com a,
	com_cliente b
WHERE	b.nr_sequencia = a.nr_seq_cliente
AND	b.ie_classificacao = 'C'

UNION ALL

SELECT	10 ie_order,
	'P' ie_tipo,
	'Pós-Vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_10),0) vl_mes,
	MIN(a.dt_mes_10) dt_mes
FROM	w_estimativa_proj_com a,
	com_cliente b
WHERE	b.nr_sequencia = a.nr_seq_cliente
AND	b.ie_classificacao = 'C'

UNION ALL

SELECT	11 ie_order,
	'P' ie_tipo,
	'Pós-Vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_11),0) vl_mes,
	MIN(a.dt_mes_11) dt_mes
FROM	w_estimativa_proj_com a,
	com_cliente b
WHERE	b.nr_sequencia = a.nr_seq_cliente
AND	b.ie_classificacao = 'C'

UNION ALL

SELECT	12 ie_order,
	'P' ie_tipo,
	'Pós-Vendas' ds_cliente,
	coalesce(SUM(a.vl_mes_12),0) vl_mes,
	MIN(a.dt_mes_12) dt_mes
FROM	w_estimativa_proj_com a,
	com_cliente b
WHERE	b.nr_sequencia = a.nr_seq_cliente
AND	b.ie_classificacao = 'C'
ORDER BY	ie_order;

