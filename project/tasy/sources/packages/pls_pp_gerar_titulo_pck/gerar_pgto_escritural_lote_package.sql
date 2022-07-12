-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_gerar_titulo_pck.gerar_pgto_escritural_lote ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


nr_seq_escritura_w	banco_escritural.nr_sequencia%type;

c01 CURSOR(	nr_seq_lote_pc	pls_pp_lote.nr_sequencia%type) FOR
	SELECT	a.nr_seq_conta_banco,
		(SELECT	max(x.cd_banco)
		from	banco_estabelecimento x
		where	x.nr_sequencia = a.nr_seq_conta_banco) cd_banco
	from	pls_pp_prestador a
	where	a.nr_seq_lote = nr_seq_lote_pc
	and	a.ie_cancelado = 'N'
	and	(a.nr_seq_conta_banco IS NOT NULL AND a.nr_seq_conta_banco::text <> '')
	group by a.nr_seq_conta_banco;

c02 CURSOR(	nr_seq_lote_pc		pls_pp_lote.nr_sequencia%type,
		nr_seq_conta_banco_pc	pls_pp_prestador.nr_seq_conta_banco%type) FOR
	SELECT	a.nr_titulo_pagar
	from	pls_pp_prestador a
	where	a.nr_seq_lote = nr_seq_lote_pc
	and	a.nr_seq_conta_banco = nr_seq_conta_banco_pc
	and	a.ie_cancelado = 'N';

BEGIN

for r_c01_w in c01(nr_seq_lote_p) loop

	insert into banco_escritural(
		nr_sequencia, dt_atualizacao, dt_atualizacao_nrec,
		nm_usuario, nm_usuario_nrec, nr_seq_conta_banco,
		dt_remessa_retorno, ie_remessa_retorno, cd_banco,
		cd_estabelecimento, ie_cobranca_pagto, nr_seq_pp_lote
	) values (
		nextval('banco_escritural_seq'), clock_timestamp(), clock_timestamp(),
		nm_usuario_p, nm_usuario_p, r_c01_w.nr_seq_conta_banco,
		clock_timestamp(), 'R', r_c01_w.cd_banco,
		cd_estabelecimento_p, 'C', nr_seq_lote_p
	) returning nr_sequencia into nr_seq_escritura_w;

	for r_c02_w in c02(nr_seq_lote_p, r_c01_w.nr_seq_conta_banco) loop

		CALL gerar_titulo_escritural(r_c02_w.nr_titulo_pagar, nr_seq_escritura_w, nm_usuario_p);
	end loop;
	
	commit;
end loop;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_gerar_titulo_pck.gerar_pgto_escritural_lote ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
