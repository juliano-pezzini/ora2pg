-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_imp_nv_protocolo ( nr_seq_lote_protocolo_p pls_protocolo_conta_imp.nr_seq_lote_protocolo%type, nr_lote_prestador_p pls_protocolo_conta_imp.nr_lote_prestador%type, cd_prestador_p pls_protocolo_conta_imp.cd_prestador%type, cd_cgc_prestador_p pls_protocolo_conta_imp.cd_cgc_prestador%type, cd_cpf_prestador_p pls_protocolo_conta_imp.cd_cpf_prestador%type, dt_transacao_p pls_protocolo_conta_imp.dt_transacao%type, nr_seq_transacao_p pls_protocolo_conta_imp.nr_seq_transacao%type, cd_ans_p pls_protocolo_conta_imp.cd_ans%type, ie_tipo_guia_p pls_protocolo_conta_imp.ie_tipo_guia%type, cd_versao_tiss_p pls_protocolo_conta_imp.cd_versao_tiss%type, nr_seq_prestador_web_p pls_protocolo_conta_imp.nr_seq_prestador_web%type, nr_seq_xml_arquivo_p pls_protocolo_conta_imp.nr_seq_xml_arquivo%type, ds_login_ws_p pls_autenticacao_tiss.nm_usuario_ws%type, ds_senha_ws_p pls_autenticacao_tiss.ds_senha_ws%type, ds_hash_p pls_protocolo_conta_imp.ds_hash%type, ie_agrupa_lote_p text, -- mantido apenas para fins de compatibilidade com rotina antiga 
 nr_seq_prest_logado_p text, --sequência do prestador logado no portal, mantido apenas para compatibilidade com rotina antiga 
 nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_sequencia_p INOUT pls_protocolo_conta_imp.nr_sequencia%type) AS $body$
BEGIN
 
-- se for para usar a nova forma de importação XML chama da package, caso contrário chama a rotina antiga 
if (pls_imp_xml_cta_pck.usar_nova_imp_xml(cd_estabelecimento_p) = 'S') then 
	 
	nr_sequencia_p := pls_imp_xml_cta_pck.pls_imp_nv_protocolo(	nr_seq_lote_protocolo_p, nr_lote_prestador_p, cd_prestador_p, cd_cgc_prestador_p, cd_cpf_prestador_p, dt_transacao_p, nr_seq_transacao_p, cd_ans_p, ie_tipo_guia_p, cd_versao_tiss_p, nr_seq_prestador_web_p, nr_seq_xml_arquivo_p, ds_login_ws_p, ds_senha_ws_p, ds_hash_p, nm_usuario_p, cd_estabelecimento_p, nr_sequencia_p, nr_seq_prest_logado_p);
else 
	-- rotina da estrutura antiga 
	-- com o tempo a mesma deve sair daqui e ficar só o novo método de implementação 
	nr_sequencia_p := pls_imp_conta_protocolo(	nr_lote_prestador_p, cd_prestador_p, cd_estabelecimento_p, cd_cgc_prestador_p, cd_cpf_prestador_p, null, dt_transacao_p, nr_seq_transacao_p, ds_hash_p, ie_tipo_guia_p, nr_seq_prest_logado_p, null, null, null, nm_usuario_p, cd_versao_tiss_p, nr_seq_prestador_web_p, nr_seq_lote_protocolo_p, nr_seq_xml_arquivo_p, null, ie_agrupa_lote_p, ds_login_ws_p, ds_senha_ws_p, nr_sequencia_p);
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_nv_protocolo ( nr_seq_lote_protocolo_p pls_protocolo_conta_imp.nr_seq_lote_protocolo%type, nr_lote_prestador_p pls_protocolo_conta_imp.nr_lote_prestador%type, cd_prestador_p pls_protocolo_conta_imp.cd_prestador%type, cd_cgc_prestador_p pls_protocolo_conta_imp.cd_cgc_prestador%type, cd_cpf_prestador_p pls_protocolo_conta_imp.cd_cpf_prestador%type, dt_transacao_p pls_protocolo_conta_imp.dt_transacao%type, nr_seq_transacao_p pls_protocolo_conta_imp.nr_seq_transacao%type, cd_ans_p pls_protocolo_conta_imp.cd_ans%type, ie_tipo_guia_p pls_protocolo_conta_imp.ie_tipo_guia%type, cd_versao_tiss_p pls_protocolo_conta_imp.cd_versao_tiss%type, nr_seq_prestador_web_p pls_protocolo_conta_imp.nr_seq_prestador_web%type, nr_seq_xml_arquivo_p pls_protocolo_conta_imp.nr_seq_xml_arquivo%type, ds_login_ws_p pls_autenticacao_tiss.nm_usuario_ws%type, ds_senha_ws_p pls_autenticacao_tiss.ds_senha_ws%type, ds_hash_p pls_protocolo_conta_imp.ds_hash%type, ie_agrupa_lote_p text, nr_seq_prest_logado_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_sequencia_p INOUT pls_protocolo_conta_imp.nr_sequencia%type) FROM PUBLIC;

