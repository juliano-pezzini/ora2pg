-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_evolucao_movto_mes_v (ds_indicador, nr_seq_wheb, nr_seq_apresent, cd_estabelecimento, nr_seq_indicador, dt_referencia, ds_ano, dt_ano, vl_indicador) AS select	b.ds_indicador,
	b.nr_seq_wheb,
	b.nr_seq_apresent,
	a.cd_estabelecimento,
	a.nr_seq_indicador,
	a.dt_referencia	,
	CASE WHEN trunc(a.dt_referencia, 'year')=add_months(trunc(LOCALTIMESTAMP, 'year'),-48) THEN  to_char(add_months(trunc(LOCALTIMESTAMP, 'year'),-48),'yyyy')  ELSE CASE WHEN trunc(a.dt_referencia, 'year')=add_months(trunc(LOCALTIMESTAMP, 'year'),-36) THEN  to_char(add_months(trunc(LOCALTIMESTAMP, 'year'),-36),'yyyy')  ELSE CASE WHEN trunc(a.dt_referencia, 'year')=add_months(trunc(LOCALTIMESTAMP, 'year'),-24) THEN  to_char(add_months(trunc(LOCALTIMESTAMP, 'year'),-24),'yyyy')  ELSE CASE WHEN trunc(a.dt_referencia, 'year')=add_months(trunc(LOCALTIMESTAMP, 'year'),-12) THEN  to_char(add_months(trunc(LOCALTIMESTAMP, 'year'),-12),'yyyy')  ELSE CASE WHEN trunc(a.dt_referencia, 'year')=trunc(LOCALTIMESTAMP, 'year') THEN  to_char(trunc(LOCALTIMESTAMP, 'year'),'yyyy') END  END  END  END  END  ds_ano,
	CASE WHEN trunc(a.dt_referencia, 'year')=add_months(trunc(LOCALTIMESTAMP, 'year'),-48) THEN  add_months(trunc(LOCALTIMESTAMP, 'year'),-48)  ELSE CASE WHEN trunc(a.dt_referencia, 'year')=add_months(trunc(LOCALTIMESTAMP, 'year'),-36) THEN  add_months(trunc(LOCALTIMESTAMP, 'year'),-36)  ELSE CASE WHEN trunc(a.dt_referencia, 'year')=add_months(trunc(LOCALTIMESTAMP, 'year'),-24) THEN  add_months(trunc(LOCALTIMESTAMP, 'year'),-24)  ELSE CASE WHEN trunc(a.dt_referencia, 'year')=add_months(trunc(LOCALTIMESTAMP, 'year'),-12) THEN  add_months(trunc(LOCALTIMESTAMP, 'year'),-12)  ELSE CASE WHEN trunc(a.dt_referencia, 'year')=trunc(LOCALTIMESTAMP, 'year') THEN  trunc(LOCALTIMESTAMP, 'year') END  END  END  END  END  dt_ano,
	a.vl_indicador
FROM	indicador_gestao b,
	eis_indicador_gestao a
where	a.nr_seq_indicador	= b.nr_seq_wheb
and	a.ie_periodo		= 'M'
and	a.ie_prev_real		= 'R'
and	trunc(a.dt_referencia, 'year') between add_months(trunc(LOCALTIMESTAMP, 'year'),-48) and trunc(LOCALTIMESTAMP, 'year');
