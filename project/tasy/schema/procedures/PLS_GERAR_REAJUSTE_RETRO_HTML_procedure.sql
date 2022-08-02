-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_reajuste_retro_html (nr_seq_reajuste_p pls_reajuste.nr_sequencia%type, nr_seq_lote_retro_p pls_reajuste_cobr_retro.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

CALL pls_reaj_cobranca_retro_pck.gerar_lancamentos(nr_seq_reajuste_p, nr_seq_lote_retro_p, cd_estabelecimento_p, nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_reajuste_retro_html (nr_seq_reajuste_p pls_reajuste.nr_sequencia%type, nr_seq_lote_retro_p pls_reajuste_cobr_retro.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

