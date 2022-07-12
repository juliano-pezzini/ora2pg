-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_indicador_gestao_v2 (nr_seq_indicador, cd_estabelecimento, cd_setor_atendimento, dt_ano, ds_ano, ie_periodo, vl_janeiro, vl_fevereiro, vl_marco, vl_abril, vl_maio, vl_junho, vl_julho, vl_agosto, vl_setembro, vl_outubro, vl_novembro, vl_dezembro, vl_media_anual) AS SELECT	a.nr_seq_indicador,
	a.cd_estabelecimento,
	a.cd_setor_atendimento,
	TRUNC(a.dt_referencia, 'yyyy') dt_ano,
	TO_CHAR(a.dt_referencia, 'yyyy') ds_ano,
	a.ie_periodo,
	SUM(CASE WHEN a.ie_periodo='M' THEN  CASE WHEN TO_CHAR(a.dt_referencia, 'mm')='01' THEN  a.vl_indicador  ELSE 0 END   ELSE 0 END ) vl_janeiro,
	SUM(CASE WHEN TO_CHAR(a.dt_referencia, 'mm')='02' THEN  a.vl_indicador  ELSE 0 END ) vl_fevereiro,
	SUM(CASE WHEN TO_CHAR(a.dt_referencia, 'mm')='03' THEN  a.vl_indicador  ELSE 0 END ) vl_marco,
	SUM(CASE WHEN TO_CHAR(a.dt_referencia, 'mm')='04' THEN  a.vl_indicador  ELSE 0 END ) vl_abril,
	SUM(CASE WHEN TO_CHAR(a.dt_referencia, 'mm')='05' THEN  a.vl_indicador  ELSE 0 END ) vl_maio,
	SUM(CASE WHEN TO_CHAR(a.dt_referencia, 'mm')='06' THEN  a.vl_indicador  ELSE 0 END ) vl_junho,
	SUM(CASE WHEN TO_CHAR(a.dt_referencia, 'mm')='07' THEN  a.vl_indicador  ELSE 0 END ) vl_julho,
	SUM(CASE WHEN TO_CHAR(a.dt_referencia, 'mm')='08' THEN  a.vl_indicador  ELSE 0 END ) vl_agosto,
	SUM(CASE WHEN TO_CHAR(a.dt_referencia, 'mm')='09' THEN  a.vl_indicador  ELSE 0 END ) vl_setembro,
	SUM(CASE WHEN TO_CHAR(a.dt_referencia, 'mm')='10' THEN  a.vl_indicador  ELSE 0 END ) vl_outubro,
	SUM(CASE WHEN TO_CHAR(a.dt_referencia, 'mm')='11' THEN  a.vl_indicador  ELSE 0 END ) vl_novembro,
	SUM(CASE WHEN TO_CHAR(a.dt_referencia, 'mm')='12' THEN  a.vl_indicador  ELSE 0 END ) vl_dezembro,
	MAX(EIS_Obter_Media_resumo(a.nr_seq_indicador, a.cd_estabelecimento, TRUNC(dt_referencia, 'year'))) vl_media_anual
FROM	w_indicador_gestao a
GROUP BY a.nr_seq_indicador,
	a.cd_estabelecimento,
	a.cd_setor_atendimento,
	a.ie_periodo,
	TRUNC(a.dt_referencia, 'yyyy'),
	TO_CHAR(a.dt_referencia, 'yyyy');
