-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_solic_rescisao_fin_pck.obter_mensagem_nota_credito ( nr_seq_solicitacao_p pls_solicitacao_rescisao.nr_sequencia%type, nr_seq_solic_resc_fin_p pls_solic_rescisao_fin.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ds_mensagem_varchar_p INOUT text, ds_mensagem_clob_p INOUT text) AS $body$
DECLARE


ds_lista_benef_w	text;
ds_mensagem_clob_w	text;


BEGIN
ds_lista_benef_w	:= pls_solic_rescisao_fin_pck.obter_lista_beneficiarios(nr_seq_solic_resc_fin_p,cd_estabelecimento_p, 'NC');

ds_mensagem_varchar_p	:= substr(wheb_mensagem_pck.get_texto(1107895,	'NR_SEQ_SOLICITACAO='||nr_seq_solicitacao_p||';'||
								'DS_LISTA_BENEF='||substr(ds_lista_benef_w,4000,1)),1,4000);		
								
ds_mensagem_clob_w	:= wheb_mensagem_pck.get_texto(1107895,	'NR_SEQ_SOLICITACAO='||nr_seq_solicitacao_p||';'||'DS_LISTA_BENEF='||'');
	
ds_mensagem_clob_p	:= ds_mensagem_clob_w||ds_lista_benef_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_solic_rescisao_fin_pck.obter_mensagem_nota_credito ( nr_seq_solicitacao_p pls_solicitacao_rescisao.nr_sequencia%type, nr_seq_solic_resc_fin_p pls_solic_rescisao_fin.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ds_mensagem_varchar_p INOUT text, ds_mensagem_clob_p INOUT text) FROM PUBLIC;