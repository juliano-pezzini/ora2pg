-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cus_resumo_conta_v (nr_seq_apres, nr_interno_conta, ds_item, vl_resumo, pr_receita, vl_paciente_dia) AS select	1 nr_seq_apres,
	a.nr_interno_conta, 
	'Receitas' ds_item, 
	coalesce(sum(a.vl_procedimento),0) + coalesce(sum(a.vl_material),0) vl_resumo, 
	cus_obter_receita_conta(a.nr_interno_conta,'') pr_receita, 
	dividir(coalesce(sum(a.vl_procedimento),0) + coalesce(sum(a.vl_material),0), max(obter_dias_conta_pac(a.nr_interno_conta))) vl_paciente_dia 
FROM	conta_paciente_resumo a 
where	coalesce(a.qt_exclusao_custo,0) = 0 
group by a.nr_interno_conta 

union all
 
select	5 nr_seq_apres, 
	a.nr_interno_conta, 
	'Custos variáveis mat/med' ds_item, 
	coalesce(sum(a.vl_custo_var_mc),0) vl_resumo, 
	cus_obter_receita_conta(a.nr_interno_conta,'CV') pr_receita, 
	dividir(coalesce(sum(a.vl_custo_var_mc),0), max(obter_dias_conta_pac(a.nr_interno_conta))) vl_paciente_dia 
from	conta_paciente_resumo a 
where	coalesce(qt_exclusao_custo,0) = 0 
and		cd_material is not null 
group by a.nr_interno_conta 

union all
 
select	10 nr_seq_apres, 
	a.nr_interno_conta, 
	'Custos e despesas variáveis' ds_item, 
	coalesce(sum(a.vl_custo_variavel),0) vl_resumo, 
	cus_obter_receita_conta(a.nr_interno_conta,'CDV') pr_receita, 
	dividir(coalesce(sum(a.vl_custo_variavel),0), max(obter_dias_conta_pac(a.nr_interno_conta))) vl_paciente_dia 
from	cus_conta_pac_mc a 
group by a.nr_interno_conta 

union all
 
select	15 nr_seq_apres, 
	a.nr_interno_conta, 
	'Repasse Médico' ds_item, 
	coalesce(max(Obter_Valor_Repasse_Conta(a.nr_interno_conta,null,'R')),0) vl_resumo, 
	0 vl_pr_receita, 
	0 vl_paciente_dia 
from	conta_Paciente_resumo a 
where	coalesce(a.qt_exclusao_custo,0) = 0 
group	by a.nr_interno_conta 

union all
 
select	distinct 
	20 nr_seq_apres, 
	a.nr_interno_conta, 
	'Valor margem' ds_item, 
	cus_obter_margem_conta(a.nr_interno_conta,'V') vl_resumo, 
	cus_obter_receita_conta(a.nr_interno_conta,'VM') pr_receita, 
	dividir(cus_obter_margem_conta(a.nr_interno_conta,'V'), obter_dias_conta_pac(a.nr_interno_conta)) vl_paciente_dia 
from	conta_paciente_resumo a 

union all
 
select	25 nr_seq_apres, 
	a.nr_interno_conta, 
	'% margem' ds_item, 
	cus_obter_margem_conta(a.nr_interno_conta,'P') vl_resumo, 
	cus_obter_receita_conta(a.nr_interno_conta,'PM') pr_receita, 
	0 vl_paciente_dia 
from	cus_conta_pac_mc a, 
	conta_paciente_resumo b 
where	a.nr_interno_conta = b.nr_interno_conta 
and	coalesce(b.qt_exclusao_custo,0) = 0 
group by a.nr_interno_conta 

union all
 
select	30 nr_seq_apres, 
	a.nr_interno_conta, 
	'Gastos fixos procedimentos' ds_item, 
	(coalesce(sum(a.vl_custo),0) - coalesce(max(Obter_Valor_Repasse_Conta(a.nr_interno_conta,null,'R')),0)) vl_resumo, 
	cus_obter_receita_conta(a.nr_interno_conta,'CP') pr_receita, 
	dividir(coalesce(sum(a.vl_custo),0), max(obter_dias_conta_pac(a.nr_interno_conta))) vl_paciente_dia 
from	conta_paciente_resumo a 
where	coalesce(a.qt_exclusao_custo,0) = 0 
and	cd_material	is null 
group by a.nr_interno_conta 

union all
 
select	35 nr_seq_apres, 
	a.nr_interno_conta, 
	'Resultado líquido' ds_item, 
	((coalesce(sum(a.vl_procedimento),0) + coalesce(sum(a.vl_material),0)) - coalesce(sum(a.vl_custo),0)) vl_resumo, 
	cus_obter_receita_conta(a.nr_interno_conta,'RL') pr_receita, 
	0 vl_paciente_dia 
from	conta_paciente_resumo a 
where	coalesce(a.qt_exclusao_custo,0) = 0 
group by a.nr_interno_conta;

