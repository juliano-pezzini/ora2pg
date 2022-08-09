-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_val_contbenef_v50_ws ( nr_seq_pedido_cont_p ptu_pedido_contagem_benef.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_ret_cont_p INOUT ptu_resp_contagem_benef.nr_sequencia%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Realizar a validação do arquivo de  00430 - Requisição Contagem Benef.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ x] Tasy (Delphi/Java) [  x] Portal [  ]  Relatórios [ x] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

ptu_val_scs_ws_pck.ptu_processa_resp_cont_benef(nr_seq_pedido_cont_p, nm_usuario_p, nr_seq_ret_cont_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_val_contbenef_v50_ws ( nr_seq_pedido_cont_p ptu_pedido_contagem_benef.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_ret_cont_p INOUT ptu_resp_contagem_benef.nr_sequencia%type) FROM PUBLIC;
