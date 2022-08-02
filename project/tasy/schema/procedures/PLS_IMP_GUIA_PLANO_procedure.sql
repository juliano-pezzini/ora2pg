-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_imp_guia_plano ( cd_ans_p pls_guia_plano_imp.cd_ans%type, cd_cbo_saude_p pls_guia_plano_imp.cd_cbo_saude%type, cd_cgc_prest_solic_p pls_guia_plano_imp.cd_cgc_prest_solic%type, cd_cgc_prest_exec_p pls_guia_plano_imp.cd_cgc_prest_exec%type, cd_cns_p pls_guia_plano_imp.cd_cns%type, cd_conselho_prof_solic_p pls_guia_plano_imp.cd_conselho_prof_solic%type, cd_cnes_prest_exec_p pls_guia_plano_imp.cd_cnes_prest_exec%type, cd_cpf_prest_solic_p pls_guia_plano_imp.cd_cpf_prest_solic%type, cd_guia_prestador_p pls_guia_plano_imp.cd_guia_prestador%type, cd_guia_principal_p pls_guia_plano_imp.cd_guia_principal%type, cd_prestador_exec_p pls_guia_plano_imp.cd_prestador_exec%type, cd_prestador_solic_p pls_guia_plano_imp.cd_prestador_solic%type, cd_tipo_acomodacao_p pls_guia_plano_imp.cd_tipo_acomodacao%type, cd_uf_conselho_prof_solic_p pls_guia_plano_imp.cd_uf_conselho_prof_solic%type, cd_usuario_plano_p pls_guia_plano_imp.cd_usuario_plano%type, cd_versao_p pls_guia_plano_imp.cd_versao%type, ds_indicacao_clinica_p pls_guia_plano_imp.ds_indicacao_clinica%type, ds_observacao_p pls_guia_plano_imp.ds_observacao%type, dt_solicitacao_p pls_guia_plano_imp.dt_solicitacao%type, dt_sugerida_internacao_p pls_guia_plano_imp.dt_sugerida_internacao%type, ie_anexo_guia_p pls_guia_plano_imp.ie_anexo_guia%type, ie_carater_atendimento_p pls_guia_plano_imp.ie_carater_atendimento%type, ie_indicacao_opm_p pls_guia_plano_imp.ie_indicacao_opm%type, ie_indicacao_quimio_p pls_guia_plano_imp.ie_indicacao_quimio%type, ie_recem_nascido_p pls_guia_plano_imp.ie_recem_nascido%type, ie_regime_internacao_p pls_guia_plano_imp.ie_regime_internacao%type, ie_tipo_internacao_p pls_guia_plano_imp.ie_tipo_internacao%type, ie_tipo_guia_p pls_guia_plano.ie_tipo_guia%type, nm_beneficiario_p pls_guia_plano_imp.nm_beneficiario%type, nm_prestador_exec_p pls_guia_plano_imp.nm_prestador_exec%type, nm_prestador_solic_p pls_guia_plano_imp.nm_prestador_solic%type, nm_profissional_solic_p pls_guia_plano_imp.nm_profissional_solic%type, nm_usuario_p pls_guia_plano_imp.nm_usuario%type, nr_conselho_prof_solic_p pls_guia_plano_imp.nr_conselho_prof_solic%type, nr_sequencia_p pls_guia_plano_imp.nr_sequencia%type, qt_diaria_solic_p pls_guia_plano_imp.qt_diaria_solic%type, ie_tipo_ident_benef_p pls_guia_plano_imp.ie_tipo_ident_benef%type, cd_ident_biometria_benef_p pls_guia_plano_imp.cd_ident_biometria_benef%type, cd_template_biomet_benef_p pls_guia_plano_imp.cd_template_biomet_benef%type, cd_ausencia_val_benef_tiss_p pls_guia_plano_imp.cd_ausencia_val_benef_tiss%type, cd_validacao_benef_tiss_p pls_guia_plano_imp.cd_validacao_benef_tiss%type, ie_etapa_autorizacao_p pls_guia_plano_imp.ie_etapa_autorizacao%type, nr_seq_guia_plano_imp_p INOUT pls_guia_plano_imp.nr_sequencia%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Importar as informações referente a guia enviada no pedido de 
Solicitação de Procedimento via WebService
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [  x] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
				
nr_seq_guia_plano_imp_w		pls_guia_plano_imp.nr_sequencia%type;



BEGIN

select	nextval('pls_guia_plano_imp_seq')
into STRICT	nr_seq_guia_plano_imp_w
;

insert into pls_guia_plano_imp(	nr_sequencia, nr_seq_guia_plano, cd_ans,
					cd_cbo_saude, cd_cgc_prest_solic, cd_cns,					
					cd_conselho_prof_solic, cd_cpf_prest_solic, cd_guia_prestador,
					cd_guia_principal, cd_prestador_exec, cd_prestador_solic,
					cd_tipo_acomodacao, cd_uf_conselho_prof_solic, cd_usuario_plano,
					ds_indicacao_clinica, ds_observacao, dt_atualizacao,
					dt_atualizacao_nrec, dt_solicitacao, dt_sugerida_internacao,
					ie_carater_atendimento, ie_indicacao_opm, ie_indicacao_quimio,
					ie_recem_nascido, ie_regime_internacao, ie_tipo_internacao,
					nm_beneficiario, nm_prestador_exec, nm_prestador_solic,
					nm_profissional_solic, nm_usuario, nm_usuario_nrec,
					nr_conselho_prof_solic, qt_diaria_solic, ie_tipo_guia, 
					cd_versao, cd_cgc_prest_exec, ie_anexo_guia,
					dt_importacao, ie_status, ie_tipo_ident_benef, cd_ident_biometria_benef,
					cd_template_biomet_benef, cd_ausencia_val_benef_tiss,cd_validacao_benef_tiss,
					ie_etapa_autorizacao)
			values (		nr_seq_guia_plano_imp_w, null, cd_ans_p,                          
					cd_cbo_saude_p, cd_cgc_prest_solic_p, cd_cns_p,					
					cd_conselho_prof_solic_p, cd_cpf_prest_solic_p, cd_guia_prestador_p,
					cd_guia_principal_p, cd_prestador_exec_p, cd_prestador_solic_p,
					cd_tipo_acomodacao_p, cd_uf_conselho_prof_solic_p, cd_usuario_plano_p,
					ds_indicacao_clinica_p, ds_observacao_p, clock_timestamp(),
					clock_timestamp(), dt_solicitacao_p, dt_sugerida_internacao_p,
					ie_carater_atendimento_p, ie_indicacao_opm_p, ie_indicacao_quimio_p,
					ie_recem_nascido_p, ie_regime_internacao_p, ie_tipo_internacao_p,
					nm_beneficiario_p, nm_prestador_exec_p, nm_prestador_solic_p,
					nm_profissional_solic_p, nm_usuario_p, nm_usuario_p,
					nr_conselho_prof_solic_p, qt_diaria_solic_p, ie_tipo_guia_p, 
					cd_versao_p, cd_cgc_prest_exec_p, ie_anexo_guia_p,
					clock_timestamp(), 3, ie_tipo_ident_benef_p, cd_ident_biometria_benef_p,
					cd_template_biomet_benef_p, cd_ausencia_val_benef_tiss_p,cd_validacao_benef_tiss_p,
					ie_etapa_autorizacao_p);

commit;

nr_seq_guia_plano_imp_p := nr_seq_guia_plano_imp_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_guia_plano ( cd_ans_p pls_guia_plano_imp.cd_ans%type, cd_cbo_saude_p pls_guia_plano_imp.cd_cbo_saude%type, cd_cgc_prest_solic_p pls_guia_plano_imp.cd_cgc_prest_solic%type, cd_cgc_prest_exec_p pls_guia_plano_imp.cd_cgc_prest_exec%type, cd_cns_p pls_guia_plano_imp.cd_cns%type, cd_conselho_prof_solic_p pls_guia_plano_imp.cd_conselho_prof_solic%type, cd_cnes_prest_exec_p pls_guia_plano_imp.cd_cnes_prest_exec%type, cd_cpf_prest_solic_p pls_guia_plano_imp.cd_cpf_prest_solic%type, cd_guia_prestador_p pls_guia_plano_imp.cd_guia_prestador%type, cd_guia_principal_p pls_guia_plano_imp.cd_guia_principal%type, cd_prestador_exec_p pls_guia_plano_imp.cd_prestador_exec%type, cd_prestador_solic_p pls_guia_plano_imp.cd_prestador_solic%type, cd_tipo_acomodacao_p pls_guia_plano_imp.cd_tipo_acomodacao%type, cd_uf_conselho_prof_solic_p pls_guia_plano_imp.cd_uf_conselho_prof_solic%type, cd_usuario_plano_p pls_guia_plano_imp.cd_usuario_plano%type, cd_versao_p pls_guia_plano_imp.cd_versao%type, ds_indicacao_clinica_p pls_guia_plano_imp.ds_indicacao_clinica%type, ds_observacao_p pls_guia_plano_imp.ds_observacao%type, dt_solicitacao_p pls_guia_plano_imp.dt_solicitacao%type, dt_sugerida_internacao_p pls_guia_plano_imp.dt_sugerida_internacao%type, ie_anexo_guia_p pls_guia_plano_imp.ie_anexo_guia%type, ie_carater_atendimento_p pls_guia_plano_imp.ie_carater_atendimento%type, ie_indicacao_opm_p pls_guia_plano_imp.ie_indicacao_opm%type, ie_indicacao_quimio_p pls_guia_plano_imp.ie_indicacao_quimio%type, ie_recem_nascido_p pls_guia_plano_imp.ie_recem_nascido%type, ie_regime_internacao_p pls_guia_plano_imp.ie_regime_internacao%type, ie_tipo_internacao_p pls_guia_plano_imp.ie_tipo_internacao%type, ie_tipo_guia_p pls_guia_plano.ie_tipo_guia%type, nm_beneficiario_p pls_guia_plano_imp.nm_beneficiario%type, nm_prestador_exec_p pls_guia_plano_imp.nm_prestador_exec%type, nm_prestador_solic_p pls_guia_plano_imp.nm_prestador_solic%type, nm_profissional_solic_p pls_guia_plano_imp.nm_profissional_solic%type, nm_usuario_p pls_guia_plano_imp.nm_usuario%type, nr_conselho_prof_solic_p pls_guia_plano_imp.nr_conselho_prof_solic%type, nr_sequencia_p pls_guia_plano_imp.nr_sequencia%type, qt_diaria_solic_p pls_guia_plano_imp.qt_diaria_solic%type, ie_tipo_ident_benef_p pls_guia_plano_imp.ie_tipo_ident_benef%type, cd_ident_biometria_benef_p pls_guia_plano_imp.cd_ident_biometria_benef%type, cd_template_biomet_benef_p pls_guia_plano_imp.cd_template_biomet_benef%type, cd_ausencia_val_benef_tiss_p pls_guia_plano_imp.cd_ausencia_val_benef_tiss%type, cd_validacao_benef_tiss_p pls_guia_plano_imp.cd_validacao_benef_tiss%type, ie_etapa_autorizacao_p pls_guia_plano_imp.ie_etapa_autorizacao%type, nr_seq_guia_plano_imp_p INOUT pls_guia_plano_imp.nr_sequencia%type) FROM PUBLIC;

