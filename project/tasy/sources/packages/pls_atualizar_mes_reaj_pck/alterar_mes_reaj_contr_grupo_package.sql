-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_atualizar_mes_reaj_pck.alterar_mes_reaj_contr_grupo ( nr_seq_contrato_p pls_contrato.nr_sequencia%type, nr_seq_intercambio_p pls_intercambio.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
BEGIN

if (coalesce(nr_seq_contrato_p, 0) <> 0) then
	CALL pls_atualizar_mes_reaj_pck.aprovar_contrato(nr_seq_contrato_p, nm_usuario_p, cd_estabelecimento_p);
elsif (coalesce(nr_seq_intercambio_p, 0) <> 0) then
	CALL pls_atualizar_mes_reaj_pck.aprovar_contrato_intercambio(nr_seq_intercambio_p, nm_usuario_p, cd_estabelecimento_p);
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_mes_reaj_pck.alterar_mes_reaj_contr_grupo ( nr_seq_contrato_p pls_contrato.nr_sequencia%type, nr_seq_intercambio_p pls_intercambio.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
