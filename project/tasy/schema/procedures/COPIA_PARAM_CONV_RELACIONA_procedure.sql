-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copia_param_conv_relaciona ( cd_convenio_orig_p bigint, cd_convenio_dest_p bigint, nm_tabela_p text, nm_usuario_p text, ie_excluir_p text, cd_estabelecimento_p bigint) AS $body$
BEGIN

IF (nm_tabela_p = 'CONVENIO_ESTABELECIMENTO') THEN
	IF (ie_excluir_p = 'S') THEN
		DELETE FROM CONVENIO_ESTABELECIMENTO
		WHERE cd_convenio = cd_convenio_dest_p
		AND	cd_estabelecimento = cd_estabelecimento_p;
	END IF;
	INSERT INTO convenio_estabelecimento(
		NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, CD_CONVENIO, CD_ESTABELECIMENTO, CD_CONTA_CONTABIL,
		NR_SEQ_REGRA_FUNCAO, NR_SEQ_CONTA, CD_CONTA_PRE_FATUR, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC,
		IE_EXIGE_DATA_ULT_PAGTO, IE_EXIGE_GUIA, IE_EXIGE_ORC_ATEND, IE_GLOSA_ATENDIMENTO, IE_PRECO_MEDIO_MATERIAL,
		IE_AGENDA_CONSULTA, IE_REP_COD_USUARIO, IE_EXIGE_CARTEIRA_ATEND, IE_EXIGE_VALIDADE_ATEND, IE_EXIGE_PLANO,
		IE_SEPARA_CONTA, IE_GUIA_UNICA_CONTA, IE_VALOR_CONTABIL, IE_TITULO_RECEBER, IE_CONVERSAO_MAT,
		IE_DOC_CONVENIO, IE_DOC_RETORNO, QT_CONTA_PROTOCOLO, QT_DIA_FIM_CONTA, IE_EXIGE_SENHA_ATEND,
		IE_PARTIC_CIRURGIA, IE_EXIGE_ORIGEM, CD_INTERNO, CD_REGIONAL, IE_PROTOCOLO_CONTA,
		IE_GERAR_NF_TITULO, IE_CANCELAR_CONTA, IE_MANTER_ZERADO_EDICAO, NR_DEC_UNITARIO, IE_ARREDONDAMENTO,
		IE_EXIGE_GUIA_PRINC, IE_DOC_AUTORIZACAO, IE_EXIGE_FIM_VIGENCIA, IE_PARTIC_RESP_CRED, IE_FECHAR_ATEND_ADIANT, ie_conta_fim_mes, ie_cgc_cih,
		ie_obter_preco_mat_autor, IE_REGRA_PRIOR_EDICAO, IE_GERAR_NF, IE_MEDICO_COOPERADO, IE_DOC_CONV_PART_FUNC, IE_CONSISTE_GUIA_ATEND, ie_autor_generico,
		ie_gera_nome_nf_convenio, ie_forma_geracao_nf,
		ie_permite_cod_convenio_duplic, ie_trunc_vl_material, ie_consistir_tit,
		ie_exige_cpf_titulo, ie_fecha_conta_int, nr_seq_tf_cr_grc, nr_seq_tf_cp_grc,
		ie_gerar_desconto, ie_proc_tuss_autor, ie_partic_ret, ie_arred_multiplicado,
		ie_converte_itens_audit, ie_conta_fim_dia, ie_tit_prot_pf, cd_ans,
		ie_fixar_vig_brasindice, ie_conta_atual, ie_separa_partic_adic_hor, ie_vl_conta_autor,
		ie_ajustar_periodo_conta, ie_atual_qt_solic_autor, ie_lote_reap, ie_exige_cobertura,
		ie_altera_pj_tit, ie_regra_cart_usuario, ie_dt_prev_autor_quimio, ie_dt_vigencia_autor_quimio,
		dt_inicio_vig_tuss, qt_horas_inicio_ciclo, ie_valor_original_glosa, ie_considera_regra_data_preco,
		ie_contab_lote_consig, ie_verifica_proc_glosa, ie_valor_filme_apos_adic_hor, ie_pre_faturamento,
		ds_proc_retorno, ie_exige_cpf_pagador, ie_divide_vl_med_conv_glosa, hr_conta_fim_dia,
		ie_autor_mat_conta, nr_dias_gastos_rn, cd_proc_long_perm, ie_orig_proc_long_perm,
		nr_dias_venc_atend, nr_dias_alerta, ie_exige_desconto_conta, ie_imprime_data_rodape,
		ie_periodo_inicial_seg, ie_consid_proc_bilat_autor, ie_data_vig_cbhpm, ie_regra_moeda_ajuste,
		ie_trat_conta_rn, ds_mensagem_desfecho, ie_consiste_benef_ops, ie_conta_transitoria,
		ie_imprime_qtde, ie_lib_repasse_sem_tit, ie_arred_so_glosa_perc, qt_dia_venc_tit_grg, ie_grava_guia_taxa,
		dt_fim_contrato, ie_glosa_aceita_grg, ie_copia_senha_guia, ie_conv_categ_glosa, cd_estab_pls,
		ie_registro_pep, ie_exige_conv_glosa, ie_exige_usuario_glosa, ie_exige_compl_glosa,
		ie_exige_validade_glosa, qt_exame_prescr, ie_consid_conv_glosa_eup, ie_consiste_conta_prot,
		ie_conta_prot_ref, ie_tiss_tipo_saida, ie_funcao_medico, ie_glosa_mat_aut_neg, ie_dt_conta_tit_prot,
		ie_obriga_diagnostico, ie_nova_autor_item_fim_vig, ie_dividir_indice_pmc, ie_dividir_indice_pfb,
		ie_tit_liquido, nr_seq_trans_tit_conta, CD_CNPJ_CONV_ESTAB,
		CD_TIPO_RECEB_NEG_TIT, IE_TITULO_EMPRESA_RESP, IE_RET_OUTROS_CONV, IE_IPI_BRASINDICE, CD_LOCALIZADOR_PACIENTE,
		DS_CAMINHO_EXEC, IE_TITULO_PACIENTE_PROT, IE_EXIGE_LETRA_CARTEIRA, ie_recalcular_conta, ie_codigo_convenio, ds_mascara_guia,
		ie_aplicar_tx_co_cbhpm, IE_PRIORIDADE_BRASINDICE, IE_AUTOR_MAT_EXEC, IE_PRECO_MAT_ESP, IE_PLANO_CONSULTA_PRECO, IE_PERMITE_VINC_ORC,
		IE_GERAR_CIHA,
		IE_INC_CONTA_DEF_PROT,
		IE_BLOQUEIA_PROC_SEM_AUTOR,
		IE_AUX_MAIOR_AUX_CIR,
		QT_DIAS_INTERNACAO,
		IE_COPIA_SENHA_GUIA_PRINC,
		IE_OBRIGA_NF_PROT,
		IE_GERAR_AUTOR_QUIMIOTERAPIA,
		IE_CONSISTE_SQL_NF,
		IE_FECHAR_ANALISE_SALDO_REST,
		IE_ATUALIZA_AUTOR_SENHA,
		IE_VALOR_PAGO_GLOSA_GUIA,
		IE_REGRA_HORAS_ONC_CICLO,
		IE_UTILIZA_CONV_BO,
		IE_EXIGE_DOC_CONV,
		IE_PERMITE_INTERNAR_EUP,
		IE_CALC_PORTE_ESTAB,
		QT_DIAS_REAPRE,
		QT_DIAS_AUTORIZACAO,
		QT_DIAS_AUTOR_PROC,
		IE_CONSISTE_CNS_CONTA,
		IE_CH_ANESTESISTA,
		IE_VALOR_PAGO_RET,
		IE_EXIGE_LIB_BRAS,
		IE_VALOR_INF_REVERSAO,
		DS_PROC_GRG,
		IE_DATA_AUTOR_PRORROG,
		IE_LIB_REPASSE_PROT_TIT,
		IE_FORMA_PROC_PRINC,
		IE_EXIGE_DT_VENC_PROT,
		IE_GERAR_NF_DESDOB,
		IE_AUTOR_MAT_ESP_CIRURGIA,
		IE_QT_MAT_AUTOR,
		IE_EXIGE_EMPRESA_CONS,
		IE_OBRIGA_NF_TIT_REC,
		QT_DIAS_AUTOR_QUIMIO,
		IE_GUIA_AUTOR_QUIMIO,
		IE_CALC_VL_AUX_CONV,
		IE_CONV_MEDIDA_AUTOR_QUIMIO,
		IE_TRIB_TITULO_RETORNO,
		IE_TOMADOR_NF_DESDOB,
		IE_CONSIS_INICIO_CONTA_PROT,
		IE_IGNORA_PARTIC,
		IE_TITULO_SEM_NF,
		IE_EXIGE_DOC_CONV_TITULO,
		NR_SEQ_ENVIO_PROT,
		IE_ORIGEM_PRECO,
		IE_PRECEDENCIA_PRECO,
		IE_REPASSE_PROC,
		IE_REPASSE_MAT,
		IE_VALOR_FILME_TAB_PRECO,
		IE_ATUALIZA_FUNC_MEDICO,
		IE_EXIGE_GABARITO,
		IE_RETEM_ISS,
		IE_LANCTO_AUTO_DT_ALTA,
		IE_EXIGE_TEMPO_DOENCA,
		IE_AUTORIZACAO_EUP,
		IE_MOTIVO_GLOSA_CONV,
		IE_EXIGE_COMPL_USUARIO,
		IE_SUBSTITUIR_GUIA,
		IE_REPASSE_GRATUIDADE,
		QT_DIA_CONTA_RET,
		IE_CHAMADA_TITULO,
		IE_PF_UNICA_NF_PROT,
		IE_GUIA_TRANSF_CONTA,
		IE_GRAVA_GUIA_CONTA,
		IE_EXIGE_TIPO_FATURAMENTO,
		IE_EXIGE_CPF_PACIENTE,
		IE_CONS_DIA_INT_VIG,
		IE_OBTER_FORNEC_MAT_AUTOR,
		DS_MASCARA_GUIA_PROC,
		IE_EXIGE_NR_CONV,
		IE_CONS_DUPLIC_COD_USU,
		IE_EXIGE_EMAIL,
		IE_CALCULAR_NF,
		IE_OBRIGA_TITULO_PARTIC,
		IE_FORMA_RATEIO_SADT,
		IE_INDICE_AJUSTE_FILME,
		IE_CONSISTE_PAC_PROTOCOLO,
		IE_TIT_RET_SENHA,
		IE_OBRIGA_TITULO_PROT,
		IE_ATUALIZA_SERIE_NF_SAIDA,
		IE_EXIGE_PASSAPORTE_PACIENTE,
		IE_GLOSA_ADIC_RET,
		IE_OBRIGA_OBS_DESC_PROT,
		IE_CONVERTE_ML_FR,
		IE_TIPO_GLOSA_RET,
		IE_OBRIGAR_ITEM_GLOSA,
		IE_PRECO_MEDIO_BRAS,
		IE_FORMA_AUTOR_QUIMIOTERAPIA,
		NR_DIAS_VENC,
		IE_LIB_REPASSE,
		IE_BIOMETRIA_ATEND,
		IE_REGRA_APRES_AUTOR_QUIMIO,
		IE_ORIGEM_FAT_DIRETO,
		IE_AUTOR_PRESCR_SALDO,
		IE_AUTOR_DESDOB_CONTA,
		IE_CONSISTE_REGRA_IPASGO,
		IE_CONSISTE_SEQ_CONTA,
		IE_TAXA_TEMPO_UNIDADE,
		QT_DIA_DESDOB_CONTA,
		IE_VALOR_PAGO_COBRADO_RET,
		IE_CONSIDERA_DT_ENTRADA,
		IE_CONSIDERA_DT_ENTRADA_ANAM,
		IE_FIXAR_VIG_SIMPRO,
		IE_PERMITE_DESD_PLANSERV,
		IE_PROTOCOLO_INDIVIDUAL,
		IE_ATUALIZA_JUST_ANL_ANT,
		IE_EXIBE_TITULAR_CONV,
		IE_PERMITE_INTEGRACAO,
		IE_BLOQ_LANCTO_GUIA_ANL_GRG,
		IE_VALOR_COSEGURO,
		NR_SEQ_EVENTO_INTEGRACAO,
		IE_CONVERSAO_CONV_ITEM,
		CD_REGRA_HON_SOM_FILME_IPE,
		IE_PRIORIDADE_SIMPRO,
		IE_VINC_ADIANT_PROT_PJ,
		NR_SEQ_TRANS_TIT_PROT,
		NR_SEQ_TRANS_FIN_CONV_RET,
		NR_SEQ_CONTA_BANCO,
		IE_PRIORIDADE_PACOTE_JOB,
    	IE_COPIAR_ETAPA_DESDOB,
		IE_REGRA_ORDEM_PACOTE,
		IE_REMUN_POR_DIAGNOSTICO,
		IE_PRIOR_FORM_PACOTE
		)
	SELECT	nextval('convenio_estabelecimento_seq'), clock_timestamp(), NM_USUARIO_P, CD_CONVENIO_dest_p, CD_ESTABELECIMENTO_p,
		CD_CONTA_CONTABIL, NR_SEQ_REGRA_FUNCAO, NR_SEQ_CONTA, CD_CONTA_PRE_FATUR, clock_timestamp(),
		NM_USUARIO_P, IE_EXIGE_DATA_ULT_PAGTO, IE_EXIGE_GUIA, IE_EXIGE_ORC_ATEND, IE_GLOSA_ATENDIMENTO,
		IE_PRECO_MEDIO_MATERIAL, IE_AGENDA_CONSULTA, IE_REP_COD_USUARIO, IE_EXIGE_CARTEIRA_ATEND,
		IE_EXIGE_VALIDADE_ATEND, IE_EXIGE_PLANO, IE_SEPARA_CONTA, IE_GUIA_UNICA_CONTA, IE_VALOR_CONTABIL,
		IE_TITULO_RECEBER, IE_CONVERSAO_MAT, IE_DOC_CONVENIO, IE_DOC_RETORNO, QT_CONTA_PROTOCOLO, QT_DIA_FIM_CONTA,
		IE_EXIGE_SENHA_ATEND, IE_PARTIC_CIRURGIA, IE_EXIGE_ORIGEM, CD_INTERNO, CD_REGIONAL, IE_PROTOCOLO_CONTA,
		IE_GERAR_NF_TITULO, IE_CANCELAR_CONTA, IE_MANTER_ZERADO_EDICAO, NR_DEC_UNITARIO, IE_ARREDONDAMENTO,
		IE_EXIGE_GUIA_PRINC, IE_DOC_AUTORIZACAO, IE_EXIGE_FIM_VIGENCIA, IE_PARTIC_RESP_CRED, IE_FECHAR_ATEND_ADIANT, ie_conta_fim_mes, ie_cgc_cih,
		ie_obter_preco_mat_autor, IE_REGRA_PRIOR_EDICAO, coalesce(IE_GERAR_NF,'S'), IE_MEDICO_COOPERADO, IE_DOC_CONV_PART_FUNC, IE_CONSISTE_GUIA_ATEND,
		ie_autor_generico,ie_gera_nome_nf_convenio, ie_forma_geracao_nf,
		ie_permite_cod_convenio_duplic, ie_trunc_vl_material, ie_consistir_tit,
		ie_exige_cpf_titulo, ie_fecha_conta_int, nr_seq_tf_cr_grc, nr_seq_tf_cp_grc,
		ie_gerar_desconto, ie_proc_tuss_autor, ie_partic_ret, ie_arred_multiplicado,
		ie_converte_itens_audit, ie_conta_fim_dia, ie_tit_prot_pf, cd_ans,
		ie_fixar_vig_brasindice, ie_conta_atual, ie_separa_partic_adic_hor, ie_vl_conta_autor,
		ie_ajustar_periodo_conta, ie_atual_qt_solic_autor, ie_lote_reap, ie_exige_cobertura,
		ie_altera_pj_tit, ie_regra_cart_usuario, ie_dt_prev_autor_quimio, ie_dt_vigencia_autor_quimio,
		dt_inicio_vig_tuss, qt_horas_inicio_ciclo, ie_valor_original_glosa, ie_considera_regra_data_preco,
		ie_contab_lote_consig, ie_verifica_proc_glosa, ie_valor_filme_apos_adic_hor, ie_pre_faturamento,
		ds_proc_retorno, ie_exige_cpf_pagador, ie_divide_vl_med_conv_glosa, hr_conta_fim_dia,
		ie_autor_mat_conta, nr_dias_gastos_rn, cd_proc_long_perm, ie_orig_proc_long_perm,
		nr_dias_venc_atend, nr_dias_alerta, ie_exige_desconto_conta, ie_imprime_data_rodape,
		ie_periodo_inicial_seg, ie_consid_proc_bilat_autor, ie_data_vig_cbhpm, ie_regra_moeda_ajuste,
		ie_trat_conta_rn, ds_mensagem_desfecho, ie_consiste_benef_ops, ie_conta_transitoria,
		ie_imprime_qtde, ie_lib_repasse_sem_tit, ie_arred_so_glosa_perc, qt_dia_venc_tit_grg, ie_grava_guia_taxa,
		dt_fim_contrato, ie_glosa_aceita_grg, ie_copia_senha_guia, ie_conv_categ_glosa, cd_estab_pls,
		ie_registro_pep, ie_exige_conv_glosa, ie_exige_usuario_glosa, ie_exige_compl_glosa,
		ie_exige_validade_glosa, qt_exame_prescr, ie_consid_conv_glosa_eup, ie_consiste_conta_prot,
		ie_conta_prot_ref, ie_tiss_tipo_saida, ie_funcao_medico, ie_glosa_mat_aut_neg, ie_dt_conta_tit_prot,
		ie_obriga_diagnostico, ie_nova_autor_item_fim_vig, ie_dividir_indice_pmc, ie_dividir_indice_pfb,
		ie_tit_liquido, nr_seq_trans_tit_conta, CD_CNPJ_CONV_ESTAB,
		CD_TIPO_RECEB_NEG_TIT, IE_TITULO_EMPRESA_RESP, IE_RET_OUTROS_CONV, IE_IPI_BRASINDICE, CD_LOCALIZADOR_PACIENTE,
		DS_CAMINHO_EXEC, IE_TITULO_PACIENTE_PROT, IE_EXIGE_LETRA_CARTEIRA, ie_recalcular_conta, ie_codigo_convenio, ds_mascara_guia,
		ie_aplicar_tx_co_cbhpm, IE_PRIORIDADE_BRASINDICE, IE_AUTOR_MAT_EXEC, IE_PRECO_MAT_ESP, IE_PLANO_CONSULTA_PRECO, IE_PERMITE_VINC_ORC,		
		IE_GERAR_CIHA, IE_INC_CONTA_DEF_PROT, IE_BLOQUEIA_PROC_SEM_AUTOR, IE_AUX_MAIOR_AUX_CIR, QT_DIAS_INTERNACAO, IE_COPIA_SENHA_GUIA_PRINC,
		IE_OBRIGA_NF_PROT, IE_GERAR_AUTOR_QUIMIOTERAPIA, IE_CONSISTE_SQL_NF, IE_FECHAR_ANALISE_SALDO_REST, IE_ATUALIZA_AUTOR_SENHA, IE_VALOR_PAGO_GLOSA_GUIA,
		IE_REGRA_HORAS_ONC_CICLO, IE_UTILIZA_CONV_BO, IE_EXIGE_DOC_CONV, IE_PERMITE_INTERNAR_EUP, IE_CALC_PORTE_ESTAB, QT_DIAS_REAPRE, QT_DIAS_AUTORIZACAO,
		QT_DIAS_AUTOR_PROC, IE_CONSISTE_CNS_CONTA, IE_CH_ANESTESISTA, IE_VALOR_PAGO_RET, IE_EXIGE_LIB_BRAS, IE_VALOR_INF_REVERSAO, DS_PROC_GRG, IE_DATA_AUTOR_PRORROG,
		IE_LIB_REPASSE_PROT_TIT, IE_FORMA_PROC_PRINC, IE_EXIGE_DT_VENC_PROT, IE_GERAR_NF_DESDOB, IE_AUTOR_MAT_ESP_CIRURGIA, IE_QT_MAT_AUTOR, IE_EXIGE_EMPRESA_CONS,
		IE_OBRIGA_NF_TIT_REC, QT_DIAS_AUTOR_QUIMIO, IE_GUIA_AUTOR_QUIMIO, IE_CALC_VL_AUX_CONV, IE_CONV_MEDIDA_AUTOR_QUIMIO, IE_TRIB_TITULO_RETORNO, IE_TOMADOR_NF_DESDOB,
		IE_CONSIS_INICIO_CONTA_PROT, IE_IGNORA_PARTIC, coalesce(IE_TITULO_SEM_NF, 'S'),
		IE_EXIGE_DOC_CONV_TITULO,
		NR_SEQ_ENVIO_PROT,
		IE_ORIGEM_PRECO,
		IE_PRECEDENCIA_PRECO,
		IE_REPASSE_PROC,
		IE_REPASSE_MAT,
		IE_VALOR_FILME_TAB_PRECO,
		IE_ATUALIZA_FUNC_MEDICO,
		IE_EXIGE_GABARITO,
		IE_RETEM_ISS,
		IE_LANCTO_AUTO_DT_ALTA,
		IE_EXIGE_TEMPO_DOENCA,
		IE_AUTORIZACAO_EUP,
		IE_MOTIVO_GLOSA_CONV,
		IE_EXIGE_COMPL_USUARIO,
		IE_SUBSTITUIR_GUIA,
		IE_REPASSE_GRATUIDADE,
		QT_DIA_CONTA_RET,
		IE_CHAMADA_TITULO,
		IE_PF_UNICA_NF_PROT,
		IE_GUIA_TRANSF_CONTA,
		IE_GRAVA_GUIA_CONTA,
		IE_EXIGE_TIPO_FATURAMENTO,
		IE_EXIGE_CPF_PACIENTE,
		IE_CONS_DIA_INT_VIG,
		IE_OBTER_FORNEC_MAT_AUTOR,
		DS_MASCARA_GUIA_PROC,
		IE_EXIGE_NR_CONV,
		IE_CONS_DUPLIC_COD_USU,
		IE_EXIGE_EMAIL,
		IE_CALCULAR_NF,
		IE_OBRIGA_TITULO_PARTIC,
		IE_FORMA_RATEIO_SADT,
		IE_INDICE_AJUSTE_FILME,
		IE_CONSISTE_PAC_PROTOCOLO,
		IE_TIT_RET_SENHA,
		IE_OBRIGA_TITULO_PROT,
		IE_ATUALIZA_SERIE_NF_SAIDA,
		IE_EXIGE_PASSAPORTE_PACIENTE,
		IE_GLOSA_ADIC_RET,
		IE_OBRIGA_OBS_DESC_PROT,
		IE_CONVERTE_ML_FR,
		IE_TIPO_GLOSA_RET,
		IE_OBRIGAR_ITEM_GLOSA,
		IE_PRECO_MEDIO_BRAS,
		IE_FORMA_AUTOR_QUIMIOTERAPIA,
		NR_DIAS_VENC,
		IE_LIB_REPASSE,
		IE_BIOMETRIA_ATEND,
		IE_REGRA_APRES_AUTOR_QUIMIO,
		IE_ORIGEM_FAT_DIRETO,
		IE_AUTOR_PRESCR_SALDO,
		IE_AUTOR_DESDOB_CONTA,
		IE_CONSISTE_REGRA_IPASGO,
		IE_CONSISTE_SEQ_CONTA,
		IE_TAXA_TEMPO_UNIDADE,
		QT_DIA_DESDOB_CONTA,
		IE_VALOR_PAGO_COBRADO_RET,
		IE_CONSIDERA_DT_ENTRADA,
		IE_CONSIDERA_DT_ENTRADA_ANAM,
		IE_FIXAR_VIG_SIMPRO,
		IE_PERMITE_DESD_PLANSERV,
		IE_PROTOCOLO_INDIVIDUAL,
		IE_ATUALIZA_JUST_ANL_ANT,
		IE_EXIBE_TITULAR_CONV,
		IE_PERMITE_INTEGRACAO,
		IE_BLOQ_LANCTO_GUIA_ANL_GRG,
		IE_VALOR_COSEGURO,
		NR_SEQ_EVENTO_INTEGRACAO,
		IE_CONVERSAO_CONV_ITEM,
		CD_REGRA_HON_SOM_FILME_IPE,
		IE_PRIORIDADE_SIMPRO,
		IE_VINC_ADIANT_PROT_PJ,
		NR_SEQ_TRANS_TIT_PROT,
		NR_SEQ_TRANS_FIN_CONV_RET,
		NR_SEQ_CONTA_BANCO,
		IE_PRIORIDADE_PACOTE_JOB,
    	IE_COPIAR_ETAPA_DESDOB,
		IE_REGRA_ORDEM_PACOTE,
		IE_REMUN_POR_DIAGNOSTICO,
		IE_PRIOR_FORM_PACOTE
	FROM 	convenio_estabelecimento
	WHERE 	cd_convenio = cd_convenio_orig_p
	AND	cd_estabelecimento = cd_estabelecimento_p;
ELSIF (nm_tabela_p = 'CONVENIO_BLOQUEIO') THEN
	IF (ie_excluir_p = 'S') THEN
		DELETE FROM CONVENIO_BLOQUEIO
		WHERE cd_convenio = cd_convenio_dest_p;
	END IF;
	INSERT INTO convenio_bloqueio(
		CD_CONVENIO, CD_USUARIO_CONVENIO, IE_TIPO_BLOQUEIO, DT_ATUALIZACAO, NM_USUARIO, ds_mensagem, ie_tipo_atendimento, ie_clinica,
		nr_sequencia, CD_CATEGORIA, dt_inicio_vigencia, dt_final_vigencia)
	SELECT	CD_CONVENIO_dest_p, CD_USUARIO_CONVENIO, IE_TIPO_BLOQUEIO, clock_timestamp(), NM_USUARIO_p, ds_mensagem, ie_tipo_atendimento, ie_clinica,
		nextval('convenio_bloqueio_seq'), CD_CATEGORIA, dt_inicio_vigencia, dt_final_vigencia
	FROM 	convenio_bloqueio
	WHERE 	cd_convenio = cd_convenio_orig_p;
ELSIF (nm_tabela_p = 'CONVENIO_PRESTADOR') THEN
	IF (ie_excluir_p = 'S') THEN
		DELETE FROM CONVENIO_PRESTADOR
		WHERE cd_convenio = cd_convenio_dest_p
		AND   cd_estabelecimento = cd_estabelecimento_p;
	END IF;
	INSERT INTO convenio_prestador(
		NR_SEQUENCIA, CD_ESTABELECIMENTO, DT_ATUALIZACAO, NM_USUARIO, CD_CONVENIO, CD_CGC,
		CD_PRESTADOR_CONVENIO, NR_SEQ_CLASSIFICACAO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC)
	SELECT	nextval('convenio_prestador_seq'), CD_ESTABELECIMENTO_p, clock_timestamp(), NM_USUARIO_P, CD_CONVENIO_dest_p, CD_CGC,
		CD_PRESTADOR_CONVENIO, NR_SEQ_CLASSIFICACAO, clock_timestamp(), NM_USUARIO_P
	FROM 	convenio_prestador
	WHERE 	cd_convenio = cd_convenio_orig_p
	AND 	cd_estabelecimento = cd_estabelecimento_p;
ELSIF (nm_tabela_p = 'MEDICO_CONVENIO') THEN
	IF (ie_excluir_p = 'S') THEN
		DELETE FROM MEDICO_CONVENIO
		WHERE cd_convenio = cd_convenio_dest_p;
	END IF;
	INSERT INTO MEDICO_CONVENIO(
		cd_pessoa_fisica,
		cd_convenio,
		cd_estabelecimento,
		cd_prestador,
		cd_setor_atendimento,
		cd_plano_convenio,
		ie_tipo_atendimento,
		dt_inicio_vigencia,
		ie_funcao_medico,
		ie_carater_inter_sus,
		dt_atualizacao,
		nm_usuario,
		ie_conveniado,
		ie_auditor,
		cd_medico_convenio,
		ie_plantonista,
		ie_tipo_servico_sus,
		nr_sequencia,
		cd_especialidade)	
	SELECT	cd_pessoa_fisica,
		cd_convenio_dest_p,
		cd_estabelecimento,
		cd_prestador,
		cd_setor_atendimento,
		cd_plano_convenio,
		ie_tipo_atendimento,
		dt_inicio_vigencia,
		ie_funcao_medico,
		ie_carater_inter_sus,
		clock_timestamp(),
		nm_usuario_p,
		ie_conveniado,
		ie_auditor,
		cd_medico_convenio,
		ie_plantonista,
		ie_tipo_servico_sus,
		nextval('medico_convenio_seq'),
		cd_especialidade
	FROM	MEDICO_CONVENIO
	WHERE cd_convenio = cd_convenio_orig_p;
END IF;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copia_param_conv_relaciona ( cd_convenio_orig_p bigint, cd_convenio_dest_p bigint, nm_tabela_p text, nm_usuario_p text, ie_excluir_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
