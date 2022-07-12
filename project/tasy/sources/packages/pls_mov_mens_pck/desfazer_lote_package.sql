-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


---------------- INICIO DO PROCESSO DESFAZER O LOTE ----------------------
CREATE OR REPLACE PROCEDURE pls_mov_mens_pck.desfazer_lote ( nr_seq_lote_p pls_mov_mens_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
BEGIN

delete	from pls_mov_mens_benef
where	nr_seq_lote =	nr_seq_lote_p;

delete	from	pls_mov_mens_operador_venc a
where	exists (SELECT	1
		from	pls_mov_mens_operadora x
		where	x.nr_sequencia	= a.nr_seq_mov_operadora
		and	x.nr_seq_lote	= nr_seq_lote_p);

delete	from pls_mov_mens_operadora
where	nr_seq_lote =	nr_seq_lote_p;

update	pls_mov_mens_lote
set	dt_geracao_lote	 = NULL,
	dt_atualizacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p
where	nr_sequencia = nr_seq_lote_p;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mov_mens_pck.desfazer_lote ( nr_seq_lote_p pls_mov_mens_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
