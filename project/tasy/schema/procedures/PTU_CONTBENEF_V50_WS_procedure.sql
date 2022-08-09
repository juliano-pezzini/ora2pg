-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_contbenef_v50_ws ( cd_transacao_p ptu_pedido_contagem_benef.cd_transacao%type, ie_tipo_cliente_p ptu_pedido_contagem_benef.ie_tipo_cliente%type, cd_unimed_requisitante_p ptu_pedido_contagem_benef.cd_unimed_requisitante%type, cd_unimed_destino_p ptu_pedido_contagem_benef.cd_unimed_destino%type, dt_ano_referencia_p ptu_pedido_contagem_benef.dt_ano_referencia%type, dt_mes_referencia_p ptu_pedido_contagem_benef.dt_mes_referencia%type, nr_versao_p ptu_pedido_contagem_benef.nr_versao%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_pedido_cont_p INOUT ptu_pedido_contagem_benef.nr_sequencia%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Realizar a importação do arquivo de  00430 - Requisição Contagem Benef.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ x] Tasy (Delphi/Java) [  x] Portal [  ]  Relatórios [ x] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

ptu_imp_scs_ws_pck.ptu_imp_req_contagem_benef(	cd_transacao_p, ie_tipo_cliente_p, cd_unimed_requisitante_p,
						cd_unimed_destino_p, dt_ano_referencia_p, dt_mes_referencia_p,
						nr_versao_p, nm_usuario_p, nr_seq_pedido_cont_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_contbenef_v50_ws ( cd_transacao_p ptu_pedido_contagem_benef.cd_transacao%type, ie_tipo_cliente_p ptu_pedido_contagem_benef.ie_tipo_cliente%type, cd_unimed_requisitante_p ptu_pedido_contagem_benef.cd_unimed_requisitante%type, cd_unimed_destino_p ptu_pedido_contagem_benef.cd_unimed_destino%type, dt_ano_referencia_p ptu_pedido_contagem_benef.dt_ano_referencia%type, dt_mes_referencia_p ptu_pedido_contagem_benef.dt_mes_referencia%type, nr_versao_p ptu_pedido_contagem_benef.nr_versao%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_pedido_cont_p INOUT ptu_pedido_contagem_benef.nr_sequencia%type) FROM PUBLIC;
