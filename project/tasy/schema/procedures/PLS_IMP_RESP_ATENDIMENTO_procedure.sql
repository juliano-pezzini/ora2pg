-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_imp_resp_atendimento ( cd_operadora_p ptu_resp_atendimento_pa.cd_operadora%type, cd_operadora_destino_p ptu_resp_atendimento_pa.cd_operadora_destino%type, cd_operadora_origem_p ptu_resp_atendimento_pa.cd_operadora_origem%type, cd_transacao_p ptu_resp_atendimento_pa.cd_transacao%type, nr_registro_ans_p ptu_resp_atendimento_pa.nr_registro_ans%type, ie_tipo_cliente_p ptu_resp_atendimento_pa.ie_tipo_cliente%type, cd_usuario_plano_p ptu_resp_atendimento_pa.cd_usuario_plano%type, ds_mensagem_livre_p ptu_resp_atendimento_pa.ds_mensagem_livre%type, dt_geracao_p text, ie_resposta_p ptu_resp_atendimento_pa.ie_resposta%type, nr_protocolo_p ptu_resp_atendimento_pa.nr_protocolo%type, nr_seq_execucao_p ptu_resp_atendimento_pa.nr_seq_execucao%type, nr_seq_origem_p ptu_resp_atendimento_pa.nr_seq_origem%type, nr_seq_protocolo_p ptu_resp_atendimento_pa.nr_seq_protocolo%type, nr_versao_p ptu_resp_atendimento_pa.nr_versao%type, nm_usuario_transacao_p ptu_resp_atendimento_pa.nm_usuario_transacao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_resp_atendimento_pa_p INOUT ptu_resp_atendimento_pa.nr_sequencia%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Realizar a importação dos dados da transação de Resposta de Atendimento recebida via WebService
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ X] Tasy (Delphi/Java) [ x ] Portal [  ]  Relatórios [ x] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN


nr_seq_resp_atendimento_pa_p := pls_imp_xml_integracao_ws_pck.pls_imp_resp_atendimento(cd_operadora_p, cd_operadora_destino_p, cd_operadora_origem_p, cd_transacao_p, nr_registro_ans_p, ie_tipo_cliente_p, cd_usuario_plano_p, ds_mensagem_livre_p, dt_geracao_p, ie_resposta_p, nr_protocolo_p, nr_seq_execucao_p, nr_seq_origem_p, nr_seq_protocolo_p, nr_versao_p, nm_usuario_transacao_p, nm_usuario_p, cd_estabelecimento_p, nr_seq_resp_atendimento_pa_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_resp_atendimento ( cd_operadora_p ptu_resp_atendimento_pa.cd_operadora%type, cd_operadora_destino_p ptu_resp_atendimento_pa.cd_operadora_destino%type, cd_operadora_origem_p ptu_resp_atendimento_pa.cd_operadora_origem%type, cd_transacao_p ptu_resp_atendimento_pa.cd_transacao%type, nr_registro_ans_p ptu_resp_atendimento_pa.nr_registro_ans%type, ie_tipo_cliente_p ptu_resp_atendimento_pa.ie_tipo_cliente%type, cd_usuario_plano_p ptu_resp_atendimento_pa.cd_usuario_plano%type, ds_mensagem_livre_p ptu_resp_atendimento_pa.ds_mensagem_livre%type, dt_geracao_p text, ie_resposta_p ptu_resp_atendimento_pa.ie_resposta%type, nr_protocolo_p ptu_resp_atendimento_pa.nr_protocolo%type, nr_seq_execucao_p ptu_resp_atendimento_pa.nr_seq_execucao%type, nr_seq_origem_p ptu_resp_atendimento_pa.nr_seq_origem%type, nr_seq_protocolo_p ptu_resp_atendimento_pa.nr_seq_protocolo%type, nr_versao_p ptu_resp_atendimento_pa.nr_versao%type, nm_usuario_transacao_p ptu_resp_atendimento_pa.nm_usuario_transacao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_resp_atendimento_pa_p INOUT ptu_resp_atendimento_pa.nr_sequencia%type) FROM PUBLIC;

