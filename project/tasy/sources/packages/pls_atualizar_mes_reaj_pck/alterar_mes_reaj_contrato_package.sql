-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_atualizar_mes_reaj_pck.alterar_mes_reaj_contrato ( nr_seq_contrato_p pls_contrato.nr_sequencia%type, ie_reajuste_p pls_contrato.ie_reajuste%type, nr_mes_reaj_contrato_p pls_contrato.nr_mes_reajuste%type, ie_att_grupo_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
BEGIN

CALL pls_atualizar_mes_reaj_pck.atualizar_mes_reajuste(	nr_seq_contrato_p, null, ie_reajuste_p,
			nr_mes_reaj_contrato_p, null, ie_att_grupo_p,
			'N', 'S', nm_usuario_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_mes_reaj_pck.alterar_mes_reaj_contrato ( nr_seq_contrato_p pls_contrato.nr_sequencia%type, ie_reajuste_p pls_contrato.ie_reajuste%type, nr_mes_reaj_contrato_p pls_contrato.nr_mes_reajuste%type, ie_att_grupo_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
