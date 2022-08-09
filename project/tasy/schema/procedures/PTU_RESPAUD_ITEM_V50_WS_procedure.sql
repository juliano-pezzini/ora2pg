-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_respaud_item_v50_ws ( nr_seq_resp_aud_p ptu_resposta_auditoria.nr_sequencia%type, cd_servico_p ptu_resp_auditoria_servico.cd_servico%type, ds_servico_p ptu_resp_auditoria_servico.ds_servico%type, ie_autorizado_p ptu_resp_auditoria_servico.ie_autorizado%type, ie_tipo_tabela_p ptu_resp_auditoria_servico.ie_tipo_tabela%type, qt_autorizado_p ptu_resp_auditoria_servico.qt_autorizado%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_aud_servico_p INOUT ptu_resp_auditoria_servico.nr_sequencia%type) AS $body$
DECLARE

				
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Realizar a importação do arquivo de 00404 ¿ Resposta de Auditoria
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[  ]  Objetos do dicionário [ x] Tasy (Delphi/Java) [  x] Portal [  ]  Relatórios [ x] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

ptu_imp_scs_ws_pck.ptu_imp_itens_resp_aud( 	nr_seq_resp_aud_p, cd_servico_p, ds_servico_p,
						ie_autorizado_p, ie_tipo_tabela_p, qt_autorizado_p,
						nm_usuario_p, nr_seq_aud_servico_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_respaud_item_v50_ws ( nr_seq_resp_aud_p ptu_resposta_auditoria.nr_sequencia%type, cd_servico_p ptu_resp_auditoria_servico.cd_servico%type, ds_servico_p ptu_resp_auditoria_servico.ds_servico%type, ie_autorizado_p ptu_resp_auditoria_servico.ie_autorizado%type, ie_tipo_tabela_p ptu_resp_auditoria_servico.ie_tipo_tabela%type, qt_autorizado_p ptu_resp_auditoria_servico.qt_autorizado%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_aud_servico_p INOUT ptu_resp_auditoria_servico.nr_sequencia%type) FROM PUBLIC;
