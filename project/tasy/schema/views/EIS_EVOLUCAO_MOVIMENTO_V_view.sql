-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_evolucao_movimento_v (ds_indicador, nr_seq_wheb, nr_seq_apresent, cd_estabelecimento, nr_sequencia, vl_ano_a4, vl_ano_a3, vl_ano_a2, vl_ano_a1, vl_ano_atual, vl_ano_atual_prev) AS select	b.ds_indicador,
	b.nr_seq_wheb,
	b.nr_seq_apresent,
	a.cd_estabelecimento,
	b.nr_sequencia,
	max(CASE WHEN trunc(a.dt_referencia, 'year')=add_months(trunc(LOCALTIMESTAMP, 'year'),-48) THEN  a.vl_indicador  ELSE 0 END ) vl_ano_a4,
	max(CASE WHEN trunc(a.dt_referencia, 'year')=add_months(trunc(LOCALTIMESTAMP, 'year'),-36) THEN  a.vl_indicador  ELSE 0 END ) vl_ano_a3,
	max(CASE WHEN trunc(a.dt_referencia, 'year')=add_months(trunc(LOCALTIMESTAMP, 'year'),-24) THEN  a.vl_indicador  ELSE 0 END ) vl_ano_a2,
	max(CASE WHEN trunc(a.dt_referencia, 'year')=add_months(trunc(LOCALTIMESTAMP, 'year'),-12) THEN  a.vl_indicador  ELSE 0 END ) vl_ano_a1,
	max(CASE WHEN trunc(a.dt_referencia, 'year')=trunc(LOCALTIMESTAMP, 'year') THEN  CASE WHEN a.ie_prev_real='R' THEN  a.vl_indicador  ELSE 0 END   ELSE 0 END ) vl_ano_atual,
	max(CASE WHEN trunc(a.dt_referencia, 'year')=trunc(LOCALTIMESTAMP, 'year') THEN  CASE WHEN a.ie_prev_real='P' THEN  a.vl_indicador  ELSE 0 END   ELSE 0 END ) vl_ano_atual_prev
FROM	indicador_gestao b,
	eis_indicador_gestao a
where	a.nr_seq_indicador	= b.nr_seq_wheb
and	a.ie_periodo		= 'A'
group by b.ds_indicador,
	b.nr_seq_apresent,
	b.nr_seq_wheb,
	a.cd_estabelecimento,
	b.nr_sequencia;
