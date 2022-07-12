-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_imp_pre_pagto_pck.inserir_pre_pagto_prot ( nr_seq_fat_arquivo_p pls_faturamento_prot.nr_seq_fat_arquivo%type, cd_cgc_prestador_p pls_faturamento_prot.cd_cgc_prestador%type, cd_cpf_prestador_p pls_faturamento_prot.cd_cpf_prestador%type, cd_ans_p pls_faturamento_prot.cd_ans%type, cd_ans_destino_p pls_faturamento_prot.cd_ans_destino%type, cd_versao_tiss_p pls_faturamento_prot.cd_versao_tiss%type, ds_hash_p pls_faturamento_prot.ds_hash%type, ie_tipo_faturamento_p pls_faturamento_prot.ie_tipo_faturamento%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_prot_w INOUT pls_protocolo_conta.nr_sequencia%type) AS $body$
BEGIN

insert into pls_faturamento_prot(	nr_sequencia,				nr_seq_fat_arquivo,		cd_cgc_prestador,
					cd_cpf_prestador,			cd_ans,				cd_ans_destino,
					cd_versao_tiss,				ds_hash,			cd_estabelecimento,
					nr_seq_prest_inter,			ie_guia_fisica_conv,		nr_seq_outorgante,
					ie_tipo_faturamento,			dt_atualizacao,			dt_atualizacao_nrec,
					nm_usuario,				nm_usuario_nrec,		dt_mes_competencia_conv,
					dt_recebimento_conv)
			values (	nextval('pls_faturamento_prot_seq'),	nr_seq_fat_arquivo_p,		cd_cgc_prestador_p,
					cd_cpf_prestador_p,			cd_ans_p,			cd_ans_destino_p,
					cd_versao_tiss_p,			ds_hash_p,			cd_estabelecimento_p,
					null,					'N',				null,
					ie_tipo_faturamento_p,			clock_timestamp(),			clock_timestamp(),
					nm_usuario_p,				nm_usuario_p,			null,
					null) return;
					
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_pre_pagto_pck.inserir_pre_pagto_prot ( nr_seq_fat_arquivo_p pls_faturamento_prot.nr_seq_fat_arquivo%type, cd_cgc_prestador_p pls_faturamento_prot.cd_cgc_prestador%type, cd_cpf_prestador_p pls_faturamento_prot.cd_cpf_prestador%type, cd_ans_p pls_faturamento_prot.cd_ans%type, cd_ans_destino_p pls_faturamento_prot.cd_ans_destino%type, cd_versao_tiss_p pls_faturamento_prot.cd_versao_tiss%type, ds_hash_p pls_faturamento_prot.ds_hash%type, ie_tipo_faturamento_p pls_faturamento_prot.ie_tipo_faturamento%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_prot_w INOUT pls_protocolo_conta.nr_sequencia%type) FROM PUBLIC;
