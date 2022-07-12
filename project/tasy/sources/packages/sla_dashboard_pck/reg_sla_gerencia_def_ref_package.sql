-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION sla_dashboard_pck.reg_sla_gerencia_def_ref (dt_referencia_p timestamp, ie_tipo_sla_p text) RETURNS SETOF T_GERENCIA_SLA AS $body$
DECLARE


	t_gerencia_sla_row_w		t_gerencia_sla_row;
	nr_seq_gerencia_des_w		bigint;
	nr_seq_gerencia_sup_w		bigint;
	dt_referencia_w			timestamp;
	dt_referencia_fim_w		timestamp;

	c01 CURSOR FOR
	SELECT  a.nr_seq_gerencia_des,
		a.nr_seq_gerencia_sup,
		sum(a.qt_sla) qt_sla,
		sum(a.qt_sla_calculo) qt_sla_calculo,
		a.reclassified_defects,
		sum(a.qt_atraso_resposta) qt_atraso_resposta,
		sum(a.qt_atraso_solucao) qt_atraso_solucao,
		round((100-dividir(((sum(a.qt_atraso_resposta))+(sum(qt_atraso_solucao))*100),(sum(qt_sla_calculo)))),2) pr_atingido,
		sla_dashboard_pck.obter_meta_sla(dt_referencia_w,'ALLDEF') qt_target
	from (
		SELECT  develop_management_id nr_seq_gerencia_des,
		null nr_seq_gerencia_sup,
		sum(CASE WHEN ie_indicador=1 THEN 1  ELSE 0 END ) qt_sla,
		(sum(CASE WHEN ie_indicador=1 THEN 1  ELSE 0 END )* sla_dashboard_pck.obter_mult_sla_all_def(sla_detail)) qt_sla_calculo,
		sum(CASE WHEN ie_indicador=2 THEN 1  ELSE 0 END ) reclassified_defects,
		sum(CASE WHEN ie_indicador=3 THEN 1  ELSE 0 END ) qt_atraso_resposta,
		sum(CASE WHEN ie_indicador=4 THEN 1  ELSE 0 END ) qt_atraso_solucao
		from    sla_information_alldef_v
		where   extract_date between dt_referencia_w and dt_referencia_fim_w
		and	ie_tipo_sla_p = 'ALLDEF'
		and    (develop_management_id IS NOT NULL AND develop_management_id::text <> '')
		group by   develop_management_id,
		develop_management,
		sla_detail
	) a
	group by a.nr_seq_gerencia_des, a.nr_seq_gerencia_sup
	order by pr_atingido;

	c01_w	c01%rowtype;

	
BEGIN

	dt_referencia_w	:= trunc(dt_referencia_p,'month');
	dt_referencia_fim_w	:= fim_mes(dt_referencia_p);

	open C01;
	loop
	fetch C01 into
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */

		t_gerencia_sla_row_w.ds_gerencia		:= obter_nome_gerencia( coalesce( c01_w.nr_seq_gerencia_des, c01_w.nr_seq_gerencia_sup ));
		t_gerencia_sla_row_w.nr_seq_gerencia_des	:= c01_w.nr_seq_gerencia_des;
		t_gerencia_sla_row_w.nr_seq_gerencia_sup	:= c01_w.nr_seq_gerencia_sup;
		t_gerencia_sla_row_w.dt_referencia		:= dt_referencia_w;
		t_gerencia_sla_row_w.qt_atraso_resposta		:= c01_w.qt_atraso_resposta;
		t_gerencia_sla_row_w.qt_atraso_solucao		:= c01_w.qt_atraso_solucao;
		t_gerencia_sla_row_w.qt_sla			:= c01_w.qt_sla;
		t_gerencia_sla_row_w.qt_sla_calculo		:= c01_w.qt_sla_calculo;
		t_gerencia_sla_row_w.pr_atingido		:= c01_w.pr_atingido;

		t_gerencia_sla_row_w.qt_target	:= sla_dashboard_pck.obter_meta_sla(dt_referencia_w,ie_tipo_sla_p);

		RETURN NEXT t_gerencia_sla_row_w;

	end loop;
	close C01;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION sla_dashboard_pck.reg_sla_gerencia_def_ref (dt_referencia_p timestamp, ie_tipo_sla_p text) FROM PUBLIC;