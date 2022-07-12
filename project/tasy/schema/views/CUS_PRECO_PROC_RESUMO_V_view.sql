-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cus_preco_proc_resumo_v (cd_setor_atendimento, cd_especialidade, cd_procedimento, ie_origem_proced, dt_referencia, qt_resumo, vl_procedimento, vl_custo, cd_convenio_parametro, vl_preco_calculado, vl_preco_tabela, vl_custo_variavel, vl_custo_dir_apoio, vl_custo_mao_obra, vl_custo_direto_fixo, vl_custo_indireto, vl_despesa, pr_margem_lucro, pr_dvv, pr_despesa_fixa, pr_custo_indireto_fixo, qt_parametro) AS select	c.cd_setor_atendimento,
	c.cd_especialidade, 
	c.cd_procedimento, 
	c.ie_origem_proced, 
	c.dt_referencia, 
	c.qt_resumo, 
	c.vl_procedimento, 
	c.vl_custo, 
	obter_conv_conta(c.nr_interno_conta) cd_convenio_parametro, 
	a.vl_preco_calculado, 
	a.vl_preco_tabela, 
	a.vl_custo_variavel, 
	a.vl_custo_dir_apoio, 
	a.vl_custo_mao_obra, 
	a.vl_custo_direto_fixo, 
	a.vl_custo_indireto, 
	a.vl_despesa, 
	a.pr_margem_lucro, 
	a.pr_dvv, 
	a.pr_despesa_fixa, 
	a.pr_custo_indireto_fixo, 
	a.qt_parametro 
FROM	preco_padrao_proc a, 
	conta_paciente_resumo c, 
	tabela_custo e 
where	a.cd_procedimento = c.cd_procedimento 
and	a.ie_origem_proced = c.ie_origem_proced 
and	a.cd_tabela_custo = e.cd_tabela_custo 
and	a.cd_estabelecimento = e.cd_estabelecimento 
and	trunc(c.dt_referencia,'mm') = trunc(e.dt_mes_referencia,'mm') 
and	e.cd_tipo_tabela_custo = 9;
