-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_gerar_resumo_conta_estorno ( nr_interno_conta_org_p conta_paciente.nr_interno_conta%type, nr_interno_conta_est_p conta_paciente.nr_interno_conta%type, nm_usuario_p text) AS $body$
DECLARE

						
qt_acao_w			smallint := -1;
vl_desconto_w			conta_paciente.vl_desconto%type;
vl_conta_w			conta_paciente.vl_conta%type;


BEGIN
delete from conta_paciente_resumo_imp imp
where imp.nr_interno_conta = nr_interno_conta_est_p;
delete /*+ index( a CONPARE_PK)*/ from conta_paciente_resumo a
where a.nr_interno_conta = nr_interno_conta_est_p;

insert into conta_paciente_resumo(	
	nr_sequencia,
	cd_cgc_fornec,
	cd_cgc_prestador,
	cd_conta_contabil,
	cd_especialidade,
	cd_estrutura_conta,
	cd_forma_organizacao,
	cd_grupo,
	cd_material,
	cd_procedimento,
	cd_setor_atendimento,
	cd_setor_paciente,
	cd_setor_receita,
	cd_subgrupo,
	cd_unidade_medida,
	cd_unid_medida_conv,
	ds_complexidade,
	ds_forma_organizacao,
	ds_grupo,
	ds_subgrupo,
	ds_tipo_financiamento,
	dt_referencia,
	ie_complexidade,
	ie_diaria,
	ie_origem_proced,
	ie_proc_mat,
	ie_responsavel_credito,
	ie_tipo_financiamento,
	nr_cirugia,
	nr_interno_conta,
	nr_prescricao,
	nr_seq_conta_financ,
	nr_seq_exame,
	nr_seq_grupo_rec,
	nr_seq_proc_interno,
	nr_seq_proc_pacote,
	nr_seq_produto,
	pr_imposto_custo,
	qt_estoque,
	qt_exclusao_conta,
	qt_exclusao_custo,
	qt_resumo,
	tx_conversao_qtde,
	vl_anestesista,
	vl_auxiliares,
	vl_custo,
	vl_custo_dir_apoio,
	vl_custo_direto,
	vl_custo_excluido,
	vl_custo_hm,
	vl_custo_indireto,
	vl_custo_mao_obra,
	vl_custo_operacional,
	vl_custo_sadt,
	vl_custo_unitario,
	vl_custo_variavel,
	vl_custo_var_mc,
	vl_desc_financ,
	vl_desconto,
	vl_despesa,
	vl_glosa,
	vl_imposto,
	vl_materiais,
	vl_material,
	vl_medico,
	vl_medico_fora_conta,
	vl_original,
	vl_procedimento,
	vl_repasse_calc,
	vl_repasse_terceiro,
	vl_sadt_fora_conta)
SELECT	nr_sequencia,
	cd_cgc_fornec,
	cd_cgc_prestador,
	cd_conta_contabil,
	cd_especialidade,
	cd_estrutura_conta,
	cd_forma_organizacao,
	cd_grupo,
	cd_material,
	cd_procedimento,
	cd_setor_atendimento,
	cd_setor_paciente,
	cd_setor_receita,
	cd_subgrupo,
	cd_unidade_medida,
	cd_unid_medida_conv,
	ds_complexidade,
	ds_forma_organizacao,
	ds_grupo,
	ds_subgrupo,
	ds_tipo_financiamento,
	dt_referencia,
	ie_complexidade,
	ie_diaria,
	ie_origem_proced,
	ie_proc_mat,
	ie_responsavel_credito,
	ie_tipo_financiamento,
	nr_cirugia,
	nr_interno_conta_est_p,
	nr_prescricao,
	nr_seq_conta_financ,
	nr_seq_exame,
	nr_seq_grupo_rec,
	nr_seq_proc_interno,
	nr_seq_proc_pacote,
	nr_seq_produto,
	pr_imposto_custo,
	qt_estoque,
	qt_exclusao_conta,
	qt_exclusao_custo,
	qt_resumo,
	tx_conversao_qtde,
	vl_anestesista * qt_acao_w,
	vl_auxiliares * qt_acao_w,
	vl_custo * qt_acao_w,
	vl_custo_dir_apoio * qt_acao_w,
	vl_custo_direto * qt_acao_w,
	vl_custo_excluido * qt_acao_w,
	vl_custo_hm * qt_acao_w,
	vl_custo_indireto * qt_acao_w,
	vl_custo_mao_obra * qt_acao_w,
	vl_custo_operacional * qt_acao_w,
	vl_custo_sadt * qt_acao_w,
	vl_custo_unitario * qt_acao_w,
	vl_custo_variavel * qt_acao_w,
	vl_custo_var_mc * qt_acao_w,
	vl_desc_financ * qt_acao_w,
	vl_desconto * qt_acao_w,
	vl_despesa * qt_acao_w,
	vl_glosa * qt_acao_w,
	vl_imposto * qt_acao_w,
	vl_materiais * qt_acao_w,
	vl_material * qt_acao_w,
	vl_medico * qt_acao_w,
	vl_medico_fora_conta * qt_acao_w,
	vl_original * qt_acao_w,
	vl_procedimento * qt_acao_w,
	vl_repasse_calc * qt_acao_w,
	vl_repasse_terceiro * qt_acao_w,
	vl_sadt_fora_conta * qt_acao_w
from	conta_paciente_resumo
where	nr_interno_conta = nr_interno_conta_org_p;

select	sum(coalesce(vl_desconto,0)),
	coalesce(sum(vl_procedimento + vl_material),0)
into STRICT	vl_desconto_w,
	vl_conta_w
from	conta_paciente_resumo
where	nr_interno_conta = nr_interno_conta_org_p;

update	conta_paciente
set	vl_conta	  = vl_conta_w * qt_acao_w,
	vl_desconto	  = vl_desconto_w * qt_acao_w,
	dt_geracao_resumo = clock_timestamp()
where	nr_interno_conta  = nr_interno_conta_est_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_gerar_resumo_conta_estorno ( nr_interno_conta_org_p conta_paciente.nr_interno_conta%type, nr_interno_conta_est_p conta_paciente.nr_interno_conta%type, nm_usuario_p text) FROM PUBLIC;

