-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_consprest_v50_ws ( cd_transacao_p ptu_consulta_prestador.cd_transacao%type, ie_tipo_cliente_p ptu_consulta_prestador.ie_tipo_cliente%type, cd_unimed_executora_p ptu_consulta_prestador.cd_unimed_executora%type, cd_unimed_beneficiario_p ptu_consulta_prestador.cd_unimed_beneficiario%type, nr_seq_execucao_p ptu_consulta_prestador.nr_seq_execucao%type, nm_prestador_p ptu_consulta_prestador.nm_prestador%type, cd_cgc_cpf_p ptu_consulta_prestador.cd_cgc_cpf%type, sg_cons_profissional_p ptu_consulta_prestador.sg_cons_profissional%type, nr_cons_profissional_p ptu_consulta_prestador.nr_cons_profissional%type, uf_cons_profissional_p ptu_consulta_prestador.uf_cons_profissional%type, ds_arquivo_pedido_p ptu_consulta_prestador.ds_arquivo_pedido%type, nr_versao_p ptu_consulta_prestador.nr_versao%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_consulta_p INOUT ptu_consulta_prestador.nr_sequencia%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Realizar a importação do arquivo 00418 - Consulta Prestado do PTU
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ x] Tasy (Delphi/Java) [  x] Portal [  ]  Relatórios [ x] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

ptu_imp_scs_ws_pck.ptu_imp_consulta_prest(	cd_transacao_p, ie_tipo_cliente_p, cd_unimed_executora_p,
						cd_unimed_beneficiario_p, nr_seq_execucao_p, nm_prestador_p,
						cd_cgc_cpf_p, sg_cons_profissional_p, nr_cons_profissional_p,
						uf_cons_profissional_p, ds_arquivo_pedido_p, nr_versao_p,
						nm_usuario_p, nr_seq_consulta_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_consprest_v50_ws ( cd_transacao_p ptu_consulta_prestador.cd_transacao%type, ie_tipo_cliente_p ptu_consulta_prestador.ie_tipo_cliente%type, cd_unimed_executora_p ptu_consulta_prestador.cd_unimed_executora%type, cd_unimed_beneficiario_p ptu_consulta_prestador.cd_unimed_beneficiario%type, nr_seq_execucao_p ptu_consulta_prestador.nr_seq_execucao%type, nm_prestador_p ptu_consulta_prestador.nm_prestador%type, cd_cgc_cpf_p ptu_consulta_prestador.cd_cgc_cpf%type, sg_cons_profissional_p ptu_consulta_prestador.sg_cons_profissional%type, nr_cons_profissional_p ptu_consulta_prestador.nr_cons_profissional%type, uf_cons_profissional_p ptu_consulta_prestador.uf_cons_profissional%type, ds_arquivo_pedido_p ptu_consulta_prestador.ds_arquivo_pedido%type, nr_versao_p ptu_consulta_prestador.nr_versao%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_consulta_p INOUT ptu_consulta_prestador.nr_sequencia%type) FROM PUBLIC;
