-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW conta_paciente_resumo_v3 (nr_interno_conta, qt_resumo, vl_medico, vl_auxiliares, vl_custo_operacional, vl_anestesista, vl_materiais, vl_procedimento, vl_material, vl_custo, cd_setor_atendimento, cd_especialidade, cd_conta_contabil, cd_material, cd_unidade_medida, ie_origem_proced, cd_procedimento, vl_medico_fora_conta, cd_setor_receita, ie_diaria, vl_sadt_fora_conta, vl_repasse_terceiro, nr_seq_grupo_rec, cd_estrutura_conta, nr_seq_conta_financ, dt_referencia, vl_imposto, nr_cirugia, nr_prescricao, cd_cgc_fornec, vl_desconto, nr_seq_proc_pacote, vl_original, vl_custo_dir_apoio, vl_custo_mao_obra, vl_custo_direto, vl_custo_variavel, vl_custo_indireto, vl_despesa, vl_glosa, vl_repasse_calc, vl_custo_sadt, vl_desc_financ, vl_custo_hm, qt_exclusao_custo, nr_seq_exame, nr_seq_proc_interno, pr_imposto_custo, vl_custo_var_mc, cd_convenio, nr_atendimento, ds_material, nr_seq_grupo_exame, ds_grupo_exame, nm_exame, ds_setor_atendimento, ds_procedimento, ds_proc_interno, cd_area_procedimento, ds_area_procedimento, cd_grupo_proc, ds_grupo_proc, cd_especialidade_proc, ds_especialidade_proc) AS select	a.nr_interno_conta,
	a.qt_resumo, 
	a.vl_medico, 
	a.vl_auxiliares, 
	a.vl_custo_operacional, 
	a.vl_anestesista, 
	a.vl_materiais, 
	a.vl_procedimento, 
	a.vl_material, 
	a.vl_custo, 
	a.cd_setor_atendimento, 
	a.cd_especialidade, 
	a.cd_conta_contabil, 
	a.cd_material, 
	a.cd_unidade_medida, 
	a.ie_origem_proced, 
	a.cd_procedimento, 
	a.vl_medico_fora_conta, 
	a.cd_setor_receita, 
	a.ie_diaria, 
	a.vl_sadt_fora_conta, 
	a.vl_repasse_terceiro, 
	a.nr_seq_grupo_rec, 
	a.cd_estrutura_conta, 
	a.nr_seq_conta_financ, 
	a.dt_referencia, 
	a.vl_imposto, 
	a.nr_cirugia, 
	a.nr_prescricao, 
	a.cd_cgc_fornec, 
	a.vl_desconto, 
	a.nr_seq_proc_pacote, 
	a.vl_original, 
	a.vl_custo_dir_apoio, 
	a.vl_custo_mao_obra, 
	a.vl_custo_direto, 
	a.vl_custo_variavel, 
	a.vl_custo_indireto, 
	a.vl_despesa, 
	a.vl_glosa, 
	a.vl_repasse_calc, 
	a.vl_custo_sadt, 
	a.vl_desc_financ, 
	a.vl_custo_hm, 
	a.qt_exclusao_custo, 
	a.nr_seq_exame, 
	a.nr_seq_proc_interno, 
	a.pr_imposto_custo, 
	a.vl_custo_var_mc, 
	(substr(obter_conv_conta(a.nr_interno_conta),1,8))::numeric  cd_convenio, 
	obter_atendimento_conta(a.nr_interno_conta) nr_atendimento, 
	substr(obter_desc_material(a.cd_material),1,100) ds_material, 
	CASE WHEN coalesce(a.nr_seq_exame,0)=0 THEN 0  ELSE obter_grupo_exame_lab(a.nr_seq_exame) END  nr_seq_grupo_exame, 
	substr(CASE WHEN coalesce(a.nr_seq_exame,0)=0 THEN ''  ELSE obter_desc_grupo_exame_lab(obter_grupo_exame_lab(a.nr_seq_exame)) END ,1,50) ds_grupo_exame, 
	substr(obter_desc_exame_lab(a.nr_seq_exame,'',null,null),1,80) nm_exame, 
	substr(obter_nome_setor(a.cd_setor_atendimento),1,40) ds_setor_atendimento, 
	substr(obter_descricao_procedimento(a.cd_procedimento, a.ie_origem_proced),1,255) ds_procedimento, 
	substr(obter_desc_proc_interno(a.nr_seq_proc_interno),1,255) ds_proc_interno, 
	substr(obter_dados_estrut_proc(a.cd_procedimento, a.ie_origem_proced,'C','A'),1,240) cd_area_procedimento, 
	substr(obter_dados_estrut_proc(a.cd_procedimento, a.ie_origem_proced,'D','A'),1,240) ds_area_procedimento, 
	substr(obter_dados_estrut_proc(a.cd_procedimento, a.ie_origem_proced,'C','G'),1,240) cd_grupo_proc, 
	substr(obter_dados_estrut_proc(a.cd_procedimento, a.ie_origem_proced,'D','G'),1,240) ds_grupo_proc, 
	substr(obter_dados_estrut_proc(a.cd_procedimento, a.ie_origem_proced,'C','E'),1,240) cd_especialidade_proc, 
	substr(obter_dados_estrut_proc(a.cd_procedimento, a.ie_origem_proced,'D','E'),1,240) ds_especialidade_proc 
FROM	conta_paciente_resumo a;

