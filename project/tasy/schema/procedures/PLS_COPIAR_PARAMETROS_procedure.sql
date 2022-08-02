-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_copiar_parametros ( cd_estab_origem_p bigint, cd_estab_destino_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_parametros_w		bigint;
nr_seq_parametros_ant_w		bigint;
cd_serie_nf_w			nota_fiscal.cd_serie_nf%type;
cd_serie_desp_nf_w		varchar(5);
qt_serie_nota_fiscal_w		bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		cd_serie_nf,
		cd_serie_desp_nf
	from	pls_parametros
	where	cd_estabelecimento	= cd_estab_origem_p;


BEGIN
open C01;
loop
fetch C01 into	
	nr_seq_parametros_ant_w,
	cd_serie_nf_w,
	cd_serie_desp_nf_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	nextval('pls_parametros_seq')
	into STRICT	nr_seq_parametros_w
	;

	select	count(*)
	into STRICT	qt_serie_nota_fiscal_w
	from	serie_nota_fiscal
	where	cd_estabelecimento	= cd_estab_destino_p
	and	cd_serie_nf = cd_serie_nf_w;

	if (qt_serie_nota_fiscal_w = 0) then
		cd_serie_nf_w	:= null;
	end if;
	
	select	count(*)
	into STRICT	qt_serie_nota_fiscal_w
	from	serie_nota_fiscal
	where	cd_estabelecimento	= cd_estab_destino_p
	and	cd_serie_nf = cd_serie_desp_nf_w;
	
	if (qt_serie_nota_fiscal_w = 0) then
		cd_serie_desp_nf_w	:= null;
	end if;

	insert into  pls_parametros(nr_sequencia, cd_estabelecimento, dt_atualizacao,
		nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
		ie_exige_lib_bras, ie_fora_linha_simpro, qt_idade_limite, 
		qt_tempo_limite, nr_seq_emissor, nr_seq_conta_banco, 
		nr_seq_motivo_inclusao, cd_perfil_comunic_integr, ie_origem_titulo, 
		cd_tipo_taxa_juro, cd_tipo_taxa_multa, pr_juro_padrao, 
		pr_multa_padrao, ie_origem_tit_pagar, cd_natureza_operacao, 
		nr_seq_classif_fiscal, nr_seq_sit_trib, cd_serie_nf, 
		cd_operacao_nf, cd_condicao_pagamento, qt_dias_rescisao_mig, 
		nr_seq_trans_fin_baixa, ie_origem_tit_reembolso, cd_centro_custo, 
		nr_seq_trans_fin_inadi, cd_tipo_recebimento, cd_tipo_receb_inadimplencia, 
		qt_dias_protocolo, cd_operacao_desp_nf, cd_natureza_operacao_desp, 
		nr_seq_sit_trib_desp, cd_serie_desp_nf, ie_material_rede_propria, 
		nr_seq_trans_fin_baixa_conta, nr_seq_trans_fin_baixa_reemb, ie_fluxo_caixa, 
		ie_idade_saldo, ie_lucro_prejuizo, ie_solvencia, 
		ie_balancete_ativo, ie_balancete_passivo, ie_balancete_receita, 
		ie_balancete_despesa, ie_geracao_coparticipacao, nr_seq_trans_fin_baixa_vend, 
		cd_conta_financ, nr_seq_tipo_avaliacao, cd_conta_financ_conta, 
		/*cd_conta_financ_mensalidade,*/
 cd_conta_financ_ressarcimento, cd_conta_financ_reembolso, 
		nr_seq_relatorio, nr_seq_relatorio_cat, ie_tela_guia_cm, 
		cd_cgc_ans, ie_origem_tit_taxa_saude, nr_seq_trans_fin_baixa_taxa, 
		cd_conta_financ_taxa, cd_tipo_receb_adiantamento, cd_moeda_adiantamento, 
		cd_portador, cd_tipo_portador, nr_seq_trans_fin_baixa_prov, 
		cd_conta_financ_prov, nr_seq_modelo, nr_seq_agente_motivador, 
		ie_hash_conta, ie_intercambio, ie_pro_rata_dia, ie_reajuste, 
		ie_analise_cm_nova, ie_libera_item_sem_glosa, ie_utilizar_liberacao_pacote, ie_desfaz_lote_pag_copartic,
		ie_alt_nova_analise, ie_sip_contagem_evento, ie_cobra_tx_inter_copartic)
	SELECT	nr_seq_parametros_w, cd_estab_destino_p, clock_timestamp(),
		nm_usuario_p, clock_timestamp(), nm_usuario_p,
		ie_exige_lib_bras, ie_fora_linha_simpro, qt_idade_limite, 
		qt_tempo_limite, nr_seq_emissor, nr_seq_conta_banco, 
		nr_seq_motivo_inclusao, cd_perfil_comunic_integr, ie_origem_titulo, 
		cd_tipo_taxa_juro, cd_tipo_taxa_multa, pr_juro_padrao, 
		pr_multa_padrao, ie_origem_tit_pagar, cd_natureza_operacao, 
		nr_seq_classif_fiscal, nr_seq_sit_trib, cd_serie_nf_w, 
		cd_operacao_nf, cd_condicao_pagamento, qt_dias_rescisao_mig, 
		nr_seq_trans_fin_baixa, ie_origem_tit_reembolso, cd_centro_custo, 
		nr_seq_trans_fin_inadi, cd_tipo_recebimento, cd_tipo_receb_inadimplencia, 
		qt_dias_protocolo, cd_operacao_desp_nf, cd_natureza_operacao_desp, 
		nr_seq_sit_trib_desp, cd_serie_desp_nf_w, ie_material_rede_propria, 
		nr_seq_trans_fin_baixa_conta, nr_seq_trans_fin_baixa_reemb, ie_fluxo_caixa, 
		ie_idade_saldo, ie_lucro_prejuizo, ie_solvencia, 
		ie_balancete_ativo, ie_balancete_passivo, ie_balancete_receita, 
		ie_balancete_despesa, ie_geracao_coparticipacao, nr_seq_trans_fin_baixa_vend, 
		cd_conta_financ, nr_seq_tipo_avaliacao, cd_conta_financ_conta, 
		/*cd_conta_financ_mensalidade,*/
 cd_conta_financ_ressarcimento, cd_conta_financ_reembolso, 
		nr_seq_relatorio, nr_seq_relatorio_cat, ie_tela_guia_cm, 
		cd_cgc_ans, ie_origem_tit_taxa_saude, nr_seq_trans_fin_baixa_taxa, 
		cd_conta_financ_taxa, cd_tipo_receb_adiantamento, cd_moeda_adiantamento, 
		cd_portador, cd_tipo_portador, nr_seq_trans_fin_baixa_prov, 
		cd_conta_financ_prov, nr_seq_modelo, nr_seq_agente_motivador, 
		ie_hash_conta, ie_intercambio, ie_pro_rata_dia, ie_reajuste, 
		ie_analise_cm_nova, ie_libera_item_sem_glosa, ie_utilizar_liberacao_pacote, ie_desfaz_lote_pag_copartic,
		ie_alt_nova_analise, ie_sip_contagem_evento, ie_cobra_tx_inter_copartic
	from	pls_parametros
	where	nr_sequencia	= nr_seq_parametros_ant_w;
	
end;
end loop;
close C01;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_copiar_parametros ( cd_estab_origem_p bigint, cd_estab_destino_p bigint, nm_usuario_p text) FROM PUBLIC;

