-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_sib_geracao_pck.inicia_registro () AS $body$
BEGIN
current_setting('pls_sib_geracao_pck.tb_nr_seq_segurado_w')::pls_util_cta_pck.t_number_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_ie_tipo_movimento_w')::pls_util_cta_pck.t_number_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_cd_cco_w')::pls_util_cta_pck.t_varchar2_table_15(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nm_beneficiario_w')::pls_util_cta_pck.t_varchar2_table_255(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_dt_rescisao_w')::pls_util_cta_pck.t_date_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_seq_motivo_cancel_w')::pls_util_cta_pck.t_number_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_cd_motivo_cancelamento_w')::pls_util_cta_pck.t_varchar2_table_5(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_dt_reativacao_w')::pls_util_cta_pck.t_date_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_dt_nascimento_w')::pls_util_cta_pck.t_date_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_cd_sexo_w')::pls_util_cta_pck.t_number_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_cpf_w')::pls_util_cta_pck.t_varchar2_table_15(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_pis_pasep_w')::pls_util_cta_pck.t_varchar2_table_15(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nm_mae_w')::pls_util_cta_pck.t_varchar2_table_255(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_dn_w')::pls_util_cta_pck.t_varchar2_table_15(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_cns_w')::pls_util_cta_pck.t_number_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_cd_beneficiario_w')::pls_util_cta_pck.t_varchar2_table_50(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_cd_beneficiario_titular_w')::pls_util_cta_pck.t_varchar2_table_50(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_dt_contratacao_w')::pls_util_cta_pck.t_date_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_seq_plano_w')::pls_util_cta_pck.t_number_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_ie_retificacao_null_w')::pls_util_cta_pck.t_varchar2_table_5(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_plano_ans_w')::pls_util_cta_pck.t_varchar2_table_50(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_plano_operadora_w')::pls_util_cta_pck.t_varchar2_table_50(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_plano_portabilidade_w')::pls_util_cta_pck.t_varchar2_table_50(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_ie_cpt_w')::pls_util_cta_pck.t_number_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_ie_itens_excluidos_cober_w')::pls_util_cta_pck.t_number_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_cnpj_w')::pls_util_cta_pck.t_varchar2_table_15(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_cei_w')::pls_util_cta_pck.t_varchar2_table_50(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_cd_caepf_w')::pls_util_cta_pck.t_varchar2_table_15(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_seq_parentesco_w')::pls_util_cta_pck.t_number_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_cd_relacao_dependencia_w')::pls_util_cta_pck.t_number_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_ie_tipo_endereco_w')::pls_util_cta_pck.t_varchar2_table_5(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_ds_logradouro_w')::pls_util_cta_pck.t_varchar2_table_255(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_logradouro_w')::pls_util_cta_pck.t_varchar2_table_5(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_ds_complemento_w')::pls_util_cta_pck.t_varchar2_table_255(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_ds_bairro_w')::pls_util_cta_pck.t_varchar2_table_255(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_cd_municipio_ibge_w')::pls_util_cta_pck.t_varchar2_table_15(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_cd_cep_w')::pls_util_cta_pck.t_varchar2_table_15(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_ie_reside_exterior_w')::pls_util_cta_pck.t_varchar2_table_5(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_cd_municipio_ibge_resid_w')::pls_util_cta_pck.t_varchar2_table_15(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_seq_reenvio_w')::pls_util_cta_pck.t_number_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_seq_status_inclusao_w')::pls_util_cta_pck.t_number_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_seq_status_exclusao_w')::pls_util_cta_pck.t_number_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;

current_setting('pls_sib_geracao_pck.tb_nm_beneficiario_ant_w')::pls_util_cta_pck.t_varchar2_table_255(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_dt_rescisao_ant_w')::pls_util_cta_pck.t_date_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_cd_motivo_cancel_ant_w')::pls_util_cta_pck.t_varchar2_table_5(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_dt_reativacao_ant_w')::pls_util_cta_pck.t_date_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_dt_nascimento_ant_w')::pls_util_cta_pck.t_date_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_cd_sexo_ant_w')::pls_util_cta_pck.t_number_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_cpf_ant_w')::pls_util_cta_pck.t_varchar2_table_15(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_pis_pasep_ant_w')::pls_util_cta_pck.t_varchar2_table_15(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nm_mae_ant_w')::pls_util_cta_pck.t_varchar2_table_255(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_dn_ant_w')::pls_util_cta_pck.t_varchar2_table_15(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_cns_ant_w')::pls_util_cta_pck.t_number_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_cd_beneficiario_ant_w')::pls_util_cta_pck.t_varchar2_table_50(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_cd_beneficiario_tit_ant_w')::pls_util_cta_pck.t_varchar2_table_50(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_dt_contratacao_ant_w')::pls_util_cta_pck.t_date_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_plano_ans_ant_w')::pls_util_cta_pck.t_varchar2_table_50(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_plano_operadora_ant_w')::pls_util_cta_pck.t_varchar2_table_50(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_plano_portab_ant_w')::pls_util_cta_pck.t_varchar2_table_50(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_ie_cpt_ant_w')::pls_util_cta_pck.t_number_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_ie_itens_excluidos_ant_w')::pls_util_cta_pck.t_number_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_cnpj_ant_w')::pls_util_cta_pck.t_varchar2_table_15(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_cei_ant_w')::pls_util_cta_pck.t_varchar2_table_50(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_cd_caepf_ant_w')::pls_util_cta_pck.t_varchar2_table_15(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_cd_relacao_depend_ant_w')::pls_util_cta_pck.t_number_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_ie_tipo_endereco_ant_w')::pls_util_cta_pck.t_varchar2_table_5(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_ds_logradouro_ant_w')::pls_util_cta_pck.t_varchar2_table_255(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_nr_logradouro_ant_w')::pls_util_cta_pck.t_varchar2_table_5(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_ds_complemento_ant_w')::pls_util_cta_pck.t_varchar2_table_255(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_ds_bairro_ant_w')::pls_util_cta_pck.t_varchar2_table_255(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_cd_municipio_ibge_ant_w')::pls_util_cta_pck.t_varchar2_table_15(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_cd_cep_ant_w')::pls_util_cta_pck.t_varchar2_table_15(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_ie_reside_exterior_ant_w')::pls_util_cta_pck.t_varchar2_table_5(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
current_setting('pls_sib_geracao_pck.tb_cd_municipio_ibge_res_ant_w')::pls_util_cta_pck.t_varchar2_table_15(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sib_geracao_pck.inicia_registro () FROM PUBLIC;