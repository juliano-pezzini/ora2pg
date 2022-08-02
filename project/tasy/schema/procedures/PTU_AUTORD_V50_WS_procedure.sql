-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_autord_v50_ws ( cd_transacao_p ptu_autorizacao_ordem_serv.cd_transacao%type, ie_tipo_cliente_p ptu_autorizacao_ordem_serv.ie_tipo_cliente%type, cd_unimed_executora_p ptu_autorizacao_ordem_serv.cd_unimed_executora%type, cd_unimed_beneficiario_p ptu_autorizacao_ordem_serv.cd_unimed_beneficiario%type, nr_seq_execucao_p ptu_autorizacao_ordem_serv.nr_seq_execucao%type, nr_seq_origem_p ptu_autorizacao_ordem_serv.nr_seq_origem%type, dt_validade_p ptu_autorizacao_ordem_serv.dt_validade%type, nr_transacao_solicitante_p ptu_autorizacao_ordem_serv.nr_transacao_solicitante%type, cd_unimed_solicitante_p ptu_autorizacao_ordem_serv.cd_unimed_solicitante%type, nr_versao_p ptu_autorizacao_ordem_serv.nr_versao%type, ds_mensagem_p ptu_autorizacao_ordem_serv.ds_mensagem%type, nm_usuario_p ptu_autorizacao_ordem_serv.nm_usuario%type, nr_seq_aut_ord_p INOUT ptu_autorizacao_ordem_serv.nr_sequencia%type) AS $body$
BEGIN

ptu_imp_scs_ws_pck.ptu_imp_autor_ordem_serv(cd_transacao_p,
					ie_tipo_cliente_p,
					cd_unimed_executora_p,
					cd_unimed_beneficiario_p,
					nr_seq_execucao_p,
					nr_seq_origem_p,
					dt_validade_p,
					nr_transacao_solicitante_p,
					cd_unimed_solicitante_p,
					nr_versao_p,
					ds_mensagem_p,
					nm_usuario_p,
					nr_seq_aut_ord_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_autord_v50_ws ( cd_transacao_p ptu_autorizacao_ordem_serv.cd_transacao%type, ie_tipo_cliente_p ptu_autorizacao_ordem_serv.ie_tipo_cliente%type, cd_unimed_executora_p ptu_autorizacao_ordem_serv.cd_unimed_executora%type, cd_unimed_beneficiario_p ptu_autorizacao_ordem_serv.cd_unimed_beneficiario%type, nr_seq_execucao_p ptu_autorizacao_ordem_serv.nr_seq_execucao%type, nr_seq_origem_p ptu_autorizacao_ordem_serv.nr_seq_origem%type, dt_validade_p ptu_autorizacao_ordem_serv.dt_validade%type, nr_transacao_solicitante_p ptu_autorizacao_ordem_serv.nr_transacao_solicitante%type, cd_unimed_solicitante_p ptu_autorizacao_ordem_serv.cd_unimed_solicitante%type, nr_versao_p ptu_autorizacao_ordem_serv.nr_versao%type, ds_mensagem_p ptu_autorizacao_ordem_serv.ds_mensagem%type, nm_usuario_p ptu_autorizacao_ordem_serv.nm_usuario%type, nr_seq_aut_ord_p INOUT ptu_autorizacao_ordem_serv.nr_sequencia%type) FROM PUBLIC;

