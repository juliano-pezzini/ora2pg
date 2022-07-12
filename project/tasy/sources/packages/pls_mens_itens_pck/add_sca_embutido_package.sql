-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_mens_itens_pck.add_sca_embutido ( nr_indice_preco_p integer, nr_seq_mensalidade_p pls_mensalidade.nr_sequencia%type, nr_seq_vinculo_sca_p pls_sca_vinculo.nr_sequencia%type, nr_parcela_p pls_mensalidade_sca.nr_parcela%type, vl_parcela_p pls_mensalidade_sca.vl_parcela%type, nr_seq_segurado_preco_p pls_mensalidade_sca.nr_seq_segurado_preco%type, ie_lancamento_mensalidade_p pls_sca_vinculo.ie_lancamento_mensalidade%type, dt_inicio_cobertura_p pls_mensalidade_sca.dt_inicio_cobertura%type, dt_fim_cobertura_p pls_mensalidade_sca.dt_fim_cobertura%type) AS $body$
BEGIN
current_setting('pls_mens_itens_pck.tb_sca_indice_preco_pre_w')::pls_util_cta_pck.t_number_table(current_setting('pls_mens_itens_pck.nr_indice_sca_emb_w')::integer)		:= nr_indice_preco_p;
current_setting('pls_mens_itens_pck.tb_sca_seq_mensalidade_w')::pls_util_cta_pck.t_number_table(current_setting('pls_mens_itens_pck.nr_indice_sca_emb_w')::integer)		:= nr_seq_mensalidade_p;
current_setting('pls_mens_itens_pck.tb_sca_nr_seq_vinculo_sca_w')::pls_util_cta_pck.t_number_table(current_setting('pls_mens_itens_pck.nr_indice_sca_emb_w')::integer)	:= nr_seq_vinculo_sca_p;
current_setting('pls_mens_itens_pck.tb_sca_parcela_w')::pls_util_cta_pck.t_number_table(current_setting('pls_mens_itens_pck.nr_indice_sca_emb_w')::integer)			:= nr_parcela_p;
current_setting('pls_mens_itens_pck.tb_sca_vl_item_w')::pls_util_cta_pck.t_number_table(current_setting('pls_mens_itens_pck.nr_indice_sca_emb_w')::integer)			:= vl_parcela_p;
current_setting('pls_mens_itens_pck.tb_sca_nr_seq_segurado_preco_w')::pls_util_cta_pck.t_number_table(current_setting('pls_mens_itens_pck.nr_indice_sca_emb_w')::integer)	:= nr_seq_segurado_preco_p;
current_setting('pls_mens_itens_pck.tb_sca_inicio_cobertura_w')::pls_util_cta_pck.t_date_table(current_setting('pls_mens_itens_pck.nr_indice_sca_emb_w')::integer)		:= dt_inicio_cobertura_p;
current_setting('pls_mens_itens_pck.tb_sca_fim_cobertura_w')::pls_util_cta_pck.t_date_table(current_setting('pls_mens_itens_pck.nr_indice_sca_emb_w')::integer)		:= dt_fim_cobertura_p;
PERFORM set_config('pls_mens_itens_pck.nr_indice_sca_emb_w', current_setting('pls_mens_itens_pck.nr_indice_sca_emb_w')::integer + 1, false);

--Atualizar o item preco pre-estabelecido

current_setting('pls_mens_itens_pck.tb_vl_sca_embutido_w')::pls_util_cta_pck.t_number_table(nr_indice_preco_p)	:= current_setting('pls_mens_itens_pck.tb_vl_sca_embutido_w')::pls_util_cta_pck.t_number_table(nr_indice_preco_p) + vl_parcela_p;
if (ie_lancamento_mensalidade_p = 'C') then --Embutido acrescendo o preco pre-estabelecido
	current_setting('pls_mens_itens_pck.tb_vl_item_w')::pls_util_cta_pck.t_number_table(nr_indice_preco_p)	:= current_setting('pls_mens_itens_pck.tb_vl_item_w')::pls_util_cta_pck.t_number_table(nr_indice_preco_p) + vl_parcela_p;
end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mens_itens_pck.add_sca_embutido ( nr_indice_preco_p integer, nr_seq_mensalidade_p pls_mensalidade.nr_sequencia%type, nr_seq_vinculo_sca_p pls_sca_vinculo.nr_sequencia%type, nr_parcela_p pls_mensalidade_sca.nr_parcela%type, vl_parcela_p pls_mensalidade_sca.vl_parcela%type, nr_seq_segurado_preco_p pls_mensalidade_sca.nr_seq_segurado_preco%type, ie_lancamento_mensalidade_p pls_sca_vinculo.ie_lancamento_mensalidade%type, dt_inicio_cobertura_p pls_mensalidade_sca.dt_inicio_cobertura%type, dt_fim_cobertura_p pls_mensalidade_sca.dt_fim_cobertura%type) FROM PUBLIC;
