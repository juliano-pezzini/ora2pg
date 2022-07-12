-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_conta_mat_v (nr_sequencia, nr_seq_conta, nr_seq_material, ie_tipo_despesa, ie_tipo_despesa_imp, dt_inicio_atend, dt_inicio_atend_imp, dt_fim_atend, dt_fim_atend_imp, ie_status, ie_coparticipacao, nr_seq_regra, nr_seq_regra_valor, nr_seq_regra_tx_inter, ie_status_pagamento, ie_origem_preco, nr_seq_pacote, ie_valor_base, nr_seq_evento, nr_seq_evento_prod, nr_seq_grupo_ans, nr_protocolo_prestador, nr_seq_prot_referencia, nr_seq_periodo_pgto, dt_lib_pagamento, cd_guia_prestador, nr_seq_competencia, ie_glosa, dt_atendimento_imp, cd_material_inf, vl_material_ptu, vl_saldo, nr_seq_contrato, nr_seq_prestador_exec_imp_ref, nr_seq_congenere_prot, nr_seq_clas_prest_exec, cd_pessoa_fisica_prest, nr_seq_prestador_prot, nr_seq_guia, ie_origem_conta, nr_seq_prestador_exec, nr_seq_prestador_exec_imp, nr_seq_segurado, cd_medico_executor, cd_medico_executor_imp, cd_guia_referencia, cd_guia_solic_imp, cd_guia_imp, ie_tipo_conta, cd_congenere, nr_nota_cobranca, nr_fatura, nr_seq_fatura, nr_seq_congenere, ie_status_conta, ie_status_protocolo, nr_seq_lote_conta, nr_seq_protocolo, nr_nota_fiscal, cd_prestador_exec, dt_atendimento_conta, dt_postagem_fatura, dt_recebimento_fatura, cd_cooperativa, ie_tipo_intercambio, dt_alta_conta, ie_tipo_guia, nr_seq_plano_conta, cd_cgc_conta, cd_pessoa_fisica_conta, qt_idade_benef_dia, qt_idade_benef_mes, qt_idade_benef, ie_internado, ie_vinc_internado, dt_mes_competencia, ie_tipo_segurado, ie_tipo_contratacao_benef, ie_segmentacao_benef, ie_glosa_conta, ie_tipo_protocolo, cd_doenca_dig_conta, dt_nascimento_benef, ie_sexo_benef, nr_seq_cbo_saude, qt_nasc_vivos_total_conta, nr_seq_tipo_atendimento, ie_regime_internacao, nr_seq_clinica, ie_situacao_protocolo, cd_estabelecimento_prot, cd_estabelecimento, cd_guia, ie_status_guia, ie_situacao_prest_prot, ie_situacao_prest_solic, ie_tipo_relacao_prest_prot, ie_tipo_relacao_prest_exec, nr_seq_tipo_prest_exec, cd_cgc_prest_prot, cd_pessoa_fisica_prest_prot, nr_seq_tipo_prest_prot, dt_mes_competencia_trunc, ie_preco_pre_pos_misto, nr_seq_guia_referencia, nr_documento, qt_horas_atendimento_conta, dt_entrada_conta, ie_apresentacao, ie_regime_internacao_imp, ie_tipo_internado, ie_carater_internacao, ie_carater_internacao_imp, ie_tipo_consulta, ie_tipo_consulta_imp, nr_seq_saida_int, nr_seq_clinica_imp, ie_internacao_obstetrica, ie_internado_imp, nr_seq_tipo_acomodacao, nr_seq_tipo_acomod_imp, nr_seq_tipo_atend_imp, nr_seq_prestador_imp, nr_seq_prestador_conta, nr_seq_prestador_imp_prot, cd_medico_solicitante_imp, cd_medico_solicitante, nr_seq_conselho_solic, nr_seq_grau_partic_conta, nr_seq_conselho_exec, cd_cid_principal_conta, cd_cat_cid_principal_conta, dt_atendimento_imp_trunc, dt_atendimento_imp_hh, dt_atendimento_imp_min, dt_dia_semana_imp, dt_inicio_atend_mat_imp, dt_fim_atend_mat_imp, dt_atendimento, dt_atendimento_hh, dt_atendimento_min, dt_atendimento_trunc, dt_dia_semana, dt_inicio_atend_mat, dt_fim_atend_mat, tx_intercambio_imp, tx_intercambio, nr_seq_prest_fornec, nr_seq_prest_fornec_imp, nr_seq_prest_fornec_mat, vl_unitario_imp, vl_taxa_material_imp, vl_taxa_material, vl_glosa, vl_glosa_taxa_material, vl_unitario, vl_liberado, vl_material, vl_material_imp, vl_calculado_ant, qt_material, qt_material_imp, qt_material_imp_orig, vl_lib_taxa_material, hr_inicio_mat, hr_inicio_mat_imp, hr_fim_mat, hr_fim_mat_imp, ie_status_pagamento_calculado, vl_ok, qt_ok, cd_material, ds_material, nr_seq_estrut_princ, nr_seq_tipo_uso, dt_atendimento_real, nr_seq_congenere_seg, cd_prestador_prot, nr_seq_clas_prest_prot, ie_tipo_vinculo_prest_prot, nr_seq_regra_acao_reemb, ie_origem_protocolo, ie_indicador_dorn, ie_indicador_dorn_imp, ie_acao_analise, cd_unidade_medida, cd_tipo_tabela_imp, nr_seq_analise, dt_emissao_conta, dt_autorizacao_conta, ie_regra_data_preco_mat_exec, vl_total_sem_taxa_int, vl_total_sem_taxa_int_imp, cd_versao_tiss, ie_recem_nascido_imp, ie_recem_nascido, ie_alto_custo, nr_seq_prest_inter, ie_cobranca_prevista, ie_cobranca_prevista_inf, cd_prestador_solic, nr_seq_prestador_solic, ie_vl_apresentado_sistema, ie_tipo_atendimento_reemb, nr_seq_regra_conta_auto, nr_seq_regra_pct_fat, ie_pacote_ptu, nr_seq_mot_reembolso, cd_cnes, cd_cnes_executor_imp, nr_seq_mat_ref, nr_seq_conta_referencia, tp_rede_min, ie_tipo_faturamento_imp, cd_guia_ref, nr_seq_cbo_saude_solic, ie_guia_fisica, nr_lote_contabil_prov, ie_tipo_faturamento, vl_apresentado_xml, ds_material_imp, cd_material_imp, ie_origem_preco_imp, dt_atendimento_referencia, nr_seq_prestador_exec_princ, dt_fim_consistencia, ie_vl_apres_sist_regra, ie_regime_atendimento, ie_saude_ocupacional) AS select	/* Campos da tabela */

	a.nr_sequencia,
	a.nr_seq_conta,
	a.nr_seq_material,
	a.ie_tipo_despesa,
	a.ie_tipo_despesa_imp,
	a.dt_inicio_atend,
	a.dt_inicio_atend_imp,
	a.dt_fim_atend,
	a.dt_fim_atend_imp,
	a.ie_status,
	a.ie_coparticipacao,
	a.nr_seq_regra,
	a.nr_seq_regra_valor,
	a.nr_seq_regra_tx_inter,
	a.ie_status_pagamento,
	a.ie_origem_preco,
	a.nr_seq_pacote,
	a.ie_valor_base,
	a.nr_seq_evento,
	a.nr_seq_evento_prod,
	a.nr_seq_grupo_ans,
	b.nr_protocolo_prestador,
	b.nr_seq_prot_referencia,
	b.nr_seq_periodo_pgto,
	b.dt_lib_pagamento,
	b.cd_guia_prestador,
	b.nr_seq_competencia,
	coalesce(a.ie_glosa, 'N') ie_glosa,
	a.dt_atendimento_imp_referencia dt_atendimento_imp,
	a.cd_material cd_material_inf,
	a.vl_material_ptu,
	coalesce(a.vl_saldo, 0 ) vl_saldo,
	b.nr_seq_contrato,
	b.nr_seq_prestador_exec_imp_ref,
	b.nr_seq_congenere_prot,
	b.nr_seq_clas_prest_exec,
	b.cd_pessoa_fisica_prest,
	b.nr_seq_prestador_prot,
	b.nr_seq_guia,
	b.ie_origem_conta,
	b.nr_seq_prestador_exec,
	b.nr_seq_prestador_exec_imp,
	b.nr_seq_segurado,
	b.cd_medico_executor,
	b.cd_medico_executor_imp,
	b.cd_guia_referencia,
	b.cd_guia_solic_imp,
	b.cd_guia_imp,
	b.ie_tipo_conta,
	b.cd_congenere,
	b.nr_nota_cobranca,
	b.nr_fatura,
	b.nr_seq_fatura,
	b.nr_seq_congenere,
	b.ie_status ie_status_conta,
	b.ie_status_protocolo,
	b.nr_seq_lote_conta,
	b.nr_seq_protocolo,
	a.nr_nota_fiscal,
	b.cd_prestador_exec,
	b.dt_atendimento dt_atendimento_conta,
	b.dt_postagem_fatura,
	b.dt_recebimento_fatura,
	b.cd_cooperativa,
	b.ie_tipo_intercambio,
	b.dt_alta dt_alta_conta,
	b.ie_tipo_guia,
	b.nr_seq_plano_conta,
	b.cd_cgc_conta,
	b.cd_pessoa_fisica_conta,
	b.qt_idade_benef_dia,
	b.qt_idade_benef_mes,
	b.qt_idade_benef,
	b.ie_internado,
	b.ie_vinc_internado,
	b.dt_mes_competencia,
	b.ie_tipo_segurado,
	b.ie_tipo_contratacao_benef,
	b.ie_segmentacao_benef,
	b.ie_glosa ie_glosa_conta,
	b.ie_tipo_protocolo,
	b.cd_doenca_dig cd_doenca_dig_conta,
	b.dt_nascimento_benef,
	b.ie_sexo_benef,
	b.nr_seq_cbo_saude,
	b.qt_nasc_vivos_total qt_nasc_vivos_total_conta,
	b.nr_seq_tipo_atendimento,
	b.ie_regime_internacao,
	b.nr_seq_clinica,
	b.ie_situacao_protocolo,
	b.cd_estabelecimento_prot,
	b.cd_estabelecimento,
	b.cd_guia,
	b.ie_status_guia,
	b.ie_situacao_prest_prot,
	b.ie_situacao_prest_solic,
	b.ie_tipo_relacao_prest_prot,
	b.ie_tipo_relacao_prest_exec,
	b.nr_seq_tipo_prest_exec,
	b.cd_cgc_prest_prot,
	b.cd_pessoa_fisica_prest_prot,
	b.nr_seq_tipo_prest_prot,
	b.dt_mes_competencia_trunc,
	b.ie_preco_pre_pos_misto,
	b.nr_seq_guia_referencia,
	b.nr_documento,
	b.qt_horas_atendimento qt_horas_atendimento_conta,
	b.dt_entrada dt_entrada_conta,
	b.ie_apresentacao,
	b.ie_regime_internacao_imp,
	b.ie_tipo_internado,
	b.ie_carater_internacao,
	b.ie_carater_internacao_imp,
	b.ie_tipo_consulta,
	b.ie_tipo_consulta_imp,
	b.nr_seq_saida_int,
	b.nr_seq_clinica_imp,
	b.ie_internacao_obstetrica,
	b.ie_internado_imp,
	b.nr_seq_tipo_acomodacao,
	b.nr_seq_tipo_acomod_imp,
	b.nr_seq_tipo_atend_imp,
	b.nr_seq_prestador_imp,
	b.nr_seq_prestador_conta,
	b.nr_seq_prestador_imp_prot,
	b.cd_medico_solicitante_imp,
	b.cd_medico_solicitante,
	b.nr_seq_conselho_solic,
	b.nr_seq_grau_partic_conta,
	b.nr_seq_conselho_exec,
	b.cd_cid_principal cd_cid_principal_conta,
	b.cd_cat_cid_principal  cd_cat_cid_principal_conta,
	trunc(a.dt_atendimento_imp_referencia, 'dd') dt_atendimento_imp_trunc,
	trunc(a.dt_atendimento_imp_referencia, 'hh') dt_atendimento_imp_hh,
	trunc(a.dt_atendimento_imp_referencia, 'mi') dt_atendimento_imp_min,
	(to_char(a.dt_atendimento_imp_referencia,'d'))::numeric  dt_dia_semana_imp,
	pls_manipulacao_datas_pck.obter_data_mais_hora(a.dt_atendimento_imp_referencia, a.dt_inicio_atend_imp) dt_inicio_atend_mat_imp,
	pls_manipulacao_datas_pck.obter_data_mais_hora(a.dt_atendimento_imp_referencia, a.dt_fim_atend_imp) dt_fim_atend_mat_imp,
	-- Data de atendimento do material. Este campo e alimentado via trigger. E nela que esta a regra de negocio para decidir qual e a data correta

	a.dt_atendimento_referencia dt_atendimento,
	trunc(a.dt_atendimento_referencia, 'hh') dt_atendimento_hh,
	trunc(a.dt_atendimento_referencia, 'mi') dt_atendimento_min,
	trunc(a.dt_atendimento_referencia, 'dd') dt_atendimento_trunc,
	(to_char(a.dt_atendimento_referencia,'d'))::numeric  dt_dia_semana,
	pls_manipulacao_datas_pck.obter_data_mais_hora(a.dt_atendimento_referencia, a.dt_inicio_atend) dt_inicio_atend_mat,
	pls_manipulacao_datas_pck.obter_data_mais_hora(a.dt_atendimento_referencia, a.dt_fim_atend) dt_fim_atend_mat,
	coalesce(a.tx_intercambio_imp,0) tx_intercambio_imp,
	coalesce(a.tx_intercambio,0) tx_intercambio,
	coalesce(a.nr_seq_prest_fornec, b.nr_seq_prestador_exec) nr_seq_prest_fornec,
	coalesce(a.nr_seq_prest_fornec, b.nr_seq_prestador_exec_imp_ref) nr_seq_prest_fornec_imp,
	a.nr_seq_prest_fornec nr_seq_prest_fornec_mat,
	coalesce(a.vl_unitario_imp, 0) vl_unitario_imp,
	coalesce(a.vl_taxa_material_imp, 0) vl_taxa_material_imp,
	coalesce(a.vl_taxa_material, 0) vl_taxa_material,
	coalesce(a.vl_glosa, 0) vl_glosa,
	coalesce(a.vl_glosa_taxa_material, 0) vl_glosa_taxa_material,
	coalesce(a.vl_unitario, 0) vl_unitario,
	coalesce(a.vl_liberado, 0) vl_liberado,
	coalesce(a.vl_material,0) vl_material,
	coalesce(a.vl_material_imp,0) vl_material_imp,
	coalesce(a.vl_calculado_ant, 0) vl_calculado_ant,
	round((coalesce(a.qt_material, 0))::numeric, 2) qt_material,
	round((coalesce(a.qt_material_imp, 0))::numeric, 2) qt_material_imp,
	a.qt_material_imp qt_material_imp_orig,
	round((coalesce(a.vl_lib_taxa_material,0))::numeric,2) vl_lib_taxa_material,    
	to_date(to_char(a.dt_inicio_atend,'hh24:mi:ss'),'hh24:mi:ss') hr_inicio_mat,
	to_date(to_char(a.dt_inicio_atend_imp,'hh24:mi:ss'),'hh24:mi:ss') hr_inicio_mat_imp,
	to_date(to_char(a.dt_fim_atend,'hh24:mi:ss'),'hh24:mi:ss') hr_fim_mat,
	to_date(to_char(a.dt_fim_atend_imp,'hh24:mi:ss'),'hh24:mi:ss') hr_fim_mat_imp,
	-- estes arredondamentos foram feitos porque na autorizacao/requisicao se trabalha com tres casas de precisao e na nova especificacao do TISS foi colocada apenas duas casas.

	pls_obter_stat_pag_item(a.ie_glosa, a.vl_liberado, a.vl_glosa) ie_status_pagamento_calculado,
	pls_obter_vl_valido_item( 'M', null, a.vl_material_imp, a.vl_material, a.vl_liberado, null, null, a.ie_status, 'VL') vl_ok,
	pls_obter_vl_valido_item( 'M', null, null, null, null, a.qt_material_imp, a.qt_material, a.ie_status,  'QT') qt_ok,
	(select	coalesce(x.cd_material_ops, x.cd_material)
	FROM	pls_material x
	where	x.nr_sequencia = a.nr_seq_material) cd_material,
	(select x.ds_material 
	from pls_material x
	where x.nr_sequencia = a.nr_seq_material) ds_material,
	-- A estrutura principal, a pai, da estrutura a qual o material esta vinculado.

	(select	max(x.nr_seq_estrutura)
	from	pls_estrutura_material_v x
	where	x.nr_seq_estrut_superior is null
	and	x.nr_seq_material = a.nr_seq_material) nr_seq_estrut_princ,
	(select x.nr_seq_tipo_uso
	from pls_material x
	where x.nr_sequencia = a.nr_seq_material) nr_seq_tipo_uso,
	a.dt_atendimento dt_atendimento_real,
	b.nr_seq_congenere_seg,
	b.cd_prestador_prot,
	b.nr_seq_clas_prest_prot,
	b.ie_tipo_vinculo_prest_prot,
	a.nr_seq_regra_acao_reemb,
	b.ie_origem_protocolo,
	b.ie_indicador_dorn,
	b.ie_indicador_dorn_imp,
	a.ie_acao_analise,
	a.cd_unidade_medida,
	a.cd_tipo_tabela_imp,
	b.nr_seq_analise,
	b.dt_emissao dt_emissao_conta,
	b.dt_autorizacao dt_autorizacao_conta,
	b.ie_regra_data_preco_mat_exec,
	(coalesce(a.vl_material, 0) - coalesce(a.vl_taxa_material, 0)) vl_total_sem_taxa_int,
	(coalesce(a.vl_material_imp, 0) - coalesce(a.vl_taxa_material_imp, 0)) vl_total_sem_taxa_int_imp,
	b.cd_versao_tiss,
	b.ie_recem_nascido_imp,
	b.ie_recem_nascido,
	a.ie_alto_custo,
	b.nr_seq_prest_inter,
	a.ie_cobranca_prevista,
	a.ie_cobranca_prevista_inf,
	b.cd_prestador_solic,
	b.NR_SEQ_PRESTADOR_SOLIC,
	coalesce(a.ie_vl_apresentado_sistema,'N') ie_vl_apresentado_sistema,
	b.ie_tipo_atendimento_reemb,
	b.nr_seq_regra_conta_auto,
	a.nr_seq_regra_pct_fat,
	a.ie_pacote_ptu,
	b.nr_seq_mot_reembolso,
	b.cd_cnes,
	b.cd_cnes_executor_imp,
	a.nr_seq_mat_ref,
	b.nr_seq_conta_referencia,
	b.tp_rede_min,
	b.ie_tipo_faturamento_imp,
	b.cd_guia_ref,
	b.nr_seq_cbo_saude_solic,
	b.ie_guia_fisica,
	a.nr_lote_contabil_prov,
	b.ie_tipo_faturamento,
	a.vl_material_imp_xml vl_apresentado_xml,
	a.ds_material_imp,
	a.cd_material_imp,
	a.ie_origem_preco_imp,
	a.dt_atendimento_referencia,
	b.nr_seq_prestador_exec_princ,
	b.dt_fim_consistencia,
	(select max(x.ie_vl_apresentado_sistema) from pls_conta_mat_regra x where x.nr_sequencia = a.nr_sequencia) ie_vl_apres_sist_regra,
	b.ie_regime_atendimento,
	b.ie_saude_ocupacional
from	pls_conta_mat	a,
	pls_conta_v	b
where	b.nr_sequencia = a.nr_seq_conta;
