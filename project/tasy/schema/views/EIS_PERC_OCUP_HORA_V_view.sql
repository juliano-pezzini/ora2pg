-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_perc_ocup_hora_v (dt_referencia, cd_setor_atendimento, cd_estabelecimento, ds_setor_atendimento, vl_00, vl_01, vl_02, vl_03, vl_04, vl_05, vl_06, vl_07, vl_08, vl_09, vl_10, vl_11, vl_12, vl_13, vl_14, vl_15, vl_16, vl_17, vl_18, vl_19, vl_20, vl_21, vl_22, vl_23, nr_unidades_setor) AS select	dt_referencia,
		cd_setor_atendimento, 
		cd_estabelecimento, 
		substr(ds_setor_atendimento,1,100) ds_setor_atendimento, 
		SUM(CASE WHEN TO_CHAR(HR_INTERNADO,'HH24')=00 THEN 1  ELSE 0 END ) vl_00, 
		SUM(CASE WHEN TO_CHAR(HR_INTERNADO,'HH24')=01 THEN 1  ELSE 0 END ) vl_01, 
		SUM(CASE WHEN TO_CHAR(HR_INTERNADO,'HH24')=02 THEN 1  ELSE 0 END ) vl_02, 
		SUM(CASE WHEN TO_CHAR(HR_INTERNADO,'HH24')=03 THEN 1  ELSE 0 END ) vl_03, 
		SUM(CASE WHEN TO_CHAR(HR_INTERNADO,'HH24')=04 THEN 1  ELSE 0 END ) vl_04, 
		SUM(CASE WHEN TO_CHAR(HR_INTERNADO,'HH24')=05 THEN 1  ELSE 0 END ) vl_05, 
		SUM(CASE WHEN TO_CHAR(HR_INTERNADO,'HH24')=06 THEN 1  ELSE 0 END ) vl_06, 
		SUM(CASE WHEN TO_CHAR(HR_INTERNADO,'HH24')=07 THEN 1  ELSE 0 END ) vl_07, 
		SUM(CASE WHEN TO_CHAR(HR_INTERNADO,'HH24')=08 THEN 1  ELSE 0 END ) vl_08, 
		SUM(CASE WHEN TO_CHAR(HR_INTERNADO,'HH24')=09 THEN 1  ELSE 0 END ) vl_09, 
		SUM(CASE WHEN TO_CHAR(HR_INTERNADO,'HH24')=10 THEN 1  ELSE 0 END ) vl_10, 
		SUM(CASE WHEN TO_CHAR(HR_INTERNADO,'HH24')=11 THEN 1  ELSE 0 END ) vl_11, 
		SUM(CASE WHEN TO_CHAR(HR_INTERNADO,'HH24')=12 THEN 1  ELSE 0 END ) vl_12, 
		SUM(CASE WHEN TO_CHAR(HR_INTERNADO,'HH24')=13 THEN 1  ELSE 0 END ) vl_13, 
		SUM(CASE WHEN TO_CHAR(HR_INTERNADO,'HH24')=14 THEN 1  ELSE 0 END ) vl_14, 
   	SUM(CASE WHEN TO_CHAR(HR_INTERNADO,'HH24')=15 THEN 1  ELSE 0 END ) vl_15, 
		SUM(CASE WHEN TO_CHAR(HR_INTERNADO,'HH24')=16 THEN 1  ELSE 0 END ) vl_16, 
		SUM(CASE WHEN TO_CHAR(HR_INTERNADO,'HH24')=17 THEN 1  ELSE 0 END ) vl_17, 
		SUM(CASE WHEN TO_CHAR(HR_INTERNADO,'HH24')=18 THEN 1  ELSE 0 END ) vl_18, 
		SUM(CASE WHEN TO_CHAR(HR_INTERNADO,'HH24')=19 THEN 1  ELSE 0 END ) vl_19, 
   	SUM(CASE WHEN TO_CHAR(HR_INTERNADO,'HH24')=20 THEN 1  ELSE 0 END ) vl_20, 
		SUM(CASE WHEN TO_CHAR(HR_INTERNADO,'HH24')=21 THEN 1  ELSE 0 END ) vl_21, 
		SUM(CASE WHEN TO_CHAR(HR_INTERNADO,'HH24')=22 THEN 1  ELSE 0 END ) vl_22, 
		SUM(CASE WHEN TO_CHAR(HR_INTERNADO,'HH24')=23 THEN 1  ELSE 0 END ) vl_23, 
		(obter_unidades_setor(cd_setor_atendimento) + obter_unidades_temp_setor(cd_setor_atendimento)) nr_unidades_setor 
FROM	eis_internado_hora_v 
group by cd_setor_atendimento, 
	 cd_estabelecimento, 
	dt_referencia, 
	 ds_setor_atendimento;

