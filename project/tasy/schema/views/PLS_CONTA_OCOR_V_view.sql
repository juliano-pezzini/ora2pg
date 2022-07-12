-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_conta_ocor_v (cd_guia, cd_guia_imp, cd_guia_ref, cd_guia_referencia, cd_guia_prestador, cd_medico_executor, cd_medico_executor_imp, cd_medico_solicitante, cd_medico_solicitante_imp, cd_tiss_atendimento, cd_congenere, cd_senha, cd_senha_imp, cd_senha_externa, cd_cnes, cd_cnes_executor_imp, dt_atendimento, dt_atendimento_conta, dt_atendimento_imp, dt_atendimento_inf, dt_atendimento_imp_inf, ie_carater_internacao, ie_carater_internacao_imp, ie_glosa, ie_internacao_obstetrica, ie_internado, ie_medico_exec_informado, ie_origem_conta, ie_regime_internacao, ie_regime_internacao_imp, ie_tipo_consulta, ie_tipo_consulta_imp, ie_tipo_conta, ie_tipo_guia, ie_tipo_internado, nr_seq_clinica, nr_seq_clinica_imp, nr_seq_conselho_exec, nr_seq_conselho_solic, nr_seq_grau_partic, nr_seq_guia, nr_seq_prestador, nr_seq_prestador_exec, nr_seq_prestador_exec_imp, nr_seq_prestador_imp, nr_seq_protocolo, nr_seq_saida_int, nr_seq_saida_consulta, nr_seq_segurado, nr_seq_tipo_acomodacao, nr_seq_tipo_acomod_imp, nr_seq_tipo_atendimento, nr_seq_tipo_atend_imp, nr_sequencia, nr_seq_conta, nr_seq_nota_cobranca, dt_entrada, dt_entrada_ref, dt_entrada_trunc, dt_entrada_ref_trunc, dt_alta_ref, dt_entrada_imp, dt_entrada_imp_trunc, dt_alta, dt_alta_imp, dt_emissao, dt_emissao_imp, dt_emissao_dd, dt_emissao_imp_dd, dt_atendimento_inf_dd, dt_atendimento_imp_inf_dd, dt_atendimento_dd, dt_atendimento_conta_dd, dt_atendimento_imp_dd, cd_usuario_plano_imp, qt_nasc_mortos_imp, qt_nasc_mortos, qt_nasc_mortos_imp_num, qt_nasc_mortos_num, qt_nasc_vivos_imp_num, qt_nasc_vivos_num, qt_nasc_vivos_premat_imp_num, qt_nasc_vivos_premat_num, qt_nasc_vivos_termo, qt_nasc_vivos_termo_num, qt_nasc_vivos_total, qt_nasc_vivos_total_imp, qt_obito_precoce, qt_obito_precoce_imp, qt_obito_precoce_imp_num, qt_obito_precoce_num, qt_obito_tardio, qt_obito_tardio_imp, qt_obito_tardio_imp_num, qt_obito_tardio_num, qt_obito_total, qt_obito_total_imp, qt_nasc_total, qt_nasc_total_imp, sg_conselho_exec_imp, uf_crm_exec_imp, nr_crm_exec_imp, cd_cbo_saude_exec_imp, nr_fatura, nr_nota_cobranca, nr_seq_cbo_saude, nr_seq_cbo_saude_imp, cd_usuario_plano, nr_seq_fatura, dt_recebimento_fatura, ie_tipo_intercambio, nr_seq_congenere, ds_indicacao_clinica, ds_indicacao_clinica_imp, ie_obito_mulher, dt_postagem_fatura, dt_mes_competencia, nr_seq_guia_conta, nr_seq_guia_referencia, dt_recebimento_prot, dt_protocolo, ie_internado_imp, ie_tipo_internado_imp, ie_vinc_internado, nr_seq_prestador_req, ie_status_guia, nr_seq_prestador_exec_imp_ref, cd_guia_solic_imp, cd_estabelecimento, nr_seq_lote_conta, ie_apresentacao, nr_seq_prestador_conta, nr_seq_prestador_imp_prot, nr_seq_prestador_prot, nr_seq_grau_partic_conta, cd_cbo_saude_solic_imp, nr_seq_cbo_saude_solic, nr_seq_cbo_saude_solic_imp, dt_documento, cd_versao_tiss, dt_inicio_faturamento, dt_inicio_faturamento_imp, dt_inicio_fat_trunc, dt_inicio_fat_imp_trunc, dt_fim_faturamento, dt_fim_faturamento_imp, ie_indicador_dorn, ie_indicador_dorn_imp, ie_exige_autorizacao, ie_status_protocolo, ie_situacao_protocolo, ie_tipo_protocolo, vl_total, vl_total_imp, ds_observacao, ds_observacao_imp, dt_protocolo_imp, nr_crm_solic_imp, uf_crm_solic_imp, sg_conselho_solic_imp, nr_seq_analise, ie_recem_nascido_imp, ie_recem_nascido, nr_seq_congenere_seg, ie_tipo_atendimento_imp, cd_guia_prestador_imp, nr_seq_prestador_solic, ie_motivo_encerramento, nm_medico_solic_imp, nr_seq_conta_princ, nr_seq_segurado_prot, ie_tipo_faturamento, ie_tipo_faturamento_imp, nr_seq_prest_inter, ie_indicacao_acidente, ie_indicacao_acidente_imp, nm_medico_executor_imp, dt_alta_trunc, dt_alta_imp_trunc, tp_rede_min, ie_guia_fisica, nr_protocolo_prestador, ie_regime_atendimento, ie_saude_ocupacional, ie_cobertura_especial) AS select	-- Esta view deve ser usada nas rotinas da ocorrencia para que os tratamentos especificos das ocorrencias sejam
	-- centralizados nesta view.

	coalesce(nr_guia_tiss_operadora,cd_guia) cd_guia, --prioriza o nr_guia_tiss_operadora, pois so tera informacao nesse campo se for a500.
	cd_guia_imp,
	cd_guia_ref,
	coalesce(nr_guia_tiss_principal, cd_guia_referencia) cd_guia_referencia,
	coalesce(nr_guia_tiss_prestador, cd_guia_prestador) cd_guia_prestador,
	cd_medico_executor,
	cd_medico_executor_imp,          
	cd_medico_solicitante,           
	cd_medico_solicitante_imp,       
	cd_tiss_atendimento,   
	cd_congenere,
	cd_senha,
	cd_senha_imp,
	cd_senha_externa,
	cd_cnes,
	cd_cnes_executor_imp,
	dt_atendimento, 
	dt_atendimento dt_atendimento_conta,
	dt_atendimento_imp,
	dt_atendimento_inf,
	dt_atendimento_imp_inf,
	ie_carater_internacao,           
	ie_carater_internacao_imp,       
	ie_glosa,                        
	ie_internacao_obstetrica,
	ie_internado,    
	ie_medico_exec_informado,
	ie_origem_conta,
	ie_regime_internacao,
	ie_regime_internacao_imp,
	ie_tipo_consulta,                
	ie_tipo_consulta_imp,            
	ie_tipo_conta,
	ie_tipo_guia,                    
	ie_tipo_internado,               
	nr_seq_clinica,                  
	nr_seq_clinica_imp,              
	nr_seq_conselho_exec,            
	nr_seq_conselho_solic,           
	nr_seq_grau_partic,              
	nr_seq_guia,                     
	nr_seq_prestador,                
	nr_seq_prestador_exec,           
	nr_seq_prestador_exec_imp,       
	nr_seq_prestador_imp,            
	nr_seq_protocolo,                
	nr_seq_saida_int,
	nr_seq_saida_consulta,
	nr_seq_segurado,                 
	nr_seq_tipo_acomodacao,          
	nr_seq_tipo_acomod_imp,          
	nr_seq_tipo_atendimento,         
	nr_seq_tipo_atend_imp,           
	nr_sequencia,
	nr_sequencia nr_seq_conta,
	nr_seq_nota_cobranca,
	dt_entrada,
	dt_entrada_ref,
	dt_entrada_trunc,
	trunc(dt_entrada_ref,'dd') dt_entrada_ref_trunc,
	dt_alta_ref,
	dt_entrada_imp,
	dt_entrada_imp_trunc,
	dt_alta,
	dt_alta_imp,
	dt_emissao,
	dt_emissao_imp,
	dt_emissao_dd,
	dt_emissao_imp_dd,
	dt_atendimento_inf_dd,
	dt_atendimento_imp_inf_dd,
	dt_atendimento_dd,
	dt_atendimento_conta_dd,
	dt_atendimento_imp_dd,
	cd_usuario_plano_imp,
	qt_nasc_mortos_imp,
	qt_nasc_mortos,
	qt_nasc_mortos_imp_num,
	qt_nasc_mortos_num,
	qt_nasc_vivos_imp_num,
	qt_nasc_vivos_num,
	qt_nasc_vivos_premat_imp_num,
	qt_nasc_vivos_premat_num,
	qt_nasc_vivos_termo,
	qt_nasc_vivos_termo_num,
	qt_nasc_vivos_total,
	qt_nasc_vivos_total_imp,
	qt_obito_precoce,
	qt_obito_precoce_imp,
	qt_obito_precoce_imp_num,
	qt_obito_precoce_num,
	qt_obito_tardio,
	qt_obito_tardio_imp,
	qt_obito_tardio_imp_num,
	qt_obito_tardio_num,
	qt_obito_total,
	qt_obito_total_imp,
	qt_nasc_total,
	qt_nasc_total_imp,
	sg_conselho_exec_imp,
	uf_crm_exec_imp,
	nr_crm_exec_imp,
	cd_cbo_saude_exec_imp,
	nr_fatura,
	nr_nota_cobranca,
	nr_seq_cbo_saude,
	nr_seq_cbo_saude_imp,
	cd_usuario_plano,
	nr_seq_fatura,
	dt_recebimento_fatura,
	ie_tipo_intercambio,
	nr_seq_congenere,
	ds_indicacao_clinica,
	ds_indicacao_clinica_imp,
	ie_obito_mulher,
	dt_postagem_fatura,
	dt_mes_competencia,
	nr_seq_guia_conta,
	nr_seq_guia_referencia,
	dt_recebimento_prot,
	dt_protocolo,
	ie_internado_imp,
	ie_tipo_internado_imp,
	ie_vinc_internado,
	nr_seq_prestador_req,
	ie_status_guia,
	nr_seq_prestador_exec_imp_ref,
	cd_guia_solic_imp,
	cd_estabelecimento,
	nr_seq_lote_conta,
	ie_apresentacao,
	nr_seq_prestador_conta,
	nr_seq_prestador_imp_prot,
	nr_seq_prestador_prot,
	nr_seq_grau_partic_conta,
	cd_cbo_saude_solic_imp,
	nr_seq_cbo_saude_solic,
	nr_seq_cbo_saude_solic_imp,
	dt_documento dt_documento,
	cd_versao_tiss,
	dt_inicio_faturamento,
	dt_inicio_faturamento_imp,
	trunc(dt_inicio_faturamento,'dd') dt_inicio_fat_trunc,
	trunc(dt_inicio_faturamento_imp,'dd') dt_inicio_fat_imp_trunc,
	dt_fim_faturamento,
	dt_fim_faturamento_imp,
	ie_indicador_dorn,
	ie_indicador_dorn_imp,
	ie_exige_autorizacao, 
	ie_status_protocolo, 
	ie_situacao_protocolo,
	ie_tipo_protocolo, 
	vl_total, 
	vl_total_imp, 
	ds_observacao,
	ds_observacao_imp,
	dt_protocolo_imp, 
	nr_crm_solic_imp, 
	uf_crm_solic_imp,
	sg_conselho_solic_imp,
	nr_seq_analise,
	ie_recem_nascido_imp,
	ie_recem_nascido,
	nr_seq_congenere_seg,
	ie_tipo_atendimento_imp,
	cd_guia_prestador_imp,
	nr_seq_prestador_solic,
	ie_motivo_encerramento,
	nm_medico_solic_imp,
	nr_seq_conta_princ,
	nr_seq_segurado_prot,
	ie_tipo_faturamento,
	ie_tipo_faturamento_imp,
	nr_seq_prest_inter,
	coalesce(ie_indicacao_acidente,'%') ie_indicacao_acidente,
	coalesce(ie_indicacao_acidente_imp,'%') ie_indicacao_acidente_imp,
	nm_medico_executor_imp,
	dt_alta_trunc,
	dt_alta_imp_trunc,
	tp_rede_min,
	ie_guia_fisica,
	nr_protocolo_prestador,
	ie_regime_atendimento,
	ie_saude_ocupacional,
	ie_cobertura_especial
FROM	pls_conta_v

where	ie_status in ('A', 'F', 'L', 'P', 'U');

