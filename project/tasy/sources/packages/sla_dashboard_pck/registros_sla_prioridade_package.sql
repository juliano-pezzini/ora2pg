-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


	--################################################################################################################################




CREATE OR REPLACE FUNCTION sla_dashboard_pck.registros_sla_prioridade (dt_referencia_p timestamp, ie_tipo_sla_p text) RETURNS SETOF T_PRIORIDADE_SLA AS $body$
DECLARE


	t_prioridade_sla_row_w	t_prioridade_sla_row;
	dt_referencia_w		timestamp;

	c01 CURSOR FOR
	SELECT	ie_prioridade,
		CASE WHEN ie_prioridade='U' THEN  2 WHEN ie_prioridade='E' THEN  1 WHEN ie_prioridade='A' THEN  3 WHEN ie_prioridade='M' THEN  4 WHEN ie_prioridade='B' THEN  5  ELSE 6 END  nr_seq_order,
		qt_sla,
		qt_sla_calculo,
		null reclassified_defects,
		qt_atraso_resposta,
		qt_atraso_solucao
	from	man_resumo_sla_w
	where	dt_referencia	= dt_referencia_w
	and	ie_tipo_sla	= ie_tipo_sla_p
	and	ie_tipo_sla_p	= 'ALLDEF'
	and	ie_informacao	= 'P'
	
union

	SELECT	philips_severity ie_prioridade,
		CASE WHEN philips_severity='U' THEN  2 WHEN philips_severity='E' THEN  1 WHEN philips_severity='A' THEN  3 WHEN philips_severity='M' THEN  4 WHEN philips_severity='B' THEN  5  ELSE 6 END  nr_seq_order,
		sum(CASE WHEN ie_indicador=1 THEN 1  ELSE 0 END ) qt_sla,
		(sum(CASE WHEN ie_indicador=1 THEN 1  ELSE 0 END )*2) qt_sla_calculo,
		sum(CASE WHEN ie_indicador=2 THEN 1  ELSE 0 END ) reclassified_defects,
		sum(CASE WHEN ie_indicador=3 THEN 1  ELSE 0 END ) qt_atraso_resposta,
		sum(CASE WHEN ie_indicador=4 THEN 1  ELSE 0 END ) qt_atraso_solucao
	from  	sla_information_v2
	where 	extract_date between dt_referencia_w and fim_mes(dt_referencia_w)
	and	(((ie_tipo_sla_p = 'SWP' and sla_detail in ('CSFP', 'COSP')) and develop_management_id <> 68) or
		 ((ie_tipo_sla_p = 'SWC' and sla_detail in ('CSFNP', 'COSNP')) and develop_management_id <> 68) or (ie_tipo_sla_p = 'OBI' and sla_detail in ('CSFNP', 'COSNP', 'CSFP', 'COSP', 'PSFNP'))
		)
	group by philips_severity
	  order by nr_seq_order;

	c01_w	c01%rowtype;

	
BEGIN

	dt_referencia_w	:= trunc(dt_referencia_p,'month');

	open C01;
	loop
	fetch C01 into
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */

		t_prioridade_sla_row_w.ds_prioridade		:= obter_valor_dominio(1046,c01_w.ie_prioridade);
		t_prioridade_sla_row_w.ie_prioridade		:= c01_w.ie_prioridade;
		t_prioridade_sla_row_w.dt_referencia		:= dt_referencia_w;
		t_prioridade_sla_row_w.qt_atraso_resposta	:= c01_w.qt_atraso_resposta;
		t_prioridade_sla_row_w.qt_atraso_solucao	:= c01_w.qt_atraso_solucao;
		t_prioridade_sla_row_w.qt_sla			:= c01_w.qt_sla;
		t_prioridade_sla_row_w.qt_sla_calculo		:= c01_w.qt_sla_calculo;

		RETURN NEXT t_prioridade_sla_row_w;

	end loop;
	close C01;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION sla_dashboard_pck.registros_sla_prioridade (dt_referencia_p timestamp, ie_tipo_sla_p text) FROM PUBLIC;
