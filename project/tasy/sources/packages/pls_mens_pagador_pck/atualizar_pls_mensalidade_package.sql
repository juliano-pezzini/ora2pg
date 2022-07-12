-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_mens_pagador_pck.atualizar_pls_mensalidade ( tb_nr_seq_pagador_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_pagador_fin_p INOUT pls_util_cta_pck.t_number_table, tb_dt_referencia_p INOUT pls_util_cta_pck.t_date_table, tb_dt_vencimento_p INOUT pls_util_cta_pck.t_date_table, tb_nr_seq_forma_cobranca_p INOUT pls_util_cta_pck.t_number_table, tb_cd_banco_p INOUT pls_util_cta_pck.t_number_table, tb_cd_agencia_bancaria_p INOUT pls_util_cta_pck.t_varchar2_table_10, tb_ie_digito_agencia_p INOUT pls_util_cta_pck.t_varchar2_table_2, tb_cd_conta_p INOUT pls_util_cta_pck.t_varchar2_table_20, tb_ie_digito_conta_p INOUT pls_util_cta_pck.t_varchar2_table_2, tb_ie_endereco_boleto_p INOUT pls_util_cta_pck.t_varchar2_table_10, tb_nr_seq_conta_banco_p INOUT pls_util_cta_pck.t_number_table, tb_ie_gerar_cobr_escrit_p INOUT pls_util_cta_pck.t_varchar2_table_2, tb_nr_seq_conta_banco_deb_au_p INOUT pls_util_cta_pck.t_number_table, tb_ie_proporcional_p INOUT pls_util_cta_pck.t_varchar2_table_1, tb_nr_seq_compl_pf_tel_adic_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_compl_pj_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_tipo_compl_adic_p INOUT pls_util_cta_pck.t_number_table, tb_ie_nota_titulo_p INOUT pls_util_cta_pck.t_varchar2_table_2, tb_ie_tipo_formacao_preco_p INOUT pls_util_cta_pck.t_varchar2_table_1, tb_nr_serie_mensalidade_p INOUT pls_util_cta_pck.t_varchar2_table_50, tb_nr_parcela_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_motivo_susp_p INOUT pls_util_cta_pck.t_number_table, tb_ie_tipo_estipulante_p INOUT pls_util_cta_pck.t_varchar2_table_2, tb_ie_indice_correcao_p INOUT pls_util_cta_pck.t_varchar2_table_2, nm_usuario_p text ) AS $body$
BEGIN

if (tb_nr_seq_pagador_p.count > 0) then
	forall i in tb_nr_seq_pagador_p.first..tb_nr_seq_pagador_p.last
		insert	into	pls_mensalidade(	nr_sequencia, nr_seq_lote, nr_seq_pagador, nr_seq_pagador_fin,
				dt_atualizacao, dt_atualizacao_nrec, nm_usuario, nm_usuario_nrec,
				dt_referencia, vl_mensalidade, dt_vencimento, ie_apresentacao,
				nr_seq_forma_cobranca, cd_banco,
				cd_agencia_bancaria, ie_digito_agencia,
				cd_conta, ie_digito_conta,
				ie_endereco_boleto, nr_seq_conta_banco,
				ie_gerar_cobr_escrit, nr_seq_conta_banco_deb_aut,
				ie_proporcional, nr_seq_compl_pf_tel_adic,
				nr_seq_compl_pj, nr_seq_tipo_compl_adic,
				ie_nota_titulo, ie_tipo_formacao_preco,
				nr_serie_mensalidade, nr_parcela, nr_seq_motivo_susp,
				ie_tipo_estipulante, ie_indice_correcao
				)
			values (	nextval('pls_mensalidade_seq'), current_setting('pls_mens_pagador_pck.pls_lote_mensalidade_w')::pls_lote_mensalidade%rowtype.nr_sequencia, tb_nr_seq_pagador_p(i), tb_nr_seq_pagador_fin_p(i),
				clock_timestamp(), clock_timestamp(), nm_usuario_p, nm_usuario_p,
				tb_dt_referencia_p(i), 0, tb_dt_vencimento_p(i), 1,
				tb_nr_seq_forma_cobranca_p(i), tb_cd_banco_p(i),
				tb_cd_agencia_bancaria_p(i), tb_ie_digito_agencia_p(i),
				tb_cd_conta_p(i), tb_ie_digito_conta_p(i),
				tb_ie_endereco_boleto_p(i), tb_nr_seq_conta_banco_p(i),
				tb_ie_gerar_cobr_escrit_p(i), tb_nr_seq_conta_banco_deb_au_p(i),
				tb_ie_proporcional_p(i), tb_nr_seq_compl_pf_tel_adic_p(i),
				tb_nr_seq_compl_pj_p(i), tb_nr_seq_tipo_compl_adic_p(i),
				tb_ie_nota_titulo_p(i), tb_ie_tipo_formacao_preco_p(i),
				tb_nr_serie_mensalidade_p(i), tb_nr_parcela_p(i), tb_nr_seq_motivo_susp_p(i),
				tb_ie_tipo_estipulante_p(i), tb_ie_indice_correcao_p(i)
				);
	commit;
end if;

-- reinicializa as variaveis

tb_nr_seq_pagador_p.delete;
tb_nr_seq_pagador_fin_p.delete;
tb_dt_referencia_p.delete;
tb_dt_vencimento_p.delete;
tb_nr_seq_forma_cobranca_p.delete;
tb_cd_banco_p.delete;
tb_cd_agencia_bancaria_p.delete;
tb_ie_digito_agencia_p.delete;
tb_cd_conta_p.delete;
tb_ie_digito_conta_p.delete;
tb_ie_endereco_boleto_p.delete;
tb_nr_seq_conta_banco_p.delete;
tb_ie_gerar_cobr_escrit_p.delete;
tb_nr_seq_conta_banco_deb_au_p.delete;
tb_ie_proporcional_p.delete;
tb_nr_seq_compl_pf_tel_adic_p.delete;
tb_nr_seq_compl_pj_p.delete;
tb_nr_seq_tipo_compl_adic_p.delete;
tb_ie_nota_titulo_p.delete;
tb_ie_tipo_formacao_preco_p.delete;
tb_nr_serie_mensalidade_p.delete;
tb_nr_parcela_p.delete;
tb_nr_seq_motivo_susp_p.delete;
tb_ie_tipo_estipulante_p.delete;
tb_ie_indice_correcao_p.delete;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mens_pagador_pck.atualizar_pls_mensalidade ( tb_nr_seq_pagador_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_pagador_fin_p INOUT pls_util_cta_pck.t_number_table, tb_dt_referencia_p INOUT pls_util_cta_pck.t_date_table, tb_dt_vencimento_p INOUT pls_util_cta_pck.t_date_table, tb_nr_seq_forma_cobranca_p INOUT pls_util_cta_pck.t_number_table, tb_cd_banco_p INOUT pls_util_cta_pck.t_number_table, tb_cd_agencia_bancaria_p INOUT pls_util_cta_pck.t_varchar2_table_10, tb_ie_digito_agencia_p INOUT pls_util_cta_pck.t_varchar2_table_2, tb_cd_conta_p INOUT pls_util_cta_pck.t_varchar2_table_20, tb_ie_digito_conta_p INOUT pls_util_cta_pck.t_varchar2_table_2, tb_ie_endereco_boleto_p INOUT pls_util_cta_pck.t_varchar2_table_10, tb_nr_seq_conta_banco_p INOUT pls_util_cta_pck.t_number_table, tb_ie_gerar_cobr_escrit_p INOUT pls_util_cta_pck.t_varchar2_table_2, tb_nr_seq_conta_banco_deb_au_p INOUT pls_util_cta_pck.t_number_table, tb_ie_proporcional_p INOUT pls_util_cta_pck.t_varchar2_table_1, tb_nr_seq_compl_pf_tel_adic_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_compl_pj_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_tipo_compl_adic_p INOUT pls_util_cta_pck.t_number_table, tb_ie_nota_titulo_p INOUT pls_util_cta_pck.t_varchar2_table_2, tb_ie_tipo_formacao_preco_p INOUT pls_util_cta_pck.t_varchar2_table_1, tb_nr_serie_mensalidade_p INOUT pls_util_cta_pck.t_varchar2_table_50, tb_nr_parcela_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_motivo_susp_p INOUT pls_util_cta_pck.t_number_table, tb_ie_tipo_estipulante_p INOUT pls_util_cta_pck.t_varchar2_table_2, tb_ie_indice_correcao_p INOUT pls_util_cta_pck.t_varchar2_table_2, nm_usuario_p text ) FROM PUBLIC;