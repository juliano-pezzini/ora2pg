-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_solic_lead_html ( nr_seq_simulacao_p bigint, nm_pessoa_solicitacao_p text, nm_contato_p text, cd_cep_p text, ds_endereco_p text, nr_endereco_p text, ds_bairro_p text, ds_complemento_p text, cd_municipio_ibge_p text, sg_estado_p text, dt_nascimento_p timestamp, nr_ddi_p text, nr_ddd_p text, nr_telefone_p text, ds_email_p text, nr_celular_p text, nr_acao_origem_p bigint, ie_tipo_contratacao_p text, nr_seq_classificacao_p bigint, nr_seq_agente_motiv_p bigint, cd_pf_vinculado_p text, cd_cgc_vinculado_p text, nr_seq_solicitacao_p INOUT bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


/*
	Rotina criada unicamente para HTML5, onde passa o campo dt_nascimento no formato date e
	converte para String(apenas para não realizar nenhum ajuste na rotina padrão)
*/
BEGIN

	nr_seq_solicitacao_p := pls_gerar_solicit_lead_simul(
		nr_seq_simulacao_p, nm_pessoa_solicitacao_p, nm_contato_p, cd_cep_p, ds_endereco_p, nr_endereco_p, ds_bairro_p, ds_complemento_p, cd_municipio_ibge_p, sg_estado_p, to_char(dt_nascimento_p, 'DD/MM/YYYY'), nr_ddi_p, nr_ddd_p, nr_telefone_p, ds_email_p, nr_celular_p, nr_acao_origem_p, ie_tipo_contratacao_p, nr_seq_classificacao_p, nr_seq_agente_motiv_p, cd_pf_vinculado_p, cd_cgc_vinculado_p, nr_seq_solicitacao_p, cd_estabelecimento_p, nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_solic_lead_html ( nr_seq_simulacao_p bigint, nm_pessoa_solicitacao_p text, nm_contato_p text, cd_cep_p text, ds_endereco_p text, nr_endereco_p text, ds_bairro_p text, ds_complemento_p text, cd_municipio_ibge_p text, sg_estado_p text, dt_nascimento_p timestamp, nr_ddi_p text, nr_ddd_p text, nr_telefone_p text, ds_email_p text, nr_celular_p text, nr_acao_origem_p bigint, ie_tipo_contratacao_p text, nr_seq_classificacao_p bigint, nr_seq_agente_motiv_p bigint, cd_pf_vinculado_p text, cd_cgc_vinculado_p text, nr_seq_solicitacao_p INOUT bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
