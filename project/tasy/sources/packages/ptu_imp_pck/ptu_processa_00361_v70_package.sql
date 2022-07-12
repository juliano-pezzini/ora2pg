-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ptu_imp_pck.ptu_processa_00361_v70 ( nr_seq_guia_p ptu_resp_pedido_status.nr_seq_guia%type, nr_seq_requisicao_p ptu_resp_pedido_status.nr_seq_requisicao%type, nr_seq_pedido_p ptu_resp_pedido_status.nr_sequencia%type, cd_unimed_benef_p ptu_resp_pedido_status.cd_unimed_beneficiario%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

if (nr_seq_requisicao_p	<> 0) then
	CALL ptu_atualiza_req_status_trans(nr_seq_pedido_p, nr_seq_requisicao_p, nm_usuario_p);
	-- Inserir as glosas das inconsistencias PTU,  e necessario chamar esta rotina apos atualizar o status da requisicao e da guia

	CALL pls_obter_glosa_incons(nr_seq_requisicao_p, 'R', nm_usuario_p);

	CALL pls_requisicao_gravar_hist(nr_seq_requisicao_p, 'L', 'Recebida a resposta do pedido de status da Unimed '||cd_unimed_benef_p, null, nm_usuario_p);
elsif (nr_seq_guia_p 		<> 0) then
	CALL ptu_atualiza_guia_status_trans(nr_seq_pedido_p, nr_seq_guia_p, nm_usuario_p);
	-- Inserir as glosas das inconsistencias PTU,  e necessario chamar esta rotina apos atualizar o status da requisicao e da guia

	CALL pls_obter_glosa_incons(nr_seq_guia_p, 'G', nm_usuario_p);

	CALL pls_guia_gravar_historico(nr_seq_guia_p, 2, 'Recebida a resposta do pedido de status da Unimed '||cd_unimed_benef_p, '', nm_usuario_p);
end if;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_imp_pck.ptu_processa_00361_v70 ( nr_seq_guia_p ptu_resp_pedido_status.nr_seq_guia%type, nr_seq_requisicao_p ptu_resp_pedido_status.nr_seq_requisicao%type, nr_seq_pedido_p ptu_resp_pedido_status.nr_sequencia%type, cd_unimed_benef_p ptu_resp_pedido_status.cd_unimed_beneficiario%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
