-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE tws_solicitacao_rescisao_pck.gerar_solicitacao_rescisao ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_ddi_celular_p pls_solic_resc_contato.nr_ddi_celular%type, nr_ddd_celular_p pls_solic_resc_contato.nr_ddd_celular%type, nr_telefone_celular_p pls_solic_resc_contato.nr_telefone_celular%type, nr_ddi_telefone_p pls_solic_resc_contato.nr_ddi_telefone%type, nr_ddd_telefone_p pls_solic_resc_contato.nr_ddd_telefone%type, nr_telefone_p pls_solic_resc_contato.nr_telefone%type, ds_email_p pls_solic_resc_contato.ds_email%type, nm_pessoa_devolucao_p pls_solicitacao_rescisao.nm_pessoa_devolucao%type, nr_cpf_devolucao_p pessoa_fisica.nr_cpf%type, cd_banco_p pls_solicitacao_rescisao.cd_banco%type, cd_agencia_bancaria_p pls_solicitacao_rescisao.cd_agencia_bancaria%type, ie_digito_agencia_p pls_solicitacao_rescisao.ie_digito_agencia%type, cd_conta_p pls_solicitacao_rescisao.cd_conta%type, ie_digito_conta_p pls_solicitacao_rescisao.ie_digito_conta%type, nm_usuario_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, id_app_externo_p bigint, ie_app_externo_p text, nr_seq_solicitacao_p INOUT pls_solicitacao_rescisao.nr_sequencia%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Gerar o cabeçalho da solicitação de rescisão.
O parâmetro nr_seq_segurado_p refere-se ao usuário logado que realizou a solicitação.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ x] Outros: TWS
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 

nr_protocolo_atend_w		pls_protocolo_atendimento.nr_protocolo%type;


BEGIN

pls_gerar_solic_resc_seg_web(	nr_seq_segurado_p, null, nr_ddi_celular_p,
				nr_ddd_celular_p, nr_telefone_celular_p, nr_ddi_telefone_p,
				nr_ddd_telefone_p, nr_telefone_p, ds_email_p,
				nm_pessoa_devolucao_p, nr_cpf_devolucao_p, cd_banco_p,
				cd_agencia_bancaria_p, ie_digito_agencia_p, cd_conta_p,
				ie_digito_conta_p, nm_usuario_p, cd_estabelecimento_p,
				nr_seq_solicitacao_p, nr_protocolo_atend_w, 'N',
				id_app_externo_p, ie_app_externo_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tws_solicitacao_rescisao_pck.gerar_solicitacao_rescisao ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_ddi_celular_p pls_solic_resc_contato.nr_ddi_celular%type, nr_ddd_celular_p pls_solic_resc_contato.nr_ddd_celular%type, nr_telefone_celular_p pls_solic_resc_contato.nr_telefone_celular%type, nr_ddi_telefone_p pls_solic_resc_contato.nr_ddi_telefone%type, nr_ddd_telefone_p pls_solic_resc_contato.nr_ddd_telefone%type, nr_telefone_p pls_solic_resc_contato.nr_telefone%type, ds_email_p pls_solic_resc_contato.ds_email%type, nm_pessoa_devolucao_p pls_solicitacao_rescisao.nm_pessoa_devolucao%type, nr_cpf_devolucao_p pessoa_fisica.nr_cpf%type, cd_banco_p pls_solicitacao_rescisao.cd_banco%type, cd_agencia_bancaria_p pls_solicitacao_rescisao.cd_agencia_bancaria%type, ie_digito_agencia_p pls_solicitacao_rescisao.ie_digito_agencia%type, cd_conta_p pls_solicitacao_rescisao.cd_conta%type, ie_digito_conta_p pls_solicitacao_rescisao.ie_digito_conta%type, nm_usuario_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, id_app_externo_p bigint, ie_app_externo_p text, nr_seq_solicitacao_p INOUT pls_solicitacao_rescisao.nr_sequencia%type) FROM PUBLIC;
