-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_conta_paciente_v2 (cd_estabelecimento, cd_medico, ie_status_protocolo, cd_procedimento, ie_origem_proced, cd_convenio, nr_interno_conta, dt_referencia, nr_mes, ds_mes, cd_especialidade, ie_clinica_alta, nr_atendimento, dt_entrada, dt_alta, ie_clinica, ie_tipo_atendimento, cd_pessoa_fisica, ie_cancelamento, ie_status_acerto, dt_periodo_inicial, dt_periodo_final, ds_clinica_alta, ds_especialidade, nr_crm, ds_clinica, nm_paciente, ds_convenio, cd_convenio_atend, ds_convenio_atend, nm_medico, ds_procedimento, vl_faturado, vl_glosa, pr_glosa, vl_faturado_dif, vl_imposto, vl_repasse_terceiro, vl_repasse_calc, vl_liquido, vl_matmed, vl_custo_mat, vl_custo_sadt, vl_desc_financ, vl_custo_dir_apoio, vl_mc01, vl_mc01_sem_rep, vl_custo_mao_obra, vl_mc02, vl_custo_direto, vl_mc03, vl_custo_indireto, vl_lucro_bruto, vl_despesa, vl_lucro, pr_lucro, nr_seq_protocolo, ds_tipo_atendimento, cd_tipo_convenio, ds_tipo_convenio, qt_conta, ds_setor_atendimento, ds_status_acerto, dt_receita, ds_conta_paciente, cd_setor_atendimento, vl_custo_excluido, ie_protocolo, cd_plano, ds_plano, vl_glosado, vl_amenor, vl_adicional, cd_setor_execucao, ds_setor_execucao, ie_proc_mat, nr_seq_grupo_rec, ds_grupo_receita, cd_estrutura_conta, cd_grupo, ds_grupo, cd_subgrupo, ds_subgrupo, cd_forma_organizacao, ds_forma_organizacao, cd_complexidade, ds_complexidade, ds_municipio_ibge, vl_custo, vl_resultado_sem_rep, cd_estab_atend, cd_proc_real_aih, ds_proc_real_aih, ie_periodo, vl_procedimento, vl_material) AS select	/*+ index (EISCOPA_I1 a) + index (CONPACI_ESTABEL_FK_I b) */
	b.cd_estabelecimento,
	a.cd_medico,
	a.ie_status_protocolo,
	a.cd_procedimento,
	a.ie_origem_proced,
	a.cd_convenio,
	a.nr_interno_conta,
	a.dt_referencia,
	(to_char(a.dt_referencia, 'mm'))::numeric  nr_mes,
	to_char(a.dt_referencia, 'yyyy/mm') ds_mes,
	a.cd_especialidade,
	a.ie_clinica_alta,
	b.nr_atendimento,
	a.dt_entrada,
	a.dt_alta,
	a.ie_clinica,
	a.ie_tipo_atendimento,
	a.cd_pessoa_fisica,
	b.ie_cancelamento,
	b.ie_status_acerto,
	b.dt_periodo_inicial,
	b.dt_periodo_final,
	(select substr(coalesce(x.ds_valor_dominio_cliente, obter_desc_expressao(x.cd_exp_valor_dominio, x.ds_valor_dominio)),1,255) FROM valor_dominio x where x.cd_dominio = 1166 and x.vl_dominio = a.ie_clinica_alta) ds_clinica_alta,
	(select substr(x.ds_especialidade,1,200) from especialidade_medica x where x.cd_especialidade = a.cd_especialidade) ds_especialidade,
	(select	substr(x.nr_crm,1,200) from medico x where x.cd_pessoa_fisica = a.cd_medico) nr_crm,
	(select substr(coalesce(x.ds_valor_dominio_cliente, obter_desc_expressao(x.cd_exp_valor_dominio, x.ds_valor_dominio)),1,255) from valor_dominio x where x.cd_dominio = 17 and x.vl_dominio = a.ie_clinica) ds_clinica,
	(select	substr(x.nm_pessoa_fisica,1,60) from pessoa_fisica x where x.cd_pessoa_fisica = a.cd_pessoa_fisica) nm_paciente,
	substr(c.ds_convenio,1,200) ds_convenio,
	a.cd_convenio_atend cd_convenio_atend,
	(select substr(x.ds_convenio,1,100) from convenio x where x.cd_convenio = a.cd_convenio_atend) ds_convenio_atend,
	(select	substr(x.nm_pessoa_fisica,1,60) from pessoa_fisica x where x.cd_pessoa_fisica = a.cd_medico) nm_medico,
	(select substr(x.ds_procedimento,1,255) from procedimento x where x.cd_procedimento = a.cd_procedimento and x.ie_origem_proced = a.ie_origem_proced) ds_procedimento,
	sum(a.vl_receita + a.vl_repasse_terceiro) vl_faturado,
	sum(a.vl_glosa) vl_glosa,
	dividir(sum(a.vl_glosa * 100), sum(a.vl_receita + a.vl_repasse_terceiro)) pr_glosa,
	sum(a.vl_receita + a.vl_repasse_terceiro - a.vl_glosa) vl_faturado_dif,
	sum(a.vl_imposto) vl_imposto,
	sum(a.vl_repasse_terceiro) vl_repasse_terceiro,
	sum(a.vl_repasse_calc) vl_repasse_calc,
	sum(a.vl_receita - coalesce(a.vl_glosa,0) - coalesce(a.vl_imposto,0)) vl_liquido,
	sum(a.vl_custo_variavel) vl_matmed,
	coalesce(sum(a.vl_custo_mat),0) vl_custo_mat,
	sum(a.vl_custo_sadt) vl_custo_sadt,
	sum(a.vl_desc_financ) vl_desc_financ,
	sum(a.vl_custo_dir_apoio) vl_custo_dir_apoio,
	sum(a.vl_receita  + a.vl_desc_financ - a.vl_glosa - a.vl_imposto -  a.vl_custo_variavel - a.vl_custo_sadt -a.vl_custo_dir_apoio) vl_mc01,
	sum(a.vl_receita  + a.vl_desc_financ - a.vl_glosa - a.vl_imposto -  a.vl_custo_variavel - a.vl_custo_sadt -a.vl_custo_dir_apoio - a.vl_repasse_calc) vl_mc01_sem_rep,
	sum(a.vl_custo_mao_obra) vl_custo_mao_obra,
	sum(a.vl_receita + a.vl_repasse_terceiro + a.vl_desc_financ - a.vl_glosa - a.vl_imposto - a.vl_repasse_terceiro -
	    a.vl_custo_variavel - a.vl_custo_sadt - a.vl_custo_dir_apoio - a.vl_custo_mao_obra) vl_mc02,
	sum(vl_custo_direto) vl_custo_direto,
	sum(a.vl_receita + a.vl_repasse_terceiro  + a.vl_desc_financ - a.vl_glosa - a.vl_imposto - a.vl_repasse_terceiro -
	    a.vl_custo_variavel - a.vl_custo_sadt - a.vl_custo_dir_apoio - a.vl_custo_mao_obra - a.vl_custo_direto) vl_mc03,
	sum(a.vl_custo_indireto) vl_custo_indireto,
	sum(a.vl_receita + a.vl_repasse_terceiro  + a.vl_desc_financ - a.vl_glosa - a.vl_imposto - a.vl_repasse_terceiro -
	    a.vl_custo_variavel - a.vl_custo_sadt - a.vl_custo_dir_apoio - a.vl_custo_mao_obra - a.vl_custo_direto -
	    a.vl_custo_indireto) vl_lucro_bruto,
	sum(a.vl_despesa) vl_despesa,
	sum(a.vl_receita + a.vl_desc_financ - a.vl_glosa - a.vl_imposto -
	    a.vl_custo_variavel - a.vl_custo_sadt - a.vl_custo_dir_apoio - a.vl_custo_mao_obra - a.vl_custo_direto -
	    a.vl_custo_indireto - a.vl_despesa) vl_lucro,
	dividir(sum(a.vl_receita  + a.vl_desc_financ - a.vl_glosa - a.vl_imposto - 
		    a.vl_custo_variavel - a.vl_custo_sadt - a.vl_custo_dir_apoio - 
		    a.vl_custo_mao_obra - a.vl_custo_direto - a.vl_custo_indireto - a.vl_despesa) * 100,
		    sum(a.vl_receita - coalesce(a.vl_glosa,0) - coalesce(a.vl_imposto,0))) pr_lucro,
	b.nr_seq_protocolo,
	(select substr(coalesce(x.ds_valor_dominio_cliente, obter_desc_expressao(x.cd_exp_valor_dominio, x.ds_valor_dominio)),1,255) from valor_dominio x where x.cd_dominio = 12 and x.vl_dominio = a.ie_tipo_atendimento) ds_tipo_atendimento,
	c.ie_tipo_convenio cd_tipo_convenio,
	(select substr(coalesce(x.ds_valor_dominio_cliente, obter_desc_expressao(x.cd_exp_valor_dominio, x.ds_valor_dominio)),1,255) from valor_dominio x where x.cd_dominio = 11 and x.vl_dominio = c.ie_tipo_convenio) ds_tipo_convenio,
	1 qt_conta,
	CASE WHEN a.ds_setor_atual IS NULL THEN (select	substr(max(y.ds_setor_atendimento),1,100) from setor_atendimento y, atend_paciente_unidade x where x.cd_setor_atendimento = y.cd_setor_atendimento and x.nr_atendimento = b.nr_atendimento and x.nr_seq_interno = obter_atepacu_paciente(b.nr_atendimento, 'A'))  ELSE a.ds_setor_atual END  ds_setor_atendimento,
	CASE WHEN ie_status_acerto=1 THEN obter_desc_expressao(684300)  ELSE obter_desc_expressao(684304) END  ds_status_acerto,
	to_date(null) dt_receita,
	a.nr_interno_conta || ' - ' || (select substr(x.nm_pessoa_fisica,1,60) from pessoa_fisica x where x.cd_pessoa_fisica = a.cd_pessoa_fisica) ds_conta_paciente,
	CASE WHEN a.cd_setor_atual IS NULL THEN (select	somente_numero(max(x.cd_setor_atendimento)) from atend_paciente_unidade x where x.nr_atendimento = b.nr_atendimento and x.nr_seq_interno = obter_atepacu_paciente(b.nr_atendimento, 'A'))  ELSE a.cd_setor_atual END  cd_setor_atendimento,
	sum(coalesce(a.vl_custo_excluido,0)) vl_custo_excluido,
	CASE WHEN a.ie_protocolo IS NULL THEN  obter_status_conta_protocolo(a.nr_interno_conta,b.ie_status_acerto,b.nr_seq_protocolo)  ELSE a.ie_protocolo END  ie_protocolo,
	to_char(a.cd_convenio) || to_char(a.cd_plano_convenio) cd_plano,
	substr(substr(c.ds_convenio,1,15) || '-' ||
		(select coalesce(max(x.ds_plano),obter_desc_expressao(729347)) from convenio_plano x where x.cd_convenio = a.cd_convenio and x.cd_plano = a.cd_plano_convenio),1,255) ds_plano,
	sum(a.vl_glosado) vl_glosado,
	sum(a.vl_amenor) vl_amenor,
	sum(a.vl_adicional) vl_adicional,
	a.cd_setor_atendimento cd_setor_execucao,
	(select substr(obter_desc_expressao(max(x.cd_exp_setor_atend),max(x.ds_setor_atendimento)),1,100) from setor_atendimento x where x.cd_setor_atendimento = a.cd_setor_atendimento) ds_setor_execucao,
	a.ie_proc_mat,
	a.nr_seq_grupo_rec,
	(select substr(x.ds_grupo_receita,1,200) from grupo_receita x where x.nr_sequencia = a.nr_seq_grupo_rec) ds_grupo_receita,
	somente_numero(a.cd_estrutura_conta) cd_estrutura_conta,
	a.cd_grupo,
	a.ds_grupo,
	a.cd_subgrupo,
	a.ds_subgrupo,
	a.cd_forma_organizacao,
	a.ds_forma_organizacao,
	a.ie_complexidade cd_complexidade,
	(select substr(coalesce(x.ds_valor_dominio_cliente, obter_desc_expressao(x.cd_exp_valor_dominio, x.ds_valor_dominio)),1,100) from valor_dominio x where x.cd_dominio = 1763 and x.vl_dominio = a.ie_complexidade) ds_complexidade,
	CASE WHEN a.ds_municipio_ibge IS NULL THEN (select substr(coalesce(max(obter_compl_pf(x.cd_pessoa_fisica,1,'DM')),obter_desc_expressao(327119)),1,200) from atendimento_paciente x where x.nr_atendimento = b.nr_atendimento)  ELSE a.ds_municipio_ibge END  ds_municipio_ibge,
	sum(a.vl_custo) vl_custo,
	(sum(coalesce(a.vl_receita + a.vl_repasse_terceiro,0) - coalesce(a.vl_custo,0) - coalesce(a.vl_repasse_calc,0))) vl_resultado_sem_rep,
	a.cd_estab_atend,
	CASE WHEN a.cd_proc_real_aih IS NULL THEN  sus_obter_proced_aih_eis(a.nr_interno_conta,2,'C')  ELSE a.cd_proc_real_aih END  cd_proc_real_aih,
	CASE WHEN a.ds_proc_real_aih IS NULL THEN  substr(coalesce(sus_obter_proced_aih_eis(a.nr_interno_conta,2,'D'),obter_desc_expressao(779934)),1,255)  ELSE a.ds_proc_real_aih END  ds_proc_real_aih,
	'M' ie_periodo,
	sum(vl_procedimento)  vl_procedimento,
	sum(vl_material) vl_material
from	conta_paciente b,
	eis_conta_paciente a,
	convenio c
where	a.nr_interno_conta	= b.nr_interno_conta
and	a.cd_convenio		= c.cd_convenio
group by b.cd_estabelecimento,
	a.cd_medico,
	a.cd_procedimento,
	a.ie_status_protocolo,
	a.ie_origem_proced,
	a.cd_convenio,
	a.nr_interno_conta,
	a.dt_referencia,
	a.cd_especialidade,
	a.ie_clinica_alta,
	b.nr_atendimento,
	a.dt_entrada,
	a.dt_alta,
	a.ie_clinica,
	a.ie_tipo_atendimento,
	b.ie_cancelamento,
	b.ie_status_acerto,
	(to_char(a.dt_referencia, 'mm'))::numeric ,
	to_char(a.dt_referencia, 'mm/yyyy'),
	b.dt_periodo_inicial,
	b.dt_periodo_final,
	a.cd_pessoa_fisica,
	substr(c.ds_convenio,1,200),
	a.cd_convenio_atend,
	b.nr_seq_protocolo,
	a.ie_tipo_atendimento,
	c.ie_tipo_convenio,
	CASE WHEN ie_status_acerto=1 THEN obter_desc_expressao(684300)  ELSE obter_desc_expressao(684304) END ,
	a.cd_plano_convenio,
	c.ds_convenio,
	a.cd_setor_atendimento,
	a.ie_proc_mat,
	a.nr_seq_grupo_rec,
	somente_numero(a.cd_estrutura_conta),
	a.cd_grupo,
	a.ds_grupo,
	a.cd_subgrupo,
	a.ds_subgrupo,
	a.cd_forma_organizacao,
	a.ds_forma_organizacao,
	a.ie_complexidade,
	a.cd_estab_atend,
	a.ie_protocolo,
	a.cd_proc_real_aih,
	a.ds_proc_real_aih,
	a.ds_municipio_ibge,
	a.cd_setor_atual, 
	a.ds_setor_atual

union

select	/*+ index (EISCOPA_I1 a) + index (CONPACI_ESTABEL_FK_I b) */
	b.cd_estabelecimento,
	a.cd_medico,
	a.ie_status_protocolo,
	a.cd_procedimento,
	a.ie_origem_proced,
	a.cd_convenio,
	a.nr_interno_conta,
	to_date(null) dt_referencia,
	(to_char(a.dt_referencia, 'mm'))::numeric  nr_mes,
	to_char(a.dt_referencia, 'mm/yyyy') ds_mes,
	a.cd_especialidade,
	a.ie_clinica_alta,
	b.nr_atendimento,
	a.dt_entrada,
	a.dt_alta,
	a.ie_clinica,
	a.ie_tipo_atendimento,
	a.cd_pessoa_fisica,
	b.ie_cancelamento,
	b.ie_status_acerto,
	b.dt_periodo_inicial,
	b.dt_periodo_final,
	(select substr(coalesce(x.ds_valor_dominio_cliente, obter_desc_expressao(x.cd_exp_valor_dominio, x.ds_valor_dominio)),1,255) from valor_dominio x where x.cd_dominio = 1166 and x.vl_dominio = a.ie_clinica_alta) ds_clinica_alta,
	(select substr(x.ds_especialidade,1,200) from especialidade_medica x where x.cd_especialidade = a.cd_especialidade) ds_especialidade,
	(select	substr(x.nr_crm,1,200) from medico x where x.cd_pessoa_fisica = a.cd_medico) nr_crm,
	(select substr(coalesce(x.ds_valor_dominio_cliente, obter_desc_expressao(x.cd_exp_valor_dominio, x.ds_valor_dominio)),1,255) from valor_dominio x where x.cd_dominio = 17 and x.vl_dominio = a.ie_clinica) ds_clinica,
	(select	substr(x.nm_pessoa_fisica,1,60) from pessoa_fisica x where x.cd_pessoa_fisica = a.cd_pessoa_fisica) nm_paciente,
	substr(c.ds_convenio,1,200) ds_convenio,
	a.cd_convenio_atend,
	(select substr(x.ds_convenio,1,100) from convenio x where x.cd_convenio = a.cd_convenio_atend) ds_convenio_atend,
	(select	substr(x.nm_pessoa_fisica,1,60) from pessoa_fisica x where x.cd_pessoa_fisica = a.cd_medico) nm_medico,
	(select substr(x.ds_procedimento,1,255) from procedimento x where x.cd_procedimento = a.cd_procedimento and x.ie_origem_proced = a.ie_origem_proced) ds_procedimento,
	sum(a.vl_receita + a.vl_repasse_terceiro) vl_faturado,
	sum(a.vl_glosa) vl_glosa,
	dividir(sum(a.vl_glosa * 100), sum(a.vl_receita + a.vl_repasse_terceiro)) pr_glosa,
	sum(a.vl_receita + a.vl_repasse_terceiro - a.vl_glosa) vl_faturado_dif,
	sum(a.vl_imposto) vl_imposto,
	sum(a.vl_repasse_terceiro) vl_repasse_terceiro,
	sum(a.vl_repasse_calc) vl_repasse_calc,
	sum(a.vl_receita - coalesce(a.vl_glosa,0) - coalesce(a.vl_imposto,0)) vl_liquido,
	sum(a.vl_custo_variavel) vl_matmed,
	coalesce(sum(a.vl_custo_mat),0) vl_custo_mat,
	sum(a.vl_custo_sadt) vl_custo_sadt,
	sum(a.vl_desc_financ) vl_desc_financ,
	sum(a.vl_custo_dir_apoio) vl_custo_dir_apoio,
	sum(a.vl_receita  + a.vl_desc_financ - a.vl_glosa - a.vl_imposto -  a.vl_custo_variavel - a.vl_custo_sadt -a.vl_custo_dir_apoio) vl_mc01,
	sum(a.vl_receita  + a.vl_desc_financ - a.vl_glosa - a.vl_imposto -  a.vl_custo_variavel - a.vl_custo_sadt -a.vl_custo_dir_apoio - a.vl_repasse_calc) vl_mc01_sem_rep,	
	sum(a.vl_custo_mao_obra) vl_custo_mao_obra,
	sum(a.vl_receita + a.vl_repasse_terceiro + a.vl_desc_financ - a.vl_glosa - a.vl_imposto - a.vl_repasse_terceiro -
	    a.vl_custo_variavel - a.vl_custo_sadt - a.vl_custo_dir_apoio - a.vl_custo_mao_obra) vl_mc02,
	sum(vl_custo_direto) vl_custo_direto,
	sum(a.vl_receita + a.vl_repasse_terceiro  + a.vl_desc_financ - a.vl_glosa - a.vl_imposto - a.vl_repasse_terceiro -
	    a.vl_custo_variavel - a.vl_custo_sadt - a.vl_custo_dir_apoio - a.vl_custo_mao_obra - a.vl_custo_direto) vl_mc03,
	sum(a.vl_custo_indireto) vl_custo_indireto,
	sum(a.vl_receita + a.vl_repasse_terceiro  + a.vl_desc_financ - a.vl_glosa - a.vl_imposto - a.vl_repasse_terceiro -
	    a.vl_custo_variavel - a.vl_custo_sadt - a.vl_custo_dir_apoio - a.vl_custo_mao_obra - a.vl_custo_direto -
	    a.vl_custo_indireto) vl_lucro_bruto,
	sum(a.vl_despesa) vl_despesa,
	sum(a.vl_receita + a.vl_desc_financ - a.vl_glosa - a.vl_imposto - 
	    a.vl_custo_variavel - a.vl_custo_sadt - a.vl_custo_dir_apoio - a.vl_custo_mao_obra - a.vl_custo_direto -
	    a.vl_custo_indireto - a.vl_despesa) vl_lucro,
	dividir(sum(a.vl_receita  + a.vl_desc_financ - a.vl_glosa - a.vl_imposto - 
		    a.vl_custo_variavel - a.vl_custo_sadt - a.vl_custo_dir_apoio - 
		    a.vl_custo_mao_obra - a.vl_custo_direto - a.vl_custo_indireto - a.vl_despesa) * 100,
		    sum(a.vl_receita - coalesce(a.vl_glosa,0) - coalesce(a.vl_imposto,0))) pr_lucro,
	b.nr_seq_protocolo,
	(select substr(coalesce(x.ds_valor_dominio_cliente, obter_desc_expressao(x.cd_exp_valor_dominio, x.ds_valor_dominio)),1,255) from valor_dominio x where x.cd_dominio = 12 and x.vl_dominio = a.ie_tipo_atendimento) ds_tipo_atendimento,
	c.ie_tipo_convenio cd_tipo_convenio,
	(select substr(coalesce(x.ds_valor_dominio_cliente, obter_desc_expressao(x.cd_exp_valor_dominio, x.ds_valor_dominio)),1,255) from valor_dominio x where x.cd_dominio = 11 and x.vl_dominio = c.ie_tipo_convenio) ds_tipo_convenio,
	1 qt_conta,
	CASE WHEN a.ds_setor_atual IS NULL THEN (select	substr(max(y.ds_setor_atendimento),1,100) from setor_atendimento y, atend_paciente_unidade x where x.cd_setor_atendimento = y.cd_setor_atendimento and x.nr_atendimento = b.nr_atendimento and x.nr_seq_interno = obter_atepacu_paciente(b.nr_atendimento, 'A'))  ELSE a.ds_setor_atual END  ds_setor_atendimento,
	CASE WHEN ie_status_acerto=1 THEN obter_desc_expressao(684300)  ELSE obter_desc_expressao(684304) END  ds_status_acerto,
	a.dt_receita,
	a.nr_interno_conta || ' - ' || (select substr(x.nm_pessoa_fisica,1,60) from pessoa_fisica x where x.cd_pessoa_fisica = a.cd_pessoa_fisica) ds_conta_paciente,
	CASE WHEN a.cd_setor_atual IS NULL THEN (select	somente_numero(max(x.cd_setor_atendimento)) from atend_paciente_unidade x where x.nr_atendimento = b.nr_atendimento and x.nr_seq_interno = obter_atepacu_paciente(b.nr_atendimento, 'A'))  ELSE a.cd_setor_atual END  cd_setor_atendimento,
	sum(coalesce(a.vl_custo_excluido,0)) vl_custo_excluido,
	CASE WHEN a.ie_protocolo IS NULL THEN  obter_status_conta_protocolo(a.nr_interno_conta,b.ie_status_acerto,b.nr_seq_protocolo)  ELSE a.ie_protocolo END  ie_protocolo,
	to_char(a.cd_convenio) || to_char(a.cd_plano_convenio),
	substr(substr(c.ds_convenio,1,15) || '-' ||
		(select coalesce(max(x.ds_plano),obter_desc_expressao(729347)) from convenio_plano x where x.cd_convenio = a.cd_convenio and x.cd_plano = a.cd_plano_convenio),1,255) ds_plano,
	sum(a.vl_glosado) vl_glosado,
	sum(a.vl_amenor) vl_amenor,
	sum(a.vl_adicional) vl_adicional,
	a.cd_setor_atendimento cd_setor_execucao,
	(select substr(obter_desc_expressao(max(x.cd_exp_setor_atend),max(x.ds_setor_atendimento)),1,100) from setor_atendimento x where x.cd_setor_atendimento = a.cd_setor_atendimento) ds_setor_execucao,
	a.ie_proc_mat,
	a.nr_seq_grupo_rec,
	(select substr(x.ds_grupo_receita,1,200) from grupo_receita x where x.nr_sequencia = a.nr_seq_grupo_rec) ds_grupo_receita,
	somente_numero(a.cd_estrutura_conta) cd_estrutura_conta,
	a.cd_grupo,
	a.ds_grupo,
	a.cd_subgrupo,
	a.ds_subgrupo,
	a.cd_forma_organizacao,
	a.ds_forma_organizacao,
	a.ie_complexidade cd_complexidade,
	(select substr(coalesce(x.ds_valor_dominio_cliente, obter_desc_expressao(x.cd_exp_valor_dominio, x.ds_valor_dominio)),1,255) from valor_dominio x where x.cd_dominio = 1763 and x.vl_dominio = a.ie_complexidade) ds_complexidade,
	CASE WHEN a.ds_municipio_ibge IS NULL THEN (select substr(coalesce(max(obter_compl_pf(x.cd_pessoa_fisica,1,'DM')),obter_desc_expressao(327119)),1,200) from atendimento_paciente x where x.nr_atendimento = b.nr_atendimento)  ELSE a.ds_municipio_ibge END  ds_municipio_ibge,
	sum(a.vl_custo) vl_custo,
	(sum(coalesce(a.vl_receita + a.vl_repasse_terceiro,0) - coalesce(a.vl_custo,0) - coalesce(a.vl_repasse_calc,0))) vl_resultado_sem_rep,
	a.cd_estab_atend,
	CASE WHEN a.cd_proc_real_aih IS NULL THEN  sus_obter_proced_aih_eis(a.nr_interno_conta,2,'C')  ELSE a.cd_proc_real_aih END  cd_proc_real_aih,
	CASE WHEN a.ds_proc_real_aih IS NULL THEN  substr(coalesce(sus_obter_proced_aih_eis(a.nr_interno_conta,2,'D'),obter_desc_expressao(779934)),1,255)  ELSE a.ds_proc_real_aih END  ds_proc_real_aih,	
	'M' ie_periodo,
	sum(vl_procedimento)  vl_procedimento,
	sum(vl_material) vl_material
from	conta_paciente b,
	eis_conta_paciente a,
	convenio c
where	a.nr_interno_conta	= b.nr_interno_conta
and	a.cd_convenio		= c.cd_convenio
group by b.cd_estabelecimento,
	a.cd_medico,
	a.cd_procedimento,
	a.ie_status_protocolo,
	a.ie_origem_proced,
	a.cd_convenio,
	a.nr_interno_conta,
	a.cd_especialidade,
	a.ie_clinica_alta,
	b.nr_atendimento,
	a.dt_entrada,
	a.dt_alta,
	a.ie_clinica,
	a.ie_tipo_atendimento,
	b.ie_cancelamento,
	b.ie_status_acerto,
	(to_char(a.dt_referencia, 'mm'))::numeric ,
	to_char(a.dt_referencia, 'mm/yyyy'),
	b.dt_periodo_inicial,
	b.dt_periodo_final,
	a.cd_pessoa_fisica,
	substr(c.ds_convenio,1,200),
	a.cd_convenio_atend,	
	b.nr_seq_protocolo,
	a.ie_tipo_atendimento,
	c.ie_tipo_convenio,
	CASE WHEN ie_status_acerto=1 THEN obter_desc_expressao(684300)  ELSE obter_desc_expressao(684304) END ,
	a.dt_receita,
	a.cd_plano_convenio,
	c.ds_convenio,
	a.cd_setor_atendimento,
	a.ie_proc_mat,
	a.nr_seq_grupo_rec,
	somente_numero(a.cd_estrutura_conta),
	a.cd_grupo,
	a.ds_grupo,
	a.cd_subgrupo,
	a.ds_subgrupo,
	a.cd_forma_organizacao,
	a.ds_forma_organizacao,
	a.ie_complexidade,
	a.cd_estab_atend,
	a.ie_protocolo,
	a.cd_proc_real_aih,
	a.ds_proc_real_aih,
	a.ds_municipio_ibge,
	a.cd_setor_atual, 
	a.ds_setor_atual;

