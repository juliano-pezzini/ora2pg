-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_mens_itens_pck.add_detalhe_item_conta (nr_indice_item_p integer, nr_seq_conta_copartic_p pls_conta_coparticipacao.nr_sequencia%type, nr_seq_conta_pos_estab_p pls_conta_pos_estabelecido.nr_sequencia%type, nr_seq_conta_co_p pls_conta_co.nr_sequencia%type, vl_item_p bigint, vl_ato_cooperado_p bigint, vl_ato_auxiliar_p bigint, vl_ato_nao_coop_p bigint, nr_seq_conta_pos_proc_p pls_conta_pos_proc.nr_sequencia%type, nr_seq_conta_pos_mat_p pls_conta_pos_mat.nr_sequencia%type, ds_observacao_p pls_mensalidade_item_conta.ds_observacao%type, ie_excecao_item_valor_limite_p text, tb_apropriacao_item_p tb_apropriacao_item) AS $body$
BEGIN
current_setting('pls_mens_itens_pck.tb_conta_indice_item_w')::pls_util_cta_pck.t_number_table(current_setting('pls_mens_itens_pck.nr_indice_conta_w')::integer)	:= nr_indice_item_p;
current_setting('pls_mens_itens_pck.tb_conta_nr_seq_copartic_w')::pls_util_cta_pck.t_number_table(current_setting('pls_mens_itens_pck.nr_indice_conta_w')::integer)	:= nr_seq_conta_copartic_p;
current_setting('pls_mens_itens_pck.tb_conta_nr_seq_pos_estab_w')::pls_util_cta_pck.t_number_table(current_setting('pls_mens_itens_pck.nr_indice_conta_w')::integer)	:= nr_seq_conta_pos_estab_p;
current_setting('pls_mens_itens_pck.tb_conta_nr_seq_conta_co_w')::pls_util_cta_pck.t_number_table(current_setting('pls_mens_itens_pck.nr_indice_conta_w')::integer)	:= nr_seq_conta_co_p;
current_setting('pls_mens_itens_pck.tb_conta_vl_item_w')::pls_util_cta_pck.t_number_table(current_setting('pls_mens_itens_pck.nr_indice_conta_w')::integer)		:= vl_item_p;
current_setting('pls_mens_itens_pck.tb_conta_vl_ato_cooperado_w')::pls_util_cta_pck.t_number_table(current_setting('pls_mens_itens_pck.nr_indice_conta_w')::integer)	:= vl_ato_cooperado_p;
current_setting('pls_mens_itens_pck.tb_conta_vl_ato_auxiliar_w')::pls_util_cta_pck.t_number_table(current_setting('pls_mens_itens_pck.nr_indice_conta_w')::integer)	:= vl_ato_auxiliar_p;
current_setting('pls_mens_itens_pck.tb_conta_vl_ato_nao_coop_w')::pls_util_cta_pck.t_number_table(current_setting('pls_mens_itens_pck.nr_indice_conta_w')::integer)	:= vl_ato_nao_coop_p;
current_setting('pls_mens_itens_pck.tb_conta_pos_proc_w')::pls_util_cta_pck.t_number_table(current_setting('pls_mens_itens_pck.nr_indice_conta_w')::integer)		:= nr_seq_conta_pos_proc_p;
current_setting('pls_mens_itens_pck.tb_excecao_item_valor_limite_w')::pls_util_cta_pck.t_varchar2_table_1(current_setting('pls_mens_itens_pck.nr_indice_conta_w')::integer) := coalesce(ie_excecao_item_valor_limite_p, 'N');
current_setting('pls_mens_itens_pck.tb_conta_pos_mat_w')::pls_util_cta_pck.t_number_table(current_setting('pls_mens_itens_pck.nr_indice_conta_w')::integer)		:= nr_seq_conta_pos_mat_p;
current_setting('pls_mens_itens_pck.tb_conta_ds_observacao_w')::pls_util_cta_pck.t_varchar2_table_4000(current_setting('pls_mens_itens_pck.nr_indice_conta_w')::integer)	:= ds_observacao_p;
current_setting('pls_mens_itens_pck.tb_conta_apropriacao_w')::tb_apropriacao_item_t(current_setting('pls_mens_itens_pck.nr_indice_conta_w')::integer)	:= tb_apropriacao_item_p;

PERFORM set_config('pls_mens_itens_pck.nr_indice_conta_w', current_setting('pls_mens_itens_pck.nr_indice_conta_w')::integer + 1, false);

current_setting('pls_mens_itens_pck.tb_vl_item_w')::pls_util_cta_pck.t_number_table(nr_indice_item_p)			:= current_setting('pls_mens_itens_pck.tb_vl_item_w')::pls_util_cta_pck.t_number_table(nr_indice_item_p) + vl_item_p;
current_setting('pls_mens_itens_pck.tb_vl_ato_cooperado_w')::pls_util_cta_pck.t_number_table(nr_indice_item_p)		:= current_setting('pls_mens_itens_pck.tb_vl_ato_cooperado_w')::pls_util_cta_pck.t_number_table(nr_indice_item_p) + vl_ato_cooperado_p;
current_setting('pls_mens_itens_pck.tb_vl_ato_auxiliar_w')::pls_util_cta_pck.t_number_table(nr_indice_item_p)		:= current_setting('pls_mens_itens_pck.tb_vl_ato_auxiliar_w')::pls_util_cta_pck.t_number_table(nr_indice_item_p) + vl_ato_auxiliar_p;
current_setting('pls_mens_itens_pck.tb_vl_ato_nao_cooperado_w')::pls_util_cta_pck.t_number_table(nr_indice_item_p)	:= current_setting('pls_mens_itens_pck.tb_vl_ato_nao_cooperado_w')::pls_util_cta_pck.t_number_table(nr_indice_item_p) + vl_ato_nao_coop_p;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mens_itens_pck.add_detalhe_item_conta (nr_indice_item_p integer, nr_seq_conta_copartic_p pls_conta_coparticipacao.nr_sequencia%type, nr_seq_conta_pos_estab_p pls_conta_pos_estabelecido.nr_sequencia%type, nr_seq_conta_co_p pls_conta_co.nr_sequencia%type, vl_item_p bigint, vl_ato_cooperado_p bigint, vl_ato_auxiliar_p bigint, vl_ato_nao_coop_p bigint, nr_seq_conta_pos_proc_p pls_conta_pos_proc.nr_sequencia%type, nr_seq_conta_pos_mat_p pls_conta_pos_mat.nr_sequencia%type, ds_observacao_p pls_mensalidade_item_conta.ds_observacao%type, ie_excecao_item_valor_limite_p text, tb_apropriacao_item_p tb_apropriacao_item) FROM PUBLIC;