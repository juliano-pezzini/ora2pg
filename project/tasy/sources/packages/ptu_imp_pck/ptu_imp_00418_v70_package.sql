-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--------------------------------------------------------------------------------00418 Consulta de Dados do Beneficiario-----------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE OR REPLACE PROCEDURE ptu_imp_pck.ptu_imp_00418_v70 ( cd_transacao_p ptu_consulta_prestador.cd_transacao%type, ie_tipo_cliente_p ptu_consulta_prestador.ie_tipo_cliente%type, cd_unimed_executora_p ptu_consulta_prestador.cd_unimed_executora%type, cd_unimed_beneficiario_p ptu_consulta_prestador.cd_unimed_beneficiario%type, nr_seq_execucao_p ptu_consulta_prestador.nr_seq_execucao%type, nm_prestador_p ptu_consulta_prestador.nm_prestador%type, cd_cgc_cpf_p ptu_consulta_prestador.cd_cgc_cpf%type, sg_cons_profissional_p ptu_consulta_prestador.sg_cons_profissional%type, nr_cons_profissional_p ptu_consulta_prestador.nr_cons_profissional%type, uf_cons_profissional_p ptu_consulta_prestador.uf_cons_profissional%type, ds_arquivo_pedido_p ptu_consulta_prestador.ds_arquivo_pedido%type, nr_versao_p ptu_consulta_prestador.nr_versao%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_consulta_p INOUT ptu_consulta_prestador.nr_sequencia%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Realizar a importacao do arquivo 00418 - Consulta Prestado do PTU
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[  ]  Objetos do dicionario [ x] Tasy (Delphi/Java) [  x] Portal [  ]  Relatorios [ x] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


ie_tipo_cliente_w	ptu_consulta_prestador.ie_tipo_cliente%type;


BEGIN

ie_tipo_cliente_w := ptu_converter_tipo_cliente(ie_tipo_cliente_p);

insert	into ptu_consulta_prestador(nr_sequencia, cd_transacao, ie_tipo_cliente,
	cd_unimed_executora, cd_unimed_beneficiario, nr_seq_execucao,
	nm_prestador, dt_atualizacao, nm_usuario,
	cd_cgc_cpf, sg_cons_profissional, nr_cons_profissional,
	uf_cons_profissional, nr_seq_guia, nr_seq_requisicao,
	ds_arquivo_pedido, nm_usuario_nrec, dt_atualizacao_nrec,
	nr_versao)
values (nextval('ptu_consulta_prestador_seq'), cd_transacao_p, ie_tipo_cliente_w,
	cd_unimed_executora_p, cd_unimed_beneficiario_p, nr_seq_execucao_p,
	nm_prestador_p, clock_timestamp(), nm_usuario_p,
	cd_cgc_cpf_p, sg_cons_profissional_p, nr_cons_profissional_p,
	uf_cons_profissional_p, nr_seq_execucao_p, null,
	ds_arquivo_pedido_p, nm_usuario_p, clock_timestamp(),
	nr_versao_p) returning nr_sequencia into nr_seq_consulta_p;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_imp_pck.ptu_imp_00418_v70 ( cd_transacao_p ptu_consulta_prestador.cd_transacao%type, ie_tipo_cliente_p ptu_consulta_prestador.ie_tipo_cliente%type, cd_unimed_executora_p ptu_consulta_prestador.cd_unimed_executora%type, cd_unimed_beneficiario_p ptu_consulta_prestador.cd_unimed_beneficiario%type, nr_seq_execucao_p ptu_consulta_prestador.nr_seq_execucao%type, nm_prestador_p ptu_consulta_prestador.nm_prestador%type, cd_cgc_cpf_p ptu_consulta_prestador.cd_cgc_cpf%type, sg_cons_profissional_p ptu_consulta_prestador.sg_cons_profissional%type, nr_cons_profissional_p ptu_consulta_prestador.nr_cons_profissional%type, uf_cons_profissional_p ptu_consulta_prestador.uf_cons_profissional%type, ds_arquivo_pedido_p ptu_consulta_prestador.ds_arquivo_pedido%type, nr_versao_p ptu_consulta_prestador.nr_versao%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_consulta_p INOUT ptu_consulta_prestador.nr_sequencia%type) FROM PUBLIC;
