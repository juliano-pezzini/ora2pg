-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_executar_gerar_contas_a700 ( nr_seq_servico_p ptu_servico_pre_pagto.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Rotina responável por executar a package PLS_GERAR_CONTAS_A700_PCK.

Obs: não é possível chamar a PACKAGE no Netbeans sem a mesma estar em uma PROCEDURE.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

if (nr_seq_servico_p IS NOT NULL AND nr_seq_servico_p::text <> '') then
	CALL pls_gerar_contas_a700_pck.pls_gerenciar_contas_a700(nr_seq_servico_p, nm_usuario_p, cd_estabelecimento_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_executar_gerar_contas_a700 ( nr_seq_servico_p ptu_servico_pre_pagto.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

