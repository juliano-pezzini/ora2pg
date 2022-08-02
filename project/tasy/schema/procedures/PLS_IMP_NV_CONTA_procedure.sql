-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_imp_nv_conta ( nr_seq_protocolo_p pls_conta_imp.nr_seq_protocolo%type, cd_guia_operadora_p pls_conta_imp.cd_guia_operadora%type, cd_guia_prestador_p pls_conta_imp.cd_guia_prestador%type, cd_guia_principal_p pls_conta_imp.cd_guia_principal%type, cd_senha_p pls_conta_imp.cd_senha%type, dt_validade_senha_p pls_conta_imp.dt_validade_senha%type, dt_autorizacao_p pls_conta_imp.dt_autorizacao%type, cd_ans_p pls_conta_imp.cd_ans%type, cd_usuario_plano_p pls_conta_imp.cd_usuario_plano%type, nm_beneficiario_p pls_conta_imp.nm_beneficiario%type, ie_recem_nascido_p pls_conta_imp.ie_recem_nascido%type, cd_cns_p pls_conta_imp.cd_cns%type, -- prestador executor
 cd_prestador_exec_p pls_conta_imp.cd_prestador_exec%type, cd_cgc_prest_exec_p pls_conta_imp.cd_cgc_prest_exec%type, cd_cpf_prest_exec_p pls_conta_imp.cd_cpf_prest_exec%type, nr_conselho_prest_exec_p pls_conta_imp.nr_conselho_prest_exec%type, cd_uf_conselho_prest_exec_p pls_conta_imp.cd_uf_conselho_prest_exec%type, cd_cnes_prest_exec_p pls_conta_imp.cd_cnes_prest_exec%type, nm_prestador_exec_p pls_conta_imp.nm_prestador_exec%type, -- profissional executor
 nr_conselho_prof_exec_p pls_conta_imp.nr_conselho_prof_exec%type, cd_conselho_prof_exec_p pls_conta_imp.cd_conselho_prof_exec%type, cd_uf_conselho_prof_exec_p pls_conta_imp.cd_uf_conselho_prof_exec%type, cd_cbo_saude_prof_exec_p pls_conta_imp.cd_cbo_saude_prof_exec%type, nm_profissional_exec_p pls_conta_imp.nm_profissional_exec%type, -- prestador solicitante
 cd_prestador_solic_p pls_conta_imp.cd_prestador_solic%type, cd_cgc_prest_solic_p pls_conta_imp.cd_cgc_prest_solic%type, cd_cpf_prest_solic_p pls_conta_imp.cd_cpf_prest_solic%type, cd_cnes_prest_solic_p pls_conta_imp.cd_cnes_prest_solic%type, nm_prestador_solic_p pls_conta_imp.nm_prestador_solic%type, -- profissional solicitante
 nr_conselho_prof_solic_p pls_conta_imp.nr_conselho_prof_solic%type, cd_conselho_prof_solic_p pls_conta_imp.cd_conselho_prof_solic%type, cd_uf_conselho_prof_solic_p pls_conta_imp.cd_uf_conselho_prof_solic%type, cd_cbo_saude_prof_solic_p pls_conta_imp.cd_cbo_saude_prof_solic%type, nm_profissional_solic_p pls_conta_imp.nm_profissional_solic%type, -- inicio demais campos
 ie_indicacao_acidente_p pls_conta_imp.ie_indicacao_acidente%type, ie_tipo_consulta_p pls_conta_imp.ie_tipo_consulta%type, dt_atendimento_p pls_conta_imp.dt_atendimento%type, dt_solicitacao_p pls_conta_imp.dt_solicitacao%type, ie_carater_atendimento_p pls_conta_imp.ie_carater_atendimento%type, ds_indicacao_clinica_p pls_conta_imp.ds_indicacao_clinica%type, ie_tipo_atendimento_p pls_conta_imp.ie_tipo_atendimento%type, ie_motivo_encerramento_p pls_conta_imp.ie_motivo_encerramento%type, vl_procedimentos_p pls_conta_imp.vl_procedimentos%type, vl_diarias_p pls_conta_imp.vl_diarias%type, vl_taxas_alugueis_p pls_conta_imp.vl_taxas_alugueis%type, vl_materiais_p pls_conta_imp.vl_materiais%type, vl_medicamentos_p pls_conta_imp.vl_medicamentos%type, vl_gases_medicinais_p pls_conta_imp.vl_gases_medicinais%type, vl_opme_p pls_conta_imp.vl_opme%type, vl_total_geral_p pls_conta_imp.vl_total_geral%type, vl_total_coparticipacao_p pls_conta_imp.vl_total_coparticipacao%type, ie_tipo_faturamento_p pls_conta_imp.ie_tipo_faturamento%type, dt_inicio_faturamento_p pls_conta_imp.dt_inicio_faturamento%type, dt_fim_faturamento_p pls_conta_imp.dt_fim_faturamento%type, ie_tipo_internacao_p pls_conta_imp.ie_tipo_internacao%type, ie_regime_internacao_p pls_conta_imp.ie_regime_internacao%type, dt_emissao_guia_p pls_conta_imp.dt_emissao_guia%type, ds_plano_p pls_conta_imp.ds_plano%type, ds_empresa_benef_p pls_conta_imp.ds_empresa_benef%type, nr_telefone_benef_p pls_conta_imp.nr_telefone_benef%type, nm_titular_benef_p pls_conta_imp.nm_titular_benef%type, dt_fim_tratamento_p pls_conta_imp.dt_fim_tratamento%type, ie_tipo_atend_odonto_p pls_conta_imp.ie_tipo_atend_odonto%type, qt_total_unidade_serv_p pls_conta_imp.qt_total_unidade_serv%type, ds_observacao_p pls_conta_imp.ds_observacao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_validacao_benef_tiss_p pls_conta_tiss.cd_validacao_benef_tiss%type, cd_ausencia_val_benef_tiss_p pls_conta_tiss.cd_ausencia_val_benef_tiss%type, cd_ident_biometria_benef_p pls_conta_tiss.cd_ident_biometria_benef%type, cd_template_biomet_benef_p pls_conta_tiss.cd_template_biomet_benef%type, ie_tipo_ident_benef_p pls_conta_tiss.ie_tipo_ident_benef%type, cd_assinat_digital_prest_p pls_conta_tiss.cd_assinat_digital_prest%type, nr_sequencia_p INOUT pls_conta_imp.nr_sequencia%type, ie_cobertura_especial_p pls_conta.ie_cobertura_especial%type default null, ie_regime_atendimento_p pls_conta.ie_regime_atendimento%type default null, ie_saude_ocupacional_p pls_conta.ie_saude_ocupacional%type default null) AS $body$
DECLARE

				
ie_tipo_guia_w		pls_conta.ie_tipo_guia%type;


BEGIN

-- se for para usar a nova forma de importacao XML chama da package, caso contrario chama a rotina antiga
if (pls_imp_xml_cta_pck.usar_nova_imp_xml(cd_estabelecimento_p) = 'S') then
	
	nr_sequencia_p := pls_imp_xml_cta_pck.pls_imp_nv_conta(	nr_seq_protocolo_p, cd_guia_operadora_p, cd_guia_prestador_p, cd_guia_principal_p, cd_senha_p, dt_validade_senha_p, dt_autorizacao_p, cd_ans_p, cd_usuario_plano_p, nm_beneficiario_p, ie_recem_nascido_p, cd_cns_p, cd_prestador_exec_p, cd_cgc_prest_exec_p, cd_cpf_prest_exec_p, nr_conselho_prest_exec_p, cd_uf_conselho_prest_exec_p, cd_cnes_prest_exec_p, nm_prestador_exec_p, nr_conselho_prof_exec_p, cd_conselho_prof_exec_p, cd_uf_conselho_prof_exec_p, cd_cbo_saude_prof_exec_p, nm_profissional_exec_p, cd_prestador_solic_p, cd_cgc_prest_solic_p, cd_cpf_prest_solic_p, cd_cnes_prest_solic_p, nm_prestador_solic_p, nr_conselho_prof_solic_p, cd_conselho_prof_solic_p, cd_uf_conselho_prof_solic_p, cd_cbo_saude_prof_solic_p, nm_profissional_solic_p, ie_indicacao_acidente_p, ie_tipo_consulta_p, dt_atendimento_p, dt_solicitacao_p, ie_carater_atendimento_p, ds_indicacao_clinica_p, ie_tipo_atendimento_p, ie_motivo_encerramento_p, vl_procedimentos_p, vl_diarias_p, vl_taxas_alugueis_p, vl_materiais_p, vl_medicamentos_p, vl_gases_medicinais_p, vl_opme_p, vl_total_geral_p, vl_total_coparticipacao_p, ie_tipo_faturamento_p, dt_inicio_faturamento_p, dt_fim_faturamento_p, ie_tipo_internacao_p, ie_regime_internacao_p, dt_emissao_guia_p, ds_plano_p, ds_empresa_benef_p, nr_telefone_benef_p, nm_titular_benef_p, dt_fim_tratamento_p, ie_tipo_atend_odonto_p, qt_total_unidade_serv_p, ds_observacao_p, nm_usuario_p, cd_estabelecimento_p, nr_sequencia_p, ie_cobertura_especial_p, ie_regime_atendimento_p, ie_saude_ocupacional_p);
else
	-- faco select separado para alimentar a redundancia de forma correta
	select	max(ie_tipo_guia)
	into STRICT	ie_tipo_guia_w
	from	pls_protocolo_conta
	where	nr_sequencia = nr_seq_protocolo_p;
	
	select	nextval('pls_conta_seq')
	into STRICT	nr_sequencia_p
	;
	
	
	-- rotina da estrutura antiga

	-- com o tempo a mesma deve sair daqui e ficar so o novo metodo de implementacao
	CALL pls_imp_conta(	null, nr_sequencia_p,
			nr_seq_protocolo_p, ie_tipo_guia_w,
			cd_guia_operadora_p, cd_guia_prestador_p,
			ie_carater_atendimento_p, cd_ans_p,
			dt_emissao_guia_p, cd_guia_principal_p,
			cd_usuario_plano_p, nm_beneficiario_p,
			ds_plano_p, null,
			cd_cns_p, cd_prestador_exec_p,
			nm_prestador_solic_p, coalesce(cd_cnes_prest_solic_p,cd_cnes_prest_exec_p),
			dt_inicio_faturamento_p, null,
			ie_tipo_consulta_p, dt_validade_senha_p,
			cd_senha_p, dt_autorizacao_p,
			ie_tipo_atendimento_p, ds_observacao_p,
			vl_procedimentos_p, vl_diarias_p,
			vl_taxas_alugueis_p, vl_materiais_p,
			vl_medicamentos_p, vl_gases_medicinais_p,
			vl_opme_p, vl_total_geral_p,
			ie_tipo_faturamento_p, cd_cpf_prest_exec_p,
			cd_cgc_prest_exec_p, cd_estabelecimento_p,
			nm_usuario_p, cd_cgc_prest_solic_p,
			cd_cpf_prest_solic_p, cd_prestador_solic_p,			
			null, null,
			null, nm_profissional_solic_p,
			nr_conselho_prof_solic_p, cd_uf_conselho_prof_solic_p,
			cd_cbo_saude_prof_solic_p, cd_conselho_prof_solic_p,
			nm_prestador_exec_p, nm_profissional_exec_p,
			nr_conselho_prof_exec_p, cd_uf_conselho_prof_exec_p,
			cd_cbo_saude_prof_exec_p, cd_conselho_prof_exec_p,
			null, null,
			null, null,
			cd_cnes_prest_exec_p, null,
			null, null,
			null, null,
			null, null,
			null, null,
			ie_regime_internacao_p, ie_tipo_faturamento_p,
			null, ie_indicacao_acidente_p,
			null, null,
			null, null,
			null, null,
			null, dt_fim_faturamento_p,
			ie_tipo_internacao_p, coalesce(dt_atendimento_p, dt_solicitacao_p),
			ie_recem_nascido_p, ds_indicacao_clinica_p,
			ie_tipo_atend_odonto_p, qt_total_unidade_serv_p,
			vl_total_coparticipacao_p, ds_empresa_benef_p,
			nr_telefone_benef_p, nm_titular_benef_p,
			nr_conselho_prest_exec_p, cd_uf_conselho_prest_exec_p,
			dt_fim_tratamento_p, dt_fim_tratamento_p,
			ie_motivo_encerramento_p, ie_cobertura_especial_p,
			ie_regime_atendimento_p, ie_saude_ocupacional_p);
	
	-- gera o registro de tiss, se nao existir
	CALL pls_conta_tiss_pck.criar_registro(	nr_sequencia_p,			cd_estabelecimento_p,		cd_validacao_benef_tiss_p,
						cd_ausencia_val_benef_tiss_p,	cd_ident_biometria_benef_p,	cd_template_biomet_benef_p,
						ie_tipo_ident_benef_p,		cd_assinat_digital_prest_p,	nm_usuario_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_nv_conta ( nr_seq_protocolo_p pls_conta_imp.nr_seq_protocolo%type, cd_guia_operadora_p pls_conta_imp.cd_guia_operadora%type, cd_guia_prestador_p pls_conta_imp.cd_guia_prestador%type, cd_guia_principal_p pls_conta_imp.cd_guia_principal%type, cd_senha_p pls_conta_imp.cd_senha%type, dt_validade_senha_p pls_conta_imp.dt_validade_senha%type, dt_autorizacao_p pls_conta_imp.dt_autorizacao%type, cd_ans_p pls_conta_imp.cd_ans%type, cd_usuario_plano_p pls_conta_imp.cd_usuario_plano%type, nm_beneficiario_p pls_conta_imp.nm_beneficiario%type, ie_recem_nascido_p pls_conta_imp.ie_recem_nascido%type, cd_cns_p pls_conta_imp.cd_cns%type,  cd_prestador_exec_p pls_conta_imp.cd_prestador_exec%type, cd_cgc_prest_exec_p pls_conta_imp.cd_cgc_prest_exec%type, cd_cpf_prest_exec_p pls_conta_imp.cd_cpf_prest_exec%type, nr_conselho_prest_exec_p pls_conta_imp.nr_conselho_prest_exec%type, cd_uf_conselho_prest_exec_p pls_conta_imp.cd_uf_conselho_prest_exec%type, cd_cnes_prest_exec_p pls_conta_imp.cd_cnes_prest_exec%type, nm_prestador_exec_p pls_conta_imp.nm_prestador_exec%type,  nr_conselho_prof_exec_p pls_conta_imp.nr_conselho_prof_exec%type, cd_conselho_prof_exec_p pls_conta_imp.cd_conselho_prof_exec%type, cd_uf_conselho_prof_exec_p pls_conta_imp.cd_uf_conselho_prof_exec%type, cd_cbo_saude_prof_exec_p pls_conta_imp.cd_cbo_saude_prof_exec%type, nm_profissional_exec_p pls_conta_imp.nm_profissional_exec%type,  cd_prestador_solic_p pls_conta_imp.cd_prestador_solic%type, cd_cgc_prest_solic_p pls_conta_imp.cd_cgc_prest_solic%type, cd_cpf_prest_solic_p pls_conta_imp.cd_cpf_prest_solic%type, cd_cnes_prest_solic_p pls_conta_imp.cd_cnes_prest_solic%type, nm_prestador_solic_p pls_conta_imp.nm_prestador_solic%type,  nr_conselho_prof_solic_p pls_conta_imp.nr_conselho_prof_solic%type, cd_conselho_prof_solic_p pls_conta_imp.cd_conselho_prof_solic%type, cd_uf_conselho_prof_solic_p pls_conta_imp.cd_uf_conselho_prof_solic%type, cd_cbo_saude_prof_solic_p pls_conta_imp.cd_cbo_saude_prof_solic%type, nm_profissional_solic_p pls_conta_imp.nm_profissional_solic%type,  ie_indicacao_acidente_p pls_conta_imp.ie_indicacao_acidente%type, ie_tipo_consulta_p pls_conta_imp.ie_tipo_consulta%type, dt_atendimento_p pls_conta_imp.dt_atendimento%type, dt_solicitacao_p pls_conta_imp.dt_solicitacao%type, ie_carater_atendimento_p pls_conta_imp.ie_carater_atendimento%type, ds_indicacao_clinica_p pls_conta_imp.ds_indicacao_clinica%type, ie_tipo_atendimento_p pls_conta_imp.ie_tipo_atendimento%type, ie_motivo_encerramento_p pls_conta_imp.ie_motivo_encerramento%type, vl_procedimentos_p pls_conta_imp.vl_procedimentos%type, vl_diarias_p pls_conta_imp.vl_diarias%type, vl_taxas_alugueis_p pls_conta_imp.vl_taxas_alugueis%type, vl_materiais_p pls_conta_imp.vl_materiais%type, vl_medicamentos_p pls_conta_imp.vl_medicamentos%type, vl_gases_medicinais_p pls_conta_imp.vl_gases_medicinais%type, vl_opme_p pls_conta_imp.vl_opme%type, vl_total_geral_p pls_conta_imp.vl_total_geral%type, vl_total_coparticipacao_p pls_conta_imp.vl_total_coparticipacao%type, ie_tipo_faturamento_p pls_conta_imp.ie_tipo_faturamento%type, dt_inicio_faturamento_p pls_conta_imp.dt_inicio_faturamento%type, dt_fim_faturamento_p pls_conta_imp.dt_fim_faturamento%type, ie_tipo_internacao_p pls_conta_imp.ie_tipo_internacao%type, ie_regime_internacao_p pls_conta_imp.ie_regime_internacao%type, dt_emissao_guia_p pls_conta_imp.dt_emissao_guia%type, ds_plano_p pls_conta_imp.ds_plano%type, ds_empresa_benef_p pls_conta_imp.ds_empresa_benef%type, nr_telefone_benef_p pls_conta_imp.nr_telefone_benef%type, nm_titular_benef_p pls_conta_imp.nm_titular_benef%type, dt_fim_tratamento_p pls_conta_imp.dt_fim_tratamento%type, ie_tipo_atend_odonto_p pls_conta_imp.ie_tipo_atend_odonto%type, qt_total_unidade_serv_p pls_conta_imp.qt_total_unidade_serv%type, ds_observacao_p pls_conta_imp.ds_observacao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_validacao_benef_tiss_p pls_conta_tiss.cd_validacao_benef_tiss%type, cd_ausencia_val_benef_tiss_p pls_conta_tiss.cd_ausencia_val_benef_tiss%type, cd_ident_biometria_benef_p pls_conta_tiss.cd_ident_biometria_benef%type, cd_template_biomet_benef_p pls_conta_tiss.cd_template_biomet_benef%type, ie_tipo_ident_benef_p pls_conta_tiss.ie_tipo_ident_benef%type, cd_assinat_digital_prest_p pls_conta_tiss.cd_assinat_digital_prest%type, nr_sequencia_p INOUT pls_conta_imp.nr_sequencia%type, ie_cobertura_especial_p pls_conta.ie_cobertura_especial%type default null, ie_regime_atendimento_p pls_conta.ie_regime_atendimento%type default null, ie_saude_ocupacional_p pls_conta.ie_saude_ocupacional%type default null) FROM PUBLIC;

