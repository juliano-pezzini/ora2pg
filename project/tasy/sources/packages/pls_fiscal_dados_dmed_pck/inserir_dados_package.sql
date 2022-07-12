-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_fiscal_dados_dmed_pck.inserir_dados ( ie_descarregar_vetor_p text) AS $body$
BEGIN

if	((ie_descarregar_vetor_p = 'S') or (current_setting('pls_fiscal_dados_dmed_pck.nr_indice_vetor_w')::bigint >= pls_util_pck.qt_registro_transacao_w)) then
	if (current_setting('pls_fiscal_dados_dmed_pck.tb_nr_seq_item_mens_w')::pls_util_cta_pck.t_number_table.count > 0) then
		for i in current_setting('pls_fiscal_dados_dmed_pck.tb_nr_seq_item_mens_w')::pls_util_cta_pck.t_number_table.first..tb_nr_seq_item_mens_w.last loop
			insert into fis_dados_dmed(nr_sequencia, cd_cgc_administradora, cd_pessoa_fisica,
				cd_pessoa_pagador, cd_pessoa_titular, dt_atualizacao,
				dt_atualizacao_nrec, ie_tipo_contratacao, ie_tipo_contrato, 
				ie_tipo_item_mensalidade, ie_tipo_segurado, nm_usuario,
				nm_usuario_nrec, nr_seq_baixa_pag, nr_seq_baixa_rec,
				nr_seq_item_mens, nr_seq_parentesco, nr_seq_segurado,
				nr_seq_tipo_lanc, nr_titulo_pag, nr_titulo_rec, 
				vl_desconto, vl_item, vl_juros,
				vl_multa, vl_recebido_maior, cd_tributo,
				ie_retencao, vl_tributo, nr_seq_tit_trib,
				nr_seq_mens_trib, ie_origem_tributo, vl_multa_negociacao,
				vl_juros_negociacao, vl_taxa_negociacao, vl_desconto_negociacao,
				vl_glosa, nr_seq_classif_ops, nr_contrato,
				vl_nota_credito, cd_pessoa_reembolso, cd_cgc_reembolso,
				dt_devolucao, nr_seq_resc_fin_item, vl_devolucao,
				ie_tipo_pagador, nr_seq_mot_reembolso, ie_origem_protocolo,
				nr_seq_item_mens_aprop, nr_seq_centro_apropriacao, nr_seq_forma_cobranca)
			values (nextval('fis_dados_dmed_seq'), current_setting('pls_fiscal_dados_dmed_pck.tb_cd_cgc_administradora_w')::pls_util_cta_pck.t_varchar2_table_15(i), current_setting('pls_fiscal_dados_dmed_pck.tb_cd_pessoa_fisica_w')::pls_util_cta_pck.t_varchar2_table_15(i),
				current_setting('pls_fiscal_dados_dmed_pck.tb_cd_pessoa_pagador_w')::pls_util_cta_pck.t_varchar2_table_15(i), current_setting('pls_fiscal_dados_dmed_pck.tb_cd_pessoa_titular_w')::pls_util_cta_pck.t_varchar2_table_15(i), clock_timestamp(),
				clock_timestamp(), current_setting('pls_fiscal_dados_dmed_pck.tb_ie_tipo_contratacao_w')::pls_util_cta_pck.t_varchar2_table_2(i), current_setting('pls_fiscal_dados_dmed_pck.tb_ie_tipo_contrato_w')::pls_util_cta_pck.t_varchar2_table_2(i),
				current_setting('pls_fiscal_dados_dmed_pck.tb_ie_tipo_item_mensalidade_w')::pls_util_cta_pck.t_varchar2_table_2(i), current_setting('pls_fiscal_dados_dmed_pck.tb_ie_tipo_segurado_w')::pls_util_cta_pck.t_varchar2_table_1(i), current_setting('pls_fiscal_dados_dmed_pck.nm_usuario_w')::usuario.nm_usuario%type,
				current_setting('pls_fiscal_dados_dmed_pck.nm_usuario_w')::usuario.nm_usuario%type, current_setting('pls_fiscal_dados_dmed_pck.nr_seq_baixa_pag_w')::integer, current_setting('pls_fiscal_dados_dmed_pck.nr_seq_baixa_rec_w')::integer,
				current_setting('pls_fiscal_dados_dmed_pck.tb_nr_seq_item_mens_w')::pls_util_cta_pck.t_number_table(i), current_setting('pls_fiscal_dados_dmed_pck.tb_nr_seq_parentesco_w')::pls_util_cta_pck.t_number_table(i), current_setting('pls_fiscal_dados_dmed_pck.tb_nr_seq_segurado_w')::pls_util_cta_pck.t_number_table(i),
				current_setting('pls_fiscal_dados_dmed_pck.tb_nr_seq_tipo_lanc_w')::pls_util_cta_pck.t_number_table(i), current_setting('pls_fiscal_dados_dmed_pck.nr_titulo_pag_w')::integer, current_setting('pls_fiscal_dados_dmed_pck.nr_titulo_rec_w')::integer,
				current_setting('pls_fiscal_dados_dmed_pck.tb_vl_desconto_w')::pls_util_cta_pck.t_number_table(i), current_setting('pls_fiscal_dados_dmed_pck.tb_vl_item_w')::pls_util_cta_pck.t_number_table(i), current_setting('pls_fiscal_dados_dmed_pck.tb_vl_juros_w')::pls_util_cta_pck.t_number_table(i),
				current_setting('pls_fiscal_dados_dmed_pck.tb_vl_multa_w')::pls_util_cta_pck.t_number_table(i), current_setting('pls_fiscal_dados_dmed_pck.tb_vl_recebido_maior_w')::pls_util_cta_pck.t_number_table(i), current_setting('pls_fiscal_dados_dmed_pck.tb_cd_tributo_w')::pls_util_cta_pck.t_number_table(i),
				current_setting('pls_fiscal_dados_dmed_pck.tb_ie_retencao_w')::pls_util_cta_pck.t_varchar2_table_1(i), current_setting('pls_fiscal_dados_dmed_pck.tb_vl_tributo_w')::pls_util_cta_pck.t_number_table(i), current_setting('pls_fiscal_dados_dmed_pck.tb_nr_seq_tit_trib_w')::pls_util_cta_pck.t_number_table(i),
				current_setting('pls_fiscal_dados_dmed_pck.tb_nr_seq_mens_trib_w')::pls_util_cta_pck.t_number_table(i), current_setting('pls_fiscal_dados_dmed_pck.tb_ie_origem_tributo_w')::pls_util_cta_pck.t_varchar2_table_3(i), current_setting('pls_fiscal_dados_dmed_pck.tb_vl_multa_negociacao_w')::pls_util_cta_pck.t_number_table(i),
				current_setting('pls_fiscal_dados_dmed_pck.tb_vl_juros_negociacao_w')::pls_util_cta_pck.t_number_table(i), current_setting('pls_fiscal_dados_dmed_pck.tb_vl_taxa_negociacao_w')::pls_util_cta_pck.t_number_table(i), current_setting('pls_fiscal_dados_dmed_pck.tb_vl_desconto_negociacao_w')::pls_util_cta_pck.t_number_table(i),
				current_setting('pls_fiscal_dados_dmed_pck.tb_vl_glosa_w')::pls_util_cta_pck.t_number_table(i), current_setting('pls_fiscal_dados_dmed_pck.tb_nr_seq_classif_ops_w')::pls_util_cta_pck.t_number_table(i), current_setting('pls_fiscal_dados_dmed_pck.tb_nr_contrato_w')::pls_util_cta_pck.t_number_table(i),
				current_setting('pls_fiscal_dados_dmed_pck.tb_vl_nota_credito_w')::pls_util_cta_pck.t_number_table(i), current_setting('pls_fiscal_dados_dmed_pck.tb_cd_pessoa_reembolso_w')::pls_util_cta_pck.t_number_table(i), current_setting('pls_fiscal_dados_dmed_pck.tb_cd_cgc_reembolso_w')::pls_util_cta_pck.t_varchar2_table_15(i),
				current_setting('pls_fiscal_dados_dmed_pck.tb_dt_devolucao_w')::pls_util_cta_pck.t_date_table(i), current_setting('pls_fiscal_dados_dmed_pck.tb_nr_seq_resc_fin_item_w')::pls_util_cta_pck.t_number_table(i), current_setting('pls_fiscal_dados_dmed_pck.tb_vl_devolucao_w')::pls_util_cta_pck.t_number_table(i),
				current_setting('pls_fiscal_dados_dmed_pck.tb_ie_tipo_pagador_w')::pls_util_cta_pck.t_varchar2_table_2(i), current_setting('pls_fiscal_dados_dmed_pck.tb_nr_seq_mot_reembolso_w')::pls_util_cta_pck.t_number_table(i), current_setting('pls_fiscal_dados_dmed_pck.tb_ie_origem_protocolo_w')::pls_util_cta_pck.t_varchar2_table_2(i),
				current_setting('pls_fiscal_dados_dmed_pck.tb_nr_seq_item_mens_aprop_w')::pls_util_cta_pck.t_number_table(i), current_setting('pls_fiscal_dados_dmed_pck.tb_nr_seq_centro_apropriacao_w')::pls_util_cta_pck.t_number_table(i), current_setting('pls_fiscal_dados_dmed_pck.tb_nr_seq_forma_cobranca_w')::pls_util_cta_pck.t_number_table(i));
		end loop;
	end if;
	
	CALL CALL CALL CALL pls_fiscal_dados_dmed_pck.limpar_vetor();
else
	PERFORM set_config('pls_fiscal_dados_dmed_pck.nr_indice_vetor_w', current_setting('pls_fiscal_dados_dmed_pck.nr_indice_vetor_w')::bigint + 1, false);
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_fiscal_dados_dmed_pck.inserir_dados ( ie_descarregar_vetor_p text) FROM PUBLIC;
