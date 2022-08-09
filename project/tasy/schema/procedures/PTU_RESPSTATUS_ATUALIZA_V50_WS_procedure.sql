-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_respstatus_atualiza_v50_ws ( nr_seq_guia_p ptu_resp_pedido_status.nr_seq_guia%type, nr_seq_requisicao_p ptu_resp_pedido_status.nr_seq_requisicao%type, nr_seq_pedido_p ptu_resp_pedido_status.nr_sequencia%type, cd_unimed_benef_p ptu_resp_pedido_status.cd_unimed_beneficiario%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

ptu_val_scs_ws_pck.ptu_processa_resp_status_trans( 	nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_pedido_p, cd_unimed_benef_p,
							nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_respstatus_atualiza_v50_ws ( nr_seq_guia_p ptu_resp_pedido_status.nr_seq_guia%type, nr_seq_requisicao_p ptu_resp_pedido_status.nr_seq_requisicao%type, nr_seq_pedido_p ptu_resp_pedido_status.nr_sequencia%type, cd_unimed_benef_p ptu_resp_pedido_status.cd_unimed_beneficiario%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
