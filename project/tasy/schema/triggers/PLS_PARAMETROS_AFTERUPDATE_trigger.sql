-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_parametros_afterupdate ON pls_parametros CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_parametros_afterupdate() RETURNS trigger AS $BODY$
declare

BEGIN

if (coalesce(wheb_usuario_pck.get_ie_executar_trigger,'S') = 'S') then
	-- Inicio Parametros Mensalidade

	if (NEW.ie_data_base_proporcional <> OLD.ie_data_base_proporcional) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_DATA_BASE_PROPORCIONAL', OLD.ie_data_base_proporcional,
						NEW.ie_data_base_proporcional, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.qt_dias_venc_primeira_mens <> OLD.qt_dias_venc_primeira_mens) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'QT_DIAS_VENC_PRIMEIRA_MENS', OLD.qt_dias_venc_primeira_mens,
						NEW.qt_dias_venc_primeira_mens, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.qt_parcelas_meses_anteriores <> OLD.qt_parcelas_meses_anteriores) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'QT_PARCELAS_MESES_ANTERIORES', OLD.qt_parcelas_meses_anteriores,
						NEW.qt_parcelas_meses_anteriores, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.qt_meses_benef_rescindido <> OLD.qt_meses_benef_rescindido) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'QT_MESES_BENEF_RESCINDIDO', OLD.qt_meses_benef_rescindido,
						NEW.qt_meses_benef_rescindido, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_mens_prop_pce <> OLD.ie_mens_prop_pce) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_MENS_PROP_PCE', OLD.ie_mens_prop_pce,
						NEW.ie_mens_prop_pce, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_att_cobertura_reativacao <> OLD.ie_att_cobertura_reativacao) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_ATT_COBERTURA_REATIVACAO', OLD.ie_att_cobertura_reativacao,
						NEW.ie_att_cobertura_reativacao, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_consis_inf_fin_pag <> OLD.ie_consis_inf_fin_pag) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_CONSIS_INF_FIN_PAG', OLD.ie_consis_inf_fin_pag,
						NEW.ie_consis_inf_fin_pag, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_susp_mens_solic_resc <> OLD.ie_susp_mens_solic_resc) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_SUSP_MENS_SOLIC_RESC', OLD.ie_susp_mens_solic_resc,
						NEW.ie_susp_mens_solic_resc, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_mens_adaptacao_retro <> OLD.ie_mens_adaptacao_retro) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_MENS_ADAPTACAO_RETRO', OLD.ie_mens_adaptacao_retro,
						NEW.ie_mens_adaptacao_retro, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_reativacao_adesao_mens <> OLD.ie_reativacao_adesao_mens) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_REATIVACAO_ADESAO_MENS', OLD.ie_reativacao_adesao_mens,
						NEW.ie_reativacao_adesao_mens, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_mens_cobrar_carteira_ant <> OLD.ie_mens_cobrar_carteira_ant) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_MENS_COBRAR_CARTEIRA_ANT', OLD.ie_mens_cobrar_carteira_ant,
						NEW.ie_mens_cobrar_carteira_ant, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_gerar_coparticipacao <> OLD.ie_gerar_coparticipacao) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_GERAR_COPARTICIPACAO', OLD.ie_gerar_coparticipacao,
						NEW.ie_gerar_coparticipacao, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_ref_copartic_mens <> OLD.ie_ref_copartic_mens) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_REF_COPARTIC_MENS', OLD.ie_ref_copartic_mens,
						NEW.ie_ref_copartic_mens, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_copartic_mens_mes_ant <> OLD.ie_copartic_mens_mes_ant) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_COPARTIC_MENS_MES_ANT', OLD.ie_copartic_mens_mes_ant,
						NEW.ie_copartic_mens_mes_ant, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_copartic_prot_sem_pag <> OLD.ie_copartic_prot_sem_pag) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_COPARTIC_PROT_SEM_PAG', OLD.ie_copartic_prot_sem_pag,
						NEW.ie_copartic_prot_sem_pag, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_gerar_coparticipacao_a700 <> OLD.ie_gerar_coparticipacao_a700) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_GERAR_COPARTICIPACAO_A700', OLD.ie_gerar_coparticipacao_a700,
						NEW.ie_gerar_coparticipacao_a700, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_gerar_copart_congenere <> OLD.ie_gerar_copart_congenere) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_GERAR_COPART_CONGENERE', OLD.ie_gerar_copart_congenere,
						NEW.ie_gerar_copart_congenere, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_pos_estab_faturamento <> OLD.ie_pos_estab_faturamento) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_POS_ESTAB_FATURAMENTO', OLD.ie_pos_estab_faturamento,
						NEW.ie_pos_estab_faturamento, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_pos_estab_fat_resc <> OLD.ie_pos_estab_fat_resc) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_POS_ESTAB_FAT_RESC', OLD.ie_pos_estab_fat_resc,
						NEW.ie_pos_estab_fat_resc, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_gerar_pos_estab_reembolso <> OLD.ie_gerar_pos_estab_reembolso) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_GERAR_POS_ESTAB_REEMBOLSO', OLD.ie_gerar_pos_estab_reembolso,
						NEW.ie_gerar_pos_estab_reembolso, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_gerar_pos_estab_ressar <> OLD.ie_gerar_pos_estab_ressar) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_GERAR_POS_ESTAB_RESSAR', OLD.ie_gerar_pos_estab_ressar,
						NEW.ie_gerar_pos_estab_ressar, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.cd_operacao_nf <> OLD.cd_operacao_nf) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'CD_OPERACAO_NF', OLD.cd_operacao_nf,
						NEW.cd_operacao_nf, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.cd_natureza_operacao <> OLD.cd_natureza_operacao) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'CD_NATUREZA_OPERACAO', OLD.cd_natureza_operacao,
						NEW.cd_natureza_operacao, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.nr_seq_classif_fiscal <> OLD.nr_seq_classif_fiscal) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'NR_SEQ_CLASSIF_FISCAL', OLD.nr_seq_classif_fiscal,
						NEW.nr_seq_classif_fiscal, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.nr_seq_sit_trib <> OLD.nr_seq_sit_trib) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'NR_SEQ_SIT_TRIB', OLD.nr_seq_sit_trib,
						NEW.nr_seq_sit_trib, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.cd_serie_nf <> OLD.cd_serie_nf) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'CD_SERIE_NF', OLD.cd_serie_nf,
						NEW.cd_serie_nf, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_geracao_nota_titulo <> OLD.ie_geracao_nota_titulo) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_GERACAO_NOTA_TITULO', OLD.ie_geracao_nota_titulo,
						NEW.ie_geracao_nota_titulo, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_geracao_nota_titulo_pf <> OLD.ie_geracao_nota_titulo_pf) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_GERACAO_NOTA_TITULO_PF', OLD.ie_geracao_nota_titulo_pf,
						NEW.ie_geracao_nota_titulo_pf, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_data_referencia_nf <> OLD.ie_data_referencia_nf) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_DATA_REFERENCIA_NF', OLD.ie_data_referencia_nf,
						NEW.ie_data_referencia_nf, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.cd_cgc_emissao_nf <> OLD.cd_cgc_emissao_nf) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'CD_CGC_EMISSAO_NF', OLD.cd_cgc_emissao_nf,
						NEW.cd_cgc_emissao_nf, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_lancar_desconto_nota_mens <> OLD.ie_lancar_desconto_nota_mens) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_LANCAR_DESCONTO_NOTA_MENS', OLD.ie_lancar_desconto_nota_mens,
						NEW.ie_lancar_desconto_nota_mens, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.nr_seq_classe_tit_mens <> OLD.nr_seq_classe_tit_mens) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'NR_SEQ_CLASSE_TIT_MENS', OLD.nr_seq_classe_tit_mens,
						NEW.nr_seq_classe_tit_mens, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.cd_tipo_taxa_juro <> OLD.cd_tipo_taxa_juro) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'CD_TIPO_TAXA_JURO', OLD.cd_tipo_taxa_juro,
						NEW.cd_tipo_taxa_juro, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.pr_juro_padrao <> OLD.pr_juro_padrao) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'PR_JURO_PADRAO', OLD.pr_juro_padrao,
						NEW.pr_juro_padrao, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.cd_tipo_taxa_multa <> OLD.cd_tipo_taxa_multa) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'CD_TIPO_TAXA_MULTA', OLD.cd_tipo_taxa_multa,
						NEW.cd_tipo_taxa_multa, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.pr_multa_padrao <> OLD.pr_multa_padrao) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'PR_MULTA_PADRAO', OLD.pr_multa_padrao,
						NEW.pr_multa_padrao, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.nr_seq_trans_fin_baixa_mens <> OLD.nr_seq_trans_fin_baixa_mens) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'NR_SEQ_TRANS_FIN_BAIXA_MENS', OLD.nr_seq_trans_fin_baixa_mens,
						NEW.nr_seq_trans_fin_baixa_mens, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.nr_seq_trans_fin_con_mens <> OLD.nr_seq_trans_fin_con_mens) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'NR_SEQ_TRANS_FIN_CON_MENS', OLD.nr_seq_trans_fin_con_mens,
						NEW.nr_seq_trans_fin_con_mens, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.nr_seq_trans_fin_baixa <> OLD.nr_seq_trans_fin_baixa) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'NR_SEQ_TRANS_FIN_BAIXA', OLD.nr_seq_trans_fin_baixa,
						NEW.nr_seq_trans_fin_baixa, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.cd_tipo_recebimento <> OLD.cd_tipo_recebimento) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'CD_TIPO_RECEBIMENTO', OLD.cd_tipo_recebimento,
						NEW.cd_tipo_recebimento, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.pr_ibpt_mens_fed <> OLD.pr_ibpt_mens_fed) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'PR_IBPT_MENS_FED', OLD.pr_ibpt_mens_fed,
						NEW.pr_ibpt_mens_fed, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.pr_ibpt_mens_est <> OLD.pr_ibpt_mens_est) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'PR_IBPT_MENS_EST', OLD.pr_ibpt_mens_est,
						NEW.pr_ibpt_mens_est, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.pr_ibpt_mens_mun <> OLD.pr_ibpt_mens_mun) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'PR_IBPT_MENS_MUN', OLD.pr_ibpt_mens_mun,
						NEW.pr_ibpt_mens_mun, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_bloqueto_deb_auto <> OLD.ie_bloqueto_deb_auto) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_BLOQUETO_DEB_AUTO', OLD.ie_bloqueto_deb_auto,
						NEW.ie_bloqueto_deb_auto, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.nr_seq_relatorio <> OLD.nr_seq_relatorio) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'NR_SEQ_RELATORIO', OLD.nr_seq_relatorio,
						NEW.nr_seq_relatorio, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_considerar_dt_liq_cancel <> OLD.ie_considerar_dt_liq_cancel) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_CONSIDERAR_DT_LIQ_CANCEL', OLD.ie_considerar_dt_liq_cancel,
						NEW.ie_considerar_dt_liq_cancel, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_pro_rata_dia <> OLD.ie_pro_rata_dia) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_PRO_RATA_DIA', OLD.ie_pro_rata_dia,
						NEW.ie_pro_rata_dia, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.cd_banco_desc_folha <> OLD.cd_banco_desc_folha) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'CD_BANCO_DESC_FOLHA', OLD.cd_banco_desc_folha,
						NEW.cd_banco_desc_folha, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.nr_seq_conta_banco_desc <> OLD.nr_seq_conta_banco_desc) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'NR_SEQ_CONTA_BANCO_DESC', OLD.nr_seq_conta_banco_desc,
						NEW.nr_seq_conta_banco_desc, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_dt_venc_quitacao_debito <> OLD.ie_dt_venc_quitacao_debito) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_DT_VENC_QUITACAO_DEBITO', OLD.ie_dt_venc_quitacao_debito,
						NEW.ie_dt_venc_quitacao_debito, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_gerar_tributo_nf_mens <> OLD.ie_gerar_tributo_nf_mens) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_GERAR_TRIBUTO_NF_MENS', OLD.ie_gerar_tributo_nf_mens,
						NEW.ie_gerar_tributo_nf_mens, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ds_remetente_sms <> OLD.ds_remetente_sms) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'DS_REMETENTE_SMS', OLD.ds_remetente_sms,
						NEW.ds_remetente_sms, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ds_mensagem_sms_mens <> OLD.ds_mensagem_sms_mens) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'DS_MENSAGEM_SMS_MENS', OLD.ds_mensagem_sms_mens,
						NEW.ds_mensagem_sms_mens, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;
	-- Fim Parametros Mensalidade


	-- Inicio Parametros Contratos e Beneficiarios

	if (NEW.cd_condicao_pagamento <> OLD.cd_condicao_pagamento) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'CD_CONDICAO_PAGAMENTO', OLD.cd_condicao_pagamento,
						NEW.cd_condicao_pagamento, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.cd_tipo_portador <> OLD.cd_tipo_portador) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'CD_TIPO_PORTADOR', OLD.cd_tipo_portador,
						NEW.cd_tipo_portador, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.cd_portador <> OLD.cd_portador) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'CD_PORTADOR', OLD.cd_portador,
						NEW.cd_portador, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.nr_seq_conta_banco <> OLD.nr_seq_conta_banco) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'NR_SEQ_CONTA_BANCO', OLD.nr_seq_conta_banco,
						NEW.nr_seq_conta_banco, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.nr_seq_emissor <> OLD.nr_seq_emissor) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'NR_SEQ_EMISSOR', OLD.nr_seq_emissor,
						NEW.nr_seq_emissor, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.nr_seq_motivo_inclusao <> OLD.nr_seq_motivo_inclusao) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'NR_SEQ_MOTIVO_INCLUSAO', OLD.nr_seq_motivo_inclusao,
						NEW.nr_seq_motivo_inclusao, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.nr_seq_motivo_migracao <> OLD.nr_seq_motivo_migracao) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'NR_SEQ_MOTIVO_MIGRACAO', OLD.nr_seq_motivo_migracao,
						NEW.nr_seq_motivo_migracao, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.qt_dias_rescisao_mig <> OLD.qt_dias_rescisao_mig) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'QT_DIAS_RESCISAO_MIG', OLD.qt_dias_rescisao_mig,
						NEW.qt_dias_rescisao_mig, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.qt_cons_dias_incl_cong_filho <> OLD.qt_cons_dias_incl_cong_filho) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'QT_CONS_DIAS_INCL_CONG_FILHO', OLD.qt_cons_dias_incl_cong_filho,
						NEW.qt_cons_dias_incl_cong_filho, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.qt_idade_proposta_cpf <> OLD.qt_idade_proposta_cpf) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'QT_IDADE_PROPOSTA_CPF', OLD.qt_idade_proposta_cpf,
						NEW.qt_idade_proposta_cpf, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.dt_base_validade_carteira <> OLD.dt_base_validade_carteira) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'DT_BASE_VALIDADE_CARTEIRA', OLD.dt_base_validade_carteira,
						NEW.dt_base_validade_carteira, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_venc_cartao_rescisao <> OLD.ie_venc_cartao_rescisao) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_VENC_CARTAO_RESCISAO', OLD.ie_venc_cartao_rescisao,
						NEW.ie_venc_cartao_rescisao, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_gerar_validade_cartao <> OLD.ie_gerar_validade_cartao) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_GERAR_VALIDADE_CARTAO', OLD.ie_gerar_validade_cartao,
						NEW.ie_gerar_validade_cartao, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_isentar_carencia_nasc <> OLD.ie_isentar_carencia_nasc) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_ISENTAR_CARENCIA_NASC', OLD.ie_isentar_carencia_nasc,
						NEW.ie_isentar_carencia_nasc, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_renovacao_cartao_dt_atual <> OLD.ie_renovacao_cartao_dt_atual) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_RENOVACAO_CARTAO_DT_ATUAL', OLD.ie_renovacao_cartao_dt_atual,
						NEW.ie_renovacao_cartao_dt_atual, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_venc_cart_fim_mes <> OLD.ie_venc_cart_fim_mes) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_VENC_CART_FIM_MES', OLD.ie_venc_cart_fim_mes,
						NEW.ie_venc_cart_fim_mes, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_pessoa_contrato <> OLD.ie_pessoa_contrato) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_PESSOA_CONTRATO', OLD.ie_pessoa_contrato,
						NEW.ie_pessoa_contrato, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_carencia_abrangencia_ant <> OLD.ie_carencia_abrangencia_ant) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_CARENCIA_ABRANGENCIA_ANT', OLD.ie_carencia_abrangencia_ant,
						NEW.ie_carencia_abrangencia_ant, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_emissao_cart_repasse_pre <> OLD.ie_emissao_cart_repasse_pre) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_EMISSAO_CART_REPASSE_PRE', OLD.ie_emissao_cart_repasse_pre,
						NEW.ie_emissao_cart_repasse_pre, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_apropriacao_copartic <> OLD.ie_apropriacao_copartic) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_APROPRIACAO_COPARTIC', OLD.ie_apropriacao_copartic,
						NEW.ie_apropriacao_copartic, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_gerar_cod_tit <> OLD.ie_gerar_cod_tit) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_GERAR_COD_TIT', OLD.ie_gerar_cod_tit,
						NEW.ie_gerar_cod_tit, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_contratos_estab <> OLD.ie_contratos_estab) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_CONTRATOS_ESTAB', OLD.ie_contratos_estab,
						NEW.ie_contratos_estab, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_estip_estab <> OLD.ie_estip_estab) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_ESTIP_ESTAB', OLD.ie_estip_estab,
						NEW.ie_estip_estab, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_permite_incl_dep_sit_trab <> OLD.ie_permite_incl_dep_sit_trab) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_PERMITE_INCL_DEP_SIT_TRAB', OLD.ie_permite_incl_dep_sit_trab,
						NEW.ie_permite_incl_dep_sit_trab, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_rescindir_contrato_migracao <> OLD.ie_rescindir_contrato_migracao) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_RESCINDIR_CONTRATO_MIGRACAO', OLD.ie_rescindir_contrato_migracao,
						NEW.ie_rescindir_contrato_migracao, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_rescindir_contrato_benef <> OLD.ie_rescindir_contrato_benef) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_RESCINDIR_CONTRATO_BENEF', OLD.ie_rescindir_contrato_benef,
						NEW.ie_rescindir_contrato_benef, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_rescindir_contrato_pj_benef <> OLD.ie_rescindir_contrato_pj_benef) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_RESCINDIR_CONTRATO_PJ_BENEF', OLD.ie_rescindir_contrato_pj_benef,
						NEW.ie_rescindir_contrato_pj_benef, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_reativar_sca_reativacao <> OLD.ie_reativar_sca_reativacao) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_REATIVAR_SCA_REATIVACAO', OLD.ie_reativar_sca_reativacao,
						NEW.ie_reativar_sca_reativacao, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_novo_codigo_emp_pj <> OLD.ie_novo_codigo_emp_pj) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_NOVO_CODIGO_EMP_PJ', OLD.ie_novo_codigo_emp_pj,
						NEW.ie_novo_codigo_emp_pj, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;
	-- Fim Parametros Contratos e Beneficiarios


	-- Inicio Parametros Reajuste

	if (NEW.qt_idade_limite <> OLD.qt_idade_limite) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'QT_IDADE_LIMITE', OLD.qt_idade_limite,
						NEW.qt_idade_limite, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.qt_tempo_limite <> OLD.qt_tempo_limite) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'QT_TEMPO_LIMITE', OLD.qt_tempo_limite,
						NEW.qt_tempo_limite, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_reaj_idade_limite_pre <> OLD.ie_reaj_idade_limite_pre) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_REAJ_IDADE_LIMITE_PRE', OLD.ie_reaj_idade_limite_pre,
						NEW.ie_reaj_idade_limite_pre, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_data_ref_reaj_adaptado <> OLD.ie_data_ref_reaj_adaptado) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_DATA_REF_REAJ_ADAPTADO', OLD.ie_data_ref_reaj_adaptado,
						NEW.ie_data_ref_reaj_adaptado, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_reajuste <> OLD.ie_reajuste) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_REAJUSTE', OLD.ie_reajuste,
						NEW.ie_reajuste, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_mes_cobranca_reaj <> OLD.ie_mes_cobranca_reaj) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_MES_COBRANCA_REAJ', OLD.ie_mes_cobranca_reaj,
						NEW.ie_mes_cobranca_reaj, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_mes_cobranca_reaj_reg <> OLD.ie_mes_cobranca_reaj_reg) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_MES_COBRANCA_REAJ_REG', OLD.ie_mes_cobranca_reaj_reg,
						NEW.ie_mes_cobranca_reaj_reg, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_reajustar_benef_cancelado <> OLD.ie_reajustar_benef_cancelado) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_REAJUSTAR_BENEF_CANCELADO', OLD.ie_reajustar_benef_cancelado,
						NEW.ie_reajustar_benef_cancelado, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_truncar_valor_reajuste <> OLD.ie_truncar_valor_reajuste) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_TRUNCAR_VALOR_REAJUSTE', OLD.ie_truncar_valor_reajuste,
						NEW.ie_truncar_valor_reajuste, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_consistir_envio_rpc <> OLD.ie_consistir_envio_rpc) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_CONSISTIR_ENVIO_RPC', OLD.ie_consistir_envio_rpc,
						NEW.ie_consistir_envio_rpc, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_destacar_reajuste_sca <> OLD.ie_destacar_reajuste_sca) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_DESTACAR_REAJUSTE_SCA', OLD.ie_destacar_reajuste_sca,
						NEW.ie_destacar_reajuste_sca, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_reaj_retro_benef_resc <> OLD.ie_reaj_retro_benef_resc) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_REAJ_RETRO_BENEF_RESC', OLD.ie_reaj_retro_benef_resc,
						NEW.ie_reaj_retro_benef_resc, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_reaj_tab_contrato_benef <> OLD.ie_reaj_tab_contrato_benef) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_REAJ_TAB_CONTRATO_BENEF', OLD.ie_reaj_tab_contrato_benef,
						NEW.ie_reaj_tab_contrato_benef, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_gerar_rpc_mes_aniver <> OLD.ie_gerar_rpc_mes_aniver) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_GERAR_RPC_MES_ANIVER', OLD.ie_gerar_rpc_mes_aniver,
						NEW.ie_gerar_rpc_mes_aniver, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;

	if (NEW.ie_inativar_extratos_ant <> OLD.ie_inativar_extratos_ant) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_INATIVAR_EXTRATOS_ANT', OLD.ie_inativar_extratos_ant,
						NEW.ie_inativar_extratos_ant, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;
	-- Fim Parametros Reajuste


	-- Inicio Parametros Intercambio

	if (NEW.ie_produto_tarja <> OLD.ie_produto_tarja) then
		CALL pls_gerar_log_alt_parametros(	'PLS_PARAMETROS', 'IE_PRODUTO_TARJA', OLD.ie_produto_tarja,
						NEW.ie_produto_tarja, NEW.nm_usuario, NEW.cd_estabelecimento);
	end if;
	--Fim Parametros Intercambio

end if;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_parametros_afterupdate() FROM PUBLIC;

CREATE TRIGGER pls_parametros_afterupdate
	AFTER UPDATE ON pls_parametros FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_parametros_afterupdate();

