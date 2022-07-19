-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_val_pedaut_v50_ws ( nr_seq_pedido_aut_p ptu_pedido_autorizacao.nr_sequencia%type, ie_possui_pedido_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_resp_pedido_aut_p INOUT ptu_resposta_autorizacao.nr_sequencia%type) AS $body$
DECLARE

				
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Rotina utilizada para consistir o pedido de autorização e para popular as
tabelas quentes da Autorização ou Requisição 
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[  ]  Objetos do dicionário [ x] Tasy (Delphi/Java) [  x] Portal [  ]  Relatórios [ x] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

ptu_val_scs_ws_pck.ptu_processa_pedido_aut( nr_seq_pedido_aut_p, ie_possui_pedido_p, nm_usuario_p, cd_estabelecimento_p, nr_seq_resp_pedido_aut_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_val_pedaut_v50_ws ( nr_seq_pedido_aut_p ptu_pedido_autorizacao.nr_sequencia%type, ie_possui_pedido_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_resp_pedido_aut_p INOUT ptu_resposta_autorizacao.nr_sequencia%type) FROM PUBLIC;

