-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


---------------- INICIO DO PROCESSO DESFAZER O LOTE ----------------------
CREATE OR REPLACE PROCEDURE pls_mov_benef_pck.desfazer_lote_mov_benef ( nr_seq_lote_p pls_mov_benef_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
BEGIN

delete	from pls_mov_benef_segurado
where	nr_seq_lote =	nr_seq_lote_p;

delete from pls_mov_benef_plano a
where	exists (SELECT	1
		from	pls_mov_benef_contrato x,
			pls_mov_benef_operadora y
		where	y.nr_sequencia	= x.nr_seq_mov_operadora
		and	x.nr_sequencia	= a.nr_seq_mov_contrato
		and	y.nr_seq_lote	= nr_seq_lote_p);

delete	from pls_mov_benef_contrato a
where	exists (SELECT	1
		from	pls_mov_benef_operadora x
		where	x.nr_sequencia	= a.nr_seq_mov_operadora
		and	x.nr_seq_lote	= nr_seq_lote_p);

delete	from pls_mov_benef_operadora
where	nr_seq_lote =	nr_seq_lote_p;

update	pls_mov_benef_lote
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
-- REVOKE ALL ON PROCEDURE pls_mov_benef_pck.desfazer_lote_mov_benef ( nr_seq_lote_p pls_mov_benef_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
