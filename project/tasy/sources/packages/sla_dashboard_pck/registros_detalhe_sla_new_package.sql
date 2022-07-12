-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION sla_dashboard_pck.registros_detalhe_sla_new ( dt_month_p timestamp, ie_type_p text, nr_seq_gerencia_p bigint, nr_seq_gerencia_sup_p bigint, nr_seq_localizacao_p bigint, ie_apenas_sla_p text, ie_resposta_atrasada_p text, ie_solucao_atrasada_p text) RETURNS SETOF T_DETALHE_SLA_REF AS $body$
DECLARE


t_detalhe_sla_ref_row_w		t_detalhe_sla_ref_row;
dt_referencia_w			timestamp;

c01 CURSOR FOR  --Forma do mes Janeiro e Fev
SELECT	a.nr_seq_ordem_serv,
	a.ds_dano_breve,
	a.ds_localizacao,
	a.ie_sla,
	a.ie_resposta_os,
	a.qt_dif_min_resposta,
	a.ie_solucao_os,
	a.qt_dif_min_solucao,
	a.ds_grupo_desenv,
	a.ds_classificacao_cliente,
	a.ds_classificacao,
	a.ds_prioridade_cliente,
	a.ds_prioridade,
	a.ds_sla,
	a.ds_estagio_atual,
	a.ds_tipo_contrato
from	table(sla_dashboard_pck.registros_detalhe_sla_ref(dt_month_p ,ie_type_p , nr_seq_gerencia_p, nr_seq_gerencia_sup_p, null ,ie_apenas_sla_p , ie_resposta_atrasada_p, ie_solucao_atrasada_p)) a;

c02 CURSOR FOR  --Forma do mes Setembro
SELECT	a.nr_seq_ordem_serv,
	a.ds_dano_breve,
	a.ds_localizacao,
	a.ie_sla,
	a.ie_resposta_os,
	a.qt_dif_min_resposta,
	a.ie_solucao_os,
	a.qt_dif_min_solucao,
	a.ds_grupo_desenv,
	a.ds_classificacao_cliente,
	a.ds_classificacao,
	a.ds_prioridade_cliente,
	a.ds_prioridade,
	a.ds_sla,
	a.ds_estagio_atual,
	null ds_tipo_contrato
from	table(sla_dashboard_pck.registros_detalhe_sla(dt_month_p ,ie_type_p , nr_seq_gerencia_p, nr_seq_gerencia_sup_p, null ,ie_apenas_sla_p , ie_resposta_atrasada_p, ie_solucao_atrasada_p)) a;

c01_w	c01%rowtype;
c02_w	c02%rowtype;


BEGIN

dt_referencia_w	:= trunc(dt_month_p,'month');

if (trunc(dt_referencia_w, 'mm') > trunc(to_date('01/08/2020','dd/mm/yyyy'),'MM')) then
	
	open C01;
	loop
	fetch C01 into
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */

		t_detalhe_sla_ref_row_w.ds_localizacao  		:= c01_w.ds_localizacao;
		t_detalhe_sla_ref_row_w.nr_seq_ordem_serv		:= c01_w.nr_seq_ordem_serv;
		t_detalhe_sla_ref_row_w.ds_dano_breve			:= c01_w.ds_dano_breve;			
		t_detalhe_sla_ref_row_w.ds_classificacao_cliente	:= c01_w.ds_classificacao_cliente;
		t_detalhe_sla_ref_row_w.ds_classificacao		:= c01_w.ds_classificacao;
		t_detalhe_sla_ref_row_w.ds_prioridade_cliente		:= c01_w.ds_prioridade_cliente;
		t_detalhe_sla_ref_row_w.ds_prioridade			:= c01_w.ds_prioridade;
		t_detalhe_sla_ref_row_w.ie_sla				:= c01_w.ie_sla;
		t_detalhe_sla_ref_row_w.ds_sla				:= c01_w.ds_sla;
		t_detalhe_sla_ref_row_w.ds_estagio_atual		:= c01_w.ds_estagio_atual;
		t_detalhe_sla_ref_row_w.qt_dif_min_solucao		:= c01_w.qt_dif_min_solucao;
		t_detalhe_sla_ref_row_w.ie_solucao_os			:= c01_w.ie_solucao_os;
		t_detalhe_sla_ref_row_w.qt_dif_min_resposta		:= c01_w.qt_dif_min_resposta;
		t_detalhe_sla_ref_row_w.ie_resposta_os			:= c01_w.ie_resposta_os;
		t_detalhe_sla_ref_row_w.ds_grupo_desenv			:= c01_w.ds_grupo_desenv;
		t_detalhe_sla_ref_row_w.ds_tipo_contrato		:= c01_w.ds_tipo_contrato;
		
		RETURN NEXT t_detalhe_sla_ref_row_w;
	end loop;
	close C01;
	
else

	open C02;
	loop
	fetch C02 into
		c02_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */

		t_detalhe_sla_ref_row_w.ds_localizacao  		:= c02_w.ds_localizacao;
		t_detalhe_sla_ref_row_w.nr_seq_ordem_serv		:= c02_w.nr_seq_ordem_serv;
		t_detalhe_sla_ref_row_w.ds_dano_breve			:= c02_w.ds_dano_breve;			
		t_detalhe_sla_ref_row_w.ds_classificacao_cliente	:= c02_w.ds_classificacao_cliente;
		t_detalhe_sla_ref_row_w.ds_classificacao		:= c02_w.ds_classificacao;
		t_detalhe_sla_ref_row_w.ds_prioridade_cliente		:= c02_w.ds_prioridade_cliente;
		t_detalhe_sla_ref_row_w.ds_prioridade			:= c02_w.ds_prioridade;
		t_detalhe_sla_ref_row_w.ie_sla				:= c02_w.ie_sla;
		t_detalhe_sla_ref_row_w.ds_sla				:= c02_w.ds_sla;
		t_detalhe_sla_ref_row_w.ds_estagio_atual		:= c02_w.ds_estagio_atual;
		t_detalhe_sla_ref_row_w.qt_dif_min_solucao		:= c02_w.qt_dif_min_solucao;
		t_detalhe_sla_ref_row_w.ie_solucao_os			:= c02_w.ie_solucao_os;
		t_detalhe_sla_ref_row_w.qt_dif_min_resposta		:= c02_w.qt_dif_min_resposta;
		t_detalhe_sla_ref_row_w.ie_resposta_os			:= c02_w.ie_resposta_os;
		t_detalhe_sla_ref_row_w.ds_grupo_desenv			:= c02_w.ds_grupo_desenv;
		t_detalhe_sla_ref_row_w.ds_tipo_contrato		:= c02_w.ds_tipo_contrato;

		RETURN NEXT t_detalhe_sla_ref_row_w;
	end loop;
	close C02;

end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION sla_dashboard_pck.registros_detalhe_sla_new ( dt_month_p timestamp, ie_type_p text, nr_seq_gerencia_p bigint, nr_seq_gerencia_sup_p bigint, nr_seq_localizacao_p bigint, ie_apenas_sla_p text, ie_resposta_atrasada_p text, ie_solucao_atrasada_p text) FROM PUBLIC;
