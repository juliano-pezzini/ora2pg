-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_inserir_ptu_nota_servico ( nr_seq_nota_cobr_p ptu_nota_servico.nr_seq_nota_cobr%type, nr_lote_p ptu_nota_servico.nr_lote%type, cd_prestador_p ptu_nota_servico.cd_prestador%type, nm_prestador_p ptu_nota_servico.nm_prestador%type, ie_tipo_participacao_p ptu_nota_servico.ie_tipo_participacao%type, dt_procedimento_p ptu_nota_servico.dt_procedimento%type, ie_tipo_tabela_p ptu_nota_servico.ie_tipo_tabela%type, nm_usuario_p ptu_nota_servico.nm_usuario%type, cd_procedimento_p ptu_nota_servico.cd_procedimento%type, ie_origem_proced_p ptu_nota_servico.ie_origem_proced%type, qt_procedimento_p ptu_nota_servico.qt_procedimento%type, ie_rede_propria_p ptu_nota_servico.ie_rede_propria%type, ie_tipo_pessoa_prestador_p ptu_nota_servico.ie_tipo_pessoa_prestador%type, vl_procedimento_p ptu_nota_servico.vl_procedimento%type, vl_custo_operacional_p ptu_nota_servico.vl_custo_operacional%type, vl_filme_p ptu_nota_servico.vl_filme%type, cd_porte_anestesico_p ptu_nota_servico.cd_porte_anestesico%type, cd_prestador_req_p ptu_nota_servico.cd_prestador_req%type, ie_via_acesso_p ptu_nota_servico.ie_via_acesso%type, vl_adic_procedimento_p ptu_nota_servico.vl_adic_procedimento%type, vl_adic_co_p ptu_nota_servico.vl_adic_co%type, vl_adic_filme_p ptu_nota_servico.vl_adic_filme%type, cd_especialidade_p ptu_nota_servico.cd_especialidade%type, nr_seq_nota_p ptu_nota_servico.nr_seq_nota%type, ds_hora_procedimento_p ptu_nota_servico.ds_hora_procedimento%type, cd_cnes_prest_p ptu_nota_servico.cd_cnes_prest%type, nm_profissional_prestador_p ptu_nota_servico.nm_profissional_prestador%type, sg_cons_prof_prest_p ptu_nota_servico.sg_cons_prof_prest%type, nr_cons_prof_prest_p ptu_nota_servico.nr_cons_prof_prest%type, sg_uf_cons_prest_p ptu_nota_servico.sg_uf_cons_prest%type, nr_cgc_cpf_req_p ptu_nota_servico.nr_cgc_cpf_req%type, nm_prestador_requisitante_p ptu_nota_servico.nm_prestador_requisitante%type, sg_cons_prof_req_p ptu_nota_servico.sg_cons_prof_req%type, nr_cons_prof_req_p ptu_nota_servico.nr_cons_prof_req%type, sg_uf_cons_req_p ptu_nota_servico.sg_uf_cons_req%type, ie_reembolso_p ptu_nota_servico.ie_reembolso%type, nr_autorizacao_p ptu_nota_servico.nr_autorizacao%type, nr_cgc_cpf_p ptu_nota_servico.nr_cgc_cpf%type, ie_pacote_p ptu_nota_servico.ie_pacote%type, cd_ato_p ptu_nota_servico.cd_ato%type, tx_procedimento_p ptu_nota_servico.tx_procedimento%type, ie_tipo_prestador_p ptu_nota_servico.ie_tipo_prestador%type, nr_seq_conta_proc_p ptu_nota_servico.nr_seq_conta_proc%type, nr_seq_conta_mat_p ptu_nota_servico.nr_seq_conta_mat%type, vl_pago_prest_p ptu_nota_servico.vl_pago_prest%type, nr_seq_registro_p ptu_nota_servico.nr_seq_registro%type, cd_unimed_autorizadora_p ptu_nota_servico.cd_unimed_autorizadora%type, cd_unimed_pre_req_p ptu_nota_servico.cd_unimed_pre_req%type, cd_unimed_prestador_p ptu_nota_servico.cd_unimed_prestador%type, nr_linha_p ptu_nota_servico.nr_linha%type, nr_seq_a500_p ptu_nota_servico.nr_seq_a500%type, cd_pacote_p ptu_nota_servico.cd_pacote%type, nr_guia_tiss_p ptu_nota_servico.nr_guia_tiss%type, tp_autoriz_p ptu_nota_servico.tp_autoriz%type, ds_servico_p ptu_nota_servico.ds_servico%type, nr_seq_proc_partic_p ptu_nota_servico.nr_seq_proc_partic%type, cd_servico_p ptu_nota_servico.cd_servico%type, nr_seq_material_p ptu_nota_servico.nr_seq_material%type, hr_servico_p ptu_nota_servico.hr_servico%type, ie_alto_custo_p ptu_nota_servico.ie_alto_custo%type, nr_seq_pacote_agrup_p ptu_nota_servico.nr_seq_pacote_agrup%type, hr_final_p ptu_nota_servico.hr_final%type, id_acres_urg_emer_p ptu_nota_servico.id_acres_urg_emer%type, nr_cbo_exec_p ptu_nota_servico.nr_cbo_exec%type, tec_utilizada_p ptu_nota_servico.tec_utilizada%type, dt_autoriz_p ptu_nota_servico.dt_autoriz%type, dt_solicitacao_p ptu_nota_servico.dt_solicitacao%type, unidade_medida_p ptu_nota_servico.unidade_medida%type, nr_reg_anvisa_p ptu_nota_servico.nr_reg_anvisa%type, cd_munic_p ptu_nota_servico.cd_munic%type, cd_ref_material_fab_p ptu_nota_servico.cd_ref_material_fab%type, dt_pgto_prestador_p ptu_nota_servico.dt_pgto_prestador%type, ie_consistente_p ptu_nota_servico.ie_consistente%type, nr_nota_p ptu_nota_servico.nr_nota%type, nr_nota_numerico_p ptu_nota_servico.nr_nota_numerico%type, nr_cnpj_fornecedor_p ptu_nota_servico.nr_cnpj_fornecedor%type, ie_tipo_data_regra_p ptu_nota_servico.ie_tipo_data_regra%type, nr_seq_pacote_p ptu_nota_servico.nr_seq_pacote%type, nr_seq_pacote_proc_p ptu_nota_servico.nr_seq_pacote_proc%type, nr_seq_pacote_mat_p ptu_nota_servico.nr_seq_pacote_mat%type, nr_seq_composicao_p ptu_nota_servico.nr_seq_composicao%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Inserir registro na PTU_NOTA_SERVICO
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN
insert into ptu_nota_servico(nr_sequencia,
	nr_seq_nota_cobr,
	nr_lote,
	cd_prestador,
	nm_prestador,
	ie_tipo_participacao,
	dt_procedimento,
	ie_tipo_tabela,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	cd_procedimento,
	ie_origem_proced,
	qt_procedimento,
	ie_rede_propria,
	ie_tipo_pessoa_prestador,
	vl_procedimento,
	vl_custo_operacional,
	vl_filme,
	cd_porte_anestesico,
	cd_prestador_req,
	ie_via_acesso,
	vl_adic_procedimento,
	vl_adic_co,
	vl_adic_filme,
	cd_especialidade,
	nr_seq_nota,
	ds_hora_procedimento,
	cd_cnes_prest,
	nm_profissional_prestador,
	sg_cons_prof_prest,
	nr_cons_prof_prest,
	sg_uf_cons_prest,
	nr_cgc_cpf_req,
	nm_prestador_requisitante,
	sg_cons_prof_req,
	nr_cons_prof_req,
	sg_uf_cons_req,
	ie_reembolso,
	nr_autorizacao,
	nr_cgc_cpf,
	ie_pacote,
	cd_ato,
	tx_procedimento,
	ie_tipo_prestador,
	nr_seq_conta_proc,
	nr_seq_conta_mat,
	vl_pago_prest,
	nr_seq_registro,
	cd_unimed_autorizadora,
	cd_unimed_pre_req,
	cd_unimed_prestador,
	nr_linha,
	nr_seq_a500,
	cd_pacote,
	nr_guia_tiss,
	tp_autoriz,
	ds_servico,
	nr_seq_proc_partic,
	cd_servico,
	nr_seq_material,
	hr_servico,
	ie_alto_custo,
	nr_seq_pacote_agrup,
	hr_final,
	id_acres_urg_emer,
	nr_cbo_exec,
	tec_utilizada,
	dt_autoriz,
	dt_solicitacao,
	unidade_medida,
	nr_reg_anvisa,
	cd_munic,
	cd_ref_material_fab,
	dt_pgto_prestador,
	ie_consistente,
	nr_nota,
	nr_nota_numerico,
	nr_cnpj_fornecedor,
	ie_tipo_data_regra,
	nr_seq_pacote,
	nr_seq_pacote_proc,
	nr_seq_pacote_mat,
	nr_seq_composicao)
values (	nextval('ptu_nota_servico_seq'),
	nr_seq_nota_cobr_p,
	nr_lote_p,
	cd_prestador_p,
	nm_prestador_p,
	ie_tipo_participacao_p,
	dt_procedimento_p,
	ie_tipo_tabela_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	cd_procedimento_p,
	ie_origem_proced_p,
	qt_procedimento_p,
	ie_rede_propria_p,
	ie_tipo_pessoa_prestador_p,
	vl_procedimento_p,
	vl_custo_operacional_p,
	vl_filme_p,
	cd_porte_anestesico_p,
	cd_prestador_req_p,
	ie_via_acesso_p,
	vl_adic_procedimento_p,
	vl_adic_co_p,
	vl_adic_filme_p,
	cd_especialidade_p,
	nr_seq_nota_p,
	ds_hora_procedimento_p,
	cd_cnes_prest_p,
	nm_profissional_prestador_p,
	sg_cons_prof_prest_p,
	nr_cons_prof_prest_p,
	sg_uf_cons_prest_p,
	nr_cgc_cpf_req_p,
	nm_prestador_requisitante_p,
	sg_cons_prof_req_p,
	nr_cons_prof_req_p,
	sg_uf_cons_req_p,
	ie_reembolso_p,
	nr_autorizacao_p,
	nr_cgc_cpf_p,
	ie_pacote_p,
	cd_ato_p,
	tx_procedimento_p,
	ie_tipo_prestador_p,
	nr_seq_conta_proc_p,
	nr_seq_conta_mat_p,
	vl_pago_prest_p,
	nr_seq_registro_p,
	cd_unimed_autorizadora_p,
	cd_unimed_pre_req_p,
	cd_unimed_prestador_p,
	nr_linha_p,
	nr_seq_a500_p,
	cd_pacote_p,
	nr_guia_tiss_p,
	tp_autoriz_p,
	ds_servico_p,
	nr_seq_proc_partic_p,
	cd_servico_p,
	nr_seq_material_p,
	hr_servico_p,
	ie_alto_custo_p,
	nr_seq_pacote_agrup_p,
	hr_final_p,
	id_acres_urg_emer_p,
	nr_cbo_exec_p,
	tec_utilizada_p,
	dt_autoriz_p,
	dt_solicitacao_p,
	unidade_medida_p,
	nr_reg_anvisa_p,
	cd_munic_p,
	cd_ref_material_fab_p,
	dt_pgto_prestador_p,
	ie_consistente_p,
	nr_nota_p,
	nr_nota_numerico_p,
	nr_cnpj_fornecedor_p,
	ie_tipo_data_regra_p,
	nr_seq_pacote_p,
	nr_seq_pacote_proc_p,
	nr_seq_pacote_mat_p,
	nr_seq_composicao_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_inserir_ptu_nota_servico ( nr_seq_nota_cobr_p ptu_nota_servico.nr_seq_nota_cobr%type, nr_lote_p ptu_nota_servico.nr_lote%type, cd_prestador_p ptu_nota_servico.cd_prestador%type, nm_prestador_p ptu_nota_servico.nm_prestador%type, ie_tipo_participacao_p ptu_nota_servico.ie_tipo_participacao%type, dt_procedimento_p ptu_nota_servico.dt_procedimento%type, ie_tipo_tabela_p ptu_nota_servico.ie_tipo_tabela%type, nm_usuario_p ptu_nota_servico.nm_usuario%type, cd_procedimento_p ptu_nota_servico.cd_procedimento%type, ie_origem_proced_p ptu_nota_servico.ie_origem_proced%type, qt_procedimento_p ptu_nota_servico.qt_procedimento%type, ie_rede_propria_p ptu_nota_servico.ie_rede_propria%type, ie_tipo_pessoa_prestador_p ptu_nota_servico.ie_tipo_pessoa_prestador%type, vl_procedimento_p ptu_nota_servico.vl_procedimento%type, vl_custo_operacional_p ptu_nota_servico.vl_custo_operacional%type, vl_filme_p ptu_nota_servico.vl_filme%type, cd_porte_anestesico_p ptu_nota_servico.cd_porte_anestesico%type, cd_prestador_req_p ptu_nota_servico.cd_prestador_req%type, ie_via_acesso_p ptu_nota_servico.ie_via_acesso%type, vl_adic_procedimento_p ptu_nota_servico.vl_adic_procedimento%type, vl_adic_co_p ptu_nota_servico.vl_adic_co%type, vl_adic_filme_p ptu_nota_servico.vl_adic_filme%type, cd_especialidade_p ptu_nota_servico.cd_especialidade%type, nr_seq_nota_p ptu_nota_servico.nr_seq_nota%type, ds_hora_procedimento_p ptu_nota_servico.ds_hora_procedimento%type, cd_cnes_prest_p ptu_nota_servico.cd_cnes_prest%type, nm_profissional_prestador_p ptu_nota_servico.nm_profissional_prestador%type, sg_cons_prof_prest_p ptu_nota_servico.sg_cons_prof_prest%type, nr_cons_prof_prest_p ptu_nota_servico.nr_cons_prof_prest%type, sg_uf_cons_prest_p ptu_nota_servico.sg_uf_cons_prest%type, nr_cgc_cpf_req_p ptu_nota_servico.nr_cgc_cpf_req%type, nm_prestador_requisitante_p ptu_nota_servico.nm_prestador_requisitante%type, sg_cons_prof_req_p ptu_nota_servico.sg_cons_prof_req%type, nr_cons_prof_req_p ptu_nota_servico.nr_cons_prof_req%type, sg_uf_cons_req_p ptu_nota_servico.sg_uf_cons_req%type, ie_reembolso_p ptu_nota_servico.ie_reembolso%type, nr_autorizacao_p ptu_nota_servico.nr_autorizacao%type, nr_cgc_cpf_p ptu_nota_servico.nr_cgc_cpf%type, ie_pacote_p ptu_nota_servico.ie_pacote%type, cd_ato_p ptu_nota_servico.cd_ato%type, tx_procedimento_p ptu_nota_servico.tx_procedimento%type, ie_tipo_prestador_p ptu_nota_servico.ie_tipo_prestador%type, nr_seq_conta_proc_p ptu_nota_servico.nr_seq_conta_proc%type, nr_seq_conta_mat_p ptu_nota_servico.nr_seq_conta_mat%type, vl_pago_prest_p ptu_nota_servico.vl_pago_prest%type, nr_seq_registro_p ptu_nota_servico.nr_seq_registro%type, cd_unimed_autorizadora_p ptu_nota_servico.cd_unimed_autorizadora%type, cd_unimed_pre_req_p ptu_nota_servico.cd_unimed_pre_req%type, cd_unimed_prestador_p ptu_nota_servico.cd_unimed_prestador%type, nr_linha_p ptu_nota_servico.nr_linha%type, nr_seq_a500_p ptu_nota_servico.nr_seq_a500%type, cd_pacote_p ptu_nota_servico.cd_pacote%type, nr_guia_tiss_p ptu_nota_servico.nr_guia_tiss%type, tp_autoriz_p ptu_nota_servico.tp_autoriz%type, ds_servico_p ptu_nota_servico.ds_servico%type, nr_seq_proc_partic_p ptu_nota_servico.nr_seq_proc_partic%type, cd_servico_p ptu_nota_servico.cd_servico%type, nr_seq_material_p ptu_nota_servico.nr_seq_material%type, hr_servico_p ptu_nota_servico.hr_servico%type, ie_alto_custo_p ptu_nota_servico.ie_alto_custo%type, nr_seq_pacote_agrup_p ptu_nota_servico.nr_seq_pacote_agrup%type, hr_final_p ptu_nota_servico.hr_final%type, id_acres_urg_emer_p ptu_nota_servico.id_acres_urg_emer%type, nr_cbo_exec_p ptu_nota_servico.nr_cbo_exec%type, tec_utilizada_p ptu_nota_servico.tec_utilizada%type, dt_autoriz_p ptu_nota_servico.dt_autoriz%type, dt_solicitacao_p ptu_nota_servico.dt_solicitacao%type, unidade_medida_p ptu_nota_servico.unidade_medida%type, nr_reg_anvisa_p ptu_nota_servico.nr_reg_anvisa%type, cd_munic_p ptu_nota_servico.cd_munic%type, cd_ref_material_fab_p ptu_nota_servico.cd_ref_material_fab%type, dt_pgto_prestador_p ptu_nota_servico.dt_pgto_prestador%type, ie_consistente_p ptu_nota_servico.ie_consistente%type, nr_nota_p ptu_nota_servico.nr_nota%type, nr_nota_numerico_p ptu_nota_servico.nr_nota_numerico%type, nr_cnpj_fornecedor_p ptu_nota_servico.nr_cnpj_fornecedor%type, ie_tipo_data_regra_p ptu_nota_servico.ie_tipo_data_regra%type, nr_seq_pacote_p ptu_nota_servico.nr_seq_pacote%type, nr_seq_pacote_proc_p ptu_nota_servico.nr_seq_pacote_proc%type, nr_seq_pacote_mat_p ptu_nota_servico.nr_seq_pacote_mat%type, nr_seq_composicao_p ptu_nota_servico.nr_seq_composicao%type) FROM PUBLIC;
