-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_pedcancel_v50_ws ( ie_tipo_cliente_p ptu_cancelamento.ie_tipo_cliente%type, cd_unimed_executora_p ptu_cancelamento.cd_unimed_executora%type, cd_unimed_beneficiario_p ptu_cancelamento.cd_unimed_beneficiario%type, nr_seq_execucao_p ptu_cancelamento.nr_seq_execucao%type, nr_seq_origem_p ptu_cancelamento.nr_seq_origem%type, cd_transacao_p ptu_cancelamento.cd_transacao%type, nr_versao_p ptu_cancelamento.nr_versao%type, ds_motivo_cancelamento_p ptu_cancelamento.ds_motivo_cancelamento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_pedido_cancel_p INOUT ptu_cancelamento.nr_sequencia%type, ie_possui_registro_p INOUT text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Realizar a importação do arquivo de 00311-Pedido de cancelamento
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ x] Tasy (Delphi/Java) [  x] Portal [  ]  Relatórios [ x] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

ptu_imp_scs_ws_pck.ptu_imp_pedido_cancelamento(	ie_tipo_cliente_p, cd_unimed_executora_p, cd_unimed_beneficiario_p,
						nr_seq_execucao_p, nr_seq_origem_p, cd_transacao_p,
						nr_versao_p, ds_motivo_cancelamento_p, nm_usuario_p,
						nr_seq_pedido_cancel_p, ie_possui_registro_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_pedcancel_v50_ws ( ie_tipo_cliente_p ptu_cancelamento.ie_tipo_cliente%type, cd_unimed_executora_p ptu_cancelamento.cd_unimed_executora%type, cd_unimed_beneficiario_p ptu_cancelamento.cd_unimed_beneficiario%type, nr_seq_execucao_p ptu_cancelamento.nr_seq_execucao%type, nr_seq_origem_p ptu_cancelamento.nr_seq_origem%type, cd_transacao_p ptu_cancelamento.cd_transacao%type, nr_versao_p ptu_cancelamento.nr_versao%type, ds_motivo_cancelamento_p ptu_cancelamento.ds_motivo_cancelamento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_pedido_cancel_p INOUT ptu_cancelamento.nr_sequencia%type, ie_possui_registro_p INOUT text) FROM PUBLIC;

