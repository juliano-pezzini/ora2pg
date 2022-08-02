-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerencia_alt_valores_html (cd_acao_analise_p pls_acao_analise.cd_acao%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_conta_p pls_conta_v.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc_v.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat_v.nr_sequencia%type, nr_seq_proc_partic_p pls_proc_participante_v.nr_sequencia%type, nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type, nr_seq_motivo_glosa_p tiss_motivo_glosa.nr_sequencia%type, ds_observacao_p pls_conta_glosa.ds_observacao%type, qt_liberada_p pls_conta_proc_v.qt_procedimento%type, vl_liberado_p pls_conta_proc_v.vl_liberado%type, vl_unitario_p pls_conta_proc_v.vl_unitario%type, vl_liberado_hi_p pls_conta_proc_v.vl_liberado_hi%type, vl_liberado_mat_p pls_conta_proc_v.vl_liberado_material%type, vl_liberado_co_p pls_conta_proc_v.vl_liberado_co%type, vl_lib_taxa_hi_p pls_conta_proc_v.vl_lib_taxa_servico%type, vl_lib_taxa_mat_p pls_conta_proc_v.vl_lib_taxa_material%type, vl_lib_taxa_co_p pls_conta_proc_v.vl_taxa_co%type, pr_taxa_servico_p bigint, pr_taxa_material_p bigint, pr_taxa_co_p bigint, pr_taxa_exc_material_p bigint, ie_apres_calc_p text, nr_seq_grupo_atual_p pls_auditoria_conta_grupo.nr_sequencia%type, ie_manter_glosas_p text, nr_id_transacao_p bigint, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

	CALL pls_cta_alt_valor_pck.pls_gerencia_alt_valor(
	cd_acao_analise_p,
	nr_seq_analise_p,
	nr_seq_conta_p,
	nr_seq_conta_proc_p,
	nr_seq_conta_mat_p,
	nr_seq_proc_partic_p,
	nr_seq_ocorrencia_p,
	nr_seq_motivo_glosa_p,
	ds_observacao_p,
	qt_liberada_p,
	vl_liberado_p,
	vl_unitario_p,
	vl_liberado_hi_p,
	vl_liberado_mat_p,
	vl_liberado_co_p,
	vl_lib_taxa_hi_p,
	vl_lib_taxa_mat_p,
	vl_lib_taxa_co_p,
	pr_taxa_servico_p,
	pr_taxa_material_p,
	pr_taxa_co_p,
	pr_taxa_exc_material_p,
	ie_apres_calc_p,
	nr_seq_grupo_atual_p,
	ie_manter_glosas_p,
	nr_id_transacao_p,
	cd_estabelecimento_p,
	nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_alt_valores_html (cd_acao_analise_p pls_acao_analise.cd_acao%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_conta_p pls_conta_v.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc_v.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat_v.nr_sequencia%type, nr_seq_proc_partic_p pls_proc_participante_v.nr_sequencia%type, nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type, nr_seq_motivo_glosa_p tiss_motivo_glosa.nr_sequencia%type, ds_observacao_p pls_conta_glosa.ds_observacao%type, qt_liberada_p pls_conta_proc_v.qt_procedimento%type, vl_liberado_p pls_conta_proc_v.vl_liberado%type, vl_unitario_p pls_conta_proc_v.vl_unitario%type, vl_liberado_hi_p pls_conta_proc_v.vl_liberado_hi%type, vl_liberado_mat_p pls_conta_proc_v.vl_liberado_material%type, vl_liberado_co_p pls_conta_proc_v.vl_liberado_co%type, vl_lib_taxa_hi_p pls_conta_proc_v.vl_lib_taxa_servico%type, vl_lib_taxa_mat_p pls_conta_proc_v.vl_lib_taxa_material%type, vl_lib_taxa_co_p pls_conta_proc_v.vl_taxa_co%type, pr_taxa_servico_p bigint, pr_taxa_material_p bigint, pr_taxa_co_p bigint, pr_taxa_exc_material_p bigint, ie_apres_calc_p text, nr_seq_grupo_atual_p pls_auditoria_conta_grupo.nr_sequencia%type, ie_manter_glosas_p text, nr_id_transacao_p bigint, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

