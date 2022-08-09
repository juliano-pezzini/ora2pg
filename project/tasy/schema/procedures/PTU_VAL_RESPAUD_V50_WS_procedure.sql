-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_val_respaud_v50_ws ( nr_seq_resp_aud_p ptu_resposta_auditoria.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_confirmacao_p INOUT ptu_confirmacao.nr_sequencia%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Rotina utilizada para atualizar as informações da transação de Resposta de
Auditoria, na Autorização, Requisição e Auditoria
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ x] Tasy (Delphi/Java) [  x] Portal [  ]  Relatórios [ x] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

ptu_val_scs_ws_pck.ptu_processa_resposta_aud(nr_seq_resp_aud_p, nm_usuario_p, cd_estabelecimento_p, nr_seq_confirmacao_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_val_respaud_v50_ws ( nr_seq_resp_aud_p ptu_resposta_auditoria.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_confirmacao_p INOUT ptu_confirmacao.nr_sequencia%type) FROM PUBLIC;
