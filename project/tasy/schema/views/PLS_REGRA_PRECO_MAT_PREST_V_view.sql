-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_regra_preco_mat_prest_v (nr_sequencia, cd_estabelecimento, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_prestador, dt_inicio_vigencia, dt_fim_vigencia, tx_ajuste, ie_situacao, vl_negociado, tx_ajuste_pfb, tx_ajuste_pmc_neut, tx_ajuste_pmc_pos, tx_ajuste_pmc_neg, tx_ajuste_simpro_pfb, tx_ajuste_simpro_pmc, ie_origem_preco, ie_tipo_despesa, nr_seq_material_preco, tx_ajuste_tab_propria, ie_tipo_tabela, nr_seq_outorgante, nr_seq_contrato, tx_ajuste_benef_lib, nr_seq_congenere, nr_seq_regra_ant, ds_observacao, nr_seq_plano, ie_tipo_vinculo, nr_seq_classificacao, nr_seq_grupo_prestador, ie_tipo_contratacao, ie_preco, ie_tipo_segurado, nr_seq_grupo_contrato, nr_seq_grupo_produto, nr_seq_material, nr_seq_estrutura_mat, ie_tabela_adicional, cd_material, sg_uf_operadora_intercambio, ie_tipo_intercambio, cd_convenio, cd_categoria, nr_seq_categoria, nr_seq_tipo_acomodacao, nr_seq_tipo_atendimento, nr_seq_clinica, nr_seq_tipo_prestador, ie_tipo_guia, dt_base_fixo, ie_generico_unimed, nr_seq_grupo_uf, nr_seq_tipo_uso, ie_mat_autorizacao_esp, cd_prestador, nr_seq_grupo_material, ie_internado, nr_contrato, nr_seq_congenere_prot, ie_pcmso, ie_tipo_preco_simpro, ie_tipo_preco_brasindice, nr_seq_regra_mat_ref, ie_tipo_acomodacao_ptu, nr_seq_grupo_operadora, ie_tipo_ajuste_pfb, vl_pfb_neutra_simpro, vl_pfb_positiva_simpro, vl_pfb_negativa_simpro, vl_pfb_nao_aplicavel_simpro, vl_pfb_neutra_brasindice, vl_pfb_positiva_brasindice, vl_pfb_negativa_brasindice, nr_seq_intercambio, cd_especialidade_prest, ie_cooperado, ds_regra, ie_nao_gera_tx_inter, ie_tipo_prestador, cd_prestador_prot, nr_seq_tipo_prestador_prot, nr_seq_regra_atend_cart, ie_origem_protocolo, ie_atend_pcmso, ie_ref_guia_internacao, nr_seq_prestador_inter, ie_tipo_preco_tab_adic, cd_versao_tiss, cd_prestador_solic, ie_acomodacao_autorizada, ie_restringe_hosp, nr_seq_tipo_atend_princ, ie_tipo_atendimento, nr_seq_grupo_ajuste, pr_icms, nr_seq_mot_reembolso, ie_med_oncologico, qt_idade_inicial, qt_idade_final, ie_utilizar_duas_casas, ie_ult_valor_fabrica, ie_gerar_remido, nr_seq_tipo_conta, ie_regime_atendimento, ie_saude_ocupacional, ie_regime_atendimento_princ) AS select	a.nr_sequencia,
	a.cd_estabelecimento,
	a.dt_atualizacao,
	a.nm_usuario,
	a.dt_atualizacao_nrec,
	a.nm_usuario_nrec,
	a.nr_seq_prestador,
	a.dt_inicio_vigencia,
	a.dt_fim_vigencia,
	a.tx_ajuste,
	a.ie_situacao,
	a.vl_negociado,
	a.tx_ajuste_pfb,
	a.tx_ajuste_pmc_neut,
	a.tx_ajuste_pmc_pos,
	a.tx_ajuste_pmc_neg,
	a.tx_ajuste_simpro_pfb,
	a.tx_ajuste_simpro_pmc,
	a.ie_origem_preco,
	a.ie_tipo_despesa,
	a.nr_seq_material_preco,
	a.tx_ajuste_tab_propria,
	a.ie_tipo_tabela,
	a.nr_seq_outorgante,
	a.nr_seq_contrato,
	a.tx_ajuste_benef_lib,
	a.nr_seq_congenere,
	a.nr_seq_regra_ant,
	a.ds_observacao,
	a.nr_seq_plano,
	a.ie_tipo_vinculo,
	a.nr_seq_classificacao,
	a.nr_seq_grupo_prestador,
	a.ie_tipo_contratacao,
	a.ie_preco,
	a.ie_tipo_segurado,
	a.nr_seq_grupo_contrato,
	a.nr_seq_grupo_produto,
	a.nr_seq_material,
	a.nr_seq_estrutura_mat,
	a.ie_tabela_adicional,
	a.cd_material,
	a.sg_uf_operadora_intercambio,
	a.ie_tipo_intercambio,
	a.cd_convenio,
	a.cd_categoria,
	a.nr_seq_categoria,
	a.nr_seq_tipo_acomodacao,
	a.nr_seq_tipo_atendimento,
	a.nr_seq_clinica,
	a.nr_seq_tipo_prestador,
	a.ie_tipo_guia,
	a.dt_base_fixo,
	a.ie_generico_unimed,
	a.nr_seq_grupo_uf,
	a.nr_seq_tipo_uso,
	a.ie_mat_autorizacao_esp,
	a.cd_prestador,
	a.nr_seq_grupo_material,
	a.ie_internado,
	a.nr_contrato,
	a.nr_seq_congenere_prot,
	a.ie_pcmso,
	a.ie_tipo_preco_simpro,
	a.ie_tipo_preco_brasindice,
	a.nr_seq_regra_mat_ref,
	a.ie_tipo_acomodacao_ptu,
	a.nr_seq_grupo_operadora,
	a.ie_tipo_ajuste_pfb,
	a.vl_pfb_neutra_simpro,
	a.vl_pfb_positiva_simpro,
	a.vl_pfb_negativa_simpro,
	a.vl_pfb_nao_aplicavel_simpro,
	a.vl_pfb_neutra_brasindice,
	a.vl_pfb_positiva_brasindice,
	a.vl_pfb_negativa_brasindice,
	a.nr_seq_intercambio,
	a.cd_especialidade_prest,
	a.ie_cooperado,
	a.ds_regra,
	a.ie_nao_gera_tx_inter,
	a.ie_tipo_prestador,
	a.cd_prestador_prot,
	a.nr_seq_tipo_prestador_prot,
	a.nr_seq_regra_atend_cart,
	a.ie_origem_protocolo,
	a.ie_atend_pcmso,
	a.ie_ref_guia_internacao,
	a.nr_seq_prestador_inter,
	a.ie_tipo_preco_tab_adic,
	a.cd_versao_tiss,
	a.cd_prestador_solic,
        a.ie_acomodacao_autorizada,
	a.ie_restringe_hosp,
	a.nr_seq_tipo_atend_princ,
	a.ie_tipo_atendimento,
	a.nr_seq_grupo_ajuste,
	a.pr_icms,
	a.nr_seq_mot_reembolso,
	a.ie_med_oncologico,
	a.qt_idade_inicial,
	a.qt_idade_final,
	a.ie_utilizar_duas_casas,
	a.ie_ult_valor_fabrica,
	a.ie_gerar_remido,
	a.nr_seq_tipo_conta,	
	a.ie_regime_atendimento,
	a.ie_saude_ocupacional,
	a.ie_regime_atendimento_princ
FROM	pls_regra_preco_mat a
where	a.ie_situacao =  'A' 
and	a.ie_tipo_tabela = 'P';

