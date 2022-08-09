-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_resposta_confirmacao ( nr_seq_transacao_p ptu_complemento_pa.nr_sequencia%type, cd_operadora_p ptu_confirmacao_pa.cd_operadora%type, cd_operadora_destino_p ptu_confirmacao_pa.cd_operadora_destino%type, cd_operadora_origem_p ptu_confirmacao_pa.cd_operadora_origem%type, cd_transacao_p ptu_confirmacao_pa.cd_transacao%type, nr_registro_ans_p ptu_confirmacao_pa.nr_registro_ans%type, ie_tipo_cliente_p ptu_confirmacao_pa.ie_tipo_cliente%type, cd_usuario_plano_p ptu_confirmacao_pa.cd_usuario_plano%type, dt_geracao_p timestamp, ie_origem_resposta_p ptu_confirmacao_pa.ie_origem_resposta%type, nr_seq_execucao_p ptu_confirmacao_pa.nr_seq_execucao%type, ie_tipo_identificador_p ptu_confirmacao_pa.ie_tipo_identificador%type, nr_seq_protocolo_p ptu_confirmacao_pa.nr_seq_protocolo%type, nr_versao_p ptu_confirmacao_pa.nr_versao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_confirmacao_pa_p INOUT ptu_confirmacao_pa.nr_sequencia%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Procedure irá apenas importar a resposta que foi recebida do WebService
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ X] Tasy (Delphi/Java) [ ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN
nr_seq_confirmacao_pa_p := pls_imp_xml_integracao_ws_pck.pls_resposta_confirmacao(	nr_seq_transacao_p, cd_operadora_p, cd_operadora_destino_p, cd_operadora_origem_p, cd_transacao_p, nr_registro_ans_p, ie_tipo_cliente_p, cd_usuario_plano_p, dt_geracao_p, ie_origem_resposta_p, nr_seq_execucao_p, ie_tipo_identificador_p, nr_seq_protocolo_p, nr_versao_p, nm_usuario_p, cd_estabelecimento_p, nr_seq_confirmacao_pa_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_resposta_confirmacao ( nr_seq_transacao_p ptu_complemento_pa.nr_sequencia%type, cd_operadora_p ptu_confirmacao_pa.cd_operadora%type, cd_operadora_destino_p ptu_confirmacao_pa.cd_operadora_destino%type, cd_operadora_origem_p ptu_confirmacao_pa.cd_operadora_origem%type, cd_transacao_p ptu_confirmacao_pa.cd_transacao%type, nr_registro_ans_p ptu_confirmacao_pa.nr_registro_ans%type, ie_tipo_cliente_p ptu_confirmacao_pa.ie_tipo_cliente%type, cd_usuario_plano_p ptu_confirmacao_pa.cd_usuario_plano%type, dt_geracao_p timestamp, ie_origem_resposta_p ptu_confirmacao_pa.ie_origem_resposta%type, nr_seq_execucao_p ptu_confirmacao_pa.nr_seq_execucao%type, ie_tipo_identificador_p ptu_confirmacao_pa.ie_tipo_identificador%type, nr_seq_protocolo_p ptu_confirmacao_pa.nr_seq_protocolo%type, nr_versao_p ptu_confirmacao_pa.nr_versao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_confirmacao_pa_p INOUT ptu_confirmacao_pa.nr_sequencia%type) FROM PUBLIC;
