-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION sla_dashboard_pck.reg_sla_alldef_evento (dt_month_p timestamp) RETURNS SETOF T_SLA_ALL_DEF_TB AS $body$
DECLARE


t_sla_all_def_tb_w	t_sla_all_def;
dt_referencia_w		timestamp;

c01 CURSOR FOR  --Forma ate  o  mes de  julho
SELECT  ds_tipo_sla ds_type,
	ie_tipo_sla ie_type,
	qt_sla opened_defects,
	qt_sla_calculo sla_calc,
	0 reclassified_defects,
	qt_atraso_resposta RESPONSE_BREACHED,
	qt_atraso_solucao resolution_breached,
	pr_atingido sla_achievement,
	qt_target qt_meta,
	dt_referencia generate_date
from  table(sla_dashboard_pck.registros_sla_dashboard_new(dt_month_p))
where  1=1
group by ds_tipo_sla,
	ie_tipo_sla,
	qt_sla, 
	qt_sla_calculo, 
	qt_atraso_resposta,
	qt_atraso_solucao,
	pr_atingido,
	qt_target,
	dt_referencia
order by  ds_type desc;

c02 CURSOR FOR  --Forma apos  de  julho
SELECT 	qt_os_calc,
	qt_estouro_resp,
	qt_estouro_sol,
	qt_total_estouro,
	CASE WHEN to_char(dt_month_p, 'MM/YYYY')='08/2021' THEN  OBTER_ating_KPI_BSC(2637, dt_month_p) WHEN to_char(dt_month_p, 'MM/YYYY')='09/2021' THEN
	qt_meta
from    table(sla_dashboard_pck.obter_sla_all_def(3,to_char(dt_month_p, 'MM'),to_char(dt_month_p, 'YYYY'))) a;

c01_w	c01%rowtype;
c02_w	c02%rowtype;


BEGIN

dt_referencia_w	:= trunc(dt_month_p,'month');

if (trunc(dt_referencia_w, 'mm') <= trunc(to_date('01/07/2021','dd/mm/yyyy'),'MM')) then
	
	open C01;
	loop
	fetch C01 into
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	
		t_sla_all_def_tb_w.qt_os_calc		:= 	c01_w.sla_calc;
		t_sla_all_def_tb_w.qt_estouro_resp	:=	c01_w.RESPONSE_BREACHED;
		t_sla_all_def_tb_w.qt_estouro_sol	:=	c01_w.resolution_breached;
		t_sla_all_def_tb_w.qt_total_estouro	:=	(c01_w.RESPONSE_BREACHED + c01_w.resolution_breached);
		t_sla_all_def_tb_w.qt_atingiu		:=	c01_w.sla_achievement;
		t_sla_all_def_tb_w.qt_meta		:=	c01_w.qt_meta;

		RETURN NEXT t_sla_all_def_tb_w;
	end loop;
	close C01;
	
else
	open C02;
	loop
	fetch C02 into
		c02_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */

		t_sla_all_def_tb_w.qt_os_calc		:= 	c02_w.qt_os_calc;
		t_sla_all_def_tb_w.qt_estouro_resp	:=	c02_w.qt_estouro_resp;
		t_sla_all_def_tb_w.qt_estouro_sol	:=	c02_w.qt_estouro_sol;
		t_sla_all_def_tb_w.qt_total_estouro	:=	c02_w.qt_total_estouro;
		t_sla_all_def_tb_w.qt_atingiu		:=	c02_w.qt_atingiu;
		t_sla_all_def_tb_w.qt_meta		:=	c02_w.qt_meta;

		RETURN NEXT t_sla_all_def_tb_w;
	end loop;
	close C02;

end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION sla_dashboard_pck.reg_sla_alldef_evento (dt_month_p timestamp) FROM PUBLIC;