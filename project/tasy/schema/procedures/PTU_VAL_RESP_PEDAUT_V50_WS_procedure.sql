-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_val_resp_pedaut_v50_ws ( nr_seq_resp_autorizacao_p ptu_resposta_autorizacao.nr_sequencia%type, nr_seq_execucao_p ptu_resposta_autorizacao.nr_seq_execucao%type, dt_validade_p ptu_resposta_autorizacao.dt_validade%type, cd_unimed_benef_p ptu_resposta_autorizacao.cd_unimed_beneficiario%type, ds_observacao_p ptu_resposta_autorizacao.ds_observacao%type, nm_usuario_p text) AS $body$
BEGIN

ptu_val_scs_ws_pck.ptu_processa_resp_pedido_aut(nr_seq_resp_autorizacao_p, nr_seq_execucao_p, dt_validade_p,
						cd_unimed_benef_p, ds_observacao_p, nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_val_resp_pedaut_v50_ws ( nr_seq_resp_autorizacao_p ptu_resposta_autorizacao.nr_sequencia%type, nr_seq_execucao_p ptu_resposta_autorizacao.nr_seq_execucao%type, dt_validade_p ptu_resposta_autorizacao.dt_validade%type, cd_unimed_benef_p ptu_resposta_autorizacao.cd_unimed_beneficiario%type, ds_observacao_p ptu_resposta_autorizacao.ds_observacao%type, nm_usuario_p text) FROM PUBLIC;

