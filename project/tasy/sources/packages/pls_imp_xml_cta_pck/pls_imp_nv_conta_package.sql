-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_imp_xml_cta_pck.pls_imp_nv_conta ( nr_seq_protocolo_p pls_conta_imp.nr_seq_protocolo%type, cd_guia_operadora_p pls_conta_imp.cd_guia_operadora%type, cd_guia_prestador_p pls_conta_imp.cd_guia_prestador%type, cd_guia_principal_p pls_conta_imp.cd_guia_principal%type, cd_senha_p pls_conta_imp.cd_senha%type, dt_validade_senha_p pls_conta_imp.dt_validade_senha%type, dt_autorizacao_p pls_conta_imp.dt_autorizacao%type, cd_ans_p pls_conta_imp.cd_ans%type, cd_usuario_plano_p pls_conta_imp.cd_usuario_plano%type, nm_beneficiario_p pls_conta_imp.nm_beneficiario%type, ie_recem_nascido_p pls_conta_imp.ie_recem_nascido%type, cd_cns_p pls_conta_imp.cd_cns%type, -- prestador executor
 cd_prestador_exec_p pls_conta_imp.cd_prestador_exec%type, cd_cgc_prest_exec_p pls_conta_imp.cd_cgc_prest_exec%type, cd_cpf_prest_exec_p pls_conta_imp.cd_cpf_prest_exec%type, nr_conselho_prest_exec_p pls_conta_imp.nr_conselho_prest_exec%type, cd_uf_conselho_prest_exec_p pls_conta_imp.cd_uf_conselho_prest_exec%type, cd_cnes_prest_exec_p pls_conta_imp.cd_cnes_prest_exec%type, nm_prestador_exec_p pls_conta_imp.nm_prestador_exec%type, -- profissional executor
 nr_conselho_prof_exec_p pls_conta_imp.nr_conselho_prof_exec%type, cd_conselho_prof_exec_p pls_conta_imp.cd_conselho_prof_exec%type, cd_uf_conselho_prof_exec_p pls_conta_imp.cd_uf_conselho_prof_exec%type, cd_cbo_saude_prof_exec_p pls_conta_imp.cd_cbo_saude_prof_exec%type, nm_profissional_exec_p pls_conta_imp.nm_profissional_exec%type, -- prestador solicitante
 cd_prestador_solic_p pls_conta_imp.cd_prestador_solic%type, cd_cgc_prest_solic_p pls_conta_imp.cd_cgc_prest_solic%type, cd_cpf_prest_solic_p pls_conta_imp.cd_cpf_prest_solic%type, cd_cnes_prest_solic_p pls_conta_imp.cd_cnes_prest_solic%type, nm_prestador_solic_p pls_conta_imp.nm_prestador_solic%type, -- profissional solicitante
 nr_conselho_prof_solic_p pls_conta_imp.nr_conselho_prof_solic%type, cd_conselho_prof_solic_p pls_conta_imp.cd_conselho_prof_solic%type, cd_uf_conselho_prof_solic_p pls_conta_imp.cd_uf_conselho_prof_solic%type, cd_cbo_saude_prof_solic_p pls_conta_imp.cd_cbo_saude_prof_solic%type, nm_profissional_solic_p pls_conta_imp.nm_profissional_solic%type, -- inicio demais campos
 ie_indicacao_acidente_p pls_conta_imp.ie_indicacao_acidente%type, ie_tipo_consulta_p pls_conta_imp.ie_tipo_consulta%type, dt_atendimento_p pls_conta_imp.dt_atendimento%type, dt_solicitacao_p pls_conta_imp.dt_solicitacao%type, ie_carater_atendimento_p pls_conta_imp.ie_carater_atendimento%type, ds_indicacao_clinica_p pls_conta_imp.ds_indicacao_clinica%type, ie_tipo_atendimento_p pls_conta_imp.ie_tipo_atendimento%type, ie_motivo_encerramento_p pls_conta_imp.ie_motivo_encerramento%type, vl_procedimentos_p pls_conta_imp.vl_procedimentos%type, vl_diarias_p pls_conta_imp.vl_diarias%type, vl_taxas_alugueis_p pls_conta_imp.vl_taxas_alugueis%type, vl_materiais_p pls_conta_imp.vl_materiais%type, vl_medicamentos_p pls_conta_imp.vl_medicamentos%type, vl_gases_medicinais_p pls_conta_imp.vl_gases_medicinais%type, vl_opme_p pls_conta_imp.vl_opme%type, vl_total_geral_p pls_conta_imp.vl_total_geral%type, vl_total_coparticipacao_p pls_conta_imp.vl_total_coparticipacao%type, ie_tipo_faturamento_p pls_conta_imp.ie_tipo_faturamento%type, dt_inicio_faturamento_p pls_conta_imp.dt_inicio_faturamento%type, dt_fim_faturamento_p pls_conta_imp.dt_fim_faturamento%type, ie_tipo_internacao_p pls_conta_imp.ie_tipo_internacao%type, ie_regime_internacao_p pls_conta_imp.ie_regime_internacao%type, dt_emissao_guia_p pls_conta_imp.dt_emissao_guia%type, ds_plano_p pls_conta_imp.ds_plano%type, ds_empresa_benef_p pls_conta_imp.ds_empresa_benef%type, nr_telefone_benef_p pls_conta_imp.nr_telefone_benef%type, nm_titular_benef_p pls_conta_imp.nm_titular_benef%type, dt_fim_tratamento_p pls_conta_imp.dt_fim_tratamento%type, ie_tipo_atend_odonto_p pls_conta_imp.ie_tipo_atend_odonto%type, qt_total_unidade_serv_p pls_conta_imp.qt_total_unidade_serv%type, ds_observacao_p pls_conta_imp.ds_observacao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_sequencia_p INOUT pls_conta_imp.nr_sequencia%type, ie_cobertura_especial_p pls_conta.ie_cobertura_especial%type default null, ie_regime_atendimento_p pls_conta.ie_regime_atendimento%type default null, ie_saude_ocupacional_p pls_conta.ie_saude_ocupacional%type default null) AS $body$
BEGIN
-- insere a conta

insert 	into pls_conta_imp(
	nr_sequencia, dt_atualizacao, nm_usuario,
	dt_atualizacao_nrec, nm_usuario_nrec, cd_estabelecimento,
	nr_seq_protocolo, cd_guia_operadora, cd_guia_prestador,
	cd_guia_principal, cd_senha, dt_validade_senha,
	dt_autorizacao, cd_ans, cd_usuario_plano,
	nm_beneficiario, ie_recem_nascido, cd_cns,
	cd_prestador_exec, cd_cgc_prest_exec, cd_cpf_prest_exec, 
	nr_conselho_prest_exec, cd_uf_conselho_prest_exec, cd_cnes_prest_exec,
	nm_prestador_exec, nr_conselho_prof_exec, cd_conselho_prof_exec,
	cd_uf_conselho_prof_exec, cd_cbo_saude_prof_exec, nm_profissional_exec, 
	cd_prestador_solic, cd_cgc_prest_solic, cd_cpf_prest_solic,
	cd_cnes_prest_solic, nm_prestador_solic, nr_conselho_prof_solic,
	cd_conselho_prof_solic, cd_uf_conselho_prof_solic, cd_cbo_saude_prof_solic,
	nm_profissional_solic, ie_indicacao_acidente, ie_tipo_consulta,
	dt_atendimento, dt_solicitacao, ie_carater_atendimento, 
	ds_indicacao_clinica, ie_tipo_atendimento, ie_motivo_encerramento,
	vl_procedimentos, vl_diarias, vl_taxas_alugueis,
	vl_materiais, vl_medicamentos, vl_gases_medicinais,
	vl_opme, vl_total_geral, vl_total_coparticipacao,
	ie_tipo_faturamento, dt_inicio_faturamento, ie_tipo_internacao,
	ie_regime_internacao, dt_emissao_guia, ds_plano,
	ds_empresa_benef, nr_telefone_benef, nm_titular_benef,
	dt_fim_tratamento, ie_tipo_atend_odonto, qt_total_unidade_serv,
	ds_observacao, dt_fim_faturamento, ie_cobertura_especial, 
	ie_regime_atendimento, ie_saude_ocupacional
) values (
	nextval('pls_conta_imp_seq'), clock_timestamp(), nm_usuario_p,
	clock_timestamp(), nm_usuario_p, cd_estabelecimento_p,
	nr_seq_protocolo_p, cd_guia_operadora_p, cd_guia_prestador_p,
	cd_guia_principal_p, cd_senha_p, dt_validade_senha_p,
	dt_autorizacao_p, cd_ans_p, cd_usuario_plano_p,
	nm_beneficiario_p, ie_recem_nascido_p, cd_cns_p,
	cd_prestador_exec_p, cd_cgc_prest_exec_p, cd_cpf_prest_exec_p,
	nr_conselho_prest_exec_p, cd_uf_conselho_prest_exec_p, cd_cnes_prest_exec_p,
	nm_prestador_exec_p, nr_conselho_prof_exec_p, cd_conselho_prof_exec_p,
	cd_uf_conselho_prof_exec_p, cd_cbo_saude_prof_exec_p, nm_profissional_exec_p,
	cd_prestador_solic_p, cd_cgc_prest_solic_p, cd_cpf_prest_solic_p,
	cd_cnes_prest_solic_p, nm_prestador_solic_p, nr_conselho_prof_solic_p,
	cd_conselho_prof_solic_p, cd_uf_conselho_prof_solic_p, cd_cbo_saude_prof_solic_p,
	nm_profissional_solic_p, ie_indicacao_acidente_p, ie_tipo_consulta_p,
	dt_atendimento_p, dt_solicitacao_p, ie_carater_atendimento_p,
	ds_indicacao_clinica_p, ie_tipo_atendimento_p, ie_motivo_encerramento_p,
	vl_procedimentos_p, vl_diarias_p, vl_taxas_alugueis_p,
	vl_materiais_p, vl_medicamentos_p, vl_gases_medicinais_p,
	vl_opme_p, vl_total_geral_p, vl_total_coparticipacao_p,
	ie_tipo_faturamento_p, dt_inicio_faturamento_p, ie_tipo_internacao_p,
	ie_regime_internacao_p, dt_emissao_guia_p, ds_plano_p,
	ds_empresa_benef_p, nr_telefone_benef_p, nm_titular_benef_p,
	dt_fim_tratamento_p, ie_tipo_atend_odonto_p, qt_total_unidade_serv_p,
	ds_observacao_p, dt_fim_faturamento_p, ie_cobertura_especial_p, 
	ie_regime_atendimento_p, ie_saude_ocupacional_p
) returning nr_sequencia into nr_sequencia_p;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_xml_cta_pck.pls_imp_nv_conta ( nr_seq_protocolo_p pls_conta_imp.nr_seq_protocolo%type, cd_guia_operadora_p pls_conta_imp.cd_guia_operadora%type, cd_guia_prestador_p pls_conta_imp.cd_guia_prestador%type, cd_guia_principal_p pls_conta_imp.cd_guia_principal%type, cd_senha_p pls_conta_imp.cd_senha%type, dt_validade_senha_p pls_conta_imp.dt_validade_senha%type, dt_autorizacao_p pls_conta_imp.dt_autorizacao%type, cd_ans_p pls_conta_imp.cd_ans%type, cd_usuario_plano_p pls_conta_imp.cd_usuario_plano%type, nm_beneficiario_p pls_conta_imp.nm_beneficiario%type, ie_recem_nascido_p pls_conta_imp.ie_recem_nascido%type, cd_cns_p pls_conta_imp.cd_cns%type,  cd_prestador_exec_p pls_conta_imp.cd_prestador_exec%type, cd_cgc_prest_exec_p pls_conta_imp.cd_cgc_prest_exec%type, cd_cpf_prest_exec_p pls_conta_imp.cd_cpf_prest_exec%type, nr_conselho_prest_exec_p pls_conta_imp.nr_conselho_prest_exec%type, cd_uf_conselho_prest_exec_p pls_conta_imp.cd_uf_conselho_prest_exec%type, cd_cnes_prest_exec_p pls_conta_imp.cd_cnes_prest_exec%type, nm_prestador_exec_p pls_conta_imp.nm_prestador_exec%type,  nr_conselho_prof_exec_p pls_conta_imp.nr_conselho_prof_exec%type, cd_conselho_prof_exec_p pls_conta_imp.cd_conselho_prof_exec%type, cd_uf_conselho_prof_exec_p pls_conta_imp.cd_uf_conselho_prof_exec%type, cd_cbo_saude_prof_exec_p pls_conta_imp.cd_cbo_saude_prof_exec%type, nm_profissional_exec_p pls_conta_imp.nm_profissional_exec%type,  cd_prestador_solic_p pls_conta_imp.cd_prestador_solic%type, cd_cgc_prest_solic_p pls_conta_imp.cd_cgc_prest_solic%type, cd_cpf_prest_solic_p pls_conta_imp.cd_cpf_prest_solic%type, cd_cnes_prest_solic_p pls_conta_imp.cd_cnes_prest_solic%type, nm_prestador_solic_p pls_conta_imp.nm_prestador_solic%type,  nr_conselho_prof_solic_p pls_conta_imp.nr_conselho_prof_solic%type, cd_conselho_prof_solic_p pls_conta_imp.cd_conselho_prof_solic%type, cd_uf_conselho_prof_solic_p pls_conta_imp.cd_uf_conselho_prof_solic%type, cd_cbo_saude_prof_solic_p pls_conta_imp.cd_cbo_saude_prof_solic%type, nm_profissional_solic_p pls_conta_imp.nm_profissional_solic%type,  ie_indicacao_acidente_p pls_conta_imp.ie_indicacao_acidente%type, ie_tipo_consulta_p pls_conta_imp.ie_tipo_consulta%type, dt_atendimento_p pls_conta_imp.dt_atendimento%type, dt_solicitacao_p pls_conta_imp.dt_solicitacao%type, ie_carater_atendimento_p pls_conta_imp.ie_carater_atendimento%type, ds_indicacao_clinica_p pls_conta_imp.ds_indicacao_clinica%type, ie_tipo_atendimento_p pls_conta_imp.ie_tipo_atendimento%type, ie_motivo_encerramento_p pls_conta_imp.ie_motivo_encerramento%type, vl_procedimentos_p pls_conta_imp.vl_procedimentos%type, vl_diarias_p pls_conta_imp.vl_diarias%type, vl_taxas_alugueis_p pls_conta_imp.vl_taxas_alugueis%type, vl_materiais_p pls_conta_imp.vl_materiais%type, vl_medicamentos_p pls_conta_imp.vl_medicamentos%type, vl_gases_medicinais_p pls_conta_imp.vl_gases_medicinais%type, vl_opme_p pls_conta_imp.vl_opme%type, vl_total_geral_p pls_conta_imp.vl_total_geral%type, vl_total_coparticipacao_p pls_conta_imp.vl_total_coparticipacao%type, ie_tipo_faturamento_p pls_conta_imp.ie_tipo_faturamento%type, dt_inicio_faturamento_p pls_conta_imp.dt_inicio_faturamento%type, dt_fim_faturamento_p pls_conta_imp.dt_fim_faturamento%type, ie_tipo_internacao_p pls_conta_imp.ie_tipo_internacao%type, ie_regime_internacao_p pls_conta_imp.ie_regime_internacao%type, dt_emissao_guia_p pls_conta_imp.dt_emissao_guia%type, ds_plano_p pls_conta_imp.ds_plano%type, ds_empresa_benef_p pls_conta_imp.ds_empresa_benef%type, nr_telefone_benef_p pls_conta_imp.nr_telefone_benef%type, nm_titular_benef_p pls_conta_imp.nm_titular_benef%type, dt_fim_tratamento_p pls_conta_imp.dt_fim_tratamento%type, ie_tipo_atend_odonto_p pls_conta_imp.ie_tipo_atend_odonto%type, qt_total_unidade_serv_p pls_conta_imp.qt_total_unidade_serv%type, ds_observacao_p pls_conta_imp.ds_observacao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_sequencia_p INOUT pls_conta_imp.nr_sequencia%type, ie_cobertura_especial_p pls_conta.ie_cobertura_especial%type default null, ie_regime_atendimento_p pls_conta.ie_regime_atendimento%type default null, ie_saude_ocupacional_p pls_conta.ie_saude_ocupacional%type default null) FROM PUBLIC;
