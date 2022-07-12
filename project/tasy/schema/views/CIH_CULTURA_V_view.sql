-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cih_cultura_v (nr_ficha_ocorrencia, nr_seq_cultura, cd_amostra_cultura, ds_amostra_cultura, dt_coleta, cd_microorganismo, cd_topografia, cd_laboratorio, ds_codigo_laboratorio, ie_resultado, cd_caso_infeccao, cd_setor_atendimento, cd_procedimento, nr_positivo, nr_negativo, nr_ih, nr_ic, nr_sem, nr_outras, nr_con, nr_col) AS select	a.nr_ficha_ocorrencia,
	a.nr_seq_cultura,
	a.cd_amostra_cultura,
	b.ds_amostra_cultura,
	a.dt_coleta,
	a.cd_microorganismo,
	a.cd_topografia,
	a.cd_laboratorio,
	a.ds_codigo_laboratorio,
	a.ie_resultado,
	a.cd_caso_infeccao,
	a.cd_setor_atendimento,
	a.cd_procedimento,
	CASE WHEN a.ie_resultado='P' THEN 1  ELSE 0 END  nr_positivo,
	CASE WHEN a.ie_resultado='N' THEN 1  ELSE 0 END  nr_negativo,
	CASE WHEN a.cd_caso_infeccao=1 THEN 1  ELSE 0 END  nr_ih,
	CASE WHEN a.cd_caso_infeccao=2 THEN 1  ELSE 0 END  nr_ic,
	CASE WHEN a.cd_caso_infeccao=3 THEN 1  ELSE 0 END  nr_sem,
	CASE WHEN a.cd_caso_infeccao=1 THEN 0 WHEN a.cd_caso_infeccao=2 THEN 0 WHEN a.cd_caso_infeccao=3 THEN 0  ELSE 1 END  nr_outras,
	CASE WHEN a.cd_caso_infeccao=4 THEN 1  ELSE 0 END  nr_con,
	CASE WHEN a.cd_caso_infeccao=5 THEN 1  ELSE 0 END  nr_col
FROM cih_cultura a,
     cih_amostra_cultura b
where a.cd_amostra_cultura = b.cd_amostra_cultura;
