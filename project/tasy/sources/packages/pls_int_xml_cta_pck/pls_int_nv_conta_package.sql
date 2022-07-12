-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_int_xml_cta_pck.pls_int_nv_conta ( nr_seq_lote_protocolo_p pls_lote_protocolo_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


tb_nr_seq_conta_w		pls_util_cta_pck.t_number_table;
tb_cd_estabelecimento_w		pls_util_cta_pck.t_number_table;
tb_dt_atualizacao_w		pls_util_cta_pck.t_date_table;
tb_nm_usuario_w			pls_util_cta_pck.t_varchar2_table_15;
tb_dt_atualizacao_nrec_w	pls_util_cta_pck.t_date_table;
tb_nm_usuario_nrec_w		pls_util_cta_pck.t_varchar2_table_15;
tb_nr_seq_protocolo_imp_w	pls_util_cta_pck.t_number_table;
tb_cd_guia_operadora_w		pls_util_cta_pck.t_varchar2_table_20;
tb_cd_guia_prestador_w		pls_util_cta_pck.t_varchar2_table_20;
tb_cd_guia_principal_w		pls_util_cta_pck.t_varchar2_table_20;
tb_cd_senha_w			pls_util_cta_pck.t_varchar2_table_20;
tb_dt_validade_senha_w		pls_util_cta_pck.t_date_table;
tb_dt_autorizacao_w		pls_util_cta_pck.t_date_table;
tb_cd_ans_w			pls_util_cta_pck.t_varchar2_table_10;
tb_cd_usuario_plano_w		pls_util_cta_pck.t_varchar2_table_20;
tb_nm_beneficiario_w		pls_util_cta_pck.t_varchar2_table_255;
tb_ie_recem_nascido_w		pls_util_cta_pck.t_varchar2_table_1;
tb_cd_cns_w			pls_util_cta_pck.t_varchar2_table_15;
tb_cd_prestador_exec_w		pls_util_cta_pck.t_varchar2_table_15;
tb_cd_cgc_prest_exec_w		pls_util_cta_pck.t_varchar2_table_15;
tb_cd_cpf_prest_exec_w		pls_util_cta_pck.t_varchar2_table_15;
tb_nr_conselho_prest_exec_w	pls_util_cta_pck.t_varchar2_table_15;
tb_cd_uf_conselho_prest_exec_w	pls_util_cta_pck.t_varchar2_table_2;
tb_nm_prestador_exec_w		pls_util_cta_pck.t_varchar2_table_255;
tb_nr_conselho_prof_exec_w	pls_util_cta_pck.t_varchar2_table_15;
tb_cd_conselho_prof_exec_w	pls_util_cta_pck.t_varchar2_table_2;
tb_cd_uf_conselho_prof_exec_w	pls_util_cta_pck.t_varchar2_table_2;
tb_cd_cbo_saude_prof_exec_w	pls_util_cta_pck.t_varchar2_table_10;
tb_nm_profissional_exec_w	pls_util_cta_pck.t_varchar2_table_255;
tb_cd_prestador_solic_w		pls_util_cta_pck.t_varchar2_table_15;
tb_cd_cgc_prest_solic_w		pls_util_cta_pck.t_varchar2_table_15;
tb_cd_cpf_prest_solic_w		pls_util_cta_pck.t_varchar2_table_15;
tb_cd_cnes_prest_solic_w	pls_util_cta_pck.t_varchar2_table_10;
tb_nm_prestador_solic_w		pls_util_cta_pck.t_varchar2_table_255;
tb_nr_conselho_prof_solic_w	pls_util_cta_pck.t_varchar2_table_15;
tb_cd_conselho_prof_solic_w	pls_util_cta_pck.t_varchar2_table_2;
tb_cd_uf_conselho_prof_solic_w	pls_util_cta_pck.t_varchar2_table_2;
tb_cd_cbo_saude_prof_solic_w	pls_util_cta_pck.t_varchar2_table_10;
tb_nm_profissional_solic_w	pls_util_cta_pck.t_varchar2_table_255;
tb_ie_indicacao_acidente_w	pls_util_cta_pck.t_varchar2_table_1;
tb_ie_tipo_consulta_w		pls_util_cta_pck.t_varchar2_table_1;
tb_dt_atendimento_w		pls_util_cta_pck.t_date_table;
tb_dt_solicitacao_w		pls_util_cta_pck.t_date_table;
tb_ie_carater_atendimento_w	pls_util_cta_pck.t_varchar2_table_1;
tb_ds_indicacao_clinica_w	pls_util_cta_pck.t_varchar2_table_4000;
tb_ie_tipo_atendimento_w	pls_util_cta_pck.t_varchar2_table_2;
tb_ie_motivo_encerramento_w	pls_util_cta_pck.t_varchar2_table_2;
tb_vl_procedimentos_w		pls_util_cta_pck.t_number_table;
tb_vl_diarias_w			pls_util_cta_pck.t_number_table;
tb_vl_taxas_alugueis_w		pls_util_cta_pck.t_number_table;
tb_vl_materiais_w		pls_util_cta_pck.t_number_table;
tb_vl_medicamentos_w		pls_util_cta_pck.t_number_table;
tb_vl_gases_medicinais_w	pls_util_cta_pck.t_number_table;
tb_vl_opme_w			pls_util_cta_pck.t_number_table;
tb_vl_total_geral_w		pls_util_cta_pck.t_number_table;
tb_vl_total_coparticipacao_w	pls_util_cta_pck.t_number_table;
tb_ie_tipo_faturamento_w	pls_util_cta_pck.t_varchar2_table_1;
tb_dt_inicio_faturamento_w	pls_util_cta_pck.t_date_table;
tb_dt_fim_faturamento_w		pls_util_cta_pck.t_date_table;
tb_ie_tipo_internacao_w		pls_util_cta_pck.t_varchar2_table_1;
tb_ie_regime_internacao_w	pls_util_cta_pck.t_varchar2_table_1;
tb_dt_emissao_guia_w		pls_util_cta_pck.t_date_table;
tb_ds_plano_w			pls_util_cta_pck.t_varchar2_table_255;
tb_ds_empresa_benef_w		pls_util_cta_pck.t_varchar2_table_255;
tb_nr_telefone_benef_w		pls_util_cta_pck.t_varchar2_table_15;
tb_nm_titular_benef_w		pls_util_cta_pck.t_varchar2_table_255;
tb_dt_fim_tratamento_w		pls_util_cta_pck.t_date_table;
tb_ie_tipo_atend_odonto_w	pls_util_cta_pck.t_varchar2_table_2;
tb_qt_total_unidade_serv_w	pls_util_cta_pck.t_number_table;
tb_ds_observacao_w		pls_util_cta_pck.t_varchar2_table_4000;
tb_cd_cnes_prest_exec_w		pls_util_cta_pck.t_varchar2_table_10;
tb_cd_usuario_plano_conv_w	pls_util_cta_pck.t_varchar2_table_20;
tb_nr_seq_segurado_conv_w	pls_util_cta_pck.t_number_table;
tb_cd_guia_operadora_conv_w	pls_util_cta_pck.t_varchar2_table_20;
tb_cd_cooperativa_cart_conv_w	pls_util_cta_pck.t_varchar2_table_10;
tb_nr_congenere_cart_conv_w	pls_util_cta_pck.t_number_table;
tb_cd_coop_cart_number_conv_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_prest_exec_conv_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_prest_solic_conv_w	pls_util_cta_pck.t_number_table;
tb_cd_prest_exec_conv_w		pls_util_cta_pck.t_varchar2_table_15;
tb_cd_prest_exec_upper_conv_w	pls_util_cta_pck.t_varchar2_table_15;
tb_cd_prest_exec_number_conv_w	pls_util_cta_pck.t_number_table;
tb_cd_cgc_prest_exec_conv_w	pls_util_cta_pck.t_varchar2_table_15;
tb_cd_cpf_prest_exec_conv_w	pls_util_cta_pck.t_varchar2_table_15;
tb_cd_prest_solic_conv_w	pls_util_cta_pck.t_varchar2_table_15;
tb_cd_prest_solic_upper_conv_w	pls_util_cta_pck.t_varchar2_table_15;
tb_cd_prest_solic_num_conv_w	pls_util_cta_pck.t_number_table;
tb_cd_cgc_prest_solic_conv_w	pls_util_cta_pck.t_varchar2_table_15;
tb_cd_cpf_prest_solic_conv_w	pls_util_cta_pck.t_varchar2_table_15;
tb_nr_seq_cbo_prof_exec_conv_w	pls_util_cta_pck.t_number_table;
tb_nr_cbo_prof_solic_conv_w	pls_util_cta_pck.t_number_table;
tb_ie_carater_atend_conv_w	pls_util_cta_pck.t_varchar2_table_1;	
tb_cd_uf_cons_prof_exec_conv_w	pls_util_cta_pck.t_varchar2_table_2;
tb_nr_regra_prof_exec_conv_w	pls_util_cta_pck.t_number_table;
tb_nr_cons_prof_exec_conv_w	pls_util_cta_pck.t_varchar2_table_15;
tb_seq_cons_prof_exec_conv_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_tipo_atend_conv_w	pls_util_cta_pck.t_number_table;
tb_ie_saude_ocupacional_w	pls_util_cta_pck.t_varchar2_table_10;
tb_ie_regime_atendimento_w	pls_util_cta_pck.t_varchar2_table_10;
tb_cd_profissional_exec_conv_w	pls_util_cta_pck.t_varchar2_table_10;
tb_cd_uf_cons_prof_sol_conv_w	pls_util_cta_pck.t_varchar2_table_2;
tb_nr_regra_prof_solic_conv_w	pls_util_cta_pck.t_number_table;
tb_nr_cons_prof_solic_conv_w	pls_util_cta_pck.t_varchar2_table_15;
tb_seq_cons_prof_solic_conv_w	pls_util_cta_pck.t_number_table;
tb_cd_prof_solic_conv_w		pls_util_cta_pck.t_varchar2_table_10;
tb_nr_seq_motivo_encer_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_congenere_conv_w	pls_util_cta_pck.t_number_table;
tb_cd_guia_principal_conv_w	pls_util_cta_pck.t_varchar2_table_20;
tb_nr_seq_guia_conv_w		pls_util_cta_pck.t_number_table;
tb_dt_atendimento_conv_w	pls_util_cta_pck.t_date_table;
tb_ie_tipo_atend_odonto_conv_w	pls_util_cta_pck.t_varchar2_table_20;
tb_ie_tipo_guia_w		pls_util_cta_pck.t_varchar2_table_2;
tb_nr_seq_protoclo_w		pls_util_cta_pck.t_number_table;
tb_ie_tipo_internacao_conv_w	pls_util_cta_pck.t_number_table;
tb_cd_guia_ok_conv_w		pls_util_cta_pck.t_varchar2_table_20;
tb_ie_tipo_internado_conv_w	pls_util_cta_pck.t_varchar2_table_1;
tb_ie_vinc_internacao_conv_w	pls_util_cta_pck.t_varchar2_table_1;

C01 CURSOR(nr_seq_lote_protocolo_pc	pls_protocolo_conta_imp.nr_seq_lote_protocolo%type) FOR
	SELECT	a.nr_sequencia nr_seq_conta,
		a.cd_estabelecimento,
		a.dt_atualizacao,
		a.nm_usuario,
		a.dt_atualizacao_nrec,
		a.nm_usuario_nrec,
		a.nr_seq_protocolo nr_seq_protocolo_imp,
		a.cd_guia_operadora,
		a.cd_guia_prestador,
		a.cd_guia_principal,
		a.cd_senha,
		a.dt_validade_senha,
		a.dt_autorizacao,
		a.cd_ans,
		a.cd_usuario_plano,
		a.nm_beneficiario,
		a.ie_recem_nascido,
		a.cd_cns,
		a.cd_prestador_exec,
		a.cd_cgc_prest_exec,
		a.cd_cpf_prest_exec,
		a.nr_conselho_prest_exec,
		a.cd_uf_conselho_prest_exec,
		a.nm_prestador_exec,
		a.nr_conselho_prof_exec,
		a.cd_conselho_prof_exec,
		a.cd_uf_conselho_prof_exec,
		a.cd_cbo_saude_prof_exec,
		a.nm_profissional_exec,
		a.cd_prestador_solic,
		a.cd_cgc_prest_solic,
		a.cd_cpf_prest_solic,
		a.cd_cnes_prest_solic,
		a.nm_prestador_solic,
		a.nr_conselho_prof_solic,
		a.cd_conselho_prof_solic,
		a.cd_uf_conselho_prof_solic,
		a.cd_cbo_saude_prof_solic,
		a.nm_profissional_solic,
		a.ie_indicacao_acidente,
		a.ie_tipo_consulta,
		a.dt_atendimento,
		a.dt_solicitacao,
		a.ie_carater_atendimento,
		a.ds_indicacao_clinica,
		a.ie_tipo_atendimento,
		a.ie_motivo_encerramento,
		a.vl_procedimentos,
		a.vl_diarias,
		a.vl_taxas_alugueis,
		a.vl_materiais,
		a.vl_medicamentos,
		a.vl_gases_medicinais,
		a.vl_opme,
		a.vl_total_geral,
		a.vl_total_coparticipacao,
		a.ie_tipo_faturamento,
		a.dt_inicio_faturamento,
		a.dt_fim_faturamento,
		a.ie_tipo_internacao,
		a.ie_regime_internacao,
		a.dt_emissao_guia,
		a.ds_plano,
		a.ds_empresa_benef,
		a.nr_telefone_benef,
		a.nm_titular_benef,
		a.dt_fim_tratamento,
		a.ie_tipo_atend_odonto,
		a.qt_total_unidade_serv,
		a.ds_observacao,
		a.cd_cnes_prest_exec,
		a.cd_usuario_plano_conv,
		a.nr_seq_segurado_conv,
		a.cd_guia_operadora_conv,
		a.cd_cooperativa_cart_conv,
		a.nr_seq_congenere_cart_conv,
		a.cd_coop_cart_number_conv,
		a.nr_seq_prest_exec_conv,
		a.nr_seq_prest_solic_conv,
		a.cd_prest_exec_conv,
		a.cd_prest_exec_upper_conv,
		a.cd_prest_exec_number_conv,
		a.cd_cgc_prest_exec_conv,
		a.cd_cpf_prest_exec_conv,
		a.cd_prest_solic_conv,
		a.cd_prest_solic_upper_conv,
		a.cd_prest_solic_number_conv,
		a.cd_cgc_prest_solic_conv,
		a.cd_cpf_prest_solic_conv,
		a.nr_seq_cbo_prof_exec_conv,
		a.nr_seq_cbo_prof_solic_conv,
		a.ie_carater_atendimento_conv,
		a.cd_uf_cons_prof_exec_conv,
		a.nr_seq_regra_prof_exec_conv,
		a.nr_cons_prof_exec_conv,
		a.nr_seq_cons_prof_exec_conv,
		a.nr_seq_tipo_atend_conv,
		a.cd_profissional_exec_conv,
		a.cd_uf_cons_prof_solic_conv,
		a.nr_seq_regra_prof_solic_conv,
		a.nr_cons_prof_solic_conv,
		a.nr_seq_cons_prof_solic_conv,
		a.cd_profissional_solic_conv,
		a.nr_seq_motivo_encerramento,
		a.nr_seq_congenere_conv,
		a.cd_guia_principal_conv,
		a.nr_seq_guia_conv,
		a.dt_atendimento_conv,
		a.ie_tipo_atend_odonto_conv,
		b.ie_tipo_guia,
		(SELECT	max(x.nr_sequencia)
		from	pls_protocolo_conta x
		where	x.nr_seq_imp	= b.nr_sequencia) nr_seq_protoclo,
		a.ie_tipo_internacao_conv,
		a.cd_guia_ok_conv,
		a.ie_tipo_internado_conv,
		a.ie_vinc_internacao_conv,
		a.ie_regime_atendimento,
		a.ie_saude_ocupacional
	from	pls_protocolo_conta_imp b,
		pls_conta_imp a
	where	b.nr_seq_lote_protocolo	= nr_seq_lote_protocolo_pc
	and	a.nr_seq_protocolo	= b.nr_sequencia;


BEGIN

open C01(nr_seq_lote_protocolo_p);
loop
	--Carrega as vari_veis conforme informa__es obtidas atrav_s do Cursor

	fetch C01 bulk collect into	tb_nr_seq_conta_w, tb_cd_estabelecimento_w,
					tb_dt_atualizacao_w, tb_nm_usuario_w,
					tb_dt_atualizacao_nrec_w, tb_nm_usuario_nrec_w,
					tb_nr_seq_protocolo_imp_w, tb_cd_guia_operadora_w,
					tb_cd_guia_prestador_w, tb_cd_guia_principal_w,
					tb_cd_senha_w, tb_dt_validade_senha_w,
					tb_dt_autorizacao_w, tb_cd_ans_w,
					tb_cd_usuario_plano_w, tb_nm_beneficiario_w,
					tb_ie_recem_nascido_w, tb_cd_cns_w,
					tb_cd_prestador_exec_w, tb_cd_cgc_prest_exec_w,
					tb_cd_cpf_prest_exec_w, tb_nr_conselho_prest_exec_w,
					tb_cd_uf_conselho_prest_exec_w, tb_nm_prestador_exec_w,
					tb_nr_conselho_prof_exec_w, tb_cd_conselho_prof_exec_w,
					tb_cd_uf_conselho_prof_exec_w, tb_cd_cbo_saude_prof_exec_w,
					tb_nm_profissional_exec_w, tb_cd_prestador_solic_w,
					tb_cd_cgc_prest_solic_w, tb_cd_cpf_prest_solic_w,
					tb_cd_cnes_prest_solic_w, tb_nm_prestador_solic_w,
					tb_nr_conselho_prof_solic_w, tb_cd_conselho_prof_solic_w,
					tb_cd_uf_conselho_prof_solic_w, tb_cd_cbo_saude_prof_solic_w,
					tb_nm_profissional_solic_w, tb_ie_indicacao_acidente_w,
					tb_ie_tipo_consulta_w, tb_dt_atendimento_w,
					tb_dt_solicitacao_w, tb_ie_carater_atendimento_w,
					tb_ds_indicacao_clinica_w, tb_ie_tipo_atendimento_w,
					tb_ie_motivo_encerramento_w, tb_vl_procedimentos_w,
					tb_vl_diarias_w, tb_vl_taxas_alugueis_w,
					tb_vl_materiais_w, tb_vl_medicamentos_w,
					tb_vl_gases_medicinais_w, tb_vl_opme_w,
					tb_vl_total_geral_w, tb_vl_total_coparticipacao_w,
					tb_ie_tipo_faturamento_w, tb_dt_inicio_faturamento_w,
					tb_dt_fim_faturamento_w, tb_ie_tipo_internacao_w,
					tb_ie_regime_internacao_w, tb_dt_emissao_guia_w,
					tb_ds_plano_w, tb_ds_empresa_benef_w,
					tb_nr_telefone_benef_w, tb_nm_titular_benef_w,
					tb_dt_fim_tratamento_w, tb_ie_tipo_atend_odonto_w,
					tb_qt_total_unidade_serv_w, tb_ds_observacao_w,
					tb_cd_cnes_prest_exec_w, tb_cd_usuario_plano_conv_w,
					tb_nr_seq_segurado_conv_w, tb_cd_guia_operadora_conv_w,
					tb_cd_cooperativa_cart_conv_w, tb_nr_congenere_cart_conv_w,
					tb_cd_coop_cart_number_conv_w, tb_nr_seq_prest_exec_conv_w,
					tb_nr_seq_prest_solic_conv_w, tb_cd_prest_exec_conv_w,
					tb_cd_prest_exec_upper_conv_w, tb_cd_prest_exec_number_conv_w,
					tb_cd_cgc_prest_exec_conv_w, tb_cd_cpf_prest_exec_conv_w,
					tb_cd_prest_solic_conv_w, tb_cd_prest_solic_upper_conv_w,
					tb_cd_prest_solic_num_conv_w, tb_cd_cgc_prest_solic_conv_w,
					tb_cd_cpf_prest_solic_conv_w, tb_nr_seq_cbo_prof_exec_conv_w,
					tb_nr_cbo_prof_solic_conv_w, tb_ie_carater_atend_conv_w,
					tb_cd_uf_cons_prof_exec_conv_w, tb_nr_regra_prof_exec_conv_w,
					tb_nr_cons_prof_exec_conv_w, tb_seq_cons_prof_exec_conv_w,
					tb_nr_seq_tipo_atend_conv_w, tb_cd_profissional_exec_conv_w,
					tb_cd_uf_cons_prof_sol_conv_w, tb_nr_regra_prof_solic_conv_w,
					tb_nr_cons_prof_solic_conv_w, tb_seq_cons_prof_solic_conv_w,
					tb_cd_prof_solic_conv_w, tb_nr_seq_motivo_encer_w,
					tb_nr_seq_congenere_conv_w, tb_cd_guia_principal_conv_w,
					tb_nr_seq_guia_conv_w, tb_dt_atendimento_conv_w,
					tb_ie_tipo_atend_odonto_conv_w, tb_ie_tipo_guia_w,
					tb_nr_seq_protoclo_w, tb_ie_tipo_internacao_conv_w,
					tb_cd_guia_ok_conv_w, tb_ie_tipo_internado_conv_w,
					tb_ie_vinc_internacao_conv_w, tb_ie_regime_atendimento_w,
					tb_ie_saude_ocupacional_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_seq_conta_w.count = 0;
	
	-- Realiza o insert na tabela PLS_CONTA. Este _ o processo de integra__o da conta.

	-- Os registros da tabela PLS_CONTA_IMP s_o inclu_dos na PLS_CONTA em seus respectivos campos.

	-- Os campos _IMP tamb_m devem ser populados

	forall i in tb_nr_seq_conta_w.first..tb_nr_seq_conta_w.last
		insert	into pls_conta(cd_ans, cd_ans_imp,
			cd_cbo_saude_exec_imp, cd_cbo_saude_solic_imp,
			cd_cgc_executor_imp, cd_cgc_prestador_imp,
			cd_cnes,cd_cnes_executor_imp, cd_cnes_imp,
			cd_cooperativa, cd_cpf_prestador_imp,
			cd_estabelecimento, cd_guia,
			cd_guia_imp, cd_guia_prestador,
			cd_guia_prestador_imp, cd_guia_referencia,
			cd_guia_solic_imp, cd_medico_executor,
			cd_medico_solicitante, cd_prestador_exec_imp,
			cd_prestador_solic_imp, cd_senha,
			cd_senha_imp, cd_tipo_atend_odont, 
			cd_tipo_atend_odont_imp, cd_usuario_plano_imp, 
			ds_empresa_benef_imp, ds_indicacao_clinica,
			ds_indicacao_clinica_imp, ds_observacao,
			ds_observacao_imp, ds_plano_imp,
			dt_alta, dt_alta_imp,
			dt_atendimento, dt_atendimento_imp,
			dt_atualizacao, dt_atualizacao_nrec,
			dt_autorizacao, dt_autorizacao_imp,
			dt_emissao, dt_emissao_imp,
			dt_entrada, dt_entrada_imp, 
			dt_fim_faturamento, dt_fim_faturamento_imp, 
			dt_inicio_geracao_conta, dt_fim_tratamento, 
			dt_fim_tratamento_imp, dt_inicio_faturamento, 
			dt_inicio_faturamento_imp, dt_validade_senha,
			dt_validade_senha_imp, ie_carater_internacao,
			ie_carater_internacao_imp, ie_indicacao_acidente, 
			ie_indicacao_acidente_imp, ie_motivo_encerramento, 
			ie_origem_conta, ie_recem_nascido, 
			ie_recem_nascido_imp, ie_regime_internacao, 
			ie_regime_internacao_imp, ie_status, 
			ie_tipo_atendimento_imp, ie_tipo_consulta,
			ie_tipo_consulta_imp, ie_tipo_faturamento,
			ie_tipo_faturamento_imp, nm_medico_executor_imp, 
			nm_medico_solic_imp, nm_prestador_exec_imp, 
			nm_prestador_imp, nm_segurado_imp,
			nm_titular_benef_imp, nm_usuario,
			nm_usuario_nrec, nr_crm_exec, 
			nr_crm_exec_imp, nr_crm_prest_exec_imp, 
			nr_crm_prest_solic_imp, nr_crm_solic_imp, 
			nr_seq_cbo_saude, nr_seq_cbo_saude_solic,
			nr_seq_congenere, nr_seq_conselho_exec, 
			nr_seq_conselho_solic, nr_seq_imp,
			nr_seq_guia, nr_seq_prestador, 
			nr_seq_prestador_exec, nr_seq_prestador_exec_imp, 
			nr_seq_prestador_exec_imp_ref, nr_seq_prestador_imp, 
			nr_seq_prestador_imp_ref, nr_seq_prestador_solic_ref,
			nr_seq_protocolo, nr_seq_segurado, 
			nr_seq_tipo_atendimento, nr_sequencia,
			nr_telefone_benef_imp, qt_total_unidade_serv_imp,
			vl_cobrado, vl_diarias,
			vl_diarias_imp, vl_gases,
			vl_gases_imp, vl_materiais,
			vl_materiais_imp, vl_medicamentos,
			vl_medicamentos_imp, vl_opm,
			vl_opm_imp, vl_procedimentos,
			vl_procedimentos_imp, vl_taxas, 
			vl_taxas_imp, vl_total_imp,
			cd_cpf_executor_imp, ie_tipo_guia,
			nr_cartao_nac_sus_imp, nr_seq_clinica, 
			nr_seq_clinica_imp, sg_conselho_exec, 
			sg_conselho_exec_imp, sg_conselho_solic, 
			sg_conselho_solic_imp, uf_crm_exec, 
			uf_crm_exec_imp, uf_crm_prest_exec_imp,
			uf_crm_prest_solic_imp, uf_crm_solic_imp,
			vl_total, nr_seq_saida_int,
			cd_guia_ok, ie_tipo_internado,
			ie_vinc_internacao, ie_regime_atendimento,
			ie_saude_ocupacional
		) values (tb_cd_ans_w(i), tb_cd_ans_w(i),
			tb_cd_cbo_saude_prof_exec_w(i), tb_cd_cbo_saude_prof_solic_w(i),
			tb_cd_cgc_prest_exec_conv_w(i), tb_cd_cgc_prest_solic_conv_w(i),
			tb_cd_cns_w(i), tb_cd_cnes_prest_exec_w(i), tb_cd_cnes_prest_exec_w(i),
			tb_cd_cooperativa_cart_conv_w(i), tb_cd_cpf_prest_exec_w(i),
			tb_cd_estabelecimento_w(i), tb_cd_guia_operadora_conv_w(i),
			tb_cd_guia_operadora_w(i), tb_cd_guia_prestador_w(i),
			tb_cd_guia_prestador_w(i), tb_cd_guia_principal_conv_w(i),
			tb_cd_guia_principal_w(i), tb_cd_profissional_exec_conv_w(i),
			tb_cd_prof_solic_conv_w(i), tb_cd_prestador_exec_w(i),
			tb_cd_prest_solic_conv_w(i), tb_cd_senha_w(i),
			tb_cd_senha_w(i), tb_ie_tipo_atend_odonto_conv_w(i),
			tb_ie_tipo_atend_odonto_w(i), tb_cd_usuario_plano_w(i),
			tb_ds_empresa_benef_w(i), tb_ds_indicacao_clinica_w(i),
			tb_ds_indicacao_clinica_w(i), tb_ds_observacao_w(i),
			tb_ds_observacao_w(i), tb_ds_plano_w(i),
			tb_dt_fim_faturamento_w(i), tb_dt_fim_faturamento_w(i),
			tb_dt_atendimento_conv_w(i), tb_dt_atendimento_w(i),
			clock_timestamp(), clock_timestamp(),
			tb_dt_autorizacao_w(i), tb_dt_autorizacao_w(i),
			tb_dt_emissao_guia_w(i), tb_dt_emissao_guia_w(i),
			tb_dt_inicio_faturamento_w(i), tb_dt_inicio_faturamento_w(i),
			tb_dt_fim_faturamento_w(i), tb_dt_fim_faturamento_w(i),
			clock_timestamp(), tb_dt_fim_tratamento_w(i),
			tb_dt_fim_tratamento_w(i), tb_dt_inicio_faturamento_w(i),
			tb_dt_inicio_faturamento_w(i), tb_dt_validade_senha_w(i),
			tb_dt_validade_senha_w(i), tb_ie_carater_atend_conv_w(i),
			tb_ie_carater_atendimento_w(i), tb_ie_indicacao_acidente_w(i),
			tb_ie_indicacao_acidente_w(i), tb_ie_motivo_encerramento_w(i),
			'E', tb_ie_recem_nascido_w(i),
			tb_ie_recem_nascido_w(i), tb_ie_regime_internacao_w(i),
			tb_ie_regime_internacao_w(i), 'U',
			tb_ie_tipo_atendimento_w(i), tb_ie_tipo_consulta_w(i),
			tb_ie_tipo_consulta_w(i), tb_ie_tipo_faturamento_w(i),
			tb_ie_tipo_faturamento_w(i), tb_nm_profissional_exec_w(i),
			tb_nm_profissional_solic_w(i), tb_nm_prestador_exec_w(i),
			tb_nm_prestador_exec_w(i), tb_nm_beneficiario_w(i),
			tb_nm_titular_benef_w(i), nm_usuario_p,
			nm_usuario_p, tb_nr_conselho_prest_exec_w(i),
			tb_nr_conselho_prest_exec_w(i), tb_nr_conselho_prest_exec_w(i),
			tb_nr_conselho_prof_solic_w(i), tb_nr_cons_prof_solic_conv_w(i),
			tb_nr_seq_cbo_prof_exec_conv_w(i), tb_nr_cbo_prof_solic_conv_w(i),
			tb_nr_seq_congenere_conv_w(i), tb_seq_cons_prof_exec_conv_w(i),
			tb_seq_cons_prof_solic_conv_w(i), tb_nr_seq_conta_w(i),
			tb_nr_seq_guia_conv_w(i), tb_nr_seq_prest_exec_conv_w(i),
			tb_nr_seq_prest_exec_conv_w(i), tb_nr_seq_prest_exec_conv_w(i),
			tb_nr_seq_prest_exec_conv_w(i), tb_nr_seq_prest_exec_conv_w(i),
			tb_nr_seq_prest_exec_conv_w(i), tb_nr_seq_prest_solic_conv_w(i),
			tb_nr_seq_protoclo_w(i), tb_nr_seq_segurado_conv_w(i),
			tb_nr_seq_tipo_atend_conv_w(i), nextval('pls_conta_seq'),
			tb_nr_telefone_benef_w(i), tb_qt_total_unidade_serv_w(i),
			tb_vl_total_geral_w(i), tb_vl_diarias_w(i),
			tb_vl_diarias_w(i), tb_vl_gases_medicinais_w(i),
			tb_vl_gases_medicinais_w(i), tb_vl_materiais_w(i),
			tb_vl_materiais_w(i), tb_vl_medicamentos_w(i),
			tb_vl_medicamentos_w(i), tb_vl_opme_w(i),
			tb_vl_opme_w(i), tb_vl_procedimentos_w(i),
			tb_vl_procedimentos_w(i), tb_vl_taxas_alugueis_w(i),
			tb_vl_taxas_alugueis_w(i), tb_vl_total_geral_w(i),
			tb_cd_cpf_prest_exec_w(i), tb_ie_tipo_guia_w(i),
			tb_cd_cns_w(i), tb_ie_tipo_internacao_conv_w(i),
			tb_ie_tipo_atend_odonto_w(i), tb_cd_conselho_prof_exec_w(i),
			tb_cd_conselho_prof_exec_w(i), tb_cd_conselho_prof_solic_w(i),
			tb_cd_conselho_prof_solic_w(i), tb_cd_uf_cons_prof_exec_conv_w(i),
			tb_cd_uf_conselho_prof_exec_w(i), tb_cd_uf_conselho_prest_exec_w(i),
			tb_cd_uf_conselho_prof_solic_w(i), tb_cd_uf_conselho_prof_solic_w(i),
			tb_vl_total_geral_w(i), tb_nr_seq_motivo_encer_w(i),
			tb_cd_guia_ok_conv_w(i), tb_ie_tipo_internado_conv_w(i),
			tb_ie_vinc_internacao_conv_w(i), tb_ie_regime_atendimento_w(i),
			tb_ie_saude_ocupacional_w(i));
	commit;
end loop;
close C01;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_int_xml_cta_pck.pls_int_nv_conta ( nr_seq_lote_protocolo_p pls_lote_protocolo_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;